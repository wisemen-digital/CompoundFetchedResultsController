//
//  LimitedFetchedResultsController.m
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 23/12/16.
//  Copyright © 2016. All rights reserved.
//

#import "LimitedFetchedResultsController.h"

#pragma mark - StaticSectionInfo

@interface CompoundFetchedResultsController_LimitedSectionInfo: NSObject<NSFetchedResultsSectionInfo>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *objects;

@end

@implementation CompoundFetchedResultsController_LimitedSectionInfo

- (instancetype)initWithName:(NSString *)name objects:(NSArray *)objects {
	if (self = [super init]) {
		self.name = name;
		self.objects = objects;
	}
	return self;
}

- (NSString *)indexTitle {
	return nil;
}

- (NSUInteger)numberOfObjects {
	return self.objects.count;
}

@end

#pragma mark - LimitedFetchedResultsController

@interface LimitedFetchedResultsController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, assign) NSUInteger fetchLimit;
@property (nonatomic, strong) NSFetchedResultsController *actualFRC;
@property (nonatomic, assign) BOOL changed;

@end

@implementation LimitedFetchedResultsController

- (instancetype)initWithFetchRequest:(NSFetchRequest *)fetchRequest managedObjectContext:(NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name {
	self = [super initWithFetchRequest: fetchRequest managedObjectContext: context sectionNameKeyPath: sectionNameKeyPath cacheName: name];

	self.fetchLimit = fetchRequest.fetchLimit;
	fetchRequest.fetchLimit = NSUIntegerMax;
	self.actualFRC = [[NSFetchedResultsController alloc] initWithFetchRequest: fetchRequest managedObjectContext: context sectionNameKeyPath: sectionNameKeyPath cacheName: name];
	self.actualFRC.delegate = self;

	return self;
}

#pragma mark - NSFetchedResultsController overrides

- (BOOL)performFetch:(NSError * _Nullable __autoreleasing *)error {
	return [self.actualFRC performFetch: error];
}

- (NSArray *)fetchedObjects {
	NSArray *result = self.actualFRC.fetchedObjects;

	if (result.count > self.fetchLimit) {
		NSRange range = NSMakeRange(0, self.fetchLimit);
		result = [result subarrayWithRange: range];
	}

	return result;
}

- (id<NSFetchRequestResult>)objectAtIndexPath:(NSIndexPath *)indexPath {
	return self.fetchedObjects[indexPath.item];
}

- (NSIndexPath *)indexPathForObject:(id<NSFetchRequestResult>)object {
	NSUInteger index = [self.fetchedObjects indexOfObject: object];

	if (index != NSNotFound) {
		return [NSIndexPath indexPathForRow: index inSection: 0];
	} else {
		return nil;
	}
}

- (NSArray<NSString *> *)sectionIndexTitles {
	if (super.sectionIndexTitles.count > 1) {
		return @[self.actualFRC.sectionIndexTitles.firstObject];
	} else {
		return self.actualFRC.sectionIndexTitles;
	}
}

- (NSArray<id<NSFetchedResultsSectionInfo>> *)sections {
	NSString *name = self.actualFRC.sections.firstObject.name;

	return @[
		[[CompoundFetchedResultsController_LimitedSectionInfo alloc] initWithName: name objects: self.fetchedObjects]
	];
}

- (NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)sectionIndex {
	return 0;
}

#pragma mark - NSFetchedResultsController delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	self.changed = NO;

	if ([self.delegate respondsToSelector: @selector(controllerWillChangeContent:)]) {
		[self.delegate controllerWillChangeContent: self];
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath {
	self.changed = YES;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	self.changed = YES;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	if (self.changed && [self.delegate respondsToSelector: @selector(controller:didChangeSection:atIndex:forChangeType:)]) {
		[self.delegate controller: self didChangeSection: self.sections.firstObject atIndex: 0 forChangeType: NSFetchedResultsChangeUpdate];
	}

	if ([self.delegate respondsToSelector: @selector(controllerDidChangeContent:)]) {
		[self.delegate controllerDidChangeContent: self];
	}
}

@end

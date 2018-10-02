//
//  StaticFetchedResultsController.m
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 23/12/16.
//  Copyright © 2016. All rights reserved.
//

#import "StaticFetchedResultsController.h"

#pragma mark - StaticSectionInfo

@interface CompoundFetchedResultsController_StaticSectionInfo: NSObject<NSFetchedResultsSectionInfo>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *objects;

@end

@implementation CompoundFetchedResultsController_StaticSectionInfo

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

#pragma mark - StaticFetchedResultsController

@implementation StaticFetchedResultsController

- (instancetype)initWithItems:(NSArray *)items {
	return [self initWithItems: items sectionTitle: @""];
}

- (instancetype)initWithItems:(NSArray *)items sectionTitle:(NSString *)sectionTitle {
	if (self = [super init]) {
		_items = items;
		_sectionTitle = sectionTitle;
	}
	return self;
}

- (void)setItems:(NSArray *)items {
	if ([self.delegate respondsToSelector: @selector(controllerWillChangeContent:)]) {
		[self.delegate controllerWillChangeContent: self];
	}

	_items = items;
	if ([self.delegate respondsToSelector: @selector(controller:didChangeSection:atIndex:forChangeType:)]) {
		id<NSFetchedResultsSectionInfo> info = [[CompoundFetchedResultsController_StaticSectionInfo alloc] initWithName: self.sectionTitle objects: items];
		[self.delegate controller: self didChangeSection: info atIndex: 0 forChangeType: NSFetchedResultsChangeUpdate];
	}

	if ([self.delegate respondsToSelector: @selector(controllerDidChangeContent:)]) {
		[self.delegate controllerDidChangeContent: self];
	}
}

#pragma mark - NSFetchedResultsController overrides

- (BOOL)performFetch:(NSError * _Nullable __autoreleasing *)error {
	return true;
}

- (NSFetchRequest *)fetchRequest {
	return [NSFetchRequest new];
}

- (NSManagedObjectContext *)managedObjectContext {
	return [[NSManagedObjectContext alloc] initWithConcurrencyType: NSMainQueueConcurrencyType];
}

- (NSString *)sectionNameKeyPath {
	return nil;
}

- (NSString *)cacheName {
	return nil;
}

- (NSArray *)fetchedObjects {
	return self.items;
}

- (id<NSFetchRequestResult>)objectAtIndexPath:(NSIndexPath *)indexPath {
	return self.items[indexPath.item];
}

- (NSIndexPath *)indexPathForObject:(id<NSFetchRequestResult>)object {
	NSUInteger index = [self.items indexOfObject: object];

	if (index != NSNotFound) {
		return [NSIndexPath indexPathForRow: index inSection: 0];
	} else {
		return nil;
	}
}

- (NSString *)sectionIndexTitleForSectionName:(NSString *)sectionName {
	return nil;
}

- (NSArray<NSString *> *)sectionIndexTitles {
	return @[@""];
}

- (NSArray<id<NSFetchedResultsSectionInfo>> *)sections {
	return @[
		[[CompoundFetchedResultsController_StaticSectionInfo alloc] initWithName: self.sectionTitle objects: self.items]
	];
}

- (NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)sectionIndex {
	return NSNotFound;
}

@end

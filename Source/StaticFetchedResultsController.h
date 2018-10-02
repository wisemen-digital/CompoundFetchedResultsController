//
//  StaticFetchedResultsController.h
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 23/12/16.
//  Copyright © 2016. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface StaticFetchedResultsController<ResultType: id<NSFetchRequestResult>>: NSFetchedResultsController<ResultType>

@property (nonatomic, strong) NSArray<ResultType> *items;
@property (nonatomic, strong) NSString *sectionTitle;

- (instancetype)initWithItems:(NSArray<ResultType> *)items;
- (instancetype)initWithItems:(NSArray<ResultType> *)items sectionTitle:(NSString *)sectionTitle;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFetchRequest:(NSFetchRequest<ResultType> *)fetchRequest managedObjectContext: (NSManagedObjectContext *)context sectionNameKeyPath:(nullable NSString *)sectionNameKeyPath cacheName:(nullable NSString *)name NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

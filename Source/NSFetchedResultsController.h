//
//  NSFetchedResultsController.h
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 25/01/2019.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFetchedResultsController (CompoundFetchedResultsController)

@property (nonatomic, readonly) NSFetchedResultsController<NSFetchRequestResult> *genericController;

@end

NS_ASSUME_NONNULL_END

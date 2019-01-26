//
//  LimitedFetchedResultsController.h
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 23/12/16.
//  Copyright © 2016. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface LimitedFetchedResultsController<ResultType: id<NSFetchRequestResult>>: NSFetchedResultsController<ResultType>

@end

NS_ASSUME_NONNULL_END

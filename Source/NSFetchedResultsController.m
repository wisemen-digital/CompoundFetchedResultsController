//
//  NSFetchedResultsController.m
//  CompoundFetchedResultsController
//
//  Created by David Jennes on 25/01/2019.
//

#import "NSFetchedResultsController.h"

@implementation NSFetchedResultsController (CompoundFetchedResultsController)

- (NSFetchedResultsController<NSFetchRequestResult> *)genericController {
	return (NSFetchedResultsController<NSFetchRequestResult> *)self;
}

@end

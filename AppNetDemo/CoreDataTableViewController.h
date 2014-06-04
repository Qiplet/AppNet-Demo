//
//  CoreDataTableViewController.h
//  Template
//
//  Created by David Butts on 11/28/13.
//  Copyright (c) 2013 Qiplet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

// The fetchedResultsController property MUST be set for the class to fetch its data
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

// The fetchedResultsController should ignore update notifications involving table changes initiated by the user.
// * For example, when the method tableView:moveRowAtIndexPath:toIndexPath is called, set the suspendAutomaticTableUpdates
// * property to YES to suspend tracking at the beginning of method implementation.
// * The property should be set to NO after completing implementation to re-enable tracking of changes.
// * Do NOT set this property for the implementation of row deletion or insertion methods.
@property (nonatomic) BOOL suspendAutomaticTableUpdates;

// Enables debugging output for the console
@property BOOL debug;

// performFetch method will refetch data for class
// In general, this method is unnecessary due to:
//  - NSFetchedResultsController observes the context for data changes (table data automatically updated)
//  - performFetch is called when the fetchedResultsController property is initially set
- (void) performFetch;

@end

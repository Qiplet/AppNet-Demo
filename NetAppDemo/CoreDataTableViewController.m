//
//  CoreDataTableViewController.m
//  Template
//
//  Created by David Butts on 11/28/13.
//  Copyright (c) 2013 Qiplet. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface CoreDataTableViewController ()
@property (nonatomic) BOOL updateInProgress;

@end

@implementation CoreDataTableViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - NSFetchedResultsController

/*
 // *** Standard NSFetchedResultsController setup ***
 NSManagedObjectContext *context = <#Managed object context#>;
 NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
 // Configure the request's entity, and optionally its predicate.
 NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"<#Sort key#>" ascending:YES];
 NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
 [fetchRequest setSortDescriptors:sortDescriptors];
 
 NSFetchedResultsController *controller = [[NSFetchedResultsController alloc]
 initWithFetchRequest:fetchRequest
 managedObjectContext:context
 sectionNameKeyPath:nil
 cacheName:@"<#Cache name#>"];
 */



-(void) performFetch
{
    if(self.fetchedResultsController)
    {
        if(self.debug)
        {
            if(!self.fetchedResultsController.fetchRequest.predicate) NSLog(@"[%@ %@] fetching all %@ (no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName);
            else NSLog(@"[%@ %@] fetching %@ using predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName, self.fetchedResultsController.fetchRequest.predicate);
        }
        NSError *error = nil;
        [self.fetchedResultsController performFetch:&error];
        if(error) NSLog(@"[%@ %@] %@ %@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason], [error localizedRecoverySuggestion]);

    } else {
        NSLog(@"[%@ %@] fetchedResultsController property is nil (i.e. not setup).", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    [self.tableView reloadData];
}

-(void) setFetchedResultsController:(NSFetchedResultsController *)newFRC
{
    NSFetchedResultsController * currentFRC = _fetchedResultsController;
    if(currentFRC!=newFRC)
    {
        _fetchedResultsController = newFRC;
        newFRC.delegate = self;
        //Consider setting self.title using fetchRequest.entity.name
        if(newFRC){
            if(self.debug) NSLog(@"[%@ %@] %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd), currentFRC ? @"updated" : @"set");
            [self performFetch];
        } else {
            if(self.debug) NSLog(@"[%@ %@] set to nil",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
            [self.tableView reloadData];
        }
        
    }
    //self.debug = YES;
}

#pragma mark - UITableViewDataSource

// Implement cellForRowAtIndexPath in the appropriate subclass
/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 static NSString *CellIdentifier = @"templateCell";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
 ModelClass *element = [self.fetchedResultsController objectAtIndexPath:indexPath];
 cell.textLabel.text = element.name;
 cell.detailTextLabel.text = [NSString stringWithFormat:@"%d items", [element.items count]];
 
 return cell;
 }*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    } else
        return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark - NSFetchedResultsControllerDelegate
// See NSFetchedResultsControllerDelegate for details (this section is mostly copy & paste)

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if(!self.suspendAutomaticTableUpdates){
        [self.tableView beginUpdates];
        self.updateInProgress = YES;
    }
    
}


- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    if(self.debug) NSLog(@"[%@ %@] %i",NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.suspendAutomaticTableUpdates);
    if(!self.suspendAutomaticTableUpdates)
    {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    if(self.debug) NSLog(@"[%@ %@] %i",NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.suspendAutomaticTableUpdates);
    if(!self.suspendAutomaticTableUpdates)
    {
        UITableView *tableView = self.tableView;
        
        switch(type) {
                
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
                
            case NSFetchedResultsChangeMove:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
        
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if(self.updateInProgress)
    {
        [self.tableView endUpdates];
    }
}

- (void)setSuspendAutomaticTableUpdates:(BOOL)suspend
{
    if(self.debug) NSLog(@"[%@ %@] %i",NSStringFromClass([self class]), NSStringFromSelector(_cmd), suspend);
    if (suspend) {
        _suspendAutomaticTableUpdates = YES;
    } else {
        // Creates slight delay to account for timing associated with notification processing
        [self performSelector:@selector(endSuspendAutomaticUpdates) withObject:0 afterDelay:0];
    }
}

- (void) endSuspendAutomaticUpdates
{
    _suspendAutomaticTableUpdates = NO;
}




@end

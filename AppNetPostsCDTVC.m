//
//  AppNetPosts.m
//  NetAppDemo
//
//  Created by David Butts on 5/29/14.
//  Copyright (c) 2014 Qiplet. All rights reserved.
//

#import "AppNetPostsCDTVC.h"
#import "Post+Creator.h"
#import "PostDataFetcher.h"

#define MANAGED_DOCUMENT @"Post Document"
#define NSLOG_APPNET_DEBUG NO

@implementation AppNetPostsCDTVC

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Whenever the table view is about to appear, ensure that our managed document is open/created
    if (!self.managedObjectContext) [self useManagedDocument];
}


// Creates, opens or just uses our managed document
// Because creating and opening the document are asynchronous, the managedObjectContext must be set in the completion handler.

- (void)useManagedDocument
{
    // Create document using the MANAGED_DOCUMENT path URL
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:MANAGED_DOCUMENT];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    // Create if document doesn't exist.  Otherwise use existing document and take into account if its state is 'open'.
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if(success){
                self.managedObjectContext = document.managedObjectContext;
                [self refresh];
            }
        }];
    } else if(document.documentState == UIDocumentStateClosed){
        [document openWithCompletionHandler:^(BOOL success) {
            if(success){
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    } else
    {
        self.managedObjectContext = document.managedObjectContext;
    }
}

#pragma mark - Refresh data

- (void) refresh
{
    [self.refreshControl beginRefreshing];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_queue_t queryQ = dispatch_queue_create("AppNet Query", NULL);
    dispatch_async(queryQ, ^{
        // Query data from internet
        NSArray *posts = [PostDataFetcher fetchPosts];
        if (NSLOG_APPNET_DEBUG) NSLog(@"[%@ %@] received %lul", NSStringFromClass([self class]), NSStringFromSelector(_cmd), (unsigned long)[posts count]);
        
        // Place fetched posts in core data
        [self.managedObjectContext performBlock:^{
            for(NSDictionary *postData in posts){
                [Post postFromAppNetGlobalFeed:postData inManagedObjectContext:self.managedObjectContext];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [self.refreshControl endRefreshing];
            });
        }];
    });
}

@end

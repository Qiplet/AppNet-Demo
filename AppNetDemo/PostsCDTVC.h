//
//  PostsCDTVC.h
//  AppNetDemo
//
//  Created by David Butts on 5/29/14.
//  Copyright (c) 2014 Qiplet. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Post+Creator.h"

@interface PostsCDTVC : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

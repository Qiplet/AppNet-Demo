//
//  QIPAppDelegate.h
//  AppNetDemo
//
//  Created by David Butts on 5/29/14.
//  Copyright (c) 2014 Qiplet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QIPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

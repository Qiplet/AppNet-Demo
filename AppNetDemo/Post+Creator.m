//
//  Post+Creator.m
//  AppNetDemo
//
//  Created by David Butts on 5/29/14.
//  Copyright (c) 2014 Qiplet. All rights reserved.
//

#import "Post+Creator.h"
#import "PostDataFetcher.h"
#import "NSDate+ISO8601.h"

// Assumes 2-line text message


@implementation Post (Creator)

// Creation method
+ (Post *) postFromAppNetGlobalFeed:(NSDictionary *) postDictionary
              inManagedObjectContext:(NSManagedObjectContext*)context
{
    Post *post = nil;
    if(postDictionary && context)
    {
        //Return post if it already exists in database else if post doesn't exist then create new database object
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_NAME];
        fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:ENTITY_KEY ascending:NO]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:ENTITY_PREDICATE, postDictionary[POST_ID]];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
        if(error) NSLog(@"[%@ %@] %@ %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
        
        // Process matches result from our query; returns nil for an error, empty array with no matches, or an array of matches
        if(!matches || [matches count]>1) {
            NSLog(@"[%@ %@] %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd), matches ? [NSNumber numberWithInteger:[matches count]] : @"matches is nil");

        } else if(![matches count]){
            post = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:context];
            post.post_id = [postDictionary valueForKeyPath:POST_ID];
            post.text = [postDictionary valueForKeyPath:POST_TEXT];
            post.username = [postDictionary[POST_USER] valueForKeyPath:POST_USERNAME];
            post.avatar_image = [[postDictionary[POST_USER] valueForKeyPath:POST_AVATAR_IMAGE] valueForKeyPath:POST_AVATAR_IMAGE_URL];
            post.row_height = nil;
            
            // Parse date from string (eg "2004-06-17T00:00:00.000Z") using C based NSDate category
            post.created_at = [NSDate dateFromISO8601String:[postDictionary[POST_CREATED_AT] description]];

        } else {
            post = [matches lastObject];
        }
    } else {
        NSLog(@"[%@ %@] %@",NSStringFromClass([self class]), NSStringFromSelector(_cmd), postDictionary ? @"context is nil" : @"postDictionary is nil");
    }
    
    return post;
}


@end

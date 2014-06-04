//
//  Post+Creator.h
//  AppNetDemo
//
//  Created by David Butts on 5/29/14.
//  Copyright (c) 2014 Qiplet. All rights reserved.
//

#import "Post.h"

#define ENTITY_NAME @"Post"
#define ENTITY_KEY @"post_id"
#define ENTITY_PREDICATE @"post_id = %@"

@interface Post (Creator)

+ (Post *) postFromAppNetGlobalFeed:(NSDictionary *)postDictionary
         inManagedObjectContext:(NSManagedObjectContext *)context;

@end

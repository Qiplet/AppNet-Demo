//
//  DroneDataFetcher.h
//  Drone Tracker
//
//  Created by David Butts on 11/3/13.
//  Copyright (c) 2013 Qiplet. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSLOG_FETCH_DATA NO

#define POSTS_DATA @"data" // parent data array containing posts
#define POST_ID @"id"
#define POST_TEXT @"text"
#define POST_CREATED_AT @"created_at"
#define POST_USER @"user" // array containing the user data (e.g. username)
#define POST_USERNAME @"username"
#define POST_AVATAR_IMAGE @"avatar_image" // array containing avatar image data (e.g. url)
#define POST_AVATAR_IMAGE_URL @"url"


@interface PostDataFetcher : NSObject

+ (NSArray *)fetchPosts;

@end


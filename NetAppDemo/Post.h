//
//  Post.h
//  NetAppDemo
//
//  Created by David Butts on 6/2/14.
//  Copyright (c) 2014 Qiplet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * avatar_image;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * post_id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * row_height;

@end

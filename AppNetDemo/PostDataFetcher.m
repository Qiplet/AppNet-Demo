//
//  DroneDataFetcher.m
//  Drone Tracker
//
//  Created by David Butts on 11/3/13.
//  Copyright (c) 2013 Qiplet. All rights reserved.
//

#define JSON_SOURCE_URL @"https://alpha-api.app.net/stream/0/posts/stream/global"

#import "PostDataFetcher.h"

@implementation PostDataFetcher

// Returns an array of posts
+ (NSArray *)fetchPosts
{
    NSString *request = [NSString stringWithFormat:JSON_SOURCE_URL];
    return [[self executeFetch:request] valueForKeyPath:POSTS_DATA];
}

+ (NSDictionary *)executeFetch:(NSString *)query
{
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //if (NSLOG_FETCH_DATA) NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
    
    // Refresh will appear broken if it is too quick; introduce momentary sleep to improve user experience
    //[NSThread sleepForTimeInterval:1.5];
    
    // Instantiate string using URL
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query]
                                                 encoding:NSUTF8StringEncoding
                                                    error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                                                         error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    if (NSLOG_FETCH_DATA) NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    
    return results;
}


@end

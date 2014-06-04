//
//  NSDate+ISO8601.m
//  AppNetDemo
//
//  Created by David Butts on 6/3/14.
//  Copyright (c) 2014 Qiplet. All rights reserved.
//

#import "NSDate+ISO8601.h"
#include <time.h>

#define TIME_CHAR_BUFFER ((int) 80)

@implementation NSDate (ISO8601)

+ (NSDate *)dateFromISO8601String:(NSString *)dateString {
    if (!dateString) {
        return nil;
    }
    
    struct tm tm;
    time_t time;
    
    strptime([dateString cStringUsingEncoding:NSUTF8StringEncoding], "%Y-%m-%dT%H:%M:%S%z", &tm);
    tm.tm_isdst = -1;
    time = mktime(&tm);
    
    return [NSDate dateWithTimeIntervalSince1970:time + [[NSTimeZone localTimeZone] secondsFromGMT]];
}

//
- (NSString *)ISO8601String {
    char buffer[TIME_CHAR_BUFFER];
    time_t time = [self timeIntervalSince1970] - [[NSTimeZone localTimeZone] secondsFromGMT];
    
    strftime(buffer, TIME_CHAR_BUFFER, "%Y-%m-%dT%H:%M:%S%z", localtime(&time));
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

// Returns simple time string - "12:45 PM"
- (NSString *)shortFormattedTimeString {
    char buffer[TIME_CHAR_BUFFER];
    time_t time = [self timeIntervalSince1970];
    
    strftime(buffer, TIME_CHAR_BUFFER, "%-l:%M %p", localtime(&time));
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

@end

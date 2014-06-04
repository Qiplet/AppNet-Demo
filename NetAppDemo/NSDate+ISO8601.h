//
//  NSDate+ISO8601.h
//  AppNetDemo
//
//  Created by David Butts on 6/3/14.
//  Copyright (c) 2014 Qiplet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ISO8601)

+ (NSDate *)dateFromISO8601String:(NSString *)string;
- (NSString *)ISO8601String;
- (NSString *)shortFormattedTimeString;

@end

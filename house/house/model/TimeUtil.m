//
//  TimeUtil.m
//  house
//
//  Created by Michael Arbuckle on 12/15/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeUtil.h"

#define sec_in_hour 3600
#define sec_in_day 86400
#define sec_in_week 604800

@implementation TimeUtil

+(double)offsetDate:(NSDate*)date startDate:(NSDate*)start endDate:(NSDate*)end
{
    NSTimeInterval occurence = [date timeIntervalSinceDate:start];
    NSTimeInterval span = [end timeIntervalSinceDate:start];
    
    double fraction =occurence/span;
    
    double offset = span;

    return fraction;
}

+(NSDateFormatter*)getTimestampDateFormatter
{
    NSDateFormatter* form = [[NSDateFormatter alloc] init];
    form.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS ";
    //@"yyyy-MM-dd hh:mm:ss a";
    
    //2015-01-07T17:26:18.995Z
    return form;
}
@end

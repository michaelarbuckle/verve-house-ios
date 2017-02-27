//
//  TimeUtil.h
//  house
//
//  Created by Michael Arbuckle on 12/15/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//
@interface TimeUtil : NSObject

+(double)offsetDate:(NSDate*)date startDate:(NSDate*)start endDate:(NSDate*)end;
+(NSDateFormatter*)getTimestampDateFormatter;
@end

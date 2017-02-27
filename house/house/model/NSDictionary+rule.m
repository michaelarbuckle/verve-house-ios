//
//  NSDictionary+device.m
//  AirQualityWSClient
//
//  Created by Michael Arbuckle on 9/21/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import "NSDictionary+rule.h"

@implementation NSDictionary  (rule)


- (NSString *)id
{
    NSString *cc = self[@"id"];
    return cc;
}

- (NSString *)name{
    NSString *cc = self[@"name"];
    return cc;
}
 
- (NSString *)href {
    NSString *cc = self[@"href"];
    return cc;
}


@end

//
//  NSDictionary+device.m
//  AirQualityWSClient
//
//  Created by Michael Arbuckle on 9/21/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import "NSDictionary+group.h"

@implementation NSDictionary  (group)


- (NSString *)id
{
    NSString *cc = self[@"id"];
    return cc;
}

- (NSString *)name{
    NSString *cc = self[@"name"];
    return cc;
}
- (NSArray *)objects{
    
    return NULL;
}

- (NSString *)href
{
    NSString *cc = self[@"href"];
    return cc;
}
@end

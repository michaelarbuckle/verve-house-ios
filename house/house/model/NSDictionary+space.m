//
//  NSDictionary+device.m
//  AirQualityWSClient
//
//  Created by Michael Arbuckle on 9/21/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import "NSDictionary+space.h"

@implementation NSDictionary  (space)


- (NSString *)id
{
    NSString *cc = self[@"id"];
    return cc;
}

- (NSString *)name{
    NSString *cc = self[@"name"];
    return cc;
}
- (NSString *)SSID_key{
    NSString *cc = self[@"SSID_key"];
    return cc;
}
- (NSString *)hostname{
    NSString *cc = self[@"hostname"];
    return cc;
}
- (NSArray *)sensorTypes{
    NSString *cc = self[@"id"];
    return cc;
}
- (NSString *)href {
    NSString *cc = self[@"href"];
    return cc;
}


@end

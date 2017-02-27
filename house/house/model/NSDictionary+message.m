//
//  NSDictionary+device.m
//  AirQualityWSClient
//
//  Created by Michael Arbuckle on 9/21/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import "NSDictionary+message.h"

@implementation NSDictionary  (message)


- (NSString *)id
{
    NSString *cc = self[@"id"];
    return cc;
}

- (NSString *)message{
    NSString *cc = self[@"message"];
    return cc;
}
- (NSString *)topic{
    NSString *cc = self[@"topic"];
    return cc;
}
- (NSString *)correlationId{
    NSString *cc = self[@"correlationId"];
    return cc;
}
- (NSString *)author{
    NSString *cc = self[@"author"];
    return cc;
}

- (NSString *)type{
    NSString *cc = self[@"type"];
    return cc;
}
- (NSString *)level{
    NSString *cc = self[@"level"];
    return cc;
}

- (NSString *)timestamp {
    NSString *cc = self[@"timestamp"];
    return cc;
}


-(Message*)messageInstance
{
    Message *s = [[Message alloc]init];
    s.message = (NSString*)self[@"message"];
    s.topic =  (NSString*)self[@"topic"];
    s.correlationId =  (NSString*)self[@"correlationId"];
    s.author =  (NSString*)self[@"author"];
    s.type =  (NSString*)self[@"type"];
    s.level =  (NSString*)self[@"level"];
    s.timestamp =  (NSString*)self[@"timestamp"];
    return s;
}

@end

//
//  NSDictionary+device.m
//  AirQualityWSClient
//
//  Created by Michael Arbuckle on 9/21/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import "NSDictionary+sensor.h"

@implementation NSDictionary  (sensor)

/*
 "sensors" : [ {
 "name" : null,
 "n" : "CO2",
 "v" : "558",
 "mn" : null,
 "mx" : null,
 "a" : null,
 "u" : "ppm",
 "t" : "2015-01-07T17:26:18.995Z",
 "_links" : {
 "self" : {
 "href" : "http://localhost:8080/sensors/57d1da0660ca06203b3e9248"
 },
*/
- (NSString *)id
{
    NSString *cc = self[@"id"];
    return cc;
}

- (NSString *)name{
    NSString *cc = self[@"name"];
    return cc;
}

- (NSString *)timestamp{
    NSString *cc = self[@"t"];
    return cc;
}


- (NSString *)units{
    NSString *cc = self[@"units"];
    return cc;
}
- (NSString *)value{
    NSString *cc = self[@"value"];
    return cc;
}
- (NSString *)type{
    NSString *cc = self[@"type"];
    return cc;
}
- (NSString *)href {
    NSDictionary *l = self[@"links"];
    NSDictionary *s = l[@"self"];
    NSString *cc = s[@"href"];
    return cc;
}
- (float )min { return 0.0f;}
- (float )max{ return 0.0f;}
- (float )avg{ return 0.0f;}
-(Measurand*)sensor
{
    Measurand *s = [[Measurand alloc]init];
    s.name = (NSString*)self[@"n"];
    s.type =  (NSString*)self[@"type"];
    s.value =  (NSString*)self[@"value"];
    s.units =  (NSString*)self[@"u"];
    s.timestamp =  (NSString*)self[@"t"];
    return s;
}

-(MeasurableSeries*)daySeries
{
    MeasurableSeries* d = [[MeasurableSeries alloc] init];
    d.values = (NSArray*)self[@"dayTimeSeries"];
    d.timestamps =  (NSArray*)self[@"dayTimeSeriesTimestamps"];
/*    d.avg =  [ self[@"dayAvg"] doubleValue];
    d.max =  [ self[@"dayMax"] doubleValue];
    d.min =  [ self[@"dayMin"] doubleValue]; */
    
    return d;
}
-(MeasurableSeries*)weekSeries{
    MeasurableSeries* d = [[MeasurableSeries alloc] init];
    d.values = (NSArray*)self[@"weekTimeSeries"];
    d.timestamps =  (NSArray*)self[@"weekTimeSeriesTimestamps"];
  /*  d.avg =  [ self[@"weekAvg"] doubleValue];
    d.max =  [ self[@"weekMax"] doubleValue];
    d.min =  [ self[@"weekMin"] doubleValue];
    */
    
    
    return d;
}


@end

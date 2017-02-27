//
//  MeasurableSeries.m
//  house
//
//  Created by Michael Arbuckle on 12/15/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeasurableSeries.h"
@implementation MeasurableSeries

-(id)initWithDictionary:(NSDictionary*)initializers
{
    self.uUID=[initializers valueForKey:@"uuid"];
    self.values=[initializers valueForKey:@"value"];
    self.interval= [[initializers valueForKey:@"interval"] integerValue];
    self.timestamps=[initializers valueForKey:@"timestamp"];
    
  
    return self;
}

@end

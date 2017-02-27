//
//  Measurable.h
//  airquality
//
//  Created by Michael Arbuckle on 7/18/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

@interface MeasurableSeries : NSObject
{}
-(id)initWithDictionary:(NSDictionary*)initializers;
@property (nonatomic, copy) NSString *uUID;
@property (nonatomic, copy) NSArray *values;
@property (nonatomic, copy) NSArray *timestamps;
@property NSInteger avg;
@property NSInteger min;
@property NSInteger max;
@property (nonatomic, copy) NSString *valueType;
@property (nonatomic, copy) NSString *scale;
@property  NSInteger interval;
@end

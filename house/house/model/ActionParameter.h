//
//  Measurable.h
//  HouseExplorer
//
//  Created by Michael Arbuckle on 11/28/14.
//  Copyright (c) 2014 Michael Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionParameter: NSObject
{}
-(id)initWithDictionary:(NSDictionary*)initializers;
-(NSString*)formattedWithUnitsAndLastUpdate;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *units;
@end

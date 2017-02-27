//
//  Measurable.h
//  HouseExplorer
//
//  Created by Michael Arbuckle on 11/28/14.
//  Copyright (c) 2014 Michael Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
{}
-(id)initWithDictionary:(NSDictionary*)initializers;
-(NSString*)formattedWithUnitsAndLastUpdate;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *topic;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *correlationId;
@property (nonatomic, copy) NSString *author;
@end

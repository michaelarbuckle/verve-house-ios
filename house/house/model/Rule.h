//
//  Measurable.h
//  HouseExplorer
//
//  Created by Michael Arbuckle on 11/28/14.
//  Copyright (c) 2014 Michael Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Rule : NSObject
{}
-(id)initWithDictionary:(NSDictionary*)initializers;
-(NSDictionary*)getDictionary;
-(NSString*)formattedWithUnitsAndLastUpdate;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* message;
@property (nonatomic, copy) NSString* topic;
@property (nonatomic, copy) NSString* actionText;
@property (nonatomic) BOOL enabled;
@property (nonatomic, copy) NSString* level;

@property (nonatomic, copy) NSMutableArray *whenList;
@property (nonatomic, copy) NSMutableArray *thenList;
@property (nonatomic, copy) NSString *href;

@end

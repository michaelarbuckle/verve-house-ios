//
//  Measurable.h
//  HouseExplorer
//
//  Created by Michael Arbuckle on 11/28/14.
//  Copyright (c) 2014 Michael Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Action : NSObject
{}
-(id)initWithDictionary:(NSDictionary*)initializers;
-(id)initWithName:(NSString*)name type:(NSString*)type image:(NSString*)image;


@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSArray *parameters;
@end

//
//  Measurable.h
//  HouseExplorer
//
//  Created by Michael Arbuckle on 11/28/14.
//  Copyright (c) 2014 Michael Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Person : NSObject
{}
-(id)initWithDictionary:(NSDictionary*)initializers;
-(NSDictionary*)getDictionary;
@property (nonatomic, copy) NSString* name;
@property (nonatomic) BOOL enabled;
@property (nonatomic, copy) NSString* level;

@property (nonatomic, copy) NSMutableArray *preferences;
@property (nonatomic, copy) NSMutableArray *spaceRoles;


@end

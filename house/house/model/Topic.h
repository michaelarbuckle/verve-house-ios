//
//  Measurable.h
//  HouseExplorer
//
//  Created by Michael Arbuckle on 11/28/14.
//  Copyright (c) 2014 Michael Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Topic : NSObject
{}
-(id)initWithDictionary:(NSDictionary*)initializers;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *timestamp;
@end

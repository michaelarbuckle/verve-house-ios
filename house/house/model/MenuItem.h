//
//  Measurable.h
//  HouseExplorer
//
//  Created by Michael Arbuckle on 11/28/14.
//  Copyright (c) 2014 Michael Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MenuItem : NSObject
{}
-(id)initWithDictionary:(NSDictionary*)initializers;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* type;
@property (nonatomic, copy) UIImage* image;
@property (nonatomic, copy) NSString* controller;
@property (nonatomic, copy) NSObject* data ;
@property (nonatomic, copy) NSString* path;

@end

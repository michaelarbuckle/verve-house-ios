//
//  MasterViewController.m
//  airquality
//
//  Created by Michael Arbuckle on 7/17/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DevicesHTTPClient.h"


@interface DetailViewController: UIViewController <  UIActionSheetDelegate,DevicesHTTPClientDelegate>
@property UIView* dataView;
@property  Class* class;
@property (atomic, retain) NSObject* item;
@property (atomic, retain) NSString* path;
@property (atomic, retain) NSString* itemId;

-(id)initWithData:(NSObject*)data path:(NSString*)path;
-(void)setData:(Class*)cls  data:(NSObject*)data path:(NSString*)path;

@end


//
//  MasterViewController.m
//  airquality
//
//  Created by Michael Arbuckle on 7/17/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DevicesHTTPClient.h"

//@class DetailViewController;
//@class DemoBaseViewController;


@interface SceneViewController: UITableViewController <  UIActionSheetDelegate,DevicesHTTPClientDelegate>


//@property (strong, nonatomic) DemoBaseViewController *detailViewController;
@property (strong, nonatomic) UIViewController *graphicsViewController;
@property (strong, nonatomic) UIViewController *chartViewController;


@end


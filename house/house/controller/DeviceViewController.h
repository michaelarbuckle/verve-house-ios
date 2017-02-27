//
//  MasterViewController.m
//  airquality
//
//  Created by Michael Arbuckle on 7/17/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DevicesHTTPClient.h"
#import "TableSectionHeader.h"    // for SectionHeaderViewDelegate
#import "MGSwipeTableCell.h"
//@class DetailViewController;
//@class DemoBaseViewController;

//UITableViewController
@interface DeviceViewController : UITableViewController < MGSwipeTableCellDelegate,UIActionSheetDelegate,DevicesHTTPClientDelegate, SectionHeaderViewDelegate>

//@property (strong, nonatomic) DemoBaseViewController *detailViewController;
@property (strong, nonatomic) UIViewController *graphicsViewController;
@property (strong, nonatomic) UIViewController *chartViewController;
//@property (strong, nonatomic) IBOutlet UITableView* tableView;

@end


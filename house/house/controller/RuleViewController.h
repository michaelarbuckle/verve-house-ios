//
//  MasterViewController.h
//  airquality
//
//  Created by Michael Arbuckle on 7/17/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DevicesHTTPClient.h"
#import "TableSectionHeader.h"



@interface RuleViewController : UITableViewController <  UIActionSheetDelegate, DevicesHTTPClientDelegate,UIGestureRecognizerDelegate,SectionHeaderViewDelegate>


@end


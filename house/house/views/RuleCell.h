//
//  RuleCell.h
//  airquality
//
//  Created by Michael Arbuckle on 7/18/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#ifndef RuleCell_h
#define RuleCell_h
#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface RuleCell: MGSwipeTableCell

@property (nonatomic) IBOutlet UIImageView*   icon;
@property (nonatomic) IBOutlet UILabel*   name;
@property (nonatomic) IBOutlet UILabel*  message;
@property (nonatomic) IBOutlet UILabel*  topic;
@property (nonatomic) IBOutlet UILabel*  recommendation;
@property (nonatomic) IBOutlet UISwitch*   enabled;
@property (nonatomic) IBOutlet UIScrollView*   whenList;
@property (nonatomic) IBOutlet UIScrollView*   thenList;

@end

#endif /* RuleCell_h */

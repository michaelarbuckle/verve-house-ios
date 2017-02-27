//
//  ActivityCell.h
//  airquality
//
//  Created by Michael Arbuckle on 7/18/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#ifndef ActivityCell_h
#define ActivityCell_h
#import <UIKit/UIKit.h>

@interface ActivityCell: UITableViewCell

@property (nonatomic) IBOutlet UILabel*    status;
@property (nonatomic) IBOutlet UIImageView*   icon;
@property (nonatomic) IBOutlet UILabel*  message;
@property (nonatomic) IBOutlet UILabel*  topic;
@property (nonatomic) IBOutlet UILabel*   timestamp;
@property (nonatomic) IBOutlet UILabel*   author;
@end

#endif /* ActivityCell_h */

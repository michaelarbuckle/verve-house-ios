//
//  ActivityCell.h
//  airquality
//
//  Created by Michael Arbuckle on 7/18/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

 #import <UIKit/UIKit.h>

@interface PreferenceCell: UITableViewCell
@property (nonatomic) IBOutlet UILabel*   name;
@property (nonatomic) IBOutlet UIImageView*   greenIcon;
@property (nonatomic) IBOutlet UIImageView*   goldIcon;
@property (nonatomic) IBOutlet UIImageView*   redIcon;
@property (nonatomic) IBOutlet UITextField* max;
@property (nonatomic) IBOutlet UITextField* day;
@property (nonatomic) IBOutlet UITextField* night;
@property (nonatomic) IBOutlet UITextField* min;
@end


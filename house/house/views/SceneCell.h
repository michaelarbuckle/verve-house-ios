//
//  SceneCell.h
//  airquality
//
//  Created by Michael Arbuckle on 7/18/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#ifndef SceneCell_h
#define SceneCell_h
#import <UIKit/UIKit.h>

@interface SceneCell: UITableViewCell

    
@property (nonatomic) IBOutlet UILabel*    status;
@property (nonatomic) IBOutlet UILabel*  measurment;
@property (nonatomic) IBOutlet UIImageView*   icon;
@property (nonatomic) IBOutlet UILabel*   units;
@property (nonatomic) IBOutlet UILabel*   name;
@property (nonatomic) IBOutlet UILabel*   timestamp;
@property (nonatomic) IBOutlet UILabel*   valueType;
@end

#endif /* SceneCell_h */

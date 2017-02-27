//
//  SceneCell.m
//  airquality
//
//  Created by Michael Arbuckle on 7/18/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SceneCell.h"
#import "Scene.h"


@implementation SceneCell
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    NSLog(@"MeasCell init@ithStyle");
    if (self) {
        // Helpers
        //CGSize size = self.contentView.frame.size;
        
        // Initialize Main Label
       // self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 8.0, size.width - 16.0, size.height - 16.0)];
        
        // Configure Main Label
        [self.measurment setFont:[UIFont boldSystemFontOfSize:24.0]];
        [self.measurment setTextColor:[UIColor orangeColor]];
        [self.measurment setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        
        // Add Main Label to Content View
      //  [self.contentView addSubview:self.mainLabel];
    }
    
    return self;
}

- (void) updateData:(Scene*)scene
{
    self.measurment.text = scene.value;
    self.timestamp.text = [NSString stringWithFormat:  @"last updated %@", scene.timestamp];

     self.status.text = @"Normal";
    [self.status setTextColor:[UIColor greenColor]];
    
}

@end

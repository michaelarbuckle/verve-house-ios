//
//  ActivityCell.m
//  airquality
//
//  Created by Michael Arbuckle on 7/18/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ActivityCell.h"
#import "Message.h"


@implementation ActivityCell
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    NSLog(@"MeasCell init@ithStyle");
    if (self) {
        
        // Add Main Label to Content View
      //  [self.contentView addSubview:self.mainLabel];
    }
    
    return self;
}

- (void) updateData:(NSArray*)Activity
{
    
   

 
    
}

@end

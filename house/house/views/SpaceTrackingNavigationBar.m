//
//  SpaceTrackingNavigationBar.m
//  Tabby
//
//  Created by Michael Arbuckle on 12/6/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpaceTrackingNavigationBar.h"

@implementation SpaceTrackingNavigationBar


-(void)layoutSubviews {
    
[super layoutSubviews];

    
    
}
- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat height = 90;
    
    CGSize   newSize = CGSizeMake(self.superview.bounds.size.width, height);
  
    
    return newSize;
}


@end

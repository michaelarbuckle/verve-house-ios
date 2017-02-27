//
//  RuleCell.m
//  airquality
//
//  Created by Michael Arbuckle on 7/18/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RuleCell.h"
#import "Rule.h"


@implementation RuleCell
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    NSLog(@"rule Cell init@ithStyle");
    if (self) {
        // Helpers
        //CGSize size = self.contentView.frame.size;
        
        // Initialize Main Label
       // self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 8.0, size.width - 16.0, size.height - 16.0)];
        
        // Configure Main Label
        [self.name setFont:[UIFont boldSystemFontOfSize:24.0]];
        [self.name setTextColor:[UIColor orangeColor]];
        [self.name setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        
        // Add Main Label to Content View
      //  [self.contentView addSubview:self.mainLabel];
    }
    
    return self;
}

- (void) updateData:(Rule*)rule
{
     self.topic.text=rule.name;
     self.name.text=rule.name;
     self.message.text=rule.message;
    [self updateWhenList:self.whenList ];
    [self updateThenList:self.thenList ];
    self.enabled.on=[NSNumber numberWithBool:rule.enabled];
   
}
-(void)updateWhenList:(UIScrollView*)list
{
    for (id object in self.whenList) {

        NSString* line = (NSString* )object;
        UIButton* b = [self getButtonForCondition:line];
    
    }
}
-(void)updateThenList:(UIScrollView*)list
{
    
}


-(UIButton*)getButtonForCondition:(NSString*)line
{
    UIButton* b= [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, line.length * 10, 35)];
    b.titleLabel.text = @"POS";
    return b;
}
-(UIButton*)getButtonForAction:(NSString*)line
{
    UIButton* b= [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 35,35)];
    b.titleLabel.text = @"POS";
    return b;
}


@end

//
//  TableSectionHeader.m
//  Tabby
//
//  Created by Michael Arbuckle on 11/25/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TableSectionHeader.h"

@implementation TableSectionHeader

- (void)awakeFromNib {
    
    // set the selected image for the disclosure button
    [self.disclosureButton setImage:[UIImage imageNamed:@"carat-open.png"] forState:UIControlStateSelected];
    
    // set up the tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(toggleOpen:)];
    [self addGestureRecognizer:tapGesture];
    NSLog(@"TableSectionHDr awake from NIB selectd=%d",self.disclosureButton.selected);
    
    //init as open
    // toggle the disclosure button state
  //  self.disclosureButton.selected = !self.disclosureButton.selected;

}

- (IBAction)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
}

- (void)toggleOpenWithUserAction:(BOOL)userAction {
    
    NSLog(@"TableSectionHDr toggleOpen=%d selectd=%d section=%@ ",(BOOL)userAction,self.disclosureButton.selected
,self.titleLabel.text);
    
    // toggle the disclosure button state
    self.disclosureButton.selected = !self.disclosureButton.selected;

    NSLog(@"toggle selectd=%d  ",self.disclosureButton.selected);
    
    // if this was a user action, send the delegate the appropriate message
    if (userAction) {
        
        if (self.disclosureButton.selected == 1) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}

@end

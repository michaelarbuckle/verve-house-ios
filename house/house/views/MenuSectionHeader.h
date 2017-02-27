//
//  TableSectionHeader.h
//  Tabby
//
//  Created by Michael Arbuckle on 11/25/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//
#import <UIKit/UIKit.h>


#import <Foundation/Foundation.h>

@protocol MenuSectionHeaderViewDelegate;

@interface MenuSectionHeader: UITableViewHeaderFooterView
@property (nonatomic, weak) IBOutlet UIImageView *icon;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *disclosureButton;
@property (nonatomic, weak) IBOutlet id <MenuSectionHeaderViewDelegate> delegate;

@property (nonatomic) NSInteger section;

- (void)toggleOpenWithUserAction:(BOOL)userAction;

@end

#pragma mark -

/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol MenuSectionHeaderViewDelegate <NSObject>

@optional
- (void)sectionHeaderView:(MenuSectionHeader *)sectionHeaderView sectionOpened:(NSInteger)section;
- (void)sectionHeaderView:(MenuSectionHeader *)sectionHeaderView sectionClosed:(NSInteger)section;

@end

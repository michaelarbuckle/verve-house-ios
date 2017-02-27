//
//  TableSectionHeader.h
//  Tabby
//
//  Created by Michael Arbuckle on 11/25/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//
#import <UIKit/UIKit.h>


#import <Foundation/Foundation.h>

@protocol SectionHeaderViewDelegate;

@interface TableSectionHeader: UITableViewHeaderFooterView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *disclosureButton;
@property (nonatomic, weak) IBOutlet id <SectionHeaderViewDelegate> delegate;

@property (nonatomic) NSInteger section;

- (void)toggleOpenWithUserAction:(BOOL)userAction;

@end

#pragma mark -

/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol SectionHeaderViewDelegate <NSObject>

@optional
- (void)sectionHeaderView:(TableSectionHeader *)sectionHeaderView sectionOpened:(NSInteger)section;
- (void)sectionHeaderView:(TableSectionHeader *)sectionHeaderView sectionClosed:(NSInteger)section;

@end

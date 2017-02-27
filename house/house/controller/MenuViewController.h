//
//  MasterViewController.h
//  airquality
//
//  Created by Michael Arbuckle on 7/17/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DevicesHTTPClient.h"
#import "MenuSectionHeader.h"
#import "MenuCell.h"

@protocol MenuViewControllerDelegate <NSObject>

@required
- (void)itemSelected:(NSObject *)item;
- (void)itemSelected:(NSObject *)item path:(NSString*)path;
- (void)menuPanelClosed;
- (void)menuPanelOpen;

@end





@interface MenuViewController : UIViewController <  DevicesHTTPClientDelegate,UIGestureRecognizerDelegate,MenuSectionHeaderViewDelegate>

@property (nonatomic, assign) id<MenuViewControllerDelegate> delegate;
@property (nonatomic) IBOutlet UIImageView*   headerImage;
@property (nonatomic) IBOutlet UILabel*   houseName;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) IBOutlet MenuCell *MenuCell;
-(void)movePanelRight;
-(void)movePanelToOriginalPosition;

@end


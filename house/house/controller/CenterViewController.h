//
//  CenterViewController.h
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@protocol CenterViewControllerDelegate <NSObject>

@optional
- (void)movePanelRight;
-(void)displayPanel ;
-(void)movePanelRightToPeek;//show icon

@required
- (void)movePanelToOriginalPosition;

@end

@interface CenterViewController : UIViewController <MenuViewControllerDelegate>

@property (nonatomic, assign) id<CenterViewControllerDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *leftButton;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;

@end

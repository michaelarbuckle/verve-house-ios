//
//  MainViewController.h
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
@interface MainViewController : UIViewController < MenuViewControllerDelegate>


-(void)displayPanel ;
-(void)movePanelRightToPeek;//show icon
-(void)movePanelRight;
-(void)movePanelToOriginalPosition;




@end

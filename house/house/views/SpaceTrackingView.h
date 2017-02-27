//
//  SpaceTrackingView.h
//  Tabby
//
//  Created by Michael Arbuckle on 11/22/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CustomBadge.h"
@interface SpaceTrackingView : UIView
@property (nonatomic, strong) UIViewController* cntlr;
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CustomBadge *warningBadge;
@property (nonatomic, strong) CustomBadge *hazardBadge;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (atomic, strong) NSString *spaceName;
@property   NSInteger warningCount;
@property   NSInteger hazardCount;
@end

@interface SpaceTrackingPopupView : UICollectionView



@end
 

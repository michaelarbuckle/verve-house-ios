//
//  SpaceTrackingView.m
//  Tabby
//
//  Created by Michael Arbuckle on 11/22/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "SpaceTrackingView.h"

@implementation SpaceTrackingView 


-(id)init
{
    self = [super init];
    CGSize minImageSize=CGSizeMake(5, 5);
    int bottomMargin = 5;
    int sideMargin = 10;
    CGSize  badgeSz=CGSizeMake(25, 25);
    int  labelHeight=30;
    CGSize maximumLabelSize = CGSizeMake(128,32);
    CGSize titleFrameSize = CGSizeMake(128,64);
    CGSize iconFrameSize = CGSizeMake(128,72);
    
    self.frame=CGRectMake(0, 0, titleFrameSize.width, titleFrameSize.height);

    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, titleFrameSize.height, titleFrameSize.width, titleFrameSize.height)];
    self.titleLabel = [[UILabel  alloc ]init];
    
    self.titleLabel.text = self.spaceName;
    self.titleLabel.text = @"outdoor zone"; //;self.spaceName;

    self.hazardCount = 2;
    self.warningCount = 3;
    
    
    CGSize expectedLabelSize = [self.titleLabel.text  sizeWithFont:self.titleLabel.font
                                      constrainedToSize:maximumLabelSize
                                          lineBreakMode:self.titleLabel.lineBreakMode];
    
    
    CGFloat xTitleMargin = (titleFrameSize.width- expectedLabelSize.width)/2;
    CGRect titleFrame = CGRectMake( 0 , titleFrameSize.height -30 , expectedLabelSize.width,expectedLabelSize.height);
    
//    CGRect titleFrame = CGRectMake( 0 , titleFrameSize.height - expectedLabelSize.height, expectedLabelSize.width,expectedLabelSize.height);

    self.titleLabel.frame = titleFrame;
    
    
    CGPoint ctr = self.contentView.center;

    self.titleLabel.center = CGPointMake(ctr.x,self.titleLabel.center.y);

    CGRect ovalFrame = CGRectMake(0, 0, titleFrameSize.width, titleFrameSize.height);
    CGRect hazardBadgeFrame = CGRectMake(ctr.x + iconFrameSize.height/2 - 3.0, badgeSz.height/2 -2.0, badgeSz.width, badgeSz.height);
    
    CGRect warningBadgeFrame = CGRectMake(ctr.x + iconFrameSize.height/2  -3.0,  - badgeSz.height/2. -2.0 , badgeSz.width, badgeSz.height);
    
    CGRect imageFrame = CGRectMake(0, 0, titleFrameSize.width-2*sideMargin, titleFrameSize.height- expectedLabelSize.height - bottomMargin);
    imageFrame = CGRectMake(0,0, 64, 64);
    
    UIColor* redClr =[UIColor colorWithHue:0 saturation:97 brightness:99 alpha:1.0];
    UIColor* greenClr = [UIColor colorWithHue:120.0 saturation:100.0 brightness: 76.0 alpha:1.0 ];
    UIColor* goldClr = [UIColor colorWithHue:49 saturation:98 brightness:98 alpha: 1.0];
    
   BadgeStyle* gbs = [BadgeStyle freeStyleWithTextColor:[UIColor blueColor] withInsetColor:goldClr withFrameColor:[UIColor blackColor] withFrame:YES withShadow:NO withShining:NO withFontType: BadgeStyleFontTypeHelveticaNeueMedium];

    BadgeStyle* rbs = [BadgeStyle freeStyleWithTextColor:[UIColor blackColor] withInsetColor:redClr withFrameColor:[UIColor blackColor] withFrame:YES withShadow:NO withShining:NO withFontType: BadgeStyleFontTypeHelveticaNeueMedium];
  
    
    NSString *hzStr = [NSString stringWithFormat: @"%ld", (long)self.hazardCount];
    self.hazardBadge =[CustomBadge customBadgeWithString:hzStr withScale:1.0 withStyle:rbs ];//]BadgeStyle.defaultStyle];
  //  self.hazardBadge.badgeStyle.badgeInsetColor = redClr;

    self.hazardBadge.frame = hazardBadgeFrame;
    
    NSString *inStr = [NSString stringWithFormat: @"%ld", (long)self.warningCount];
    self.warningBadge =[CustomBadge customBadgeWithString:inStr withScale:1.0 withStyle:gbs];
    //self.warningBadge.badgeStyle.badgeInsetColor = goldClr;
    self.warningBadge.frame = warningBadgeFrame;
    
    UIImage *image = [UIImage imageNamed:@"house-stone.png"];
    
    self.imageView.image = image;
    self.imageView.frame = imageFrame;
    
CALayer *sublayer = [CALayer layer];
/*
sublayer.backgroundColor = [UIColor blueColor].CGColor;
sublayer.shadowOffset = CGSizeMake(0, 3);
sublayer.shadowRadius = 5.0;
sublayer.shadowColor = [UIColor blackColor].CGColor;
sublayer.shadowOpacity = 0.8;
*/
sublayer.frame = CGRectMake(30,-18, 78, -78);


[self displayLayer:sublayer];
    
[self.contentView.layer addSublayer:sublayer];

 //[self.layer addSublayer:sublayer];

    
[self addSubview:self.contentView];
[self addSubview:self.imageView];
[self addSubview:self.titleLabel];
[self addSubview:self.hazardBadge];
[self addSubview:self.warningBadge];
    
    self.center = CGPointMake(ctr.x,self.center.y);

    
self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popover:)];
[self addGestureRecognizer:self.tapGesture];
   
return self;

}
-(void)displayLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContext(layer.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat ht = layer.frame.size.height;
    CGFloat wd = ht;
    
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0.0, 0.0, wd-6.0,ht-6.0)];
    [[UIColor whiteColor] setFill];
    [ovalPath fill];
    [[UIColor greenColor] setStroke];
    ovalPath.lineWidth = 3;
    [ovalPath stroke];
//    UIImage *image = [UIImage imageNamed:@"house-stone.png"];
    UIImage *image = [UIImage imageNamed:@"house64gray.png"];
    

    CGFloat imgXStrt = (wd - 64.0)/3;
    [image drawInRect:CGRectMake(imgXStrt, imgXStrt, 64, 64)];
    

    
    UIImage *imageBuffer = UIGraphicsGetImageFromCurrentImageContext();
    
    
    UIGraphicsEndImageContext();
    
    layer.contents = (id)[imageBuffer CGImage];
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    //Do stuff here...
}

-(void)popover:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"cliecked popover button");
    UICollectionViewController* pvc = [[UICollectionViewController alloc] init];

    UIPopoverController* aPopover = [[UIPopoverController alloc] initWithContentViewController:pvc];
    aPopover.delegate = self.cntlr;
    [self.cntlr presentViewController:aPopover animated:YES completion:nil];
}
/*

CALayer *sublayer = [CALayer layer];
sublayer.backgroundColor = [UIColor blueColor].CGColor;
sublayer.shadowOffset = CGSizeMake(0, 3);
sublayer.shadowRadius = 5.0;
sublayer.shadowColor = [UIColor blackColor].CGColor;
sublayer.shadowOpacity = 0.8;
sublayer.frame = CGRectMake(30, 30, 128, 192);
sublayer.borderColor = [UIColor blackColor].CGColor;
sublayer.borderWidth = 2.0;
sublayer.cornerRadius = 10.0;
[self.view.layer addSublayer:sublayer];

CALayer *imageLayer = [CALayer layer];
imageLayer.frame = sublayer.bounds;
imageLayer.cornerRadius = 10.0;
imageLayer.contents = (id) [UIImage imageNamed:@"BattleMapSplashScreen.jpg"].CGImage;
imageLayer.masksToBounds = YES;
[sublayer addSublayer:imageLayer];



UIBezierPath *bpath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, y, width, height)];

*/





@end

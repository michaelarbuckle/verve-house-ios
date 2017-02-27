//
//  DemoBaseViewController.h
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 13/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

#import <UIKit/UIKit.h>
#import "house-Swift.h"
#import "ChartConstants.h"

@import Charts;
@interface DemoBaseViewController : UIViewController
{

  /*@protected
    NSString* title;
    NSString* type;
    enum timescale scale;
    NSString* units;
    NSString* description;
    NSArray *valueTimestamps;
    NSArray *values;
    NSArray *annotation;
    NSArray *annotationTimestamps;
*/
}
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic, strong) IBOutlet UIButton *optionsButton;
@property (nonatomic, strong) IBOutlet NSArray *options;

@property (nonatomic, assign) BOOL shouldHideData;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* units;
@property (nonatomic, copy) NSString* type;
@property (nonatomic, copy) NSString* labelX;
@property (nonatomic, copy) NSString* labelY;


- (void)handleOption:(NSString *)key forChartView:(ChartViewBase *)chartView;

- (void)updateChartData;

@end

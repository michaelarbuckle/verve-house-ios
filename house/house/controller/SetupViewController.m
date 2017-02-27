//
//  MasterViewController.m
//  airquality
//
//  Created by Michael Arbuckle on 7/17/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//
#import "SetupViewController.h"
#import "SensorChartViewController.h"
#import "SpaceTrackingView.h"
#import "house-Swift.h"

@interface SetupViewController ()

@property NSDictionary *properties;
@property NSMutableArray *messages;
@property NSMutableArray *steps;


@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSTimer *minuteTimer;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;


@end


@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSDate *date = [NSDate date];
    // Do any additional setup after loading the view, typically from a nib.
    //    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *rightBtnImage = [UIImage imageNamed:@"magnifying-glass.png"];
    UIImage *rightBtnImagePressed = [UIImage imageNamed:@"magnifying-glass.png"];
    [rightBtn setBackgroundImage:rightBtnImage forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:rightBtnImagePressed forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(insertNewMessage:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 24, 24);
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,32, 32)];
    rightButtonView.bounds = CGRectOffset(rightButtonView.bounds, 0, 45);

    [rightButtonView addSubview:rightBtn];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];

    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftBtnImage = [UIImage imageNamed:@"menu-alt32.png"];
    UIImage *leftBtnImagePressed = [UIImage imageNamed:@"menu-alt32.png"];
    [leftBtn setBackgroundImage:leftBtnImage forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:leftBtnImagePressed forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(0, 0, 32, 32);
 //   leftBtn.bounds =CGRectOffset(leftBtn.bounds, 0, 37);
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,32, 32)];
//leftButtonView.bounds = CGRectOffset(leftButtonView.bounds, 0, 37);
    
    [leftButtonView addSubview:leftBtn];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:  leftButtonView ];//-
    [leftButton  setTarget:self ];    
    [leftButton setAction:@selector(retrieveSensorData:) ];
    self.navigationItem.leftBarButtonItem = leftButton;
  
                         
    SpaceTrackingView* titleView = [[SpaceTrackingView alloc] init];
     titleView.center = CGPointMake(self.view.center.x,titleView.center.y);
    

    self.navigationItem.titleView = titleView;//[[UIImageView alloc] initWithImage:image];
    
    
    
       
    
    
    NSDate *oneMinuteFromNow = [date dateByAddingTimeInterval:60];
    
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *timerDateComponents = [self.calendar components:unitFlags fromDate:oneMinuteFromNow];
    timerDateComponents.second = 1;
    NSDate *minuteTimerDate = [self.calendar dateFromComponents:timerDateComponents];
    
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:minuteTimerDate interval:60 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.minuteTimer = timer;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
  //  self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewMessage:(id)sender {
    
    NSLog(@"insertNewMessage");
    
    if (!self.messages) {
        self.messages = [[NSMutableArray alloc] init];
    }
    [self.messages insertObject: @"test message @10a.m. \(self.messages.count)"  atIndex:0];
 }

- (void)connectDevices:(id)sender {
    NSLog(@"connect deivces not implemeneted");
}


-(void)setupPage:(int)page
{
         //LABEL   NO DEVICES AVAILABLE    HT = CTR + 60
        //LABEL   CONNECT TO THE CLOUD    HT = CTR + 30
        //ICON    CLOUD                   CTR
        //LABEL   FIND LOCAL DEVICES      HT  = CTR - 35
        //ICON    WIFI SIGNAL              HT = CTR - 65
        
        
        UIView *noDevicesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        CGPoint viewCtr =  [noDevicesView convertPoint:noDevicesView.center fromView:noDevicesView.superview];
        CGPoint lblNoDev = CGPointMake(viewCtr.x,viewCtr.y-60);
        CGPoint lblCloud = CGPointMake(viewCtr.x,viewCtr.y-30);
        CGPoint icnCloud = viewCtr;
        CGPoint lblLocal = CGPointMake(viewCtr.x,viewCtr.y+35);
        CGPoint icnLocal = CGPointMake(viewCtr.x,viewCtr.y+65);
        
        
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        noDataLabel.text             = @"No devices available";
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        noDataLabel.center = lblNoDev;
        
        UILabel *cloudLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        cloudLabel.text             = @"Connect to the cloud at verve.house.";
        cloudLabel.textColor        = [UIColor blackColor];
        cloudLabel.textAlignment    = NSTextAlignmentCenter;
        cloudLabel.center = lblCloud;
        
        UILabel *localLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        localLabel.text             = @"Discover local devices.";
        localLabel.textColor        = [UIColor blackColor];
        localLabel.textAlignment    = NSTextAlignmentCenter;
        localLabel.center = lblLocal;
        
        
        UIButton  *btnCloud = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //set the button size and position
        btnCloud.frame = CGRectMake(85.0f, 100.0f, 64.0f, 64.0f);
        
        //set the button title for the normal state
        [btnCloud setImage:[UIImage imageNamed:@"cloud.png"]
                  forState:UIControlStateNormal];
        //add action to capture the button press down event
        [btnCloud addTarget:self
                     action:@selector(retrieveSensorData:)
           forControlEvents:UIControlEventTouchDown];
        btnCloud.center = icnCloud;
        
        UIButton  *btnLocal = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //set the button size and position
        btnLocal.frame = CGRectMake(85.0f, 100.0f, 64.0f, 64.0f);
        
        //set the button title for the normal state
        [btnLocal setImage:[UIImage imageNamed:@"devicesignal.png"]
                  forState:UIControlStateNormal];
        //add action to capture the button press down event
        [btnLocal addTarget:self
                     action:@selector(connectDevices:)
           forControlEvents:UIControlEventTouchDown];
        
        btnLocal.center = icnLocal;
        
        
        
        [noDevicesView addSubview:noDataLabel];
        [noDevicesView addSubview:cloudLabel];
        [noDevicesView addSubview:btnCloud];
        [noDevicesView addSubview:localLabel];
        [noDevicesView addSubview:btnLocal];
        
    [self.view addSubview:noDevicesView];
  

}

- (void)update {
    NSDate *date = [NSDate date];
    
}

- (void)updateTimer:(NSTimer *)timer {
    /*   NSArray *visibleCells = self.tableView.visibleCells;
     for( APLTimeZoneCell *cell in visibleCells ) {
     NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
     [self configureCell:cell forIndexPath:indexPath];
     [cell setNeedsDisplay];
     
     }
     */
}

#pragma mark - Accessors

- (NSDateFormatter *)dateFormatter {
    if( !_dateFormatter ) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"h:mm a 'on' MMM dd" options:0 locale:[NSLocale currentLocale]];
        _dateFormatter.dateFormat = dateFormat;
    }
    return _dateFormatter;
}

- (void)setMinuteTimer:(NSTimer *)newTimer {
    
    if (_minuteTimer != newTimer) {
        [_minuteTimer invalidate];
        _minuteTimer = newTimer;
    }
}

@end

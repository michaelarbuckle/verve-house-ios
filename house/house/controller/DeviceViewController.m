//
//  MasterViewController.m
//  airquality
//
//  Created by Michael Arbuckle on 7/17/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//
#import "MGSwipeTableCell.h"
#import "DeviceViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "MenuViewController.h"
#import "SensorChartViewController.h"
#import "MeasurableCell.h"
#import "NSDictionary+sensor.h"
#import "SpaceTrackingView.h"
#import "house-Swift.h"

typedef void(^DeviceActionCallback)(BOOL cancelled, BOOL deleted, NSInteger actionIndex);

@interface DeviceViewController ()
{
    DeviceActionCallback  actionCallback;
    
}
@property (strong, nonatomic) MenuViewController* menuViewController;

@property NSDictionary *deviceResults;//result o
@property NSMutableArray *devices;
@property NSMutableArray *sensorDefs;
@property NSMutableDictionary *sensorMeasurables;
@property NSMutableArray *measurands;
@property NSMutableArray* sectionIsOpen;
@property NSArray* sections;
@property int sectionCount;
@property NSString* space;

@property NSMutableArray *messages;

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSTimer *minuteTimer;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;


@end
int maxSections=10;
BOOL sectionIsOpen[10];


@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.separatorColor = [UIColor grayColor];
    // self.tableView.separatorInset = UIEdgeInsetsMake(0, 1, 0, 11);
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLineEtched;
    
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
    titleView.spaceName = self.space;
    titleView.center = CGPointMake(self.view.center.x,titleView.center.y);
    

    self.navigationItem.titleView = titleView;//[[UIImageView alloc] initWithImage:image];
    
    self.chartViewController = (DemoBaseViewController *)[[self.navigationController.viewControllers lastObject] parentViewController];
    
    self.title = @"devices";

    self.devices =[[NSMutableArray alloc]init];
    self.measurands =[[NSMutableArray alloc]init];
    self.messages =[[NSMutableArray alloc]init];
    self.sensorMeasurables =[[NSMutableDictionary alloc]init];
    
    NSString* currentTimeStamp = [self.dateFormatter stringFromDate:date ];
    
    for (int i = 0; i < maxSections; i++){
        sectionIsOpen[i] =YES;
    }
    self.sections = @[@"sensors",@"systems",@"appliances"];
    
    self.sensorDefs =@[
                        @{
                            @"title": @"Temperature",
                            @"subtitle": @"Current and Past Temperatures.",
                            @"status:": @"Initializing",
                            @"units":@"C",
                            @"class": @"",//LineChart1ViewController.class,
                            @"icon": @"temperature_green.png",
                            @"measurement": @"18.3",
                            @"valuetype" : @"sample",
                            @"enabled" : @"false",
                            @"timestamp" : currentTimeStamp
                            },
                        @{
                            @"title": @"Humidity",
                            @"subtitle": @"Current and Past Atmospheric Behaviour",
                            @"status:": @"Initializing",
                            @"units":@"%",
                            @"class": @"",//MultipleLinesChartViewController.class,
                            @"icon" : @"humidity_green.png",
                            @"measurement": @"75.0",
                            @"valuetype" : @"sample",
                            @"enabled" : @"false",
                           @"timestamp" : currentTimeStamp
                            },
                        @{
                            @"title": @"Pressure",
                            @"subtitle": @"Current and Past Atmospheric Behaviour",
                            @"status:": @"Initializing",
                            @"units":@"mbar",
                            @"class": @"",//MultipleLinesChartViewController.class,
                            @"icon" : @"pressure_green.png",
                            @"measurement": @"1013.25",
                            @"valuetype" : @"sample",
                            @"enabled" : @"false",
                            @"timestamp" : currentTimeStamp
                            },
                        @{
                            @"title": @"Dust Particles",
                            @"subtitle": @"Current and Past Atmospheric Behaviour",
                            @"status:": @"Initializing",
                            @"units":@"mg/m^3",
                            @"class": @"",//MultipleLinesChartViewController.class,
                            @"icon" : @"dust_green.png",
                            @"measurement": @"2.5",
                            @"valuetype" : @"sample",
                            @"enabled" : @"false",
                            @"timestamp" : currentTimeStamp
                            },
                        @{
                            @"title": @"CO2",
                            @"subtitle": @"Current and Past Atmospheric Behaviour",
                            @"status:": @"Initializing",
                            @"units":@"ppm",
                            @"class": @"",//MultipleLinesChartViewController.class,
                            @"icon" : @"CO2_green.png",
                            @"measurement": @"400",
                            @"valuetype" : @"mean",
                            @"enabled" : @"false",
                            @"timestamp" : currentTimeStamp
                            },
                        @{
                            @"title": @"VOCs",
                            @"subtitle": @"Current and Past Atmospheric Behaviour",
                            @"status:": @"Normal",
                            @"units":@"ppm",
                            @"class": @"",//MultipleLinesChartViewController.class,
                            @"icon" : @"VOC_green.png",
                            @"measurement": @"720",
                            @"valuetype" : @"sample",
                            @"enabled" : @"false",
                            @"timestamp" : currentTimeStamp
                            },
                        @{
                            @"title": @"Radon Gas",
                            @"subtitle": @"Current and Past Atmospheric Behaviour",
                            @"status:": @"Initializing",
                            @"units":@"Becq/m^3",
                            @"class":@"",// ProgressViewController.class,
                            @"icon" : @"radon_green.png",
                            @"measurement": @"40",
                            @"valuetype" : @"mean",
                            @"enabled" : @"false",
                            @"timestamp" : currentTimeStamp
                            }
                        ,
                        @{
                            @"title": @"Electromagnetic Field",
                            @"subtitle": @"Current and Past  Behaviour",
                            @"status:": @"Initializing",
                            @"units":@"mW/cm^2",//@"V/m"
                            @"class":@"",// ProgressViewController.class,
                            @"icon" : @"radon_green.png",
                            @"measurement": @"40",
                            @"valuetype" : @"mean",
                            @"enabled" : @"false",
                            @"timestamp" : currentTimeStamp
                            }

                        ];
    
    
       
    
    
    NSDate *oneMinuteFromNow = [date dateByAddingTimeInterval:60];
    
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *timerDateComponents = [self.calendar components:unitFlags fromDate:oneMinuteFromNow];
    timerDateComponents.second = 1;
    NSDate *minuteTimerDate = [self.calendar dateFromComponents:timerDateComponents];
    
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:minuteTimerDate interval:60 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.minuteTimer = timer;
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"TableSectionHeader" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"TableSectionHeader"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)connectDevices:(id)sender {
    NSLog(@"connect deivces not implemeneted");
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
#pragma mark - web_services

- (IBAction)retrieveSensorData:(id)sender
{
    // 1
    NSString *string = [NSString stringWithFormat:@"%@sensors", BaseURLString];

    NSLog(@"retrieveSensorData starting webservice call to %@",string);

    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    // 2
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json",@"application/json", @"text/json", @"text/javascript", @"text/html",@"application/hal+json;charset=UTF-8",@"application/json;charset=UTF-8", nil];
    
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        // 3
       NSDictionary* sensorResults = (NSDictionary *)responseObject;
        
        self.title = @"JSON Retrieved";
        self.sensorMeasurables = [self  getSensorsFromJSONResponse:sensorResults];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
    
    // 5
    NSLog(@"figure out if need something more to call web service");
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = self.sections.count;
    
    UITableView* table = (UITableView *)self.view;
    
    if (self.sensorMeasurables.count > 0)
    {return 1;}
    else if (self.devices.count == 0)
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
        
        //initWithImage:[UIImage imageNamed:@"profile-24.png"]
        
        table.backgroundView = noDevicesView;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
    
    return numOfSections;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
     return self.sensorDefs.count;
    else
     return self.sensorMeasurables.count;
    
    /*
    if (!sectionIsOpen[section]) {
        ///we just want the header cell
        return 1;
        
    } else {
    
    if (self.devices.count == 0)
        return 0;
    
    if (section == 1)
        return self.sensorDefs.count+1;
    else
        return self.messages.count+1;
    
    }
    */
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    NSLog(@"cellForRow section %d row %d",indexPath.section,indexPath.row);
    UITableViewCell *cell = NULL;
    @try
    {  if( indexPath.section == 0)
    {
        NSDictionary *def = self.sensorDefs[indexPath.row];
        
        MeasurableCell* mcell = (MeasurableCell*)[tableView dequeueReusableCellWithIdentifier:@"MeasurableCell"];
        
        if (!mcell)
        {
            mcell = [[MeasurableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MeasurableCell"];
        }
        
        mcell.delegate = self;

        NSLog(@"cellForRow title=%@ units=%@",def[@"title"],def[@"units"]);
        
        mcell.name.text = def[@"title"];
        mcell.units.text = def[@"units"];
        //   mcell.icon;
        mcell.status.text = @"Normal";
        mcell.valueType.text = def[@"valuetype"];
        mcell.icon.image = [UIImage imageNamed:def[@"icon"]];
        Measurand* m = self.sensorMeasurables[def[@"title"]];
        NSLog(@"measurand name=%@ value %@",m.name,m.value);
        
        if (m)
        {
            mcell.measurment.text = m.value;
            mcell.timestamp.text = m.timestamp;
            
        } else
        {
            NSLog(@" no measurand " );
            
            mcell.measurment.text = def[@"measurement"];
            mcell.timestamp.text = def[@"timestamp"];
            
            if ([mcell.name.text  isEqual: @"Temperature"])
            {
                mcell.status.text = @"Sunstroke Alert";
                [mcell.status setTextColor:[UIColor redColor]];
            }
            
            
            if ([mcell.name.text  isEqual: @"Dust Particles"])
            {
                mcell.status.text = @"Pollen Alert";
                [mcell.status setTextColor:[UIColor orangeColor]];
            }
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, mcell.contentView.frame.size.height - 1.0, mcell.contentView.frame.size.width, 1)];
        
        lineView.backgroundColor = [UIColor grayColor];
        [mcell.contentView addSubview:lineView];
        
        mcell.detailTextLabel.numberOfLines = 0;
        return mcell;
    } else
    {
        NSString* messageText = @"messages text";
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        }
        
        cell.textLabel.text = @"alert";
        cell.detailTextLabel.text = messageText;
        cell.detailTextLabel.numberOfLines = 0;
        
    }
         } @catch (NSException *exception) {
             NSLog(@"exception %@",exception);
            
        } @finally {
             
        }
    return cell;
}


-(void)launchChartForMeasurand:(Measurand*)measurand series:(MeasurableSeries*)mSeries
{
//    Class vcClass = SensorChartViewController.class;//def[@"class"];
//    SensorChartViewController *vc = [[vcClass alloc] init];
    
    
    SensorChartViewController *vc = [[SensorChartViewController alloc] init];
    [vc  setMeasurand:measurand series: mSeries];
    
    [self.navigationController pushViewController:vc animated:YES];
  
}

- (void)showMenu:(id)sender {
    NSLog(@"devcCtlr.showMenu");

    if (self.menuViewController == nil)
    {
        NSLog(@"menuVwCtlr == nil");
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.menuViewController  = [sb instantiateViewControllerWithIdentifier:@"MenuViewController"];
        
        // = [[MenuViewController alloc] init];
        
        //  self.menuViewController.view.tag = LEFT_PANEL_TAG;
        self.menuViewController.delegate = self;
        
     [self.view addSubview:self.menuViewController.view];
        
        [self addChildViewController:self.menuViewController];
        [self.menuViewController didMoveToParentViewController:self];
    
       // self.menuViewController.view.alpha = 0;
        
        
        self.menuViewController.view.frame = CGRectMake(0, -100, self.view.frame.size.width/2, self.view.frame.size.height);
    }

     [self.view bringSubviewToFront:self.menuViewController.view];

    //[self presentViewController:self.menuViewController animated:YES completion: nil];

    
    NSLog(@" menuFrame x=%f y=%f w=%f h=%f",
    self.menuViewController.view.frame.origin.x,
    self.menuViewController.view.frame.origin.y,
    self.menuViewController.view.frame.size.width,
          self.menuViewController.view.frame.size.height);
    /*
    [UIView animateWithDuration:2.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.menuViewController.view.frame = CGRectMake(0, 0, 240, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             NSLog(@"animate menu");
                         }
                     }];
    */
    
  //  [self presentViewController:self.menuViewController animated:YES completion: nil];

     /*
    [self displayPanel];    
      MainViewController *rc =(MainViewController*)[[(AppDelegate*)
                                                               [[UIApplication sharedApplication]delegate] window] rootViewController];
 
    [rc displayPanel];
//    [rc movePanelRight];
*/

}

-(void)launchActionForMeasurand:(Measurand*)measurand
{
    ActionPopupController *apc  = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"ActionPopupController"];
    [self.navigationController pushViewController:apc animated:YES];
   
    apc.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    apc.navigationItem.leftItemsSupplementBackButton = YES;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)//sensors
    {
         if (indexPath.row == 0) {
            ///it's the first row of any section so it would be your custom section header
            
            ///put in your code to toggle your boolean value here
             sectionIsOpen[indexPath.section]=sectionIsOpen[indexPath.section];
            
            ///reload this section
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
         } else {
    NSDictionary *def = self.sensorDefs[indexPath.row];
    
    Class vcClass = def[@"class"];
    UIViewController *vc = [[vcClass alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

         }
    } else if (indexPath.section == 1)//systems
    {
    }
    
         
         }

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TableSectionHeader *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableSectionHeader"];
    
   
    NSString* name = [self.sections objectAtIndex:section];
    sectionHeaderView.titleLabel.text = name;
    sectionHeaderView.delegate = self;
    
    return sectionHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
       return 45.0;
}
#pragma mark - Segues
/**/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.sensorDefs[indexPath.row];
        
        
        //   vcClass *controllerVC = (vcClass *)[[segue destinationViewController] topViewController];
        
        DemoBaseViewController *controller = (DemoBaseViewController *)[[segue destinationViewController] parentViewController];
        
        
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}



#pragma mark - Table View
/*
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 return 1;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 return self.objects.count;
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
 
 NSDate *object = self.objects[indexPath.row];
 cell.textLabel.text = [object description];
 return cell;
 }
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.messages removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(NSMutableDictionary*)getSensorsFromJSONResponse:(NSDictionary*)json
{
    NSLog(@"getSensorsFromJSON");
    
 NSMutableDictionary* sensors = [[NSMutableDictionary alloc] init];
 NSDictionary* e = (NSDictionary*)json[ @"_embedded"];
 if (e != nil)
 {
     json = e;
 }
 NSArray* sensorArray = (NSArray*)json[ @"sensors"];
 if (sensorArray == nil)
 {
     //for now, log an error
     NSLog(@"No Sensor array");
  
    } else {
     
     for (int i =0;i < sensorArray.count; i++) {
         NSDictionary* sensorDict = (NSDictionary*)sensorArray[i];
          Measurand* s = [sensorDict sensor];
         s.daySeries = [sensorDict daySeries];
         s.weekSeries = [sensorDict weekSeries];

         
         //   [sensors addObject:s];
      //    syntax dict[@"age"] = @5;
         
         NSLog(@"added measurand %@ %@",s.name,s.units);
         
         [self.measurands addObject:s];
         [sensors addEntriesFromDictionary:@{s.type: s}];
      }
    }
     return sensors;
 }
    


 
-(Measurand*) measurandForIndexPath:(NSIndexPath*)path
{
    
    Measurand* m=[self.measurands objectAtIndex:path.row];
    return m;
}


-(void) updateCellIndicactor:(Measurand*) mail cell:(MeasurableCell*) cell
{
    UIColor * color;
    UIColor * innerColor;
 /*   if (mail.) {
        color = [UIColor colorWithRed:1.0 green:149/255.0 blue:0.05 alpha:1.0];
        innerColor = [UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
    }
    else if (mail.flag) {
        color = [UIColor colorWithRed:1.0 green:149/255.0 blue:0.05 alpha:1.0];
    }
    else if (mail.read) {
        color = [UIColor clearColor];
    }
    else {
        color = [UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
    }
    
    cell.indicatorView.indicatorColor = color;
    cell.indicatorView.innerColor = innerColor;
  */
}

-(void) showSensorActions:(Measurand *) mail callback:(DeviceActionCallback) callback
{
    actionCallback = callback;
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Trash" otherButtonTitles: @"ventilate",@"show in timeline", @"alarm", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    actionCallback(buttonIndex == actionSheet.cancelButtonIndex, buttonIndex == actionSheet.destructiveButtonIndex, buttonIndex);
    actionCallback = nil;
}
#pragma mark Swipe Delegate

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction;
{
    return YES;
}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings
{
    
    swipeSettings.transition = MGSwipeTransitionBorder;
    expansionSettings.buttonIndex = 0;
    
    __weak DeviceViewController * me = self;
    
    Measurand * mail = [me measurandForIndexPath:[self.tableView indexPathForCell:cell]];
    
    if (direction == MGSwipeDirectionLeftToRight) {
        
        expansionSettings.fillOnTrigger = NO;
        expansionSettings.threshold = 2;
        return @[[MGSwipeButton buttonWithTitle:@"Pin" backgroundColor:[UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0] padding:5 callback:^BOOL(MGSwipeTableCell *sender) {
            
            Measurand * mail = [me measurandForIndexPath:[me.tableView indexPathForCell:sender]];
            [me updateCellIndicactor:mail cell:(MeasurableCell*)sender];
            [cell refreshContentView];
            //needed to refresh cell contents while swipping
            
            //change button text
            [(UIButton*)[cell.leftButtons objectAtIndex:0] setTitle:@"Unpin"forState:UIControlStateNormal];
            
            return YES;
        }]];
    }
    else {
        
        expansionSettings.fillOnTrigger = YES;
        expansionSettings.threshold = 1.1;
        
        CGFloat padding = 15;
        //icon: [UIImage imageNamed:@"Data-Line-Chart-icon.png"]
        MGSwipeButton * chart = [MGSwipeButton buttonWithTitle:@"Chart"  backgroundColor:[UIColor colorWithRed:1.0 green:59/255.0 blue:50/255.0 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            
            NSIndexPath * indexPath = [me.tableView indexPathForCell:sender];
           
            Measurand * measurand = [me measurandForIndexPath:indexPath];
            
            [self launchChartForMeasurand: measurand  series: measurand.daySeries];
            
            //open chart
            return NO; //don't autohide to improve delete animation
        }];
        //icon: [UIImage imageNamed:@"more@2x.png"]
        MGSwipeButton * more = [MGSwipeButton buttonWithTitle:@"Actions"   backgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:205/255.0 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            
            NSIndexPath * indexPath = [me.tableView indexPathForCell:sender];
            Measurand * measurand = [me measurandForIndexPath:indexPath];
            MeasurableCell * cell = (MeasurableCell*) sender;
            
            
            ActionPopupController* apc =[[ActionPopupController alloc] initWithNibName:@"ActionPopupController" bundle:nil];
            apc.measurand = measurand;
           
         //   [self.navigationController presentModalViewController:apc animated:YES];
            [self presentViewController:apc
                               animated:YES
                             completion:^(){
                                 //put your code here
                             }];

         /*   [me showSensorActions:measurand callback:^(BOOL cancelled, BOOL deleted, NSInteger actionIndex) {
                if (cancelled) {
                    return;
                }
                if (actionIndex == 1)
                {
                 
                    NSLog(@"action 1 on cell %@",cell);
                    [cell refreshContentView]; //needed to refresh cell contents while swipping
                }
                else if (actionIndex == 2)
                {
                    NSLog(@"action 2 on cell %@",cell);
                    
                   [self launchActionForMeasurand:measurand];
                }
                
                [cell hideSwipeAnimated:YES];
                
            }];
          
          */
            return NO; //avoid autohide swipe
        }];
        
        return @[chart,  more];
    }
    
    return nil;
    
}

-(void) swipeTableCell:(MGSwipeTableCell*) cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive
{
    NSString * str;
    switch (state) {
        case MGSwipeStateNone: str = @"None"; break;
        case MGSwipeStateSwippingLeftToRight: str = @"SwippingLeftToRight"; break;
        case MGSwipeStateSwippingRightToLeft: str = @"SwippingRightToLeft"; break;
        case MGSwipeStateExpandingLeftToRight: str = @"ExpandingLeftToRight"; break;
        case MGSwipeStateExpandingRightToLeft: str = @"ExpandingRightToLeft"; break;
    }
    NSLog(@"Swipe state: %@ ::: Gesture: %@", str, gestureIsActive ? @"Active" : @"Ended");
}


-(void)displayPanel
{
    
    UIView *childView = [self showMenuView];
    [self.view bringSubviewToFront:childView];
   // self.showingLeftPanel = true;
    
    
}

-(UIView *)showMenuView {
    // init view if it doesn't already exist
    if (self.menuViewController == nil)
    {
        NSLog(@"menuVwCtlr == nil");
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.menuViewController  = [sb instantiateViewControllerWithIdentifier:@"MenuViewController"];
        
        // = [[MenuViewController alloc] init];
        
      //  self.menuViewController.view.tag = LEFT_PANEL_TAG;
        self.menuViewController.delegate = self;
        
        [self.view addSubview:self.menuViewController.view];
        
        [self addChildViewController:self.menuViewController];
        [self.menuViewController didMoveToParentViewController:self];
        
        self.menuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height);
    }
    
    //self.showingLeftPanel = YES;
    
    // setup view shadows
    //[self showTabViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.menuViewController.view;
    return view;
}


@end

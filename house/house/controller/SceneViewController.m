//
//  MasterViewController.m
//  airquality
//
//  Created by Michael Arbuckle on 7/17/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import "SceneViewController.h"

#import "SceneCell.h"
#import "Scene.h"

#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "SpaceTrackingView.h"

@interface SceneViewController ()
@property(nonatomic, strong) NSMutableDictionary *currentDictionary;

@property NSDictionary *defaultScenes;
@property NSMutableArray *scenes;
@property NSMutableArray *groups;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;


@end

@implementation SceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor grayColor];
    // self.tableView.separatorInset = UIEdgeInsetsMake(0, 1, 0, 11);
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLineEtched;
    
    NSDate *date = [NSDate date];
    // Do any additional setup after loading the view, typically from a nib.
    //    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings-24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(insertNewMessage:)];
    //  self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *acctButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile-24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(insertNewMessage:)];
    //self.navigationItem.leftBarButtonItem = acctButton;
    
    
    
    self.title = @"Groups & Scenes";
    
    self.scenes =[[NSMutableArray alloc]init];
    self.groups =[[NSMutableArray alloc]init];
    self.defaultScenes =[[NSDictionary alloc]init];
    
    NSString* currentTimeStamp = [self.dateFormatter stringFromDate:date ];
    
    self.defaultScenes = @{
                        @{
                            @"title": @"Temperature",
                            @"subtitle": @"Current and Past Temperatures.",
                            @"status:": @"Initializing",
                            @"units":@"C",
                            @"class":@"",//LineChart1ViewController.class,
                            @"icon": @"temperature.png",
                            @"measurement": @"18.3",
                            @"valuetype" : @"sample",
                            @"timestamp" : currentTimeStamp
                            }:
                        @"Humidity"};
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 435)];
    scroll.contentSize = CGSizeMake(320, 700);
    scroll.showsHorizontalScrollIndicator = YES;
   
    
  }

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewGroup:(id)sender {
    if (!self.groups) {
        self.groups = [[NSMutableArray alloc] init];
    }
    [self.groups insertObject: @"test message @10a.m. \(self.messages.count)"  atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)insertNewScene:(id)sender {
    if (!self.groups) {
        self.groups = [[NSMutableArray alloc] init];
    }
    [self.groups insertObject: @"test message @10a.m. \(self.messages.count)"  atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - web_services

- (IBAction)jsonTapped:(id)sender
{
    // 1
    NSString *string = [NSString stringWithFormat:@"%@weather.php?format=json", BaseURLString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        // 3
        self.currentDictionary = (NSDictionary *)responseObject;
       
        self.title = @"JSON Retrieved";
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


- (IBAction)clear:(id)sender
{
    self.title = @"";
    self.currentDictionary = nil;
    [self.tableView reloadData];
}
- (IBAction)clientTapped:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"AFHTTPSessionManager"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"HTTP GET", @"HTTP POST", nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];
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


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 2;
   /* if (youHaveData)
    {
        yourTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 2;
        yourTableView.backgroundView = nil;
    }
    else
    {
        UIView *noDevicesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, yourTableView.bounds.size.width, yourTableView.bounds.size.height)];
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, yourTableView.bounds.size.width, yourTableView.bounds.size.height)];
        noDataLabel.text             = @"No devices available";
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        
        UI Button  *connectButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile-24.png"] style:UIButtonStylePlain target:self action:@selector(connectDevices:)];
        
        yourTableView.backgroundView = noDevicesView;
        yourTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    */
    return numOfSections;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    
    if (section == 1)
        return self.defaultScenes.count;
    else if (section == 2)
        return self.scenes.count;
    else
        return self.groups.count;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForRow section %d row %d",indexPath.section,indexPath.row);
    UITableViewCell *scell = NULL;
    if( indexPath.section == 1)
    {
     }
        
    
    return scell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* NSDictionary *def = self.sensorDefs[indexPath.row];
    
    Class vcClass = def[@"class"];
    UIViewController *vc = [[vcClass alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 */
    
    }
#pragma mark - Segues
/**/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.scenes[indexPath.row];
        
        
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
        [self.scenes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark - WeatherHTTPClientDelegate

- (void)weatherHTTPClient:(DevicesHTTPClient *)client didUpdateWithWeather:(id)weather
{
    self.currentDictionary = weather;
    self.title = @"API Updated";
    [self.tableView reloadData];
}

- (void)weatherHTTPClient:(DevicesHTTPClient *)client didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                        message:[NSString stringWithFormat:@"%@",error]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

@end

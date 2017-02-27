//
//  MasterViewController.m
//  airquality
//
//  Created by Michael Arbuckle on 7/17/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import "PreferenceViewController.h"
#import "PreferenceCell.h"

#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"

@interface PreferenceViewController ()
@property(nonatomic, strong) NSMutableDictionary *currentDictionary;

@property NSArray *sensorDefs;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;


@end

@implementation PreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor grayColor];
    // self.tableView.separatorInset = UIEdgeInsetsMake(0, 1, 0, 11);
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLineEtched;
    
    
    
    self.title = @"Sensor Profile";
    
    
    self.sensorDefs = @[ @{   @"name": @"temperature",
                                @"units":@"C",
                              @"greenIcon": @"temperature_green.png",
                              @"goldIcon": @"temperature_gold.png",
                              @"redIcon": @"temperature_red.png",
                            @"max": @"18.3",
                            @"min": @"18.3",
                            @"day": @"18.3",
                            @"night": @"18.3"
                              },
                         @{
                             @"name":  @"humidity",
                            @"units":@"%",
                             @"greenIcon":@"humidity_green.png",
                             @"goldIcon": @"humidity_gold.png",
                             @"redIcon": @"humidity_red.png",
                             @"max": @"18.3",
                             @"min": @"18.3",
                             @"day": @"18.3",
                             @"night": @"18.3"
                             },
                         @{
                             @"name": @"pressure",
                             @"units":@"mbar",
                             @"greenIcon":@"humidity_green.png",
                             @"goldIcon": @"humidity_gold.png",
                             @"redIcon": @"humidity_red.png",
                             @"max": @"18.3",
                             @"min": @"18.3",
                             @"day": @"18.3",
                             @"night": @"18.3"
                             }
                         ,
                         @{
                             @"name":   @"dust",
                             @"units":@"mg/m^3",
                             @"greenIcon":@"humidity_green.png",
                             @"goldIcon": @"humidity_gold.png",
                             @"redIcon": @"humidity_red.png",
                             @"max": @"18.3",
                             @"min": @"18.3",
                             @"day": @"18.3",
                             @"night": @"18.3"
                             }
                         ,
                         @{
                             @"name": @"CO2",
                             @"units":@"ppm",
                             @"greenIcon":@"CO2_green.png",
                             @"goldIcon": @"CO2_gold.png",
                             @"redIcon": @"CO2_red.png",
                             @"max": @"18.3",
                             @"min": @"18.3",
                             @"day": @"18.3",
                             @"night": @"18.3"
                             }
                         ,
                         @{
                             @"name":  @"VOC",
                             @"units":@"ppm",
                             @"greenIcon":@"VOC_green.png",
                             @"goldIcon": @"VOC_gold.png",
                             @"redIcon": @"VOC_red.png",
                             @"max": @"18.3",
                             @"min": @"18.3",
                             @"day": @"18.3",
                             @"night": @"18.3"
                             }
                         ,
                         @{
                             @"name":  @"radon",
                             @"units":@"Becq/m^3",
                             @"greenIcon":@"humidity_green.png",
                             @"goldIcon": @"humidity_gold.png",
                             @"redIcon": @"humidity_red.png",
                             @"max": @"18.3",
                             @"min": @"18.3",
                             @"day": @"18.3",
                             @"night": @"18.3"
                             }
                         ,
                         @{
                             @"name":  @"EMF",
                             @"units":@"mW/cm^2",//@"V/m"
                             @"greenIcon":@"humidity_green.png",
                             @"goldIcon": @"humidity_gold.png",
                             @"redIcon": @"humidity_red.png",
                             @"max": @"18.3",
                             @"min": @"18.3",
                             @"day": @"18.3",
                             @"night": @"18.3"
                             }

                         
                         
                         
                         ];


    
  }

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - web_services
/*
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
*/

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
    NSInteger numOfSections = 1;
     return numOfSections;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      return self.sensorDefs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForRow section %ld row %ld",(long)indexPath.section,(long)indexPath.row);
     PreferenceCell* mcell = (PreferenceCell*)[tableView dequeueReusableCellWithIdentifier:@"PreferenceCell"];
    
    NSDictionary* def = self.sensorDefs[indexPath.row];
    
    mcell.name.text = def[@"name"];
    
    mcell.greenIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_green.png",def[@"name"]]];
    mcell.goldIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_gold.png",def[@"name"]]];
    mcell.redIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_red.png",def[@"name"]]];

    // def[@"units"];
    mcell.max.text = def[@"min"];
    mcell.min.text =def[@"max"];
    mcell.day.text =def[@"day"];
    mcell.night.text =def[@"night"];
    
    
    return mcell;
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


#pragma mark - WeatherHTTPClientDelegate

@end

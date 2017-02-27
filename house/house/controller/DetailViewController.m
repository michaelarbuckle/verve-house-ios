//
//  MasterViewController.m
//  airquality
//
//  Created by Michael Arbuckle on 7/17/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import "DetailViewController.h"

#import "Structure.h"

#import "AFNetworking.h"

@interface DetailViewController ()

@property(nonatomic, strong) NSMutableDictionary *currentDictionary;
@property(nonatomic, strong) NSDictionary *results;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;



@end

@implementation DetailViewController


-(id)initWithData:(NSObject*)data path:(NSString*)path
{
    
    
    self = [super initWithNibName:[NSString stringWithFormat:@"%@.xib" , NSStringFromClass ([data class]) ] bundle:nil];

    self.path = path;
    if ([data class] == [Structure class])
    {
        Structure* structure = (Structure*)data;
        self.title = [NSString stringWithFormat:@"Structure: %@",structure.name];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings-24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(insertNewItem:)];
    //  self.navigationItem.rightBarButtonItem = addButton;
    
    //self.navigationItem.leftBarButtonItem = acctButton;
    
    
    
    self.title = @" ";
    
  
   
    
  }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - web_services
-(NSString*)getDateTimeString
{

return   [self.dateFormatter stringFromDate:[NSDate date] ];
}

-(NSString*)getAuthorization
{
    
    return @"notImpl";
}

- (IBAction)save:(id)sender
{
    NSDictionary* currentValues = (NSDictionary*)self.currentDictionary;
    
    // 1
    NSString *string = [NSString stringWithFormat:@"%@/%@/%@", BaseURLString, self.path,self.itemId];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    // 2
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer  setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer  setValue:@"datetime" forHTTPHeaderField:[self getDateTimeString]];
    [manager.requestSerializer  setValue:@"X-AUTH-TOKEN" forHTTPHeaderField:[self getAuthorization]];
    
    [manager POST:url.absoluteString parameters:currentValues progress:nil success:^(NSURLSessionTask *task, id responseObject)
    {
        NSLog(@"JSON: %@", responseObject);
        // 3
        self.results = (NSDictionary *)responseObject;
       
        self.title = @"JSON saved";
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error saving record"
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



#pragma mark - WeatherHTTPClientDelegate

- (void)weatherHTTPClient:(DevicesHTTPClient *)client didUpdateWithWeather:(id)weather
{
    self.currentDictionary = weather;
    self.title = @"API Updated";
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

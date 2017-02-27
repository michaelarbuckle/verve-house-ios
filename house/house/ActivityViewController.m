//
//  SecondViewController.m
//  Tabby
//
//  Created by Michael Arbuckle on 9/21/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import "ActivityViewController.h"
#import "UIImageView+AFNetworking.h"
//#import "UIScrollView+EmptyDataSet.h"
#import "ActivityCell.h"
#import "SpaceTrackingView.h"
#import "NSDictionary+message.h"


//@interface ActivityViewController ()  <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{}
@interface ActivityViewController ()
@property(nonatomic, strong) NSMutableDictionary *messageResults;
@property(nonatomic, strong) NSMutableArray *messages;
@property(nonatomic, strong) NSMutableArray *messagesByTopic;
@property(nonatomic, strong) NSMutableArray *messagesByTopicDisplayed;
@property(nonatomic, strong) NSMutableArray *topics;



@end

@implementation ActivityViewController
   

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    UIView *NavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , [UIScreen mainScreen].bounds.size.width , 244)];
    NavView.backgroundColor = [UIColor clearColor];
    NavView.userInteractionEnabled = YES;
    [self.navigationController.navigationBar addSubview:NavView];
    */
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,4)];

    /*
    UIButton *DateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 90, 30)];
    DateBtn.backgroundColor = [UIColor clearColor];
    [DateBtn setTitle:@"Jan 05" forState:UIControlStateNormal];
    DateBtn.titleLabel.font = [UIFont fontWithName:BrushScriptStd size:18];
    [DateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [NavView addSubview:DateBtn];
    */
    
    
    // Do any additional setup after loading the view, typically from a nib.

    //topics
        self.topics = [NSMutableArray arrayWithObjects:@"home",@"environment",@"security", nil];
}

-(void)viewDidLayoutSubviews{
[self.navigationController.navigationBar setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 128)];
    SpaceTrackingView* titleView = [[SpaceTrackingView alloc] init];
    titleView.spaceName = @"extemperie";
    
    self.navigationItem.titleView = titleView;//[[UIImageView alloc] initWithImage:image];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)jsonTapped:(id)sender
{
    // 1
    NSString *string = [NSString stringWithFormat:@"%@weather.php?format=json", BaseURLString];
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
        self.messageResults = (NSDictionary *)responseObject;
        
        self.title = @"JSON Retrieved";
        self.messages = [self  getMessagesFromJSONResponse:self.messageResults];
        self.messagesByTopic =  [NSMutableArray arrayWithObjects: @{self.messages:@"all"}, nil];
        
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

-(NSMutableArray*)getMessagesFromJSONResponse:(NSDictionary*)json
{
    NSLog(@"getMessagsFromJSON");
    
    NSMutableDictionary* sensors = [[NSMutableDictionary alloc] init];
    NSDictionary* e = (NSDictionary*)json[ @"_embedded"];
    if (e != nil)
    {
        json = e;
    }
    NSArray* sensorArray = (NSArray*)json[ @"messages"];
    if (sensorArray == nil)
    {
        //for now, log an error
        NSLog(@"No Message array");
        
    } else {
        
        for (int i =0;i < sensorArray.count; i++) {
            NSDictionary* sensorDict = (NSDictionary*)sensorArray[i];
            Message* s = [sensorDict message];
            
            NSLog(@"added message %@ from %@",s.message,s.author);
            
            [self.messages addObject:s];
            [sensors addEntriesFromDictionary:@{s.type: s}];
        }
    }
    return sensors;
}


#pragma mark - Getter Methods
    
- (UITableView *)tableView
    {
        if (!_tableView)
        {
            _tableView = [UITableView new];
            _tableView.translatesAutoresizingMaskIntoConstraints = NO;
            _tableView.delegate = self;
            _tableView.dataSource = self;
            
        //    _tableView.emptyDataSetSource = self;
        //    _tableView.emptyDataSetDelegate = self;
            
            _tableView.tableFooterView = [UIView new];
        }
        return _tableView;
    }
    
- (UISearchBar *)searchBar
    {
        if (!_searchBar)
        {
            _searchBar = [UISearchBar new];
            _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
            _searchBar.delegate = self;
            
            _searchBar.placeholder = @"Search Country";
            _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        }
        return _searchBar;
    }
    

    

- (IBAction)clear:(id)sender
{
    self.title = @"";
    self.messageResults = nil;
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        NSMutableArray* displayedMessage = self.messagesByTopicDisplayed[section];
        
        
        return self.messages.count;
 
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForRow section %ld row %ld",indexPath.section,indexPath.row);
    ActivityCell* mcell = (ActivityCell*)[tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    
    NSMutableArray* defMessages = self.messagesByTopicDisplayed[indexPath.section];
    
    
    if( indexPath.section < 4)
    {
        
        NSDictionary *def = defMessages[indexPath.row];
        
        NSLog(@"cellForRow type=%@ topic=%@ mess=%@ ",def[@"type"],def[@"topic"],def[@"message"]);
        
        //  mcell.name.text = def[@"title"];
        mcell.message.text = def[@"message"];
        mcell.topic.text = def[@"topic"];
        mcell.icon.image=  [UIImage imageNamed:@"actionchat32.png"];//[self getIcon:def[@"type"] level:def[@"level"] ];
        
    }
    
    
    
    return mcell;
    
}

/*
 - (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
 if(popoverController == nil){   //make sure popover isn't displayed more than once in the view
 popoverController = [[UIPopoverController alloc]initWithContentViewController:popoverDetailContent];
 }
 [popoverController presentPopoverFromRect:textView.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
 popoverController.delegate = self;
 return NO; // tells the textfield not to start its own editing process (ie show the keyboard)
 }
 */
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    RuleBuilder *rb = [[RuleBuilder alloc] init];
    
    [self.navigationController pushViewController:rb animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}*/
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TableSectionHeader *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableSectionHeader"];
    
    
    NSString* name = [self.topics objectAtIndex:section];
    sectionHeaderView.titleLabel.text = name;
    sectionHeaderView.delegate = self;
    sectionHeaderView.section = section;
    
    return sectionHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}
 */
#pragma mark - Segues
/**/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - Table View


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

@end

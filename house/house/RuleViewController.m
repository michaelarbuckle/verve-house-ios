//
//  MasterViewController.m
//  airquality
//
//  Created by Michael Arbuckle on 7/17/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

#import "RuleViewController.h"
#import "RuleBuilder.h"
#import "RuleCell.h"
#import "Rule.h"
#import <objc/runtime.h>
//#import "airquality-Swift.h"

#import "UIImageView+AFNetworking.h"
#import "SpaceTrackingView.h"

typedef void(^RuleActionCallback)(BOOL cancelled, BOOL deleted, NSInteger actionIndex);


@interface DZNWeakObjectContainer : NSObject

@property (nonatomic, readonly, weak) id weakObject;

- (instancetype)initWithWeakObject:(id)object;

@end

@interface DZNEmptyDataSetView : UIView

@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) CGFloat verticalOffset;
@property (nonatomic, assign) CGFloat verticalSpace;

@property (nonatomic, assign) BOOL fadeInOnDisplay;

- (void)setupConstraints;
- (void)prepareForReuse;

@end


#pragma mark - UIScrollView+EmptyDataSet

static char const * const kEmptyDataSetSource =     "emptyDataSetSource";
static char const * const kEmptyDataSetDelegate =   "emptyDataSetDelegate";
static char const * const kEmptyDataSetView =       "emptyDataSetView";

#define kEmptyImageViewAnimationKey @"com.dzn.emptyDataSet.imageViewAnimation"

//@interface UIScrollView () <UIGestureRecognizerDelegate>
//@property (nonatomic, readonly) DZNEmptyDataSetView *emptyDataSetView;
//@end





@interface RuleViewController ()
{
    UIRefreshControl * refreshControl;
    RuleActionCallback actionCallback;
}
//@property (nonatomic, readonly) DZNEmptyDataSetView *emptyDataSetView;

@property(nonatomic, strong) NSDictionary *results;

@property(nonatomic, strong) NSMutableDictionary *defaultRulesFromDB;
@property(nonatomic, strong) NSMutableArray *defaultRules;
@property(nonatomic, strong) NSMutableArray *defaultRuleArrays;
@property(nonatomic, strong) NSMutableArray *defaultRuleDisplayedArrays;


@property(nonatomic, strong) NSMutableDictionary *customRulesFromDB;
@property(nonatomic, strong) NSMutableArray *customRules;
@property(nonatomic, strong) NSMutableDictionary *draftRule;
@property NSDictionary *ruleTemplates;
@property NSArray *templatesOrder;
@property NSMutableArray *rules;
@property NSArray *sections;




@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSLayoutConstraint *keyboardHC;
@property NSString* localizedStringTable;
@property UIView* floatingAddButtonView;
@property NSArray* ruleKeys;

@property (nonatomic) IBOutlet TableSectionHeader *sectionHeaderView;

-(NSDictionary*)addDefaultRule:(NSString*)ruleKey ruleInfo:(NSMutableDictionary*) ruleInfo;
-(UIImage*)getIcon:(NSString*)type  level:(NSString*)level;

@end


int maxDefRulSections=4;
BOOL defRuleSectionIsOpen[4];


@implementation RuleViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    self.tableView.separatorColor = [UIColor grayColor];
   // self.tableView.separatorInset = UIEdgeInsetsMake(0, 1, 0, 11);
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLineEtched;
    
      // Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
 
    NSString* theString;
    theString = NSLocalizedStringFromTable (@"Yes", @"Custom", @"A comment");
    
   //    self.title = @"Choreographer";
    NSArray *itemArray = [NSArray arrayWithObjects:@"default rules",@"custom rules", nil];

    self.sections = [NSArray arrayWithObjects:@"air quality rules",@"water quality rules",@"energy usage rules",@"security rules",@"custom", nil];

    NSArray* sectionKeys = [NSArray arrayWithObjects:@"air_quality_rule",@"water_quality_rule",@"power_usage_rule",@"security_rule", nil];
    
    UISegmentedControl* defaultOrCustom = [[UISegmentedControl alloc] initWithItems:itemArray];

     defaultOrCustom.frame = CGRectMake(0,0,320,30);
    [defaultOrCustom addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    defaultOrCustom.selectedSegmentIndex = 1;
    
     self.navigationItem.titleView=defaultOrCustom;
    
    /*
    SpaceTrackingView* titleView = [[SpaceTrackingView alloc] init];
    titleView.spaceName = @"space name";
    self.navigationItem.titleView = titleView;
    */
    self.rules =[[NSMutableArray alloc]init];
    self.ruleTemplates =[[NSDictionary alloc]init];
    NSDate *date = [NSDate date];
    
    NSString* currentTimeStamp = [self.dateFormatter stringFromDate:date ];
    
 //   self.ruleKeys
    NSArray* aQRKeys=@[@"air_quality_rule.1.zone_air_quality_deterioration" ,@"air_quality_rule.2.high_humidity_persistence",@"air_quality_rule.3.radon_health_hazard",@"air_quality_rule.4.elevated_dust_level",@"air_quality_rule.5.smoke_hazard",@"air_quality_rule.6.dew_point_persistent",@"air_quality_rule.7.high_temperature_alert"  ,@"air_quality_rule.8.strong_EMF_radiation",@"air_quality_rule.9.PMI_2dot5_level_increase",@"air_quality_rule.10.PMI_10_level_increase"];
    
    NSArray* wQRKeys=@[@"water_quality_rule.2.bacteria",
                          @"water_quality_rule.3.pharmaceuticals"];
    NSArray* pUKeys=@[                   @"power_usage_rule.1.blocking_available_resource",
                                                @"power_usage_rule.2.illuminated_but_empty_room"];
    NSArray* sKeys=@[                   @"security_rule.1.unknown_visitor_arrives",
                   @"security_rule.2.pet_upon_furniture"
                     ];
    
    self.ruleKeys = @[aQRKeys,wQRKeys,pUKeys,sKeys];
 /*   self.rules =@{
                           @{
                          @"title" : @"Add Title",
                          @"icon" : @"",
                          @"when" : @"",
                          @"message" : @"",
                          @"actionText" : @"",
                          @"topic" : @"",
                          @"enabled" : @"1",
                          @"last changed" : currentTimeStamp
                          }:@"",
    @{
      @"title" : @"Add Title",
      @"icon" : @"",
      @"message" : @"",
      @"actionText" : @"",
      @"topic" : @"",
      @"enabled" : @"1",
      @"when" : @{@"":@""},
      @"then" : @{@"":@""},
      @"last changed" : currentTimeStamp
      }:@"Elevated Dust level"}
                     ;
    
  */
    
    [self prepareDemoData];

    /*
    @try {
    self.localizedStringTable =@"rules";
    for (NSString* ruleKey in self.ruleKeys)
    {
        NSMutableDictionary* rule =[self.defaultRulesFromDB objectForKey:ruleKey];
        NSDictionary* defRule = [self addDefaultRule:ruleKey ruleInfo:rule ];
       //initialize rule template
       [self.defaultRules addObject:defRule ];
 
        NSLog(@"added rule=%@",ruleKey);
    }

    }
    @catch (NSException *exception) {
        NSLog(@"Exception:%@",exception);
    }
    @finally {
        //Display Alternative
    }
    */
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshCallback) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

 
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"TableSectionHeader" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"TableSectionHeader"];
    

}
-(UIImage*)getIcon:(NSString*)type  level:(NSString*)level
{

    NSMutableString* icon = [NSMutableString stringWithCapacity:20];
    if ([level  isEqual: @"hazard"])
    {
        level = @"red";
    }
    else if ([level  isEqual: @"warning"])
    {
        level = @"gold";
    } else
    {
        level = @"green";
    }
    
    
    [icon appendFormat:@"%@_%@.png",type,level];
    NSLog(@"image for %@",icon);
    return [UIImage imageNamed:icon];
}


-(NSDictionary*)addDefaultRule:(NSString*)ruleKey ruleInfo:(NSMutableDictionary*) ruleInfo
{
@try{
    NSArray* suffixes = @[@"type",@"level",@"message",@"topic",@"action_text"];
    NSString* theString;
    
    for (NSString* suffix in suffixes)
    {
        
        NSString* lookup = [NSString stringWithFormat:@"%@.%@",ruleKey,suffix];
    theString = NSLocalizedStringFromTable (lookup,self.localizedStringTable,@"");
    
        NSLog(@"found:%@ for %@",theString,lookup);
        
        [ruleInfo setValue:theString   forKey:suffix];
    }
   }
    @catch (NSException *exception) {
        NSLog(@"Exception:%@",exception);
    }
    @finally{
        return ruleInfo;}
}

-(void) refreshCallback
{
    [self prepareDemoData];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

-(void)prepareDemoData
{
  
    NSDate *date = [NSDate date];
    
    NSString* currentTimeStamp = [self.dateFormatter stringFromDate:date ];
    
    self.defaultRuleArrays = [[NSMutableArray alloc]init];
    self.defaultRuleDisplayedArrays = [[NSMutableArray alloc]init];
    self.defaultRules = [[NSMutableArray alloc]init];
    int cnt =0;
    @try {
        self.localizedStringTable =@"rules";
        for (int i=0;i < 4;i++)
        {
            cnt++;
            NSMutableArray* defRules = [[NSMutableArray alloc]init];
            for (NSString* ruleKey in self.ruleKeys[i])
            {
                NSMutableDictionary* rule =[[NSMutableDictionary alloc] initWithObjectsAndKeys:@1,@"enabled", @"type == 'CO2'",@"when",@"",@"then", currentTimeStamp, @"last changed", nil ];
            
                NSDictionary* defRule = [self addDefaultRule:ruleKey ruleInfo:rule ];
                //initialize rule template
                [defRules  addObject:defRule ];
            
                NSLog(@"added rule=%@",ruleKey);
            }

            NSLog(@"added rule section=%d count=%ld",i,defRules.count );

            [ self.defaultRuleArrays addObject: defRules];
        
            NSMutableArray* tmp = [[NSMutableArray alloc]init];
            [ self.defaultRuleDisplayedArrays addObject:tmp];
         }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception:%@",exception);
    }
    @finally {
        
        NSLog(@"prepareDemoData defltRule count =%d  def =%ld dis =%ld",cnt,self.defaultRuleArrays.count,self.defaultRuleDisplayedArrays.count);
        //Display Alternative
    }

}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)MySegmentControlAction:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0)
    {
        // code for the first button
    }
}
- (void)createNewRulee:(id)sender {
 
}
- (IBAction)jsonRetrieve:(id)sender
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
        self.results = (NSDictionary *)responseObject;
        
        
        
        
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
    self.results = nil;
    [self.tableView reloadData];
}
- (void)update {
    NSDate *date = [NSDate date];
    //check for changes
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

#pragma mark - Getters (Private)
/*
- (DZNEmptyDataSetView *)emptyDataSetView
{
    DZNEmptyDataSetView *view = objc_getAssociatedObject(self, kEmptyDataSetView);
    
    if (!view)
    {
        view = [DZNEmptyDataSetView new];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.hidden = YES;
        
        view.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContentView:)];
        view.tapGesture.delegate = self;
        [view addGestureRecognizer:view.tapGesture];
        
        [self setEmptyDataSetView:view];
    }
    return view;
}
*/
- (IBAction)didTapContentView:(id)sender
{
    [self jsonRetrieve:sender];
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

-(void)changeDefaultRuleDisplayed:(NSInteger)section toggle:(NSInteger)toggle
{
    
    if (toggle == 1)
    {
        NSMutableArray* defRl = self.defaultRuleArrays[section] ;
        [self.defaultRuleDisplayedArrays replaceObjectAtIndex:section  withObject: defRl];
        NSMutableArray* testdefRl = self.defaultRuleDisplayedArrays[section] ;
        int z=0;
        for (NSMutableArray* na in self.defaultRuleDisplayedArrays)
        {
            NSLog(@"na section=%d sz=%ld",z,na.count);
              z++;
              }
        
        NSLog(@"opening displayArray %ld %ld",defRl.count,testdefRl.count);
    }
    else
    {
        NSMutableArray* testdefRl = self.defaultRuleDisplayedArrays[section] ;

        NSMutableArray* tmp =[[NSMutableArray alloc] init];
        [self.defaultRuleDisplayedArrays replaceObjectAtIndex:section  withObject:tmp  ];
        
        NSMutableArray* test2defRl = self.defaultRuleDisplayedArrays[section] ;
        NSLog(@"closing displayArray %ld %ld",testdefRl.count,test2defRl.count);

        
    }


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( section < 4)
    {
        NSMutableArray* defRules = self.defaultRuleDisplayedArrays[section];

        return defRules.count;
    } else
    {
    
        return self.customRules.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"cellForRow section %ld row %ld",indexPath.section,indexPath.row);
    RuleCell* mcell = (RuleCell*)[tableView dequeueReusableCellWithIdentifier:@"RuleCell"];
    mcell.delegate = self;
    NSMutableArray* defRules = self.defaultRuleDisplayedArrays[indexPath.section];
    
    
   if( indexPath.section < 4)
   {
       
        NSDictionary *def = defRules[indexPath.row];
    
       NSLog(@"cellForRow type=%@ topic=%@ mess=%@ ",def[@"type"],def[@"topic"],def[@"message"]);
 
   //  mcell.name.text = def[@"title"];
       mcell.message.text = def[@"message"];
       mcell.topic.text = def[@"topic"];
       mcell.recommendation.text = def[@"actionText"];
       
       NSNumber *enbl = def[@"enabled"];
       mcell.enabled.on =enbl;
       mcell.icon.image=[self getIcon:def[@"type"] level:def[@"level"] ];
       
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RuleBuilder *rb = [[RuleBuilder alloc] init];
    
    [self.navigationController pushViewController:rb animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TableSectionHeader *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableSectionHeader"];
    
    
    NSString* name = [self.sections objectAtIndex:section];
    sectionHeaderView.titleLabel.text = name;
    sectionHeaderView.delegate = self;
    sectionHeaderView.section = section;
    
    return sectionHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}
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
        [self.rules removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
#pragma mark - SectionHeaderViewDelegate

- (void)sectionHeaderView:(TableSectionHeader *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
    
    NSLog(@"header sectionOpened=%ld text =%@ ",sectionOpened, sectionHeaderView.titleLabel.text);
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSMutableArray* defRules = self.defaultRuleArrays[sectionOpened];
    NSLog(@"found rules count %ld",defRules.count);
    
    NSInteger countOfRowsToInsert = defRules.count;
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }

    NSLog(@"found path to insert count %ld",indexPathsToInsert.count);

    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
   NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    /* 
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
        
        APLSectionInfo *previousOpenSection = (self.sectionInfoArray)[previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.play.quotations count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    */
    
    // style the animation so that there's a smooth flow in either direction
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    
    [self changeDefaultRuleDisplayed: sectionOpened toggle:1];
    
    // apply the updates
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
 //   [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    
    defRuleSectionIsOpen[sectionOpened ] = @YES;

}

- (void)sectionHeaderView:(TableSectionHeader *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
    
    NSLog(@"header sectionCkiseded=%ld text =%@ ",sectionClosed, sectionHeaderView.titleLabel.text);
    
     NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    NSLog(@"rows to delte=%ld ",countOfRowsToDelete);
    
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            NSIndexPath* pt =[NSIndexPath indexPathForRow:i inSection:sectionClosed];
            [indexPathsToDelete addObject:pt];
            NSLog(@"row/section to delte=%ld / %ld ", pt.row, pt.section);

        }
        [self changeDefaultRuleDisplayed: sectionClosed toggle:0];

        [self.tableView beginUpdates];

        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
        
        [self.tableView endUpdates];

    }
    defRuleSectionIsOpen[sectionClosed] = @NO;
}


#pragma mark - Auto-Layout Methods
/*
- (void)setupViewConstraints
{
    NSDictionary *views = @{@"searchBar": self.searchBar, @"tableView": self.tableView};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchBar]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[searchBar(==44)]-0@999-[tableView(>=0@750)]|" options:0 metrics:nil views:views]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", NSLayoutAttributeBottom];
    self.keyboardHC = [[self.view.constraints filteredArrayUsingPredicate:predicate] firstObject];
}
 
 */

- (void)updateViewConstraintsAnimated:(NSNotification *)note
{
    CGFloat duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat curve = [[note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
    
    CGRect endFrame = CGRectZero;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
    
    CGFloat minY = CGRectGetMinY(endFrame);
    CGFloat keyboardHeight = endFrame.size.height;
    
    // Invert values when landscape, for iOS7 or prior
    // In iOS8, Apple finally fixed the keyboard endframe values by returning the correct height in landscape orientation
    if (![UIInputViewController class] && UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        keyboardHeight = endFrame.size.width;
    }
    
    if (keyboardHeight == CGRectGetHeight([UIScreen mainScreen].bounds)) keyboardHeight = 0;
    
    self.keyboardHC.constant = (minY == [UIScreen mainScreen].bounds.size.height) ? 0.0 : keyboardHeight;
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:NULL];
}


#pragma mark - Keyboard Events

- (void)keyboardWillShow:(NSNotification *)note
{
    [self updateViewConstraintsAnimated:note];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    [self updateViewConstraintsAnimated:note];
}

#pragma mark - View Auto-Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (![UIInputViewController class]) {
      //  [self.tableView reloadEmptyDataSet];
    }
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.tableView reloadData];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}


#pragma mark - View lifeterm

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

+(UIImage*) drawImage:(UIImage*) fgImage
              inImage:(UIImage*) bgImage
              atPoint:(CGPoint)  point
{
    UIGraphicsBeginImageContextWithOptions(bgImage.size, FALSE, 0.0);
    [bgImage drawInRect:CGRectMake( 0, 0, bgImage.size.width, bgImage.size.height)];
    [fgImage drawInRect:CGRectMake( point.x, point.y, fgImage.size.width, fgImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = self.floatingAddButtonView.frame;
    frame.origin.y = scrollView.contentOffset.y;
    self.floatingAddButtonView.frame = frame;
    
    [self.view bringSubviewToFront:self.floatingAddButtonView];
}
+ (NSString *) append:(id) first, ...
{
    NSString * result = @"";
    id eachArg;
    va_list alist;
    if(first)
    {
        result = [result stringByAppendingString:first];
        va_start(alist, first);
        while (eachArg = va_arg(alist, id))
            result = [result stringByAppendingString:eachArg];
        va_end(alist);
    }
    return result;
}
@end

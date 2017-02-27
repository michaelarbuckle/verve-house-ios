//
//  MasterViewController.m
//  airquality
//
//  Created by Michael Arbuckle on 7/17/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//
#import "DetailViewController.h"
#import "MenuViewController.h"
#import <objc/runtime.h>
#import "house-Swift.h"
#import "UIImageView+AFNetworking.h"


#import "Action.h"
#import "Rule.h"
#import "Space.h"
#import "Structure.h"
#import "Person.h"
#import "Device.h"
#import "Measurand.h"
#import "Message.h"
#import "MenuItem.h"
#import "Topic.h"

enum MENU_SECTION
{
FAVORITE,STRUCTURE,SPACE,SENSOR,
SYSTEM,ACTION,RULE,MESSAGE,TOPIC,PERSON,GROUP, SCENE
} menuSection;
/*
#define ACCOUNT 0
#define STRUCTURE 0
#define SPACE 1
#define SENSOR 2
#define SYSTEM 3
#define ACTION 4
#define RULE 5
#define MESSAGE 6
#define GROUP 7
#define SCENE 8

*/
#define M_SLIDE_TIMING .25
#define M_PANEL_WIDTH 60

@interface MenuViewController ()

@property(nonatomic, strong) NSDictionary *results;
@property(nonatomic, strong) NSMutableDictionary *sessionInfoDB;
@property(nonatomic, strong) NSMutableArray *sections;
@property(nonatomic, strong) NSMutableArray *favorites;
@property(nonatomic, strong) NSMutableArray *actions;
@property(nonatomic, strong) NSMutableArray *sensors;
@property(nonatomic, strong) NSMutableArray *systems;
@property(nonatomic, strong)  NSMutableArray *messages;
@property(nonatomic, strong)  NSMutableArray *persons;
@property(nonatomic, strong)  NSMutableArray *rules;
@property(nonatomic, strong) NSMutableArray *spaces;
@property(nonatomic, strong) NSMutableArray *structures;
@property(nonatomic, strong) NSMutableArray *more;

@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSLayoutConstraint *keyboardHC;
@property NSString* localizedStringTable;
@property UIView* floatingAddButtonView;
@property (nonatomic, assign) BOOL showingMenu;
@property (nonatomic, assign) CGPoint preVelocity;


@property (nonatomic) IBOutlet MenuSectionHeader *sectionHeaderView;

 -(UIImage*)getIcon:(NSString*)type  level:(NSString*)level;

@end





@implementation MenuViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor grayColor];
   // self.tableView.separatorInset = UIEdgeInsetsMake(0, 1, 0, 11);
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLineEtched;
    
      // Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
 
    NSString* theString;
    theString = NSLocalizedStringFromTable (@"Yes", @"Custom", @"A comment");
    
   //    self.title = @"Choreographer";
    NSArray *itemArray = [NSArray arrayWithObjects:@"default rules",@"custom rules", nil];

    
    self.sections = [NSArray arrayWithObjects:@"favorites",@"structures",@"zones",@"users",@"devices",@"actions", nil];

    NSArray* favorites =  [NSArray arrayWithObjects:@"logout",@"connect cloud",@"connect local", nil];
    
    NSArray* sectionKeys = [NSArray arrayWithObjects:@"air_quality_rule",@"water_quality_rule",@"power_usage_rule",@"security_rule", nil];
    
    NSArray * favs =@[
      @{
          @"name": @"Connect to Cloud",
          @"type": @"account",
          @"icon": [UIImage imageNamed:@"cloud.png"],
          @"path" : @"login",
          @"controller" : @"LoginController"
          },
      @{
        @"name": @"Connect Local",
        @"type": @"account",
        @"icon": [UIImage imageNamed:@"devicesignal.png"],
        @"path" : @"SetupController"
        },
      @{
          @"name": @"Logout",
          @"type": @"account",
          @"icon": [UIImage imageNamed:@"cancel.png"],
          @"path" : @"logout",
          @"controller" : @"LoginController"
          },
      
      @{
          @"name": @"About",
          @"type": @"account",
          @"icon": [UIImage imageNamed:@"star.png"],
          @"path" : @"http://www.verve.house/about"
          }
      ];
    
    self.favorites = [[NSMutableArray alloc]init];
    for (NSDictionary* d in favs)
    {
        MenuItem* m=[[MenuItem alloc]initWithDictionary:d ];
        [self.favorites addObject:m];
    }
    
    self.actions=[[NSMutableArray alloc]init];
    self.structures=[[NSMutableArray alloc]init];
    self.spaces=[[NSMutableArray alloc]init];
    self.rules=[[NSMutableArray alloc]init];
    self.persons=[[NSMutableArray alloc]init];

     NSDate *date = [NSDate date];
    
    NSString* currentTimeStamp = [self.dateFormatter stringFromDate:date ];
 
    self.showingMenu = false;
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"MenuSectionHeader" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"MenuSectionHeader"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    

    [self setupGestures];
}


-(void) refreshCallback
{
    [self sessionInfoRetrieve];
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
  //  self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
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
#pragma gesture
-(void)setupGestures {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:panRecognizer];
}

-(void)close
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)movePanel:(id)sender {
    
    NSLog(@"movePnl %@",sender);
    
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        
        NSLog(@"movePnl Began");
        
     /*   UIView *childView = nil;
        
        if(velocity.x > 0) {
            childView = [self showMenuView];
            
        }
        // make sure the view we're working with is front and center
        [self.view sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    */
      }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        NSLog(@"movePnl Ended");
        
        
        
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        /* TODO
        if (!self.showingMenu) {
            [self movePanelToOriginalPosition];
        } else {
            [self movePanelRight];
        }
        */
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        
        NSLog(@"movePnl changed %f translated %f",velocity.x,translatedPoint.x);
        
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
        // are we more than halfway, if so, show the panel when done dragging by setting this value to YES (1)
        self.showingMenu = abs(self.view.center.x - 120.) > self.view.frame.size.width/2;
        
        NSLog(@"movePnl shwoMenu %d",self.showingMenu);
        
        
        // allow dragging only in x coordinates by only updating the x coordinate with translation position
        self.view.center = CGPointMake(self.view.center.x + translatedPoint.x, self.view.center.y);
        [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        
        // if you needed to check for a change in direction, you could use this code to do so
        if(velocity.x*_preVelocity.x + velocity.y*_preVelocity.y > 0) {
            // NSLog(@"same direction");
        } else {
            // NSLog(@"opposite direction");
        }
        
        _preVelocity = velocity;
    }
}
-(void)movePanelRight {
    NSLog(@"movePanelRight");
    
    [UIView animateWithDuration:M_SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.view.frame = CGRectMake(0, 0, 240, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             //_menuViewController.leftButton.tag = 0;
                         }
                     }];
}

-(void)movePanelToOriginalPosition {
    NSLog(@"movePanelToOrigin");
    [UIView animateWithDuration:M_SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.view.frame = CGRectMake(-240, 0,240, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self close];      }
                     }];
}
- (void)sessionInfoRetrieve
{
    // 1
    NSString *string = [NSString stringWithFormat:@"%@/sessionInfo", BaseURLString];
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
    [self sessionInfoRetrieve];
}


#pragma mark - Getters (Private)


#pragma mark - Accessors

- (NSDateFormatter *)dateFormatter {
    if( !_dateFormatter ) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"h:mm a 'on' MMM dd" options:0 locale:[NSLocale currentLocale]];
        _dateFormatter.dateFormat = dateFormat;
    }
    return _dateFormatter;
}


#pragma detailViewControllers
-(void)launchDetailViewForType:(NSString*)type
{
  
    
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    switch (section) {
        case FAVORITE:{
            return self.favorites.count;
        }break;
           case STRUCTURE:{
            return self.structures.count;
        }break;
        case SPACE:{
            return self.spaces.count;
        }break;
        case SENSOR:{
            return self.sensors.count;
        }break;
        case SYSTEM:{
            return self.systems.count;
        }break;
        case ACTION:{
            return self.actions.count;
        }break;
        case RULE:{
            return self.rules.count;
        }break;
        case MESSAGE:{
            return self.messages.count;
        }break;
        case PERSON:{
            return self.persons.count;
        }break;
        case GROUP:{
            return 0;
        }break;
        case SCENE:{
            return 0;
        }break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRow section %ld row %ld",indexPath.section,indexPath.row);
    MenuCell* menuCell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    
    switch (indexPath.section) {
          case FAVORITE:{

           MenuItem* m =  self.favorites[indexPath.row];
            menuCell.name.text = m.name;
            menuCell.type.text = m.type;
            menuCell.icon.image = [UIImage imageNamed:@"star.png"];

            
        }break;
        case STRUCTURE:{
            Structure* s =self.structures [indexPath.row];
            menuCell.name.text = s.name;
            menuCell.type.text = s.street;
            menuCell.icon.image = [UIImage imageNamed:@"star.png"];

        }break;
        case SPACE:{
            Space* s =self.spaces[indexPath.row];
            menuCell.name.text = s.name;
            menuCell.type.text = @"space";
            menuCell.icon.image = [UIImage imageNamed:@"star.png"];
      
        }break;
        case SENSOR:{
            Measurand* s =self.sensors[indexPath.row];
            menuCell.name.text = s.name;
            menuCell.type.text = @"measurand";
            menuCell.icon.image = [UIImage imageNamed:@"star.png"];
            
            
        }break;
        case SYSTEM:{
            Device* s =self.systems[indexPath.row];
            menuCell.name.text = s.name;
            menuCell.type.text = @"device";
            menuCell.icon.image = [UIImage imageNamed:@"star.png"];
            
            
        }break;
        case ACTION:{
            Action* s = self.actions[indexPath.row];
            menuCell.name.text = s.name;
            menuCell.type.text = @"action";
            menuCell.icon.image = [UIImage imageNamed:@"star.png"];
            
            
        }break;
        case RULE:{
            Rule* s =self.rules[indexPath.row];
            menuCell.name.text = s.name;
            menuCell.type.text = @"rule";
            menuCell.icon.image = [UIImage imageNamed:@"star.png"];
            
            
        }break;
        case MESSAGE:{
            Message* s =self.messages[indexPath.row];
            menuCell.name.text = s.topic;
            menuCell.type.text = @"message";
            menuCell.icon.image = [UIImage imageNamed:@"star.png"];
            
        }break;
        case PERSON:{
            Person* s =self.persons[indexPath.row];
            menuCell.name.text = s.name;
            menuCell.type.text = @"person";
            menuCell.icon.image = [UIImage imageNamed:@"star.png"];
            
        }break;
        case GROUP:{
            
        }break;
        case SCENE:{
            
        }break;
            
        default:
            return 0;
            break;
    }

    

       
   
       return menuCell;
    
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

    NSUInteger row = indexPath.row;
    if (row != NSNotFound)
    {
    
        // call view controller through delegate, after you initialize it with the
        // next level of data.
        
        
    
    NSString* path = @"";
    NSObject* s = [[Topic alloc]initWithDictionary: @{@"all things":@"name",@"topic":@"type"}];

    NSLog(@"didSelect %ld %ld",(long)indexPath.section,(long)indexPath.row);
    
   

    
    switch (indexPath.section) {
        case FAVORITE:{
            MenuItem * m = self.favorites[indexPath.row];
            s = m;
            path = m.path;
            
            NSLog(@"didSelect favorite %@",m.name);
                  
            //logout
            //connect to cloud
            
        }break;
        case STRUCTURE:{
            s =self.structures [indexPath.row];
            path = @"structures";
            
        }break;
        case SPACE:{
            s =self.spaces[indexPath.row];
            path = @"spaces";
            
          //  [self.delegate itemSelected:<#(NSObject *)#>];
            
            
        }break;
        case SENSOR:{
             s =self.sensors[indexPath.row];
            path = @"sensors";
            
        }break;
        case SYSTEM:{
             s =self.systems[indexPath.row];
            
            
        }break;
        case ACTION:{
             s = self.actions[indexPath.row];
            
            
        }break;
        case RULE:{
            s =self.rules[indexPath.row];
           
            
        }break;
        case MESSAGE:{
             s =self.messages[indexPath.row];
            
        }break;
        case PERSON:{
             s =self.persons[indexPath.row];
            
        }break;
        case GROUP:{
            
        }break;
        case SCENE:{
            
        }break;
            
        default:
            
            break;
    }

    
    [self.delegate itemSelected: s path:path];
    /*
    DetailViewController* rb = [[DetailViewController alloc] initWithData:s path:path ];
 
    [self.navigationController pushViewController:rb animated:YES];
    */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else
    {
        NSLog(@"controller for row not found");
    }
    
}

-(void)logout
{


}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MenuSectionHeader *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MenuSectionHeader"];
    
    
    NSString* name = [self.sections objectAtIndex:section];
    sectionHeaderView.titleLabel.text = name;
    sectionHeaderView.delegate = self;
    sectionHeaderView.section = section;
    sectionHeaderView.icon.image = [UIImage imageNamed:@"chat.png"];
    
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
      //  [self.rules removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
#pragma mark - SectionHeaderViewDelegate

- (void)sectionHeaderView:(MenuSectionHeader *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
    
    
    sectionHeaderView.icon.image = [UIImage imageNamed:@"carat-opened.png"];
    
    if (sectionOpened <= self.sections.count)
    {
        
        NSLog(@"opened section %@ ",self.sections[sectionOpened]);
    } else
    {
        NSLog(@"opened section but not found %ld",(long)sectionOpened);
        
    }

   }

- (void)sectionHeaderView:(MenuSectionHeader *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {

    sectionHeaderView.icon.image = [UIImage imageNamed:@"carat.png"];

    
    if (sectionClosed <= self.sections.count)
    {
    
        NSLog(@"closed section %@ ",self.sections[sectionClosed]);
    } else
    {
        NSLog(@"closed section but not found %ld",(long)sectionClosed);
        
    }
 }


#pragma mark - Auto-Layout Methods


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


#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "DetailViewController.h"
#import "DeviceViewController.h"
#import  "CenterViewController.h"
#import  "SpaceTrackingView.h"

#import "MenuViewController.h"
#import "MenuItem.h"
#import "Action.h"
#import "Message.h"
#import "Rule.h"
#import "Space.h"
#import "Structure.h"
#import "Person.h"


#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define RIGHT_PANEL_TAG 3

#define CORNER_RADIUS 4

#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

@interface MainViewController () < UIGestureRecognizerDelegate,MenuViewControllerDelegate,UINavigationBarDelegate>
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, strong) UINavigationController* navCtl;
@property (nonatomic, strong)  CenterViewController* ctrCtl;
@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) BOOL showingMenu;
@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;
@property (nonatomic, assign) UIStoryboard *sb;


@end

@implementation MainViewController

#pragma mark -
#pragma mark View Did Load/Unload

-(void)viewDidLoad {
    [super viewDidLoad];
    self.sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    [self setupView];
    [self showDashboard];
    [self setupNavigationBar];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Setup View

-(void)setupNavigationBar
{
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 110)];

    //LEFT BUTTON
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftBtnImage = [UIImage imageNamed:@"menu-alt32.png"];
    UIImage *leftBtnImagePressed = [UIImage imageNamed:@"menu-alt32.png"];
    [leftBtn setBackgroundImage:leftBtnImage forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:leftBtnImagePressed forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(0, 0, 32, 32);
    leftBtn.bounds =CGRectOffset(leftBtn.bounds, 0, 45);
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,32, 32)];
    //leftButtonView.bounds = CGRectOffset(leftButtonView.bounds, 0, 37);
    
    [leftButtonView addSubview:leftBtn];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:  leftButtonView ];//-
    
    navbar.topItem.leftBarButtonItem = leftButton;
    
   
     UINavigationItem* navItem = [[UINavigationItem alloc] init];
     navItem.leftBarButtonItem = leftButton;
 
    //RIGHT BUTTON
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *rightBtnImage = [UIImage imageNamed:@"magnifying-glass.png"];
    UIImage *rightBtnImagePressed = [UIImage imageNamed:@"magnifying-glass.png"];
    [rightBtn setBackgroundImage:rightBtnImage forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:rightBtnImagePressed forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(showSearch:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 24, 24);
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,32, 32)];
    rightButtonView.bounds = CGRectOffset(rightButtonView.bounds, 0, 45);
    
    [rightButtonView addSubview:rightBtn];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    
   // UINavigationItem* rightItem = [[UINavigationItem alloc] init];
    navItem.rightBarButtonItem = rightButton;

    
    
    SpaceTrackingView* titleView = [[SpaceTrackingView alloc] init];
    titleView.spaceName = @"street name here";
    titleView.center = CGPointMake(self.view.center.x,titleView.center.y);

    navItem.titleView =titleView;


    
    // Assign the navigation item to the navigation bar
   navbar.items = [NSArray arrayWithObjects: navItem, nil];

    
     //do something like background color, title, etc you self
    [self.view addSubview:navbar];

  /*  UIView* overlayView = [[UIView alloc] init];
[self.navigationController.view addSubview:overlayView];
*/

}

-(void)setupView {
		
	//[self setupGestures];
}

-(void)showTabViewWithShadow:(BOOL)value withOffset:(double)offset {
	if (value) {
		[self.view.layer setCornerRadius:CORNER_RADIUS];
		[self.view.layer setShadowColor:[UIColor blackColor].CGColor];
		[self.view.layer setShadowOpacity:0.8];
		[self.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
	} else {
		[self.view.layer setCornerRadius:0.0f];
		[self.view.layer setShadowOffset:CGSizeMake(offset, offset)];
	}
}

-(void)resetMainView {
	// remove left and right views, and reset variables, if needed
	if (self.menuViewController != nil) {
		[self.menuViewController.view removeFromSuperview];
		self.menuViewController = nil;
     //   self.menuButton.tag = 1;
		self.showingMenu = NO;
	}
	
	// remove view shadows
	[self showTabViewWithShadow:NO withOffset:0];
}
-(void)setupMenuController
{
    NSLog(@"menuVwCtlr == nil");
    
    // this is where you define the view for the left panel
    //self.menuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.menuViewController  = [sb instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
    // = [[MenuViewController alloc] init];
    
    self.menuViewController.view.tag = LEFT_PANEL_TAG;
    self.menuViewController.delegate = self;
    
    [self.view addSubview:self.menuViewController.view];
    
    [self addChildViewController:self.menuViewController];
    [self.menuViewController didMoveToParentViewController:self];
    
    self.menuViewController.view.frame = CGRectMake(-self.menuViewController.view.frame.size.width, 0, self.view.frame.size.width/2, self.view.frame.size.height);

     [self.navigationController.view.window insertSubview:self.menuViewController.view atIndex:0];

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
        
        
        self.menuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height);
    }
    
    [self.view bringSubviewToFront:self.menuViewController.view];
    
    //[self presentViewController:self.menuViewController animated:YES completion: nil];
    
    
    NSLog(@" menuFrame x=%f y=%f w=%f h=%f",
          self.menuViewController.view.frame.origin.x,
          self.menuViewController.view.frame.origin.y,
          self.menuViewController.view.frame.size.width,
          self.menuViewController.view.frame.size.height);
}
- (void)showSearch
{
    NSLog(@"show search");
}
-(UIView *)showMenuView {
	// init view if it doesn't already exist
	if (self.menuViewController == nil)
	{
        NSLog(@"menuVwCtlr == nil");
        
		// this is where you define the view for the left panel
		//self.menuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.menuViewController  = [sb instantiateViewControllerWithIdentifier:@"MenuViewController"];

      // = [[MenuViewController alloc] init];
        
		self.menuViewController.view.tag = LEFT_PANEL_TAG;
		self.menuViewController.delegate = self;
        
		[self.view addSubview:self.menuViewController.view];
        
		[self addChildViewController:self.menuViewController];
		[self.menuViewController didMoveToParentViewController:self];
        
		self.menuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height);
	}
    
	self.showingLeftPanel = YES;
    
	// setup view shadows
	[self showTabViewWithShadow:YES withOffset:-2];
    
	UIView *view = self.menuViewController.view;
	return view;
}



#pragma mark -
#pragma mark Swipe Gesture Setup/Actions

#pragma mark - setup

-(void)setupGestures {
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelegate:self];
    
	[self.view addGestureRecognizer:panRecognizer];
}

-(void)displayPanel 
{

    UIView *childView = [self showMenuView];
    [self.view bringSubviewToFront:childView];
    self.showingLeftPanel = true;


}
-(void)movePanel:(id)sender {
    
    NSLog(@"movePnl %@",sender);
    
    
    
	[[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
	CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        
        NSLog(@"movePnl Began");

        UIView *childView = nil;
        
        if(velocity.x > 0) {
                childView = [self showMenuView];
        
        }
        // make sure the view we're working with is front and center
        [self.view sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        NSLog(@"movePnl Ended");

        
        
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
        if (!_showPanel) {
            [self movePanelToOriginalPosition];
        } else {
           [self movePanelRight];
        }
	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        
        NSLog(@"movePnl changed %f",velocity.x);

        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
        // are we more than halfway, if so, show the panel when done dragging by setting this value to YES (1)
        _showPanel = abs([sender view].center.x - self.view.frame.size.width/2) > self.view.frame.size.width/2;
        
        // allow dragging only in x coordinates by only updating the x coordinate with translation position
        [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
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
-(void)movePanelRightToPeek
{



}

#pragma mark -
#pragma mark MenuDelegate actions


- (void)showDashboard
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DeviceViewController *viewController  = [sb instantiateViewControllerWithIdentifier:@"DeviceViewController"];
    
    viewController.view.frame= self.view.frame;
    
    /*[[self navigationController] pushViewController:viewController
                                           animated:YES];*/
    
 //    [[self navigationController] presentViewController:viewController animated:YES completion: ^(){NSLog(@"presented view");}];
    
    [self.view addSubview:viewController.view];
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];

    
    NSLog(@"show dashboard");
}
- (void)itemSelected:(NSObject *)item
{}

- (void)itemSelected:(NSObject *)item path:(NSString*)path
{
    
    
    if (item.class == MenuItem.class )
    {
        
        MenuItem* mi = (MenuItem*)item;
        UIViewController *viewController;
        
        if ( mi.controller != nil)
        {
        
 
            viewController  = [self.sb instantiateViewControllerWithIdentifier:mi.controller];
            
        } else
        {

           viewController  = [self.sb instantiateViewControllerWithIdentifier:@"RuleViewController"];

        }
            
        [[self navigationController] pushViewController:viewController
                                               animated:YES];

    }
        

}

- (void)menuPanelClosed
{}
- (void)menuPanelOpen
{}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DeviceViewController class]]) {
        // Configure Books View Controller
        [(TSPBooksViewController *)segue.destinationViewController setAuthor:self.author];
        
        // Reset Author
        [self setAuthor:nil];
    }
}
 */



#pragma mark -
#pragma mark Delegate Actions


-(void)movePanelLeft {
    UIView *childView = [self showMenuView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.view.frame = CGRectMake(-self.view.frame.size.width + PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                            // _centerViewController.rightButton.tag = 0;
                         }
                     }];
}



-(void)movePanelRight {
    NSLog(@"movePanelRight");
    UIView *childView = [self showMenuView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.menuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             //_menuViewController.leftButton.tag = 0;
                         }
                     }];
}

-(void)movePanelToOriginalPosition {
        NSLog(@"movePanelToOrigin");
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.menuViewController.view.frame = CGRectMake(-self.menuViewController.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self resetMainView];
                         }
                     }];
}

#pragma navigation bar delegae

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {

   // [self.navCtl navigationBar:nil shouldPopItem:nil];
      return true;
}
- (BOOL)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item {
    
    // [self.navCtl navigationBar:nil shouldPopItem:nil];
      return true;
}
- (BOOL)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
    
    // [self.navCtl navigationBar:nil shouldPopItem:nil];
    return true;
}


#pragma mark -
#pragma mark Default System Code

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

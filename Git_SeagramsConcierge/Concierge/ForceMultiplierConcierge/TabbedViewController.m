//
//  TabbedViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/16/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "TabbedViewController.h"
#import "AttendeeProfileViewController.h"



@implementation TabbedViewController

@synthesize tabBarController;
@synthesize settingsTabBarController;
@synthesize full_btn;
@synthesize quick_btn;
@synthesize content;
@synthesize blankTabBar;
@synthesize dc_fullVC;
//@synthesize dc_abbrVC;
@synthesize header;
@synthesize viewControllers;
@synthesize buttons;
@synthesize da;
@synthesize buttonData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        da = [[DataAccess alloc] init];
        buttons = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [tabBarController release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect frame;
    frame = self.view.frame;
    frame.origin.y = frame.origin.y - 55.0f;
    self.view.frame = frame;
    
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
    
    
    NSNumber *mode = [da getMode];
    
    NSArray *vcs;
    
    
    [quick_btn setImage:[UIImage imageNamed:@"QuickTab_Selected.png"] forState:UIControlStateSelected];
    [quick_btn setImage:[UIImage imageNamed:@"QuickTab_Selected.png"] forState:UIControlStateDisabled];
    [quick_btn setImage:[UIImage imageNamed:@"QuickTab_Selected.png"] forState:UIControlStateNormal];
    [quick_btn setImage:[UIImage imageNamed:@"QuickTab_Selected.png"] forState:UIControlStateHighlighted];
    self.quick_btn.selected = YES;
    
    [full_btn setImage:[UIImage imageNamed:@"FullTab_NotSelected.png"] forState:UIControlStateSelected];
    [full_btn setImage:[UIImage imageNamed:@"FullTab_NotSelected.png"] forState:UIControlStateDisabled];
    [full_btn setImage:[UIImage imageNamed:@"FullTab_NotSelected.png"] forState:UIControlStateNormal];
    [full_btn setImage:[UIImage imageNamed:@"FullTab_NotSelected.png"] forState:UIControlStateHighlighted];
    self.full_btn.selected = NO;
   
    
    
    //BUILD ABBREVIATED DATA COLLECTION VIEW
    /*
    if(dc_abbrVC==nil)
    {
        dc_abbrVC = [[DataCollection_Abbr_ViewController alloc] initWithNibName:@"DataCollection_Abbr_ViewController" bundle:nil];
        dc_abbrVC.title = @"Abbreviated";
        dc_abbrVC.hidesBottomBarWhenPushed = YES;
        
        frame = dc_abbrVC.content.frame;
        //frame.size.height = frame.size.height - 49;
        frame.origin.y = frame.origin.y - 55.0f;
        dc_abbrVC.view.frame = frame;
        
        [dc_abbrVC.view setNeedsLayout];
        [dc_abbrVC.view setNeedsDisplay];
    }
     */
    
    //BUILD FULL DATA COLLECTION VIEW
    if(dc_fullVC==nil)
    {
        dc_fullVC = [[AttendeeProfileViewController alloc] initWithNibName:@"AttendeeProfileViewController" bundle:nil];
        dc_fullVC.title = @"Full";
        dc_fullVC.hidesBottomBarWhenPushed = YES;
       
        frame = dc_fullVC.content.frame;
        //frame.size.height = frame.size.height - 49;
       // frame.origin.y = frame.origin.y - 55.0f;
        dc_fullVC.view.frame = frame;
        
        frame = dc_fullVC.content.frame;
        frame.origin.y = 40.0f;
        frame.origin.x = 10.0f;
        dc_fullVC.content.frame = frame;
        
        [dc_fullVC.view setNeedsDisplay];
        [dc_fullVC.view setNeedsLayout];
    }
    
    CATransition *viewLoadViewIn =[CATransition animation];
    // Set animation properties
    [viewLoadViewIn setDuration:4.0];
    [viewLoadViewIn setType:kCATransitionReveal];
    [viewLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    // Add animation to view
    
    
    //BOTH VIEWS
    if([mode isEqualToNumber:[NSNumber numberWithInt:2]])
    {    
       /* [[dc_abbrVC.view layer]addAnimation:viewLoadViewIn forKey:kCATransitionReveal];
        vcs = [NSArray arrayWithObjects:dc_abbrVC, dc_fullVC,  nil];
        header.hidden = NO;
        quick_btn.hidden = NO;
        full_btn.hidden = NO;*/
    }
    
    //ABBR VIEW ONLY
    if([mode isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        /*[[dc_abbrVC.view layer]addAnimation:viewLoadViewIn forKey:kCATransitionReveal];
        vcs = [NSArray arrayWithObjects:dc_abbrVC, nil];
        header.hidden = YES;
        quick_btn.hidden = YES;
        full_btn.hidden = YES;*/
    }
    
    //FULL VIEW ONLY
    if([mode isEqualToNumber:[NSNumber numberWithInt:0]])
    {
        [[dc_fullVC.view layer]addAnimation:viewLoadViewIn forKey:kCATransitionReveal];
        vcs = [NSArray arrayWithObjects:dc_fullVC, nil];
        header.hidden = YES;
        quick_btn.hidden = YES;
        full_btn.hidden = YES;
    }
    
    
    //BUILD TAB BAR CONTROLLER
    if(tabBarController==nil){
        tabBarController = [[UITabBarController alloc] init];
        tabBarController.delegate = self;
    }
   
    [self.tabBarController setViewControllers:vcs animated:YES];
    
    
    // Custom resize this view to fit its superview
    /*
     frame = self.view.superview.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.view.frame = frame;
    */
    
    // Custom resize nav controller to fit in its subview
    frame = self.content.frame;
    frame.origin.x = 0.0;
    frame.origin.y = 0.0;
    tabBarController.view.frame = frame;
    
    // Move TabBar to top
    frame = tabBarController.tabBar.frame;
    frame.origin.x = 0.0;
    frame.origin.y = 0.0;
    frame.size.width = 200;
    tabBarController.tabBar.frame = frame;
    
    [tabBarController.tabBar setAutoresizingMask: UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
    [tabBarController.tabBar setAutoresizesSubviews:YES];
    
    // Move blankTabBar to top
    /*
    frame = blankTabBar.frame;
    frame.origin.y = 0.0;
    frame.origin.x = 200;
    frame.size.width = self.view.frame.size.width - 200;
    blankTabBar.frame = frame;
    
    [blankTabBar setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
    [blankTabBar setAutoresizesSubviews:YES];//*/
    //*/
   /*[[tabBarController.tabBar.items objectAtIndex:2]setEnabled:FALSE];
    [[tabBarController.tabBar.items objectAtIndex:3]setEnabled:FALSE];
    [[tabBarController.tabBar.items objectAtIndex:4]setEnabled:FALSE];
    */
    
    [self.content addSubview:tabBarController.view];
    //[self.view bringSubviewToFront:blankTabBar];
    //[self.content bringSubviewToFront:tabBarController.tabBar];
    
    [self.content setNeedsDisplay];
    [self.content setNeedsLayout]; 
    
    [tabBarController.view setNeedsDisplay];
    [tabBarController.view setNeedsLayout];
    
    [tabBarController.tabBar setNeedsDisplay];
    [tabBarController.tabBar setNeedsLayout];
    
    
    tabBarController.tabBar.hidden = YES;
    
    
    //Register for orientation changes
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(orientationDidChange:) 
                                                 name:UIDeviceOrientationDidChangeNotification 
                                               object:nil];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _updateView];
}

-(void)viewDidAppear:(BOOL)animated{
    [self _layoutPage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self _layoutPage];
    // Return YES for supported orientations
	return YES;
}

- (void)orientationDidChange:(NSNotification *)note
{
    [self _layoutPage];
}

-(void)_updateView
{
    /*
    NSArray *vcs;
    
    [self.tabBarController setViewControllers:viewControllers animated:YES];
    
    //Build left side of first button
    CGRect startFrame;
    UIImageView *buttonStart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FirstTab_Start.png"]];
    startFrame = buttonStart.frame;
    startFrame.origin.x = 0.0f;
    startFrame.origin.y = 0.0f;
    startFrame.size.height = 32.0f;
    buttonStart.frame = startFrame;
    
    //Build Buttons
    int idx = 0;
    NSDictionary *button;
    for(button in self.buttonData){
        UIButton *aButton = [[UIButton alloc] buttonWithType:UIButtonTypeCustom];
        [aButton setTitle:[button objectForKey:@"title"] forState:UIControlStateNormal];
        
        CGRect frame,frame2;
        if(idx == 0){
            //Position button
            frame = [aButton frame];
            frame.origin.x = startFrame.size.width;
            frame.size.height = 32.0f;
            [aButton setFrame:frame];
            
            [aButton setBackgroundImage:[UIImage imageNamed:@"FirstTab_NotSelected.png"] forState:UIControlStateNormal];
            [aButton setBackgroundImage:[UIImage imageNamed:@"FirstTab_Selected.png"] forState:UIControlStateSelected];
            [aButton setBackgroundImage:[UIImage imageNamed:@"FirstTab_NotSelected"] forState:UIControlStateDisabled];
            [aButton setBackgroundImage:[UIImage imageNamed:@"FirstTab_Selected.png"] forState:UIControlStateHighlighted];
        }else{
            //Position button
            frame2 = [[self.buttons objectAtIndex:idx-1] frame];
            
            frame = [aButton frame];
            frame.origin.x = frame2.size.width + frame2.origin.x;
            frame.size.height = 32.0f;
            [aButton setFrame:frame];
            
            [aButton setBackgroundImage:[UIImage imageNamed:@"Tab_NotSelected.png"] forState:UIControlStateNormal];
            [aButton setBackgroundImage:[UIImage imageNamed:@"Tab_Selected.png"] forState:UIControlStateSelected];
            [aButton setBackgroundImage:[UIImage imageNamed:@"Tab_NotSelected"] forState:UIControlStateDisabled];
            [aButton setBackgroundImage:[UIImage imageNamed:@"Tab_Selected.png"] forState:UIControlStateHighlighted];
        }
            
        [aButton addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:aButton];
        idx++;
    }
    [self.tabBarController setViewControllers:vcs animated:YES];
     */
}

-(void)_layoutPage
{
    CGRect frame;
    
    /*
    frame = self.view.superview.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.view.frame = frame;
    */
    
    // Custom resize nav controller to fit in its subview
    frame = self.content.frame;
    frame.origin.x = 0.0;
    frame.origin.y = 0.0;
    tabBarController.view.frame = frame;
    
    // Move TabBar to top
    frame = tabBarController.tabBar.frame;
    frame.origin.x = 0.0;
    frame.origin.y = 0.0;
    frame.size.width = 200;
    tabBarController.tabBar.frame = frame;
    tabBarController.tabBar.hidden = YES;
    
    
    // Move blankTabBar to top
    /*
    frame = blankTabBar.frame;
    frame.origin.y = 0.0;
    frame.origin.x = 200;
    frame.size.width = self.view.frame.size.width - 200;
    blankTabBar.frame = frame;
    //*/
    
    [self.content bringSubviewToFront:tabBarController.view];
    //[self.view bringSubviewToFront:blankTabBar];
    //[self.content bringSubviewToFront:tabBarController.tabBar];
    
    
    [tabBarController.view setNeedsDisplay];
    [tabBarController.view setNeedsLayout];
    
    
    [tabBarController.tabBar setNeedsDisplay];
    [tabBarController.tabBar setNeedsLayout];
    
    /*
    [blankTabBar setNeedsDisplay];
    [blankTabBar setNeedsLayout]; 
    */
    
    [self.view setNeedsDisplay];
    [self.view setNeedsLayout]; 
}

#pragma mark - UITabBarControllerDelegate Methods

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSLog(@"tabBarController:%@ shouldSelectViewController:%@",tabBarController,viewController);
    if(tabBarController == [self tabBarController]){
        return YES;
    }else{
        return NO;
    }
}

#pragma IBActions

-(IBAction)selectTab:(id)sender
{
    // Get views. controllerIndex is passed in as the controller we want to go to. 
    UIView * fromView;
    UIView * toView;
    int selectedIndex;
    
    UIButton *button = sender;
    if(button == full_btn)
    {
        [quick_btn setImage:[UIImage imageNamed:@"QuickTab_NotSelected.png"] forState:UIControlStateSelected];
        [quick_btn setImage:[UIImage imageNamed:@"QuickTab_NotSelected.png"] forState:UIControlStateDisabled];
        [quick_btn setImage:[UIImage imageNamed:@"QuickTab_NotSelected.png"] forState:UIControlStateNormal];
        [quick_btn setImage:[UIImage imageNamed:@"QuickTab_NotSelected.png"] forState:UIControlStateHighlighted];
        self.quick_btn.selected = NO;
        
        [full_btn setImage:[UIImage imageNamed:@"FullTab_Selected.png"] forState:UIControlStateSelected];
        [full_btn setImage:[UIImage imageNamed:@"FullTab_Selected.png"] forState:UIControlStateDisabled];
        [full_btn setImage:[UIImage imageNamed:@"FullTab_Selected.png"] forState:UIControlStateNormal];
        [full_btn setImage:[UIImage imageNamed:@"FullTab_Selected.png"] forState:UIControlStateHighlighted];
        //self.full_btn.selected = YES;
        
        selectedIndex = 1; 
        // Get views. controllerIndex is passed in as the controller we want to go to. 
        fromView = [[tabBarController.viewControllers objectAtIndex:0] view];
        toView = [[tabBarController.viewControllers objectAtIndex:1] view];
    }
    else
    {
        [quick_btn setImage:[UIImage imageNamed:@"QuickTab_Selected.png"] forState:UIControlStateSelected];
        [quick_btn setImage:[UIImage imageNamed:@"QuickTab_Selected.png"] forState:UIControlStateDisabled];
        [quick_btn setImage:[UIImage imageNamed:@"QuickTab_Selected.png"] forState:UIControlStateNormal];
        [quick_btn setImage:[UIImage imageNamed:@"QuickTab_Selected.png"] forState:UIControlStateHighlighted];
        //self.quick_btn.selected = YES;
        
        [full_btn setImage:[UIImage imageNamed:@"FullTab_NotSelected.png"] forState:UIControlStateSelected];
        [full_btn setImage:[UIImage imageNamed:@"FullTab_NotSelected.png"] forState:UIControlStateDisabled];
        [full_btn setImage:[UIImage imageNamed:@"FullTab_NotSelected.png"] forState:UIControlStateNormal];
        [full_btn setImage:[UIImage imageNamed:@"FullTab_NotSelected.png"] forState:UIControlStateHighlighted];
        self.full_btn.selected = NO;
        
        selectedIndex = 0;
        // Get views. controllerIndex is passed in as the controller we want to go to. 
        // Get views. controllerIndex is passed in as the controller we want to go to. 
        fromView = [[tabBarController.viewControllers objectAtIndex:1] view];
        toView = [[tabBarController.viewControllers objectAtIndex:0] view];
    }
    
    [[tabBarController.viewControllers objectAtIndex:1] _layoutPage];
    [[tabBarController.viewControllers objectAtIndex:0] _layoutPage];
    
    // Transition using a page curl.
    [UIView transitionFromView:fromView 
                        toView:toView 
                      duration:0.5 
                       options:(selectedIndex > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight)
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = selectedIndex;
                            [[tabBarController.viewControllers objectAtIndex:1] _layoutPage];
                            [[tabBarController.viewControllers objectAtIndex:0] _layoutPage];
                        }
                    }];
}

-(void)setViewControllers:(NSArray *)viewControllers withButtonData:(NSArray *)buttons{
    self.viewControllers = viewControllers;
    self.buttonData = buttonData;
    
    [self _updateView];
}

@end

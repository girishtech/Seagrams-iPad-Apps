//
//  EventDetailViewController.m
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/22/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import "EventDetailViewController.h"
#import "EventOverviewViewController.h"
#import "EventVenueViewController.h"
#import "EventAttendeeListViewController.h"
#import "EventGuestListViewController.h"
#import "EventSponsorsListVC.h"
#import "KioskSettingsViewController.h"


@implementation EventDetailViewController

@synthesize brandName, eventName;
@synthesize eventTabBar,contentView;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
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
    CGRect frame;
    
    
    
    //create an array to hold the tab views
    NSMutableArray *viewcontrollers = [[NSMutableArray alloc] init];
    //create the tabController object
    eventTabBar = [[UITabBarController alloc] init];
    //create the overview object
    
    /*
     EventOverviewViewController *eventOverviewVC = [[EventOverviewViewController alloc] initWithNibName:@"EventOverviewViewController_Landscape" bundle:[NSBundle mainBundle]];
     [eventOverviewVC setTitle:@"Overview"];
     //add to the array
     frame = self.contentView.frame;
     frame.origin.y = 0.0f;
     frame.origin.x = 0.0f;
     frame.size.height = frame.size.height - 70.0f;
     eventOverviewVC.view.frame = frame;
     [viewcontrollers addObject:eventOverviewVC];
     
     [eventOverviewVC release];
     */
    
    /*
     //create the venue view object
     EventVenueViewController *evntVenueController = [[EventVenueViewController alloc] initWithNibName:@"EventVenueViewController_Landscape" bundle:[NSBundle mainBundle]];
     
     UINavigationController *eventVenueTabNavCnt = [[UINavigationController alloc] initWithRootViewController:evntVenueController];
     eventVenueTabNavCnt.navigationBar.barStyle = UIBarStyleBlack;
     [eventVenueTabNavCnt setTitle:@"Venue"];
     //add to the array
     [evtControllersArray addObject:eventVenueTabNavCnt];
     
     [evntVenueController release];
     [eventVenueTabNavCnt release];
     */
    
    //create Session selection
    KioskSettingsViewController *settingsVC = [[KioskSettingsViewController alloc] initWithNibName:@"KioskSettingsViewController" bundle:[NSBundle mainBundle]];
    [settingsVC setTitle:@"Session Selection"];
    frame = self.contentView.frame;
    frame.origin.y = 0.0f;
    frame.origin.x = 0.0f;
    frame.size.height = frame.size.height - 20.0f;//40.0f;//70.0f;
    settingsVC.view.frame = frame;
    //add to the array
    [viewcontrollers addObject:settingsVC];
    
    [settingsVC release];
    
    
    //create the Attendees tab views
    EventAttendeeListViewController *eventAttendeeVC = [[EventAttendeeListViewController alloc] initWithNibName:@"EventAttendeeListViewController_Landscape" bundle:[NSBundle mainBundle]];
    frame = self.contentView.frame;
    frame.origin.y = 0.0f;
    frame.origin.x = 0.0f;
    frame.size.height = frame.size.height - 20.0f;//40.0f;//70.0f;
    eventAttendeeVC.view.frame = frame;
    
    // Create Nav Controller
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:eventAttendeeVC];
    
    // Custom resize nav controller to fit in its subview
    frame = self.contentView.frame;
    frame.origin.y = 0.0f;
    frame.origin.x = 0.0f;
    navController.view.frame = frame;
    
    [navController setTitle:@"Attendees"];
    [navController setNavigationBarHidden:YES];
    [navController setDelegate:self];
    
    //add to the array
    [viewcontrollers addObject:navController];
    
    [eventAttendeeVC release];
    
    /*
     //Create guest tab
     EventGuestListViewController *evntGuestController = [[EventGuestListViewController alloc] initWithNibName:@"EventGuestListViewController_Landscape" bundle:[NSBundle mainBundle]];
     
     UINavigationController *eventGuestTabNavCnt = [[UINavigationController alloc] initWithRootViewController:evntGuestController];
     eventGuestTabNavCnt.navigationBar.barStyle = UIBarStyleBlack;
     [eventGuestTabNavCnt setTitle:@"Guests"];
     //add to the array
     [evtControllersArray addObject:eventGuestTabNavCnt];
     
     [evntGuestController release];
     [eventGuestTabNavCnt release];
     
     //create Sponsors tab
     EventSponsorsListVC *evntSponsorController = [[EventSponsorsListVC alloc] initWithNibName:@"EventSponsorsListVC" bundle:[NSBundle mainBundle]];
     
     UINavigationController *eventSponsorTabNavCnt = [[UINavigationController alloc] initWithRootViewController:evntSponsorController];
     eventSponsorTabNavCnt.navigationBar.barStyle = UIBarStyleBlack;
     [eventSponsorTabNavCnt setTitle:@"Sponsors"];
     //add to the array
     [evtControllersArray addObject:eventSponsorTabNavCnt];
     
     [evntSponsorController release];
     [eventSponsorTabNavCnt release];
     */
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //configure the tab bar
    eventTabBar.view.backgroundColor = [UIColor clearColor];
    eventTabBar.view.opaque = NO;
    frame = self.contentView.frame;
    frame.origin.y = 0.0f;
    frame.origin.x = 0.0f;
    frame.size.height = frame.size.height;//- 20.0f;// - 70.0f;
    eventTabBar.view.frame = frame;
    eventTabBar.tabBar.hidden = NO;
    eventTabBar.delegate = [appDelegate rootVC];
    
    
    self.eventTabBar.viewControllers = viewcontrollers;
    [self.contentView addSubview:eventTabBar.view];
    // Do any additional setup after loading the view from its nib.
    //[[appDelegate rootVC] showSyncBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.eventTabBar.selectedIndex = 1;
    self.eventTabBar.selectedIndex = 0;
    [self.contentView setNeedsLayout];
    [self.contentView setNeedsDisplay];
    [eventTabBar.view setNeedsLayout];
    [eventTabBar.view setNeedsDisplay];
}

-(void)hideMessage
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC] hideErrorMessage];
    [[appDelegate rootVC] hideSyncStatus];
}

-(void)updateDisplay
{
    /*for(UIViewController *vc in eventTabBar.viewControllers)
    {
        [vc updateDisplay];
    }*/
    
    [[eventTabBar.viewControllers objectAtIndex:0]updateDisplay];
    [[[[eventTabBar.viewControllers objectAtIndex:1] viewControllers]objectAtIndex:0]updateDisplay];
}

-(void)setEventNameLabel:(NSString*)name
{
    NSLog(@"setEventNameLabel: %@",name);
    self.eventName.text = [NSString stringWithString:name];
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(viewController == [[tabBarController viewControllers]objectAtIndex:1])
    {
        ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
        //[appDelegate.rootVC lockScreen];
        id rootVC = [appDelegate rootVC];
        [rootVC performSelectorOnMainThread:@selector(lockScreen) withObject:nil waitUntilDone:YES];
    }
    return YES;
}
@end

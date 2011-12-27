//
//  AttendeeDetailViewController.m
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/22/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import "AttendeeDetailViewController.h"
#import "AttendeeProfileViewController.h"
#import "AttendeeStatsViewController.h"
#import "AttendeeAddGuestViewController.h"
#import "AttendeeGuestListViewController.h"
#import "AttendeeQuestions.h"

@implementation AttendeeDetailViewController

@synthesize attendeeName;
@synthesize attendeeTabBar;

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
    //create an array to hold the tab views
    NSMutableArray *attendeeControllersArray = [[NSMutableArray alloc] init];
    //create the tabController object
    attendeeTabBar = [[UITabBarController alloc] init];
    //create the attendee profile object
    AttendeeProfileViewController *attendeeProfileController = [[AttendeeProfileViewController alloc] initWithNibName:@"AttendeeProfileViewController_Landscape" bundle:[NSBundle mainBundle]];
    
    UINavigationController *attendeeProfileTabNavCnt = [[UINavigationController alloc] initWithRootViewController:attendeeProfileController];
    attendeeProfileTabNavCnt.navigationBar.barStyle = UIBarStyleBlack;
    [attendeeProfileTabNavCnt setTitle:@"Profile"];
    //add to the array
    [attendeeControllersArray addObject:attendeeProfileTabNavCnt];
    
    [attendeeProfileController release];
    [attendeeProfileTabNavCnt release];
    
    //create the attendee status object
    AttendeeStatsViewController *attendeeStatsController = [[AttendeeStatsViewController alloc] initWithNibName:@"AttendeeStatsViewController" bundle:[NSBundle mainBundle]];
    
    UINavigationController *attendeeStatsTabNavCnt = [[UINavigationController alloc] initWithRootViewController:attendeeStatsController];
    attendeeStatsTabNavCnt.navigationBar.barStyle = UIBarStyleBlack;
    [attendeeStatsTabNavCnt setTitle:@"Stats"];
    //add to the array
    [attendeeControllersArray addObject:attendeeStatsTabNavCnt];
    
    [attendeeStatsController release];
    [attendeeStatsTabNavCnt release];
    
    //create the attendee add guest object
    AttendeeAddGuestViewController *attendeeAddGuestController = [[AttendeeAddGuestViewController alloc] initWithNibName:@"AttendeeAddGuestViewController_Landscape" bundle:[NSBundle mainBundle]];
    
    UINavigationController *attendeeAddGuestTabNavCnt = [[UINavigationController alloc] initWithRootViewController:attendeeAddGuestController];
    attendeeAddGuestTabNavCnt.navigationBar.barStyle = UIBarStyleBlack;
    [attendeeAddGuestTabNavCnt setTitle:@"Add a Guest"];
    //add to the array
    [attendeeControllersArray addObject:attendeeAddGuestTabNavCnt];
    
    [attendeeAddGuestController release];
    [attendeeAddGuestTabNavCnt release];
    
    //create the attendee guest list object
    AttendeeGuestListViewController *attendeeGuestListController = [[AttendeeGuestListViewController alloc] initWithNibName:@"AttendeeGuestListViewController_Landscape" bundle:[NSBundle mainBundle]];
    
    UINavigationController *attendeeGuestListTabNavCnt = [[UINavigationController alloc] initWithRootViewController:attendeeGuestListController];
    attendeeGuestListTabNavCnt.navigationBar.barStyle = UIBarStyleBlack;
    [attendeeGuestListTabNavCnt setTitle:@"Guests"];
    //add to the array
    [attendeeControllersArray addObject:attendeeGuestListTabNavCnt];
    
    [attendeeGuestListController release];
    [attendeeGuestListTabNavCnt release];
    
    //create the attendee questions object
//    AttendeeQuestions *attendeeQuestionsController = [[AttendeeQuestions alloc] initWithNibName:@"AttendeeQuestions" bundle:[NSBundle mainBundle]];
//    
//    UINavigationController *attendeeQuestionsTabNavCnt = [[UINavigationController alloc] initWithRootViewController:attendeeQuestionsController];
//    attendeeQuestionsTabNavCnt.navigationBar.barStyle = UIBarStyleBlack;
//    [attendeeQuestionsTabNavCnt setTitle:@"Guests"];
//    //add to the array
//    [attendeeControllersArray addObject:attendeeQuestionsTabNavCnt];
//    
//    [attendeeQuestionsController release];
//    [attendeeGuestListTabNavCnt release];
    
    //configure the tab bar ***************************************************** configure the tab bar
    attendeeTabBar.view.backgroundColor = [UIColor clearColor];
    attendeeTabBar.view.opaque = NO;
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height - 40.0f;
    attendeeTabBar.view.frame = frame;
    
    self.attendeeTabBar.viewControllers = attendeeControllersArray;
    [self.view addSubview:attendeeTabBar.view];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

@end

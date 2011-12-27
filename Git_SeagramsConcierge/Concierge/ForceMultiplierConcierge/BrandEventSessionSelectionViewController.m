//
//  BrandEventSessionSelectionViewController.m
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/22/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import "BrandEventSessionSelectionViewController.h"
#import "OfflineSessionSelectionViewController.h"
#import "OnlineSessionEnableViewController.h"
//#import "RootViewController.h"

@implementation BrandEventSessionSelectionViewController
@synthesize brandTabBar;//, brandSessionNavCnt;
@synthesize offOnLineList;
@synthesize offlineSelectionVC, onlineSessionVC;

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
-(IBAction)eventItemSelectBrandVC:(id)sender {
    

}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"BrandEventSessionSelectionViewController - viewDidLoad");
    //pull tab bar controller into the view this would usually be put into a nsobject
    
    brandTabBar = [[UITabBarController alloc] init];
    OfflineSessionSelectionViewController *offLineContrler2 = [[OfflineSessionSelectionViewController alloc] initWithNibName:@"OfflineSessionSelectionViewController" bundle:[NSBundle mainBundle]];
    
    UINavigationController *OffControllerNav = [[UINavigationController alloc] initWithRootViewController:offLineContrler2];
    OffControllerNav.navigationBar.barStyle = UIBarStyleBlack;
    [OffControllerNav setTitle:@"Offline Mode"];
    
    OnlineSessionEnableViewController *onlineController2 =[[OnlineSessionEnableViewController alloc] initWithNibName:@"OnlineSessionEnableViewController" bundle:[NSBundle mainBundle]];
    
    UINavigationController *OnControllerNav = [[UINavigationController alloc] initWithRootViewController:onlineController2];
    OnControllerNav.navigationBar.barStyle = UIBarStyleBlack;
    [OnControllerNav setTitle:@"Online Mode"];    

    offOnLineList = [[NSArray alloc] initWithObjects:OffControllerNav, OnControllerNav, nil];
    [offLineContrler2 release];
    [OffControllerNav release];

    [onlineController2 release];
    [OnControllerNav release];

    //make background clear
    brandTabBar.view.backgroundColor = [UIColor clearColor];
    brandTabBar.view.opaque = NO;
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height - 40.0f;
    brandTabBar.view.frame = frame;
    
    [brandTabBar setViewControllers:offOnLineList];
    [offlineSelectionVC release];
    [onlineSessionVC release];
    [offOnLineList release];
    
    [self.view addSubview:brandTabBar.view];
    
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

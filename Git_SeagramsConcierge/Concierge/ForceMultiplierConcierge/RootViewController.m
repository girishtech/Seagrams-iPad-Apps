//
//  RootViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/11/11.
//  Contributions by Dustin Fineout.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.

//

#import "RootViewController.h"


@implementation RootViewController

@synthesize navController;
//@synthesize loginVC;


//@synthesize daController;
//@synthesize view;
@synthesize scrollView;
@synthesize mainContentView;
@synthesize headerContentView,screenLock,activityIndicator;
@synthesize theBackground,theLegal;
@synthesize theLogo,settings,cancel,sync,errorMessage,syncPushBtn,syncPullBtn;
@synthesize eventDetailVC;
@synthesize tabbedVC;
@synthesize loginVC;
@synthesize version, changeCount;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"RootViewController - initWithNibName");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //daController = [[DataAccess alloc] init];
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    //[daController release];
    [navController release];
   // [loginVC release];

    
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
    NSLog(@"RootViewController - viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    CGRect frame;
    // Force page to re-layout
    /*
    frame = self.view.frame;
    frame.origin.y = 50.0;
    self.view.frame = frame;
    */
    
    [(UIScrollView*)self.scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];

    
    // Build Login View (ROOT VIEW)
    if(loginVC == nil){
        loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController_Landscape" bundle:nil];
        frame = loginVC.view.frame;
        frame.origin.y = 0.0f;//frame.origin.y - 55.0f;
        loginVC.view.frame = frame;
        [loginVC clearFields];
    }
    //frame = mainContentView.frame;
    //frame.origin.y = 78.0;
    //frame.size.height = self.view.frame.size.height - 170.0;
    //mainContentView.frame = frame;

    
    if(eventDetailVC == nil){
        eventDetailVC = [[EventDetailViewController alloc] initWithNibName:@"EventDetailViewController_Landscape" bundle:nil];
        frame = mainContentView.frame;
        frame.origin.y = 0.0f;//frame.origin.y - 55.0f;
        eventDetailVC.view.frame = frame;
    }
    
    // Build Nav Controller
    if(navController == nil)
    {
        // Create Nav Controller
        navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        // Custom resize nav controller to fit in its subview
        frame.origin.y = 0.0;
        navController.view.frame = frame;
        
        [navController setNavigationBarHidden:YES];
        [navController setDelegate:self];
        
        // Add navcontroller to the main content view
        [mainContentView addSubview:navController.view];
    }

    
    if(theBackground == nil)
    {
        
    }
    
    //Register for orientation changes
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(orientationDidChange:) 
                                                 name:UIDeviceOrientationDidChangeNotification 
                                               object:nil];
    [self updateChangeCount];
    version.text = [NSString stringWithFormat:@"Version: %@",CURRENTVERSION];
}

- (void)viewDidAppear:(BOOL)animated
{
    [(UIScrollView*)self.scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
    //[self.scrollView setScrollEnabled:NO];
    
    [self _layoutPage];
    version.text = [NSString stringWithFormat:@"Version: %@",CURRENTVERSION];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self _layoutPage];
    // Return YES for supported orientations
    if(interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        //[self _layoutPage];
        return YES;
    }else{
        return NO;
    }
}

- (void)orientationDidChange:(NSNotification *)note
{
    [self _layoutPage];
}

-(void)_layoutPage
{

}

#pragma mark - UINavigationControllerDelegate Methods

-(void)updateChangeCount
{
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    changeCount.text = [NSString stringWithFormat:@"Changes: %d",[[appDelegate da] changeCount]];
}

-(void)showSyncBtn
{
    [syncPushBtn setHidden:NO];
    [syncPullBtn setHidden:NO];
}

-(void)hideSyncBtn
{
    [syncPushBtn setHidden:YES];
    [syncPullBtn setHidden:YES];
}

-(void)setEventName:(NSString*)name
{
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
{
    [self hideSyncStatus];
    if(viewController == [[navController viewControllers] objectAtIndex:0]){
        [navController setNavigationBarHidden:YES animated:YES];
    }
}

/*
-(void)lockScreen
{
    //[self.sync setHidden:NO];
    //[[[self.navController viewControllers]objectAtIndex:2]fetchRecordCount];
}

-(void)unlockScreen
{
    //[self.sync setHidden:NO];
    //[[[self.navController viewControllers]objectAtIndex:2]fetchRecordCount];
}
*/

-(void)syncSucceeded
{
    [self.sync setHidden:NO];
    [self performSelectorOnMainThread:@selector(unlockScreen) withObject:nil waitUntilDone:YES];
    [eventDetailVC updateDisplay];
    //[self performSelector:@selector(hideSyncStatus) withObject:nil afterDelay:5.0];
    /*if([(NSString*)NSStringFromClass([viewController class]) isEqualToString:@"UINavigationController"])
    {
        [[[viewController viewControllers]objectAtIndex:0]updateDisplay];
    }else{
        [viewController updateDisplay];
    }*/
}

-(void)hideSyncStatus
{
    [self.sync setHidden:YES];
}

-(void)showErrorMessage:(NSString*)message
{
    [self.errorMessage setText:message];
    [self.errorMessage setHidden:NO];
    [self performSelector:@selector(hideErrorMessage) withObject:nil afterDelay:5.0];
}

-(void)hideErrorMessage
{
    [self.errorMessage setHidden:YES];
}

-(void)switchButtons
{
    if(self.settings.hidden == YES)
    {
        self.cancel.hidden = YES;
        self.settings.hidden = NO;
        [self hideSyncStatus];
    }
    else
    {
        self.cancel.hidden = NO;
        self.settings.hidden = YES;
    }
}

-(IBAction)clickedSettings
{
    NSLog(@"clickedSettings");
    
    if(loginVC == nil){
        loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController_Landscape" bundle:nil];
    }
    
    self.settings.hidden = YES;
    self.cancel.hidden = NO;
    [loginVC clearFields];
    //try{
        [self.navController pushViewController:loginVC animated:YES];
    //}catch(id error){
        
    //}
    
}

-(IBAction)clickedCancel
{
    self.settings.hidden = NO;
    self.cancel.hidden = YES;
    [[[self.navController viewControllers]objectAtIndex:0]_layoutPage];
    
    //if([[self.navController viewControllers]count]>1) [[[self.navController viewControllers]objectAtIndex:1]_layoutPage];
    [self.navController popToRootViewControllerAnimated:YES];
    [self hideSyncStatus];
}

-(IBAction)clickedSyncPush
{
    [self performSelectorOnMainThread:@selector(lockScreen) withObject:nil waitUntilDone:YES];
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate web] syncPush];
}

-(IBAction)clickedSyncPull
{
    [self performSelectorOnMainThread:@selector(lockScreen) withObject:nil waitUntilDone:YES];
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate web] syncPull];
}

-(IBAction)clickedTest
{
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate web] testSync];
}


-(IBAction)whoClickedWhat:(id)sender
{
    NSLog(@"sender: %@",sender);
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self hideSyncStatus];
    [self hideErrorMessage];
    if([(NSString*)NSStringFromClass([viewController class]) isEqualToString:@"UINavigationController"])
    {
        [[[viewController viewControllers]objectAtIndex:0]updateDisplay];
        [self.syncPullBtn setTitle:@"Get People" forState:UIControlStateNormal];
    }else{
        [self.syncPullBtn setTitle:@"Get Events" forState:UIControlStateNormal];
        [viewController updateDisplay];
    }
}

-(void)lockScreen
{
    NSLog(@"lockScreen");
    self.screenLock.hidden = NO;
    [self.activityIndicator startAnimating];
    //[self.accessibilityHint ];
}

-(void)lockScreen:(id)target
{
    NSLog(@"lockScreen");
    self.screenLock.hidden = NO;
    [self.activityIndicator startAnimating];
    //[target performSelectorInBackground:@selector(_sync) withObject:nil];
}

-(void)lockScreenTest:(id)target
{
    NSLog(@"lockScreen");
    self.screenLock.hidden = NO;
    [self.activityIndicator startAnimating];
    //[target performSelectorInBackground:@selector(_syncTest) withObject:nil];
}

-(void)unlockScreen
{
    NSLog(@"unlockScreen");
    self.screenLock.hidden = YES;
    [self.activityIndicator stopAnimating];
    version.text = [NSString stringWithFormat:@"Version: %@",CURRENTVERSION];
    [self updateChangeCount];
    /*
    if([NSStringFromClass([self.navController.visibleViewController class]) isEqualToString:@"KioskSettingsViewController"])
    {
        [self.navController.visibleViewController _updateDisplay];
    }
     */
}

//-(void)showDatePickerForDelegate:(i

@end

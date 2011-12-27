//
//  RootViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/11/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "RootViewController.h"
#import "OrderViewController.h"
#import "TakePhotoViewController.h"
#import "PhotoConsentViewController.h"

@implementation RootViewController

@synthesize navController;
@synthesize optInVC;
@synthesize loginVC;
@synthesize orderVC;
@synthesize emailAddress;

//@synthesize daController;

@synthesize scrollView;
@synthesize mainContentView;
@synthesize headerContentView;
@synthesize theBackground,theLegal,legal1,legal2;
@synthesize theLogo,settings,cancel,sync,eventName,errorMessage,screenLock,activityIndicator;
@synthesize da;

// shahab open
- (ForceMultiplierAppDelegate*) appDelegate {
    return (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
}

// shahab close


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //daController = [[DataAccess alloc] init];
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
        da = [appDelegate da];
    }
    return self;
}

- (void)dealloc
{
    [emailAddress release];
    [super dealloc];
    //[daController release];
    [navController release];
    [optInVC release];

    
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
    // Force page to re-layout
    /*
    frame = self.view.frame;
    frame.origin.y = 50.0;
    self.view.frame = frame;
    */
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    if([defaults valueForKey:@"kiosk_currentSessionName"]!=nil){
        [self setEventNameText:[defaults valueForKey:@"kiosk_currentSessionName"]];
        
    }
    NSString * sId=  [defaults valueForKey:@"kiosk_currentSessionName"];
    [self.legal1 setFont:[UIFont fontWithName:@"TradeGothicLT-BoldCondTwenty" 
                                         size:self.legal1.font.pointSize]];
    [self.legal2 setFont:[UIFont fontWithName:@"TradeGothicLT-BoldCondTwenty" 
                                         size:self.legal2.font.pointSize]];
    
    [(UIScrollView*)self.scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];

    
    // Build Login View (ROOT VIEW)
    if(optInVC == nil){
        optInVC = [[OptinConfirmationViewController alloc] initWithNibName:@"OptinConfirmationViewController" bundle:nil];
        frame = optInVC.view.frame;
        frame.origin.y = frame.origin.y - 55.0f;
        optInVC.view.frame = frame;
    }
    
    
    // Build Nav Controller
    if(navController == nil)
    {
        // Create Nav Controller
        navController = [[UINavigationController alloc] initWithRootViewController:optInVC];
//        navController = [[UINavigationController alloc] initWithRootViewController:[self appDelegate].settingsVw];
      
        // Custom resize nav controller to fit in its subview
        frame = mainContentView.frame;
        frame.origin.y = HEADER_HEIGHT;
        mainContentView.frame = frame;
        frame.origin.y = 0.0;
        navController.view.frame = frame;
        
        [navController setNavigationBarHidden:YES];
        [navController setDelegate:self];
        
        // Add navcontroller to the main content view
        [mainContentView addSubview:navController.view];
    }
    
    if(da.currentSession == nil)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if([defaults objectForKey:@"kiosk_currentSession"] != nil){
            if(![[defaults objectForKey:@"kiosk_currentSession"] isEqualToString:@""]){
                da.currentSession = [defaults objectForKey:@"kiosk_currentSession"];
            }
            else
            {
                [self clickedSettings];
                [self hideSettings];
            }
        }
        else
        {
            
            [self clickedSettings];
            
            // shahab open
            
            if (![self appDelegate].userIsLoggedIn) {
                [self hideSettings];
            }
            
            // shahab close
            
            // shahab open comment
            
            //[self hideSettings];

            // shahab close comment
            
        }
      
        
    }
    /*
    frame = theLegal.frame;
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || 
       [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        frame.origin.x = 0.0f;
    }
    else
    {
        
        frame.origin.x = -118.0f;
    }
    theLegal.frame = frame;
     */
    
    // Load Logo Image
    /*
     if(theLogo.image == nil)
    {
        UIImage *logo = [UIImage imageNamed:@"logo.gif"];
        theLogo.image = logo;//[daController logoImage];
    }
     //*/
    
    if(theBackground == nil)
    {
        
    }
    
    //Register for orientation changes
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(orientationDidChange:) 
                                                 name:UIDeviceOrientationDidChangeNotification 
                                               object:nil];
     */
    /*
    UIScrollView* scroller = self.view;
    CGSize size = [scroller contentSize];
    size.height = size.height + 350;
    [scroller setContentSize:size];
     */
}

- (void)viewDidAppear:(BOOL)animated
{
/*
    CGRect frame,headerFrame;
    // Force page to re-layout
    //frame = self.view.frame;
    //frame.origin.y = 0.0;
    //self.view.frame = frame;
    
    //[self.view setNeedsDisplay];
    //[self.view setNeedsLayout];
    
    headerFrame = headerContentView.frame;
    headerFrame.size.width = self.view.bounds.size.width;
    headerFrame.size.height = 79.0;
    headerFrame.origin.x = 0.0;
    headerFrame.origin.y = 0.0;
    headerContentView.frame = headerFrame;
    [self.headerContentView setNeedsDisplay];
    [self.headerContentView setNeedsLayout];
    
    headerFrame = theLegal.frame;
    headerFrame.size.width = self.view.bounds.size.width;
    //headerFrame.size.height = 79.0;
    headerFrame.origin.x = 0.0;
    //headerFrame.origin.y = 0.0;
    theLegal.frame = headerFrame;
    [self.theLegal setNeedsDisplay];
    [self.theLegal setNeedsLayout];
    
    frame = mainContentView.frame;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = self.view.bounds.size.height - headerFrame.size.height;
    frame.origin.x = 0.0;
    frame.origin.y = 79.0f;
    mainContentView.frame = frame;
    [self.mainContentView setNeedsDisplay];
    [self.mainContentView setNeedsLayout];
    
    frame.origin.y = 0.0f;
    self.navController.view.frame = frame;
    [self.navController.view setNeedsDisplay];
    [self.navController.view setNeedsLayout];
    /*self.tabbedVC.view.frame = frame;
    [self.tabbedVC.view setNeedsDisplay];
    [self.tabbedVC.view setNeedsLayout];

    //[self.view layoutIfNeeded];
    [self.scrollView setScrollEnabled:NO];
    */
    [self _layoutPage];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   // [self _layoutPage];
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)orientationDidChange:(NSNotification *)note
{
    [self _layoutPage];
}

-(void)_layoutPage
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    UIDevice *myDevice = [UIDevice currentDevice];
    
    CGRect frame,headerFrame;
    // Force page to re-layout
    frame = [[appDelegate window]frame];
        
    headerFrame = headerContentView.frame;
    headerFrame.size.width = self.view.bounds.size.width;
    headerFrame.size.height = HEADER_HEIGHT;
    headerFrame.origin.x = 0.0;
    headerFrame.origin.y = 0.0;
    headerContentView.frame = headerFrame;
    [self.headerContentView setNeedsDisplay];
    [self.headerContentView setNeedsLayout];
    
    headerFrame = theLegal.frame;
    headerFrame.size.width = self.view.bounds.size.width;
    //headerFrame.size.height = 79.0;
    headerFrame.origin.x = 0.0;
    //headerFrame.origin.y = 0.0;
    theLegal.frame = headerFrame;
    [self.theLegal setNeedsDisplay];
    [self.theLegal setNeedsLayout];
    
    frame = mainContentView.frame;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = self.view.bounds.size.height - headerFrame.size.height;
    frame.origin.x = 0.0;
    frame.origin.y = HEADER_HEIGHT;
    mainContentView.frame = frame;
    [self.mainContentView setNeedsDisplay];
    [self.mainContentView setNeedsLayout];
    
    frame.origin.y = 0.0f;
    self.navController.view.frame = frame;
    
    /*
    frame = theLegal.frame;
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || 
       [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        frame.origin.x = 0.0f;//(appDelegate.window.frame.size.width / 2.0f) - (frame.size.width / 2.0f);
    }
    else
    {
        
        frame.origin.x = -118.0f;
    }
    theLegal.frame = frame;
    */
    
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
    [self.navController.view setNeedsDisplay];
    [self.navController.view setNeedsLayout];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults valueForKey:@"kiosk_currentSessionName"]!=nil){
        [self setEventNameText:[defaults valueForKey:@"kiosk_currentSessionName"]];
    }
   /* self.tabbedVC.view.frame = frame;
    [self.tabbedVC.view setNeedsDisplay];
    [self.tabbedVC.view setNeedsLayout];*/
    
    [self.scrollView setScrollEnabled:NO];
}

#pragma mark - UINavigationControllerDelegate Methods

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
{
    if(viewController == [[navController viewControllers] objectAtIndex:0]){
        [navController setNavigationBarHidden:YES animated:YES];
        [viewController viewDidAppear:YES];
    }
}

-(void)syncSucceeded
{
    if ([self appDelegate].userIsLoggedIn) {
        [self hideErrorMessage];
        [self.sync setHidden:NO];
    } else {
        //[self hideErrorMessage];
        [self.sync setHidden:YES];
    }
    
    if([[self.navController viewControllers]count] > 1){
        NSLog(@"Nav stack size: %d",[[self.navController viewControllers]count]);
        //NSLog(@"ClassName: %@",NSStringFromClass([[self.navController viewControllers]objectAtIndex:[[self.navController viewControllers]count] - 1]));
        if([/*NSStringFromClass(*/[[self.navController viewControllers]objectAtIndex:[[self.navController viewControllers]count] - 1]/*)*/ isKindOfClass:@"KioskSettingsViewController"]){
            
            [[[self.navController viewControllers]objectAtIndex:[[self.navController viewControllers]count] - 1]_updateDisplay];
        }
    }
    //[self unlockScreen];
}

-(void)hideHeader
{
    self.headerContentView.hidden = YES;
}


-(void)showHeader
{
    self.headerContentView.hidden = NO;
}

-(void)hideSyncStatus
{
    [self.sync setHidden:YES];
}

-(void)showErrorMessage:(NSString*)message
{
    [self.errorMessage setText:message];
    [self.errorMessage setHidden:NO];
    [self hideSyncStatus];
}

-(void)hideErrorMessage
{
    [self.errorMessage setHidden:YES];
}

-(void)setEventNameText:(NSString*)eventNameStr
{
    self.eventName.text = [NSString stringWithFormat:@"%@%@",@"Event: ",eventNameStr];
    self.eventName.hidden = NO;
}

-(void)lockScreen
{
    NSLog(@"lockScreen");
    self.screenLock.hidden = NO;
    [self.activityIndicator startAnimating];
}

-(void)lockScreenPush:(id)target
{
    NSLog(@"lockScreen");
    self.screenLock.hidden = NO;
    [self.activityIndicator startAnimating];
    [target performSelectorInBackground:@selector(_syncPush) withObject:nil];
}

-(void)lockScreenPull:(id)target
{
    NSLog(@"lockScreen");
    self.screenLock.hidden = NO;
    [self.activityIndicator startAnimating];
    [target performSelectorInBackground:@selector(_syncPull) withObject:nil];
}

-(void)lockScreenTest:(id)target
{
    NSLog(@"lockScreen");
    self.screenLock.hidden = NO;
    [self.activityIndicator startAnimating];
    [target performSelectorInBackground:@selector(_syncTest) withObject:nil];
}

-(void)unlockScreen
{
    NSLog(@"unlockScreen");
    self.screenLock.hidden = YES;
    [self.activityIndicator stopAnimating];
    
    if([NSStringFromClass([self.navController.visibleViewController class]) isEqualToString:@"KioskSettingsViewController"])
    {
        [self.navController.visibleViewController _updateDisplay];
    }
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

// shahab open

- (BOOL) firstLaunch {
    if ([[self appDelegate] autoLogin]) {
        return YES;
    }
    return NO;
}

// shahab close


-(IBAction)clickedSettings
{
    // shahab open
    
    if ([self appDelegate].userIsLoggedIn) {
        [self showCancel];
    }
    // shahab close
    
    
    // shahab open commented
    //[self showCancel];
    // shahab close commented

    if([NSStringFromClass([self.navController.visibleViewController class]) isEqualToString:@"ThankYouPurchaseViewController"] || 
       [NSStringFromClass([self.navController.visibleViewController class]) isEqualToString:@"OrderViewController"])
    {
        NSLog(@"GOING TO SETTINGS FROM THANK YOU");
    }
    
    NSLog(@"clickedSettings");
    
    // shahab open
    
//    BOOL isAutologinTrue = [self firstLaunch];
//    //isAutologinTrue = NO;
//    if (isAutologinTrue) {
//        [self appDelegate].userIsLoggedIn = YES;
//        [self showCancel];
//        if([self appDelegate].settingsVw == nil){
//            [self appDelegate].settingsVw = [[KioskSettingsViewController alloc] initWithNibName:@"KioskSettingsViewController" bundle:nil];
//        }
//        [self.navController pushViewController:[self appDelegate].settingsVw animated:YES];
//    } else {
//        if(loginVC == nil){
//            loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController_Landscape" bundle:nil];
//            [loginVC clearFields];
//            
//            [self.navController pushViewController:loginVC animated:YES];
//        } else {
//            //        [self.navController popViewControllerAnimated:YES];
//            if([self appDelegate].settingsVw == nil){
//                [self appDelegate].settingsVw = [[KioskSettingsViewController alloc] initWithNibName:@"KioskSettingsViewController" bundle:nil];
//            }
//            [self.navController pushViewController:[self appDelegate].settingsVw animated:YES];
//            
//        }
//
//    }
    
 
    // shahab close
    
    // shahab open commented
    if(loginVC == nil){
        loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController_Landscape" bundle:nil];
    }
    
    [self showCancel];
    [loginVC clearFields];
    
    [self.navController pushViewController:loginVC animated:YES];
    // shahab close commented
}

-(void)hideSettings
{
    self.settings.hidden = YES;
    self.cancel.hidden = YES;
}

-(void)showCancel
{
    self.settings.hidden = YES;
    self.cancel.hidden = NO;
}

-(IBAction)showSettings
{
    self.settings.hidden = NO;
    self.cancel.hidden = YES;
}

-(IBAction)clickedCancel
{
    if(da.currentSession != nil)
    {
        self.settings.hidden = NO;
        self.cancel.hidden = YES;
        //[[[self.navController viewControllers]objectAtIndex:0]_layoutPage];
        //if([[self.navController viewControllers]count]>1) [[[self.navController viewControllers]objectAtIndex:1]_layoutPage];
        [self.navController popToRootViewControllerAnimated:YES];
        [self hideSyncStatus];
    }
}

-(IBAction)clickedLion
{
    if(self.navController.visibleViewController != orderVC)
    {
        self.settings.hidden = NO;
        self.cancel.hidden = YES;
        
        orderVC = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
        
        [self.navController pushViewController:orderVC animated:YES];
        [self hideSyncStatus];
    }
}


-(IBAction)whoClickedWhat:(id)sender
{
    NSLog(@"sender: %@",sender);
}


- (void) showTakePhotoViewControllerDelegate:(id) photodelegate {
    PhotoConsentViewController *consentViewController = (PhotoConsentViewController*)photodelegate;
    TakePhotoViewController *takePhoto = [[TakePhotoViewController alloc] initWithNibName:@"TakePhotoViewController" bundle:nil];
    takePhoto.delegate = self;
    takePhoto.currentViewController = consentViewController;
    [self presentModalViewController:takePhoto animated:NO];
    [takePhoto release];
}

- (void) takePhotoViewController:(TakePhotoViewController*)takePhotoViewController imageDidCaptured :(UIImage*)image {
    PhotoConsentViewController *consentViewController = (PhotoConsentViewController*)takePhotoViewController.currentViewController;
    [consentViewController imageRecieved:image];
    [self dismissModalViewControllerAnimated:NO];
}

@end

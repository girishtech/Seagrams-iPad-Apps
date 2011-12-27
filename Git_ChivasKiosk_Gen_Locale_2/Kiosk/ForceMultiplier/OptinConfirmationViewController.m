//
//  OptinConfirmationViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 8/5/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "OptinConfirmationViewController.h"
#import "ForceMultiplierAppDelegate.h"
#import "RootViewController.h"

@implementation OptinConfirmationViewController

@synthesize tabbedVC, optInBtn, optInLabel, optInBox;

- (ForceMultiplierAppDelegate*) appDelegate {
    return (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
}


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
    // Do any additional setup after loading the view from its nib.
    
    [self.optInLabel setFont:[UIFont fontWithName:@"TradeGothicLT-CondEighteen" 
                                             size:self.optInLabel.font.pointSize]];
    [self.optInBtn.titleLabel setFont:[UIFont fontWithName:@"TradeGothicLT-BoldCondTwenty" 
                                                      size:self.optInBtn.titleLabel.font.pointSize]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {    
    [super viewWillAppear:animated];
    RootViewController *rtController = [[self appDelegate] rootVC];
    [rtController showErrorMessage:@""];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    optInBox.selected = YES;
    
    NSLog(@"OptinConfirmation - viewDidAppear");
    
    if(HIDES_HEADER_ON_OPTIN_PAGE)
    {
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.rootVC hideHeader];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

-(IBAction)selectedOptIn
{
    optInBox.selected = !optInBox.selected;
}

-(IBAction)loadDataEntry
{
    NSLog(@"nextView");
    CGRect frame;
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    /*if(optInBox.selected){
        appDelegate.optIn = NO;
    }else{
        appDelegate.optIn = YES;
    }
     */
    appDelegate.optIn = NO;
    
    // Build Login View (ROOT VIEW)
    if(tabbedVC == nil){
        tabbedVC = [[TabbedViewController alloc] initWithNibName:@"TabbedViewController_Landscape" bundle:nil];
        frame = tabbedVC.view.frame;
        frame.origin.y = frame.origin.y - 55.0f;
        tabbedVC.view.frame = frame;
    }
    [tabbedVC _updateView];
    [appDelegate.rootVC showHeader];
    
        
    [self.navigationController pushViewController:tabbedVC animated:YES];
}

@end

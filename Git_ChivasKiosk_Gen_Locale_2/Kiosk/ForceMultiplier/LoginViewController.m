//
//  LoginViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/11/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "LoginViewController.h"
#import "DataAccess.h"

@implementation LoginViewController

@synthesize settingsVC,user,pass,currentTextField, da;

BOOL keyBoardIsOpen;

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
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
        da = [appDelegate da];
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
    textFields = [NSArray arrayWithObjects:user,pass,nil];
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
    [[appDelegate rootVC] hideErrorMessage];
   
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
     */
    
     
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)orientationDidChange:(NSNotification *)note
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    keyBoardIsOpen = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameChangeNotification:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];

    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - View Management
- (void)loadNextView
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rootVC unlockScreen];
    [appDelegate.rootVC showCancel];
    
    [[appDelegate rootVC]hideErrorMessage];
    
    // shahab open commented
//    if(settingsVC == nil){
//        settingsVC = [[KioskSettingsViewController alloc] initWithNibName:@"KioskSettingsViewController" bundle:nil];
//    }
//    [self.navigationController pushViewController:settingsVC animated:YES];
 
    // shahab close commented
    
    // shahab open
    
    if([self appDelegate].settingsVw == nil){
        [self appDelegate].settingsVw = [[KioskSettingsViewController alloc] initWithNibName:@"KioskSettingsViewController" bundle:nil];
    }

    //[self appDelegate].settingsVw = settingsVC;
    [self.navigationController pushViewController:[self appDelegate].settingsVw animated:YES];

    // shahab close
    
}

-(void)loginSuccessful
{
 
    // shahab open
    [self appDelegate].userIsLoggedIn = YES;
    // shahab close
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate da] saveUser:self.user.text Password:self.pass.text];
    [self loadNextView];
}

-(void)loginUnsuccessful
{
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rootVC unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Login Failed. Please Try Again."];
}

#pragma mark - IBActions

- (IBAction)login
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rootVC lockScreen];
    
    [da loginWithUser:self.user.text Password:self.pass.text forVC:self];
} 

#pragma keyboard notifications

- (void) keyboardFrameChangeNotification :(NSNotification*) notification {
    if (keyboardIsShown) {
        [self keyboardDidShow:notification];
    } else {
        [self keyboardDidHide:notification];
    }
    
}

-(void) keyboardDidShow:(NSNotification *) notification 
{
    //implement if needed
    keyboardIsShown = YES;
}

-(void) keyboardDidHide:(NSNotification *) notification 
{
    
    NSLog(@"keyboardDidHide with notification: %@",notification);
    if(keyboardIsShown == NO) NSLog(@"keyboard not shown");
    if(![currentTextField isFirstResponder]) NSLog(@"textfield not firstResponder");
    
    //CGPoint currentOffset;
    if(keyboardIsShown == YES && ![currentTextField isFirstResponder]){
        //Uncomment to enable auto scroll
        //*
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
        UIScrollView *masterScroll = [[appDelegate rootVC] scrollView];
        CGPoint offset = CGPointMake(0.0, 0.0);
        //currentOffset = [masterScroll contentOffset];
        [masterScroll setContentOffset:offset animated:YES];
        //*//*
        
        // [masterScroll setContentOffset:0.0 animated:YES];
        keyboardIsShown = NO;
    }
    
        
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
       
    //Set 'editing' flag
	isEditing = YES;
    //Create index property for textField index
	int index;
	
    //Find current textfield and select the next
	
    if(textField == self.user)
    {
        [self.pass becomeFirstResponder];
        return YES;
    }
	
	//Resign focus from current textfield
    [textField resignFirstResponder];
    [self login];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
        
    currentTextField = textField;
	NSLog(@"didbeginediting");
	
	isEditing = YES;
    
    //Find current textfield and return its index
    
    
      //Move Scroll View Appropriately
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
        UIScrollView *masterScroll = [[appDelegate rootVC] scrollView];
        
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:masterScroll];
        pt = rc.origin;
        pt.x = 0;
        if(pt.y >264){ 
            pt.y -= 264;
            [masterScroll setContentOffset:pt animated:YES];
        }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[[appDelegate rootVC]hideErrorMessage];
	//isEditing = NO;
}

- (id)indexForTextField:(UITextField *)textField{
    int index = 0;
	
    //Find current textfield and return its index
	for(UITextField *field in textFields){
		if(field == textField){
			return [NSNumber numberWithInt:index];
		}
		index++;
	}
    
    //No textfield found, return NO
    return NO;
}

-(void)clearFields
{
    //Find current textfield and return its index
	//for(UITextField *field in textFields){
		user.text = @"";
        pass.text = @"";
	//}
    //[self _layoutPage];
}

@end

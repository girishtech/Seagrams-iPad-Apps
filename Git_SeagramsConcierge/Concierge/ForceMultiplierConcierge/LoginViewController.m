//
//  LoginViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/11/11.
//  Contributions by Dustin Fineout.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import "LoginViewController.h"


@implementation LoginViewController

@synthesize eventDetailVC, user, pass, lang, currentTextField,keyboardIsShown,webAddress;

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
    NSLog(@"LoginViewController - viewDidLoad");
    [super viewDidLoad];
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC] hideSyncBtn];
    // Do any additional setup after loading the view from its nib.
    textFields = [NSArray arrayWithObjects:user,pass,lang,nil];
    
    //Subscribe to Keyboard Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameChangeNotification:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidShow:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
//
//    
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

- (void)orientationDidChange:(NSNotification *)note
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC] hideSyncBtn];
    webAddress.text = [[appDelegate web] WS_URL];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - View Management
- (void)loadNextView
{
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC] showSyncBtn];
    [appDelegate.rootVC unlockScreen];
    //[appDelegate.rootVC showCancel];
    
    [[appDelegate rootVC]hideErrorMessage];
    if(eventDetailVC == nil){
        eventDetailVC = [[EventDetailViewController alloc] initWithNibName:@"EventDetailViewController_Landscape" bundle:nil];
    }
    [[appDelegate rootVC] setEventDetailVC:eventDetailVC];
    [self.navigationController pushViewController:eventDetailVC animated:YES];
}

#pragma mark - IBActions

- (IBAction)login
{
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rootVC lockScreen];
    [[appDelegate da] loginWithUser:self.user.text Password:self.pass.text forVC:self];
}

-(void)loginSuccessful
{
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate da] saveUser:self.user.text Password:self.pass.text];
    [self loadNextView];
    [[appDelegate rootVC] showSyncBtn];
}

-(void)loginUnsuccessful
{
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rootVC unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Login Failed. Please Try Again."];
    
}

- (IBAction)changeWebAddress
{
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[appDelegate da] setWebAddress:webAddress.text];
} 

- (IBAction)resetWebAddress
{
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *ws_url;
    ws_url = WS_PROD;
    //DEV
	if(RELEASE == 0) ws_url = WS_DEV;
    //STAGING
    if(RELEASE == 1) ws_url = WS_STG;
    //PRODUCTION
    if(RELEASE == 2) ws_url = WS_PROD;
    
    [[appDelegate da] setWebAddress:ws_url];
    webAddress.text = [[appDelegate web] WS_URL];
} 

#pragma keyboard notifications

- (void) keyboardFrameChangeNotification :(NSNotification*) notification {
    if (!keyboardIsShown) {
        [self keyboardDidShow:notification];
    } else {
        [self keyboardDidHide:notification];
    }
}

- (void) keyboardDidShow:(NSNotification *) notification 
{
    //implement if needed
    keyboardIsShown = YES;
}

- (void) keyboardDidHide:(NSNotification *) notification 
{
    
    NSLog(@"LoginViewController - keyboardDidHide with notification: %@",notification);
    if(keyboardIsShown == NO) NSLog(@" - keyboard not shown");
    if(![currentTextField isFirstResponder]) NSLog(@" - textfield not firstResponder");
    
    //CGPoint currentOffset;
    if(keyboardIsShown == YES && ![currentTextField isFirstResponder]){
        //Uncomment to enable auto scroll
        //*
        ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
        UIScrollView *masterScroll = [[appDelegate rootVC] scrollView];
        CGPoint offset = CGPointMake(0.0, 0.0);
        //currentOffset = [masterScroll contentOffset];
        [masterScroll setContentOffset:offset animated:YES];
        //*/
        
        // [masterScroll setContentOffset:0.0 animated:YES];
        keyboardIsShown = NO;
    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
       
    //Set 'editing' flag
	isEditing = YES;
    
    //TODO: DO WE NEED THIS?? Create index property for textField index
	int index;
	
    //Find current textfield and select the next
	if (textField == self.lang)
    {
        [self.user becomeFirstResponder];
        return YES;
    }
    else if (textField == self.user)
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
	NSLog(@"LoginViewController - textFieldDidBeginEditing");
	
	isEditing = YES;
    
    //Find current textfield and return its index
    //TODO: DO WE NEED TO DO SOMETHING HERE THAT WE CURRENTLY AREN'T?
    
    //Move Scroll View Appropriately
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
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
	ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC] hideErrorMessage];
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

- (void)clearFields
{
    //Find current textfield and return its index
	//for(UITextField *field in textFields){
		user.text = @"";
        pass.text = @"";
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
   
    //[[appDelegate rootVC] hideSyncBtn];
    webAddress.text = [[appDelegate web] WS_URL];
	//}
    //[self _layoutPage];
}

@end

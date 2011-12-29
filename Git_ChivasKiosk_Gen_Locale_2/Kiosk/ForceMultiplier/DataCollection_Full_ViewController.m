//
//  DataCollection_Full_ViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/16/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "DataCollection_Full_ViewController.h"
#import "PhotoConsentViewController.h"
#import "RootViewController.h"


@implementation DataCollection_Full_ViewController

BOOL keyBoardIsOpen;

@synthesize firstName,lastName,email,confirmEmail,telephone_1,telephone_2,telephone_3,day,month,year,address_1,address_2,city,state,zip,optIn,content,isEditing,keyboardIsShown,person,person_update,person_archive,context,disclaimerText,currentOffset,popoverY,rightSide,disclaimer,next_btn,addressBox,currentPicker,states,popoverShown,popoverBuilding,accountName, dob;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
        da = [appDelegate da];
        states = [[NSDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:[[NSArray alloc] initWithObjects:@"AL",
                                                                                        @"AK",
                                                                                         @"AZ",
                                                                                         @"AR",
                                                                                         @"CA",
                                                                                         @"CO",
                                                                                         @"CT",
                                                                                         @"DE",
                                                                                         @"FL",
                                                                                         @"GA",
                                                                                         @"HI",
                                                                                         @"ID",
                                                                                         @"IL",
                                                                                         @"IN",
                                                                                         @"IA",
                                                                                         @"KS",
                                                                                         @"KY",
                                                                                         @"LA",
                                                                                         @"ME",
                                                                                         @"MD",
                                                                                         @"MA",
                                                                                         @"MI",
                                                                                         @"MN",
                                                                                         @"MS",
                                                                                         @"MO",
                                                                                         @"MT",
                                                                                         @"NE",
                                                                                         @"NV",
                                                                                         @"NH",
                                                                                         @"NJ",
                                                                                         @"NM",
                                                                                         @"NY",
                                                                                         @"NC",
                                                                                         @"ND",
                                                                                         @"OH",
                                                                                         @"OK",
                                                                                         @"OR",
                                                                                         @"PA",
                                                                                         @"RI",
                                                                                         @"SC",
                                                                                         @"SD",
                                                                                         @"TN",
                                                                                         @"TX",
                                                                                         @"UT",
                                                                                         @"VT",
                                                                                         @"VA",
                                                                                         @"WA",
                                                                                         @"WV",
                                                                                         @"WI",
                                                                                         @"WY", nil],nil]
                    forKeys:[[NSArray alloc] initWithObjects:@"states",nil]];
        popoverShown = NO;
        popoverBuilding = NO;
                  
    }
    return self;
}

- (void)dealloc
{
    [dob release];
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
    isEditing = NO;
    keyboardIsShown = NO;
    optIn.selected = YES;
    currentPicker = @"dob";
    
    disclaimerText = @"Yes, I would like to receive marketing materials, communications and other materials from Kahlua.";
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    person = nil;
    person_update = nil;
    
    
    
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    CGRect frame = [[[appDelegate rootVC] scrollView] frame];
    CGSize scrollContentSize = CGSizeMake(frame.size.width, (frame.size.height*2));
    [[[appDelegate rootVC] scrollView] setContentSize:scrollContentSize];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidHide:)
//                                                 name:UIKeyboardDidHideNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidShow:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
//     
    
    
    
    //Set styling on textfields
    textFields = [[NSArray alloc] initWithObjects:firstName,lastName,/*accountName,*/email,confirmEmail,telephone_1,telephone_2,telephone_3,zip, nil];
    //month,day,year,address_1,address_2,city,state,zip,nil];
	for(UITextField *aTextField in textFields){
        aTextField.borderStyle = UITextBorderStyleBezel;
        aTextField.backgroundColor = [UIColor whiteColor];
        aTextField.enabled = YES;
        aTextField.userInteractionEnabled = YES;
	}
    
    
    rightSide.userInteractionEnabled = YES;
    content.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    
    
    //Instantiate PopOvers
    pickerViewController = [[PickerViewController alloc] init];
	pickerViewController.components = states;
    pickerViewController.delegate = self;
	popOverControllerWithPicker = [[UIPopoverController alloc] initWithContentViewController:pickerViewController];
    popOverControllerWithPicker.delegate = self;
	popOverControllerWithPicker.popoverContentSize = CGSizeMake(300, 216);    
    
    firstName.enabled = YES;
    NSLog(@"textfield: %@, x: %f, y: %f",firstName,firstName.frame.origin.x,firstName.frame.origin.y);
    
    [self _layoutPage];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    keyBoardIsOpen = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameChangeNotification:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
   
        [super viewDidAppear:animated];
        [self _layoutPage];
    
    optIn.selected = YES;
    
    NSLog(@"viewDidAppear fullView");
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    /*
    // Return YES for supported orientations
    [self _layoutPage];
    
    //Register for orientation changes
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(orientationDidChange:) 
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
	return YES;
     */
}

- (void)orientationDidChange:(NSNotification *)note
{
    NSLog(@"DataCollection_Full - new orientation = %d", [[UIDevice currentDevice] orientation]);
    [self _layoutPage];
}

-(void)_layoutPage
{
    NSLog(@"DataCollection_Full - layout page for new orientation = %d", [[UIDevice currentDevice] orientation]);
    
    //OLD WAY
    /*
    CGRect frame = self.view.frame;
    frame.origin.y = 0.0f;
    frame.origin.x = -30.0f;
    self.view.frame = frame;
    
    //Manually center content
    frame = content.frame;
    if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait || 
       [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown || 
       [[UIDevice currentDevice] orientation] == 0)
    {
        frame.origin.y = 33;
        frame.origin.x = -30.0f;
    }else{
        frame.origin.y = 33;
    }
    content.frame = frame;
    //*/
    
    //Manually center content
    CGRect rightFrame = rightSide.frame;
    CGRect addressFrame = addressBox.frame;
    CGRect frame = content.frame;
    CGRect viewFrame = self.view.frame;
    NSNumber *newWidth;
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || 
       [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)// || 
        //[[UIDevice currentDevice] orientation] == 0)
    {
        newWidth = [NSNumber numberWithFloat:280.0f];
        frame.origin.y = 33.0f;
        frame.origin.x = 70.0f;
        /*if([[UIDevice currentDevice] orientation] != 0)*/ 
        [self setDisclaimerTextView:[NSNumber numberWithInt:1]];
        rightFrame.origin.x = 334.0f;// - 60.0f;
        rightFrame.origin.y = 330.0f;
        addressFrame.origin.x = 340.0f;
        addressFrame.origin.y = 152.0f;
        viewFrame.size.width = 748.0f;
        /*viewFrame.size.height = 800;
        viewFrame.size.width = 800;
        frame.size.height = 800;
        frame.size.width = 800;
         //*/
    }
    else
    {
        newWidth = [NSNumber numberWithFloat:320.0f];
        frame.origin.y = 40.0f;
        frame.origin.x = 10.0f;
        [self setDisclaimerTextView:[NSNumber numberWithInt:2]];
        rightFrame.origin.x = 668.0f;
        rightFrame.origin.y = 63.0f;
        addressFrame.origin.x = 340.0f;
        addressFrame.origin.y = 249.0f;
        viewFrame.size.width = 1024.0f;
        /*
        viewFrame.size.height = 800;
        viewFrame.size.width = 800;
        frame.size.height = 800;
        frame.size.width = 800;
         //*/
    }
    
    addressBox.frame = addressFrame;
    rightSide.frame = rightFrame;
    content.frame = frame;
    self.view.frame = viewFrame;
    [self resizeTextFields:newWidth];
    
    if(popOverControllerWithPicker!=nil)
    {
        if(popOverControllerWithPicker.popoverVisible)
        {
            //*
            if(popoverShown)
            {
                NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                                      target:self
                                                                    selector:@selector(displayPickerPopover)
                                                                    userInfo:nil
                                                                     repeats:NO];
            }
            //*/
        }
    }
    
    [self.view setNeedsDisplay];
    [self.view setNeedsLayout];
    [content setNeedsDisplay];
    [content setNeedsLayout];
     
}

#pragma PopOver Methods

-(void)displayPickerPopover
{
    //OLD WAY
    /*
     [self dismissFirstResponder];
     
     CGFloat newX = dob.frame.origin.x;
     CGFloat newY = dob.frame.origin.y;
     
     CGSize sizeOfPopover = CGSizeMake(300.0, 220.0);
     CGPoint positionOfPopover = CGPointMake(newX, newY);
     [popOverControllerWithPicker presentPopoverFromRect:CGRectMake(positionOfPopover.x, positionOfPopover.y, sizeOfPopover.width, sizeOfPopover.height)
     inView:self.content permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
     //*/
    [self dismissFirstResponder];
    if(!popoverBuilding)
    {
        popoverBuilding = YES;
        NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                              target:self
                                                            selector:@selector(_displayPickerPopover)
                                                            userInfo:nil
                                                             repeats:NO];
    }

    
}

-(void)_displayPickerPopover
{
    popoverShown = YES;
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    UIScrollView *masterScroll = [[appDelegate rootVC] scrollView];
    
    CGFloat newX = dob.frame.origin.x;
    CGFloat newY = dob.frame.origin.y;
    
	CGSize sizeOfPopover = CGSizeMake(300.0, 220.0);
	CGPoint positionOfPopover = CGPointMake(newX, newY);
    
    NSLog(@"dob y: %f",dob.frame.origin.y);
    
    CGRect rc = dob.frame;
    //rc = [dob convertRect:rc toView:masterView];
    popoverY = (self.view.frame.origin.y + content.frame.origin.y + rightSide.frame.origin.y + dob.frame.origin.y - masterScroll.contentOffset.y);
    
    
	[popOverControllerWithPicker presentPopoverFromRect:CGRectMake(positionOfPopover.x, positionOfPopover.y, sizeOfPopover.width, sizeOfPopover.height)
												 inView:self.rightSide permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];

   
//    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
//    UIScrollView *masterScroll = [[appDelegate rootVC] scrollView];
//    
//    popoverShown = YES;
    
    /*
    if([currentPicker isEqualToString:@"dob"]){
        pickerViewController.thePickerView.hidden = YES;
        pickerViewController.theDatePickerView.hidden = NO;
        
        CGFloat newX = dob.frame.origin.x + rightSide.frame.origin.x;
        CGFloat newY = dob.frame.origin.y - 220.0f + 31.0f +rightSide.frame.origin.y;
        
        CGSize sizeOfPopover = CGSizeMake(300.0, 220.0);
        CGPoint positionOfPopover = CGPointMake(newX, newY);
        
        NSLog(@"dob y: %f",dob.frame.origin.y);
        
        CGRect rc = dob.frame;
        //rc = [dob convertRect:rc toView:masterView];
        popoverY = (self.view.frame.origin.y + content.frame.origin.y + dob.frame.origin.y - masterScroll.contentOffset.y);
        
        
        [popOverControllerWithPicker presentPopoverFromRect:CGRectMake(positionOfPopover.x, positionOfPopover.y, sizeOfPopover.width, sizeOfPopover.height)
                                                     inView:self.content permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }else{
        pickerViewController.thePickerView.hidden = NO;
        pickerViewController.theDatePickerView.hidden = YES;
        
        CGFloat newX = state.frame.origin.x-115.0f;// + rightSide.frame.origin.x;
        CGFloat newY = state.frame.origin.y;// /*- 220.0f*/ + 31.0f;// +rightSide.frame.origin.y;
     /*   
        CGSize sizeOfPopover = CGSizeMake(300.0, 220.0);
        CGPoint positionOfPopover = CGPointMake(newX, newY);
        
        NSLog(@"dob y: %f",state.frame.origin.y);
        
        CGRect rc = state.frame;
        //rc = [dob convertRect:rc toView:masterView];
        popoverY = (self.view.frame.origin.y + content.frame.origin.y + state.frame.origin.y - masterScroll.contentOffset.y);
        
        
        [popOverControllerWithPicker presentPopoverFromRect:CGRectMake(positionOfPopover.x, positionOfPopover.y, sizeOfPopover.width, sizeOfPopover.height)
                                                     inView:self.content permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    */
}

-(IBAction)clickedDOB
{
    
    //currentPicker = @"dob";
    
    [self displayPickerPopover];
     
}

-(IBAction)clickedState
{
    /*
    currentPicker = @"state";
    [self displayPickerPopover];
     */
}

-(void)valuesDidChangeTo:(NSDictionary*)values
{
    /*NSLog(@"New Values: %@",values);
    if([currentPicker isEqualToString:@"dob"]){
        dob.text = [self parseDate:[values objectForKey:@"date"]];
    }else{
        state.text = [values objectForKey:@"states"];
    }*/
    [dob setTitle:[self parseDate:[values objectForKey:@"date"]] forState:UIControlStateNormal];
}

-(void)popoverShown
{
    NSLog(@"Popover Shown");
    popoverBuilding = NO;
    [self dismissFirstResponder];
}

#pragma mark -

#pragma keyboard notifications

- (void) keyboardFrameChangeNotification :(NSNotification*) notification {
    keyBoardIsOpen = !keyBoardIsOpen;
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
    //OLD WAY
    /*
    NSLog(@"keyboardDidHide with notification: %@",notification);
    if(keyboardIsShown == NO && ![currentTextField isFirstResponder]){
        //Uncomment to enable auto scroll
        //*
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
        UIScrollView *masterScroll = [[appDelegate rootVC] scrollView];
        CGPoint offset = CGPointMake(0.0, 0.0);
        [masterScroll setContentOffset:offset animated:YES];
        //*//*
        
        // [masterScroll setContentOffset:0.0 animated:YES];
        keyboardIsShown = NO;
        
        if(popOverControllerWithPicker!=nil)
        {
            if(popOverControllerWithPicker.popoverVisible)
            {
                //[popOverControllerWithPicker dismissPopoverAnimated:YES];
                [self displayPickerPopover];
            }
        }
        
    }
    //*/
    
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
        currentOffset = [masterScroll contentOffset];
        [masterScroll setContentOffset:offset animated:YES];
        //*//*
        
        // [masterScroll setContentOffset:0.0 animated:YES];
        keyboardIsShown = NO;
    }
    
    if(popOverControllerWithPicker!=nil)
    {
        if(popOverControllerWithPicker.popoverVisible)
        {
            UIView *popover = pickerViewController.view.superview.superview.superview;
            CGRect newCellFrame = popover.frame;
            CGFloat negOffset = 0.0f;
            //*
            if(popoverY < 220)
            {
                //if textfields y is less than popovers height, use the difference as the offset
                NSLog(@"offset: %f",popoverY);
                negOffset = newCellFrame.origin.y + newCellFrame.size.height - popoverY + 80.0f;
                
            }//*/
            if(currentOffset.y != 0.0f)
            {
                if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || 
                   [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown){
                    newCellFrame.origin.y = 210.0f;//newCellFrame.origin.y - currentOffset.y + negOffset - 220.0f - 20.0f;//popoverY; // + currentOffset.y 
                }else{
                    newCellFrame.origin.y = 240.0f;//newCellFrame.origin.y - currentOffset.y + negOffset - 220.0f - 20.0f;//popoverY; // + currentOffset.y 
                }
            }
            NSLog(@"popover: %@",popover);
            [UIView animateWithDuration:0.35 animations:^(void) {
                                                                    popover.frame = newCellFrame;
                                                                }]; 
        }
    }

    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
        
    //Set 'editing' flag
	isEditing = YES;
    //Create index property for textField index
	int index;
	
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]hideErrorMessage];

    
    //Find current textfield and select the next
	
    if([self indexForTextField:textField]!=NO)
    {
        index = [[self indexForTextField:textField]integerValue];
        NSLog(@"index value: %d",index);
        
        if(index < ([textFields count] - 2)){
            /*
            if(index == 6)
            {
                currentPicker = @"dob";
                NSLog(@"Selected DOB, display popover");
                [textField resignFirstResponder];
                //[self dismissFirstResponder];
                NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                                      target:self
                                                                    selector:@selector(displayPickerPopover)
                                                                    userInfo:nil
                                                                     repeats:NO];
                return YES;
            }
            
            if(index == 9)
            {
                currentPicker = @"state";
                NSLog(@"Selected state, display popover");
                /*[textField resignFirstResponder];
                //[self dismissFirstResponder];
                NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                                      target:self
                                                                    selector:@selector(displayPickerPopover)
                                                                    userInfo:nil
                                                                     repeats:NO];
                return YES;*/
            //}

            [[textFields objectAtIndex:(index+1)] becomeFirstResponder];
            return YES;
        }
    }
	
	//Resign focus from current textfield
    
    if (textField == telephone_3) {
        [NSTimer scheduledTimerWithTimeInterval:0.35 target:self selector:@selector(clickedDOB) userInfo:nil repeats:NO];
    } else if (textField == address_1 || textField == address_2 || textField == city || textField == state || textField == zip ) {///
        UITextField *field = [self nextField:textField];
        if (field!=nil) {
            [field becomeFirstResponder];
        }
    }
    [textField resignFirstResponder];

    return YES;
}

- (UITextField*)nextField :(UITextField*)textfield {
    NSArray *fieldArray = [NSArray arrayWithObjects:address_1,address_2,state,zip, nil];
    NSInteger index = [fieldArray indexOfObject:textfield];
    if (index>=([fieldArray count]-1)) {
        return nil;
    } 
    return [fieldArray objectAtIndex:(index+1)];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
  
    currentTextField = textField;
	NSLog(@"didbeginediting");
	ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[appDelegate rootVC]hideErrorMessage];
	isEditing = YES;
    
    //Find current textfield and return its index
    /*
    if(textField == dob || textField == state){
        //[textField resignFirstResponder];
        //[self dismissFirstResponder];
    }
    
    if(textField == dob){ 
        NSLog(@"Selected dob, display popover");
        [textField resignFirstResponder];
        currentPicker = @"dob";
        //[self performSelectorOnMainThread:@selector(displayPickerPopover) withObject:nil waitUntilDone:YES];
        NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                              target:self
                                                            selector:@selector(displayPickerPopover)
                                                            userInfo:nil
                                                             repeats:NO];
    }else if(textField == state){
        NSLog(@"Selected state, display popover");
        [textField resignFirstResponder];
        currentPicker = @"state";
        //[self performSelectorOnMainThread:@selector(displayPickerPopover) withObject:nil waitUntilDone:YES];
        NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                              target:self
                                                            selector:@selector(displayPickerPopover)
                                                            userInfo:nil
                                                             repeats:NO];
    }else{*/
        //Move Scroll View Appropriately
        //ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
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
  //  }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[[appDelegate rootVC]hideErrorMessage];
	//isEditing = NO;
}

-(IBAction)textFieldChanged:(id)sender
{
    NSLog(@"valueChanged");
    UITextField *field = (UITextField*)sender;
    if(field == self.telephone_1){
        if([field.text length]==3){
            [telephone_2 becomeFirstResponder];
        }
    }
    if(field == self.telephone_2){
        if([field.text length]==3){
            [telephone_3 becomeFirstResponder];
        }
    }
    if(field == self.telephone_3){
        if([field.text length]==4){
            [month becomeFirstResponder];
        }
    }
    if(field == self.month){
        if([field.text length]==2){
            if([field.text integerValue] > 12){
                field.text = @"12";
            }else{
                [day becomeFirstResponder];
            }
        }
    }
    if(field == self.day){
        if([field.text length]==2){
            if([field.text integerValue] > 31){
                field.text = @"31";
            }else{
                [year becomeFirstResponder];
            }
        }
    }

    if(field == self.year){
        if([field.text length]==2){
            [address_1 becomeFirstResponder];
        }
    }
}

#pragma mark - 

#pragma mark - Custom Textfield Management

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

- (void)resizeTextFields:(NSNumber*)newWidth{
    /*
    CGRect frame;
	for(UITextField *field in textFields){
        if(field != self.telephone_1 && field != self.telephone_2 && field != self.state)
        {
            frame = field.frame;
            frame.size.width = [newWidth floatValue];
            
            if(field == self.telephone_3)
            {
                frame.size.width = [newWidth floatValue] - 209.0f;
            }
            
            if(field == self.zip)
            {
                frame.size.width = [newWidth floatValue] - 82.0f;
            }
            
            field.frame = frame;
        }
	}
    
    frame = self.next_btn.frame;
    frame.origin.x = 5.0f + ([newWidth floatValue] - 127.0f);
    self.next_btn.frame = frame;
    
    frame = self.disclaimer.frame;
    frame.size.width = [newWidth floatValue] + 18.0f;
    self.disclaimer.frame = frame;
     */
}

-(void)clearFields
{
    //Find current textfield and return its index
	for(UITextField *field in textFields){
		field.text = @"";
	}
    [dob setTitle:@"" forState:UIControlStateNormal];
    address_1.text = @"";
    address_2.text = @"";

    state.text = @"";
    
    [self _layoutPage];
    optIn.selected = YES;
    person = nil;
    person_update = nil;

}

#pragma mark -

-(void)setDisclaimerTextView:(NSNumber*)size
{
    NSString *headString = [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;padding:0px;text-align:justify;}</style> </head><body><p><font face='Helvetica' size='%d' color='#ffdd00'><bold>",[size integerValue]];
    NSString *htmlString = [NSString stringWithFormat:@"%@%@%@",headString,disclaimerText,@"</bold></font></p></body></html>"];
    [disclaimer loadHTMLString:htmlString baseURL:nil];
    disclaimer.opaque = NO;
    disclaimer.backgroundColor = [UIColor clearColor];
}

/*
-(IBAction)nextView
{
    NSLog(@"nextView");
    [self dismissFirstResponder];
    if([self validateFields])
    {
        [self createPerson];
        
        DataCollection_Question_ViewController *questionsVC = [[DataCollection_Question_ViewController alloc] initWithNibName: @"DataCollection_Question_ViewController" bundle:nil];
        
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
        [[appDelegate rootVC] hideErrorMessage];
        
        [[[appDelegate rootVC] navController] pushViewController:questionsVC animated:YES];
        
    }
}

*/

-(IBAction)nextView
{
    [self dismissFirstResponder];
    
    //if fields validate, set person values
    if([self validateFields])
    {
        [self createPerson];
        [self savePerson];
        
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
        [[appDelegate rootVC] hideErrorMessage];
        
        NSLocale *locale = [NSLocale currentLocale];
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSLog(language);
        
        
        if([language isEqualToString:@"en"]){
            if(HIDES_HEADER_ON_SURVEY_PAGE)
            {
                [[appDelegate rootVC] hideHeader];
            }
  
            PhotoConsentViewController *questionListVC = [[PhotoConsentViewController alloc] initWithNibName:@"PhotoConsentViewController" bundle:nil];
            [[[appDelegate rootVC] navController] pushViewController:questionListVC animated:YES];

            
//            QuestionListViewController *questionListVC = [[QuestionListViewController alloc] initWithNibName:@"QuestionListViewController" bundle:nil];
//            [[[appDelegate rootVC] navController] pushViewController:questionListVC animated:YES];
        }else{
            if(HIDES_HEADER_ON_THANKYOU_PAGE)
            {
                [[appDelegate rootVC] hideHeader];
            }
            
            ThankYouPurchaseViewController *thankYouVC = [[ThankYouPurchaseViewController alloc] initWithNibName:@"ThankYouPurchaseViewController" bundle:nil];
            
            [[[appDelegate rootVC] navController] pushViewController:thankYouVC animated:YES];
        }

    }
}

-(IBAction)selectOptIn{
    if(optIn.selected){
        optIn.selected = NO;
    }else{
        optIn.selected = YES;
    }
}


-(NSString*) parseDate:(NSDate*)aDate{
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    NSString *newDateString = [outputFormatter stringFromDate:aDate];
    
    
	[outputFormatter release];
	
    return newDateString;
    // For US English, the output is:
    // newDateString 10:30 on Sunday July 11
}
-(BOOL)numberValid:(UITextField*)textField
{
    BOOL valid=NO;
    for(int j=0;j<[textField.text length];j++)
	{
		NSInteger i =[textField.text characterAtIndex:j];
		
		if(i<48 || i>57)
		{
            valid=NO;
            
			
		}
        else{
            valid=YES;
            
        }
	}
    return valid;
}

-(Boolean)validateFields
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(language);
    
    
    if([language isEqualToString:@"en"]){ 
    
        //firstName,lastName,email,confirmEmail,telephone_1,telephone_2,telephone_3,dob,address_1,address_2,city,state,zip,optIn
        if([firstName.text isEqualToString:@""] || [firstName.text isEqualToString:@" "]){
            [[appDelegate rootVC]showErrorMessage:@"Please enter a valid first name."];
            [firstName becomeFirstResponder];
            firstName.highlighted = YES;
            return NO;
        }
        if([lastName.text isEqualToString:@""]){
            [[appDelegate rootVC]showErrorMessage:@"Please enter a valid last name."];
            [lastName becomeFirstResponder];
            lastName.highlighted = YES;
            return NO;
        }
        if (self.dob.titleLabel.text==nil || [self.dob.titleLabel.text isEqualToString:@""]) {
            [[appDelegate rootVC]showErrorMessage:@"Please enter a valid date of birth."];
            return NO;
        }
        if(![self numberValid:self.zip])
        {
            [[appDelegate rootVC]showErrorMessage:@"Please enter a valid date of birth."];
        
            return NO;
        }

//        if([month.text isEqualToString:@""]){
//            [[appDelegate rootVC]showErrorMessage:@"Please enter a valid date of birth."];
//            [month becomeFirstResponder];
//            return NO;
//        }
//        if([day.text isEqualToString:@""]){
//            [[appDelegate rootVC]showErrorMessage:@"Please enter a valid date of birth."];
//            [month becomeFirstResponder];
//            return NO;
//        }
//        if([year.text isEqualToString:@""]){
//            [[appDelegate rootVC]showErrorMessage:@"Please enter a valid date of birth."];
        //[[appDelegate rootVC]showErrorMessage:@"Por favor ingresa una fecha de nacimiento válida."];
//            [month becomeFirstResponder];
//            return NO;
//        }else{
//            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//            NSDate *currentDate = [NSDate date];
//            NSDateComponents *comps = [[NSDateComponents alloc] init];
//            [comps setYear:-21];
//            NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
//            
//            NSDate *birthDate = [self parseDateString:[NSString stringWithFormat:@"%@/%@/19%@",month.text,day.text,year.text]];
//            
//            if([birthDate compare:maxDate] == NSOrderedDescending){
//                [[appDelegate rootVC]showErrorMessage:@"Must be over 21 years of age."];
//                [month becomeFirstResponder];
//                return NO;
//            }
//
//        }
        
        if([[email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
            [[appDelegate rootVC]showErrorMessage:@"Please enter a valid email address."];
            [email becomeFirstResponder];
            email.highlighted = YES;
            return NO;
        }
        
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES '%@'", emailRegex];
        
        //NSPredicate *regexMail = [NSPredicate predicateWithFormat:@"SELF MATCHES '\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b'"];
        
            if((![email.text isEqualToString:confirmEmail.text]) || [email.text isEqualToString:@""]){
            
                [[appDelegate rootVC]showErrorMessage:@"Please confirm that email addresses match."];
                [email becomeFirstResponder];
                email.highlighted = YES;
                return NO;
            }
        if(![self NSStringIsValidEmail:email.text]){
            [[appDelegate rootVC]showErrorMessage:@"Please enter a valid email address."];
            [email becomeFirstResponder];
            email.highlighted = YES;
            return NO;
        }
        if([address_1.text isEqualToString:@""]){
            [[appDelegate rootVC]showErrorMessage:@"Please enter a valid address."];
            [address_1 becomeFirstResponder];
            address_1.highlighted = YES;
            return NO;
        }
        if([address_2.text isEqualToString:@""]){
            address_2.text = @" ";
        }
//        if([city.text isEqualToString:@""]){
//            [[appDelegate rootVC]showErrorMessage:@"Please enter a city."];
//            [city becomeFirstResponder];
//            city.highlighted = YES;
//            return NO;
//        }
        if([state.text isEqualToString:@""]){
            [[appDelegate rootVC]showErrorMessage:@"Please enter 2 lettered abbrevated state code."];
            [state becomeFirstResponder];
            state.highlighted = YES;
            return NO;
        }
        if([state.text length]>2){
            [[appDelegate rootVC]showErrorMessage:@"Please enter a valid state."];
            [state becomeFirstResponder];
            state.highlighted = YES;
            return NO;
        }
        if([zip.text isEqualToString:@""]){
            [[appDelegate rootVC]showErrorMessage:@"Please enter a zip code."];
            [zip becomeFirstResponder];
            zip.highlighted = YES;
            return NO;
        }
        if ([zip.text length]<5) {
            [[appDelegate rootVC]showErrorMessage:@"zip code must be atleast 5 digits."];
            [zip becomeFirstResponder];
            zip.highlighted = YES;
            return NO;
        }
        if([telephone_1.text isEqualToString:@""]){
            telephone_1.text = @" ";
        }
        if([telephone_2.text isEqualToString:@""]){
            telephone_2.text = @" ";
        }
        if([telephone_3.text isEqualToString:@""]){
            telephone_3.text = @" ";
        }
    }else{
        //firstName,lastName,email,confirmEmail,telephone_1,telephone_2,telephone_3,dob,address_1,address_2,city,state,zip,optIn
        if([firstName.text isEqualToString:@""] || [firstName.text isEqualToString:@" "]){
            [[appDelegate rootVC]showErrorMessage:@"Por favor ingresa tu nombre correcto."];
            [firstName becomeFirstResponder];
            firstName.highlighted = YES;
            return NO;
        }
        if([lastName.text isEqualToString:@""]){
            [[appDelegate rootVC]showErrorMessage:@"Por favor ingresa tu apellido correcto."];
            [lastName becomeFirstResponder];
            lastName.highlighted = YES;
            return NO;
        }
        if (self.dob.titleLabel.text==nil || [self.dob.titleLabel.text isEqualToString:@""]) {
            [[appDelegate rootVC]showErrorMessage:@"Por favor ingresa una fecha de nacimiento válida."];
            return NO;
        }

//        if([month.text isEqualToString:@""]){
//            [[appDelegate rootVC]showErrorMessage:@"Por favor ingresa una fecha de nacimiento válida."];
//            [month becomeFirstResponder];
//            return NO;
//        }
//        if([day.text isEqualToString:@""]){
//            [[appDelegate rootVC]showErrorMessage:@"Por favor ingresa una fecha de nacimiento válida."];
//            [month becomeFirstResponder];
//            return NO;
//        }
//        if([year.text isEqualToString:@""]){
//            [[appDelegate rootVC]showErrorMessage:@"Por favor ingresa una fecha de nacimiento válida."];
//            [month becomeFirstResponder];
//            return NO;
//        }else{
//            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//            NSDate *currentDate = [NSDate date];
//            NSDateComponents *comps = [[NSDateComponents alloc] init];
//            [comps setYear:-21];
//            NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
//            
//            NSDate *birthDate = [self parseDateString:[NSString stringWithFormat:@"%@/%@/19%@",month.text,day.text,year.text]];
//            
//            if([birthDate compare:maxDate] == NSOrderedDescending){
//                [[appDelegate rootVC]showErrorMessage:@"Debes ser mayor de 21 años."];
//                [month becomeFirstResponder];
//                return NO;
//            }
//            
//        }
        if([[email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
            [[appDelegate rootVC]showErrorMessage:@"Please enter a valid email address."];
            [email becomeFirstResponder];
            email.highlighted = YES;
            return NO;
        }
        
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES '%@'", emailRegex];
        
        //NSPredicate *regexMail = [NSPredicate predicateWithFormat:@"SELF MATCHES '\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b'"];
        
        if((![email.text isEqualToString:confirmEmail.text]) || [email.text isEqualToString:@""]){
            
            [[appDelegate rootVC]showErrorMessage:@"Por favor confirma que tus direcciones de correo electrónico coincidan."];
            [email becomeFirstResponder];
            email.highlighted = YES;
            return NO;
        }
        if(![self NSStringIsValidEmail:email.text]){
            [[appDelegate rootVC]showErrorMessage:@"Por favor ingresa una dirección de correo electrónico válida."];
            [email becomeFirstResponder];
            email.highlighted = YES;
            return NO;
        }
        if([address_1.text isEqualToString:@""]){
            [[appDelegate rootVC]showErrorMessage:@"Por favor ingresa tu dirección correcta."];
            [address_1 becomeFirstResponder];
            address_1.highlighted = YES;
            return NO;
        }
        if([address_2.text isEqualToString:@""]){
            address_2.text = @" ";
        }
        if([city.text isEqualToString:@""]){
            [[appDelegate rootVC]showErrorMessage:@"Por favor ingresa la ciudad."];
            [city becomeFirstResponder];
            city.highlighted = YES;
            return NO;
        }
        if([state.text isEqualToString:@""]){
            [[appDelegate rootVC]showErrorMessage:@"Por favor ingresa el estado."];
            [state becomeFirstResponder];
            state.highlighted = YES;
            return NO;
        }
        if([zip.text isEqualToString:@""]){
            [[appDelegate rootVC]showErrorMessage:@"Por favor ingresa el código postal."];
            [zip becomeFirstResponder];
            zip.highlighted = YES;
            return NO;
        }
        if ([zip.text length]<5) {
            [[appDelegate rootVC]showErrorMessage:@"zip code must be atleast 5 digits."];
            [zip becomeFirstResponder];
            zip.highlighted = YES;
            return NO;
        }
        if([telephone_1.text isEqualToString:@""]){
            telephone_1.text = @" ";
        }
        if([telephone_2.text isEqualToString:@""]){
            telephone_2.text = @" ";
        }
        if([telephone_3.text isEqualToString:@""]){
            telephone_3.text = @" ";
        }
    }
    
    return YES;
}

-(NSDate*) parseDateString:(NSString*)aDateString{
    NSLog(@"a DateString: %@",aDateString);
    //aDateString = [aDateString substringToIndex:18];
    //NSLog(@"a DateString: %@",aDateString);
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *newDate = [outputFormatter dateFromString:aDateString];
    
    
	[outputFormatter release];
	
    return newDate;
    // For US English, the output is:
    // newDateString 10:30 on Sunday July 11
}


-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if([emailTest evaluateWithObject:checkString]){
        NSLog(@"valid Email");
    }else{
        NSLog(@"invalid Email");
    }
    return [emailTest evaluateWithObject:checkString];
}

-(void)createPerson
{
    person = nil;
    person_update = nil;
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    person = [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:context];
    person_update = [NSEntityDescription insertNewObjectForEntityForName:@"Trans_Queue_Author" inManagedObjectContext:context];
    
    NSString *GUID = [da generateUuidString];
    
    //CREATE MAIN AUTHOR ENTITY
    [person setValue:firstName.text forKey:@"FirstName"];
    [person setValue:lastName.text forKey:@"LastName"];
    
    NSDate *dt = [self parseDateString1:dob.titleLabel.text];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:dt];
    NSInteger day1 = [components day];    
    NSInteger month1 = [components month];
    NSInteger year1 = [components year];
    
    //[person setValue:[[NSString alloc] initWithFormat:@"%@/%@/19%@",month.text,day.text,year.text] forKey:@"DOB"];
  
    [person setValue:[[NSString alloc] initWithFormat:@"%d/%d/%d",month1,day1,year1] forKey:@"DOB"];

    
    [person setValue:email.text forKey:@"Email"];
    [appDelegate rootVC].emailAddress = email.text;
    NSString *telephone = [NSString stringWithFormat:@"%@%@%@",telephone_1.text,telephone_2.text,telephone_3.text];
    [person setValue:telephone forKey:@"Phone"];
    [person setValue:address_1.text forKey:@"Address1"];
    [person setValue:address_2.text forKey:@"Address2"];
    [person setValue:city.text forKey:@"City"];
    [person setValue:state.text forKey:@"StateProvince"];
    [person setValue:zip.text forKey:@"PostalCode"];
    //[person setValue:[NSString stringWithFormat:@"JBB Account Name %@",accountName.text] forKey:@"AccountName"];
    [person setValue:da.currentSession forKey:@"TimeID"];
    [person setValue:@"false" forKey:@"Sent"];
    if(appDelegate.optIn){
        [person setValue:[[NSString alloc] initWithString:@"true"] forKey:@"Opt_In"];
    }else{
        [person setValue:[[NSString alloc] initWithString:@"false"] forKey:@"Opt_In"];
    }
    [person setValue:GUID forKey:@"RemoteSystemID"];
    [person setValue:da.brandID forKey:@"BrandID"];
    
    
    //CREATE QUEUE AUTHOR ENTITY
    [person_update setValue:firstName.text forKey:@"FirstName"];
    [person_update setValue:lastName.text forKey:@"LastName"];
    //[person_update setValue:[[NSString alloc] initWithFormat:@"%@/%@/19%@",month.text,day.text,year.text] forKey:@"DOB"];
    [person_update setValue:[[NSString alloc] initWithFormat:@"%d/%d/%d",month1,day1,year1] forKey:@"DOB"];

    [person_update setValue:email.text forKey:@"Email"];
    [person_update setValue:telephone forKey:@"Phone"];
    [person_update setValue:address_1.text forKey:@"Address1"];
    [person_update setValue:address_2.text forKey:@"Address2"];
    [person_update setValue:city.text forKey:@"City"];
    [person_update setValue:state.text forKey:@"StateProvince"];
    [person_update setValue:zip.text forKey:@"PostalCode"];
    //[person_update setValue:[NSString stringWithFormat:@"JBB Account Name %@",accountName.text] forKey:@"AccountName"];
    [person_update setValue:da.currentSession forKey:@"TimeID"];
    [person_update setValue:@"false" forKey:@"Sent"];
    if(appDelegate.optIn){
        [person_update setValue:[[NSString alloc] initWithString:@"true"] forKey:@"Opt_In"];
    }else{
        [person_update setValue:[[NSString alloc] initWithString:@"false"] forKey:@"Opt_In"];
    }
    [person_update setValue:GUID forKey:@"RemoteSystemID"];
    [person_update setValue:da.brandID forKey:@"BrandID"];
    
    //CREATE ARCHIVE (permanent) PERSON ENTITY
    person_archive = [NSEntityDescription insertNewObjectForEntityForName:@"Trans_Archive_Author" inManagedObjectContext:context];
    
    [person_archive setValue:firstName.text forKey:@"FirstName"];
    [person_archive setValue:lastName.text forKey:@"LastName"];
    //[person_archive setValue:[[NSString alloc] initWithFormat:@"%@/%@/19%@",month.text,day.text,year.text] forKey:@"DOB"];
    [person_archive setValue:[[NSString alloc] initWithFormat:@"%d/%d/%d",month1,day1,year1] forKey:@"DOB"];
    [person_archive setValue:email.text forKey:@"Email"];
    [person_archive setValue:telephone forKey:@"Phone"];
    [person_archive setValue:address_1.text forKey:@"Address1"];
    [person_archive setValue:address_2.text forKey:@"Address2"];
    [person_archive setValue:city.text forKey:@"City"];
    [person_archive setValue:state.text forKey:@"StateProvince"];
    [person_archive setValue:zip.text forKey:@"PostalCode"];
    [person_archive setValue:da.currentSession forKey:@"TimeID"];
    [person_archive setValue:@"false" forKey:@"Sent"];
    if(appDelegate.optIn){
        [person_archive setValue:[[NSString alloc] initWithString:@"true"] forKey:@"Opt_In"];
    }else{
        [person_archive setValue:[[NSString alloc] initWithString:@"false"] forKey:@"Opt_In"];
    }
    [person_archive setValue:zip.text forKey:@"PostalCode"];
    //[person_update setValue:[NSString stringWithFormat:@"JBB Account Name %@",accountName.text] forKey:@"AccountName"];
    [person_archive setValue:GUID forKey:@"RemoteSystemID"];
    [person_archive setValue:da.brandID forKey:@"BrandID"];
}

-(void)answeredQuestionsForGender:(NSString*)genderString 
                         Language:(NSString*)languageString 
                      Preferences:(NSString*)preferencesString 
                            Ideas:(NSString*)ideasString
{
    if(person != nil){
        [person setValue:genderString forKey:@"Gender"];
        [person setValue:languageString forKey:@"LanguagePreferences"];
        [person setValue:preferencesString forKey:@"DrinkingPreferences"];
        [person setValue:ideasString forKey:@"DrinkingIdeas"];
    }
}

-(void)didOrder
{
    /*if(person!=nil){
        [person setValue:[[NSString alloc] initWithString:@"true"] forKey:@"Ordered"];
    }*/
}

-(void)cancelOrder
{
   /* if(person!=nil){
        [person setValue:[[NSString alloc] initWithString:@"false"] forKey:@"Ordered"];
    }*/
}

-(void)savePerson
{
    [person setValue:[NSDate date] forKey:@"Modified"];
    [person_update setValue:[NSDate date] forKey:@"Modified"];
    NSError *errorSavingPerson = nil;
    if (person!=nil && [context save:&errorSavingPerson] == NO) {
        person = nil;
    }
    
    /*
    
    if (person_update!=nil && [context save:&errorSavingPerson] == NO) {
        person_update = nil;
    }*/
    
    NSLog(@"");
}


-(void)dismissFirstResponder
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    UIView *masterScroll = [[appDelegate rootVC] scrollView];
    id firstResponder = [masterScroll findFirstResonder];
    NSLog(@"firstResponder: %@",firstResponder);
    if(firstResponder) [firstResponder resignFirstResponder];
}

#pragma UIPopoverDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    popoverShown = NO;
    popoverBuilding = NO;
    NSLog(@"popoverControllerDidDismissPopover:");
    [popoverController.contentViewController.view resignFirstResponder];
}

- (IBAction)chooseDOB:(id)sender {
    [self clickedDOB];
}

- (void) doneClicked {
    [self popoverShown];
    [popOverControllerWithPicker dismissPopoverAnimated:NO];
    [address_1 becomeFirstResponder];
}
#pragma digit limitvalidatio
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField==self.telephone_3){
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 4) ? NO : YES;
    }
    else{
        return YES;
    }
}


-(NSDate*) parseDateString1:(NSString*)aDateString{
    NSLog(@"a DateString: %@",aDateString);
    //aDateString = [aDateString substringToIndex:18];
    //NSLog(@"a DateString: %@",aDateString);
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    NSDate *newDate = [outputFormatter dateFromString:aDateString];
    
    
	[outputFormatter release];
	
    return newDate;
    // For US English, the output is:
    // newDateString 10:30 on Sunday July 11
}

@end

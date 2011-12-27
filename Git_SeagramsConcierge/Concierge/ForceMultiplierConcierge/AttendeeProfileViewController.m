//
//  AttendeeProfileViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/16/11.
//  Contributions by Dustin Fineout.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.

//

#import "AttendeeProfileViewController.h"


@implementation AttendeeProfileViewController

@synthesize firstName,lastName,email,confirmEmail,telephone_1,telephone_2,telephone_3,dob,address_1,address_2,city,state,zip,optIn,content,isEditing,keyboardIsShown,person,context,disclaimerText,currentOffset,popoverY,rightSide,disclaimer,next_btn,addressBox;

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
    isEditing = NO;
    keyboardIsShown = NO;
    optIn.selected = NO;
    
    disclaimerText = @"Yes I would like to receive marketing materials, communications and other materials from Royal Salute";
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    person = nil;
    
    
    
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    UIScrollView *scroll = [[appDelegate rootVC] scrollView];
    CGRect frame = [scroll frame];
    CGSize scrollContentSize = CGSizeMake(frame.size.width, (frame.size.height*2));
    [scroll setContentSize:scrollContentSize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    
    
    //Set styling on textfields
    textFields = [[NSArray alloc] initWithObjects:firstName,lastName,email,confirmEmail,telephone_1,telephone_2,telephone_3,dob,address_1,address_2,city,state,zip,nil];
	for(UITextField *aTextField in textFields){
		aTextField.borderStyle = UITextBorderStyleRoundedRect;
        aTextField.enabled = YES;
        aTextField.userInteractionEnabled = YES;
	}
    
    rightSide.userInteractionEnabled = YES;
    content.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    
    
    //Instantiate PopOvers
    pickerViewController = [[PickerViewController alloc] init];
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
   
        [super viewDidAppear:animated];
        [self _layoutPage];
    
    NSLog(@"viewDidAppear fullView");
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    [self _layoutPage];
    
    //Register for orientation changes
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(orientationDidChange:) 
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
	return YES;
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
            
            NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                                  target:self
                                                                selector:@selector(displayPickerPopover)
                                                                userInfo:nil
                                                                 repeats:NO];
           
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
    [self dismissFirstResponder];
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    RootViewController *rootVC = [appDelegate rootVC];
    UIScrollView *masterScroll = [rootVC scrollView];
    
    CGFloat newX = dob.frame.origin.x;
    CGFloat newY = dob.frame.origin.y - 220.0f + 31.0f;
    
	CGSize sizeOfPopover = CGSizeMake(300.0, 220.0);
	CGPoint positionOfPopover = CGPointMake(newX, newY);
    
    NSLog(@"dob y: %f",dob.frame.origin.y);
    

    //rc = [dob convertRect:rc toView:masterView];
    popoverY = (self.view.frame.origin.y + content.frame.origin.y + dob.frame.origin.y - masterScroll.contentOffset.y);
    
    
	[popOverControllerWithPicker presentPopoverFromRect:CGRectMake(positionOfPopover.x, positionOfPopover.y, sizeOfPopover.width, sizeOfPopover.height)
												 inView:self.content permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

}

-(IBAction)clickedDOB
{
    [self displayPickerPopover];
}

-(void)valuesDidChangeTo:(NSDictionary*)values
{
    NSLog(@"New Values: %@",values);
    
    dob.text = [self parseDate:[values objectForKey:@"date"]];
}

-(void)popoverShown
{
    NSLog(@"Popover Shown");
    
    [self dismissFirstResponder];
}

#pragma mark -

#pragma keyboard notifications

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
        ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
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
        ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
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
            //CGFloat negOffset = 0.0f;
           
            if(popoverY < 220)
            {
                //if textfields y is less than popovers height, use the difference as the offset
                NSLog(@"offset: %f",popoverY);
                //negOffset = newCellFrame.origin.y + newCellFrame.size.height - popoverY + 80.0f;
                
            }
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
    //OLD WAY
    /*
	NSLog(@"textField return");
    
    //Set 'editing' flag
	isEditing = YES;
    //Create index property for textField index
	int index;
	
    //Find current textfield and select the next
	
    if([self indexForTextField:textField]!=NO)
    {
        index = [[self indexForTextField:textField]integerValue];
        NSLog(@"index value: %d",index);
        
        if(index < ([textFields count]-1)){
            [[textFields objectAtIndex:(index+1)] becomeFirstResponder];
            return YES;
        }
    }
	
	//Resign focus from current textfield
    [textField resignFirstResponder];
    
    
	//*/
    
    //Set 'editing' flag
	isEditing = YES;
    //Create index property for textField index
	int index;
	
    //Find current textfield and select the next
	
    if([self indexForTextField:textField]!=NO)
    {
        index = [[self indexForTextField:textField]integerValue];
        NSLog(@"index value: %d",index);
        
        if(index < ([textFields count]-1)){
            if(index == 6)
            {
                NSLog(@"Selected DOB, display popover");
                [textField resignFirstResponder];
                //[self dismissFirstResponder];
                NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:0.6
                                                                      target:self
                                                                    selector:@selector(displayPickerPopover)
                                                                    userInfo:nil
                                                                     repeats:NO];
                return YES;
            }
            
            [[textFields objectAtIndex:(index+1)] becomeFirstResponder];
            return YES;
        }
    }
	
	//Resign focus from current textfield
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
    //OLD WAY
	/*
    currentTextField = textField;
	NSLog(@"didbeginediting");
	
	isEditing = YES;
    
    //Find current textfield and return its index
    
    if(textField == dob){
        NSLog(@"Selected DOB, display popover");
        //[textField resignFirstResponder];
        
        NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                              target:self
                                                            selector:@selector(displayPickerPopover)
                                                            userInfo:nil
                                                             repeats:NO];
        //[self displayPickerPopover];
    }
    
    
    //*
	ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
	UIScrollView *masterScroll = [[appDelegate rootVC] scrollView];
	
	CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:masterScroll];
    pt = rc.origin;
    pt.x = 0;
    if(pt.y >300){ 
		pt.y -= 330;
		[masterScroll setContentOffset:pt animated:YES];
	}
	//*/
    
    currentTextField = textField;
	NSLog(@"didbeginediting");
	
	isEditing = YES;
    
    //Find current textfield and return its index
    
    if(textField == dob){
        NSLog(@"Selected DOB, display popover");
        [textField resignFirstResponder];
    }else{
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
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]hideErrorMessage];
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
            [telephone_3 resignFirstResponder];
            NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:0.6
                                                                  target:self
                                                                selector:@selector(displayPickerPopover)
                                                                userInfo:nil
                                                                 repeats:NO];
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
}

-(void)clearFields
{
    //Find current textfield and return its index
	for(UITextField *field in textFields){
		field.text = @"";
	}
    [self _layoutPage];
}

#pragma mark -

-(void)setDisclaimerTextView:(NSNumber*)size
{
    NSString *headString = [NSString stringWithFormat:@"<html><head><style>body{background-color:transparent;padding:0px;text-align:justify;}</style> </head><body><p><font face='Helvetica' size='%d' color='#c7ac78'><bold>",[size integerValue]];
    NSString *htmlString = [NSString stringWithFormat:@"%@%@%@",headString,disclaimerText,@"</bold></font></p></body></html>"];
    [disclaimer loadHTMLString:htmlString baseURL:nil];
    disclaimer.opaque = NO;
    disclaimer.backgroundColor = [UIColor clearColor];
}

-(IBAction)nextView
{
    [self dismissFirstResponder];
    if([self validateFields])
    {
        [self createPerson];
        
        /*
         ThankYouViewController *thankYouVC = [[ThankYouViewController alloc] initWithNibName:@"ThankYouViewController" bundle:nil];
        
        ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication]delegate];
        [[[appDelegate rootVC] navController] pushViewController:thankYouVC animated:YES];
         */
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

-(Boolean)validateFields
{
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    
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
	if([dob.text isEqualToString:@""]){
        [[appDelegate rootVC]showErrorMessage:@"Please enter a valid date of birth."];
        [self dismissFirstResponder];
        NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:0.8
                                                              target:self
                                                            selector:@selector(displayPickerPopover)
                                                            userInfo:nil
                                                             repeats:NO];

        return NO;
    }
	if((![email.text isEqualToString:confirmEmail.text]) || [email.text isEqualToString:@""]){
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
	if([city.text isEqualToString:@""]){
        [[appDelegate rootVC]showErrorMessage:@"Please enter a city."];
        [city becomeFirstResponder];
        city.highlighted = YES;
        return NO;
    }
	if([state.text isEqualToString:@""]){
        [[appDelegate rootVC]showErrorMessage:@"Please enter a state."];
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
	if([telephone_1.text isEqualToString:@""]){
		telephone_1.text = @" ";
	}
	if([telephone_2.text isEqualToString:@""]){
		telephone_2.text = @" ";
	}
	if([telephone_3.text isEqualToString:@""]){
		telephone_3.text = @" ";
	}
    return YES;
}

-(void)createPerson
{
    person = nil;
    
    person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    
    [person setValue:firstName.text forKey:@"FirstName"];
    [person setValue:lastName.text forKey:@"LastName"];
    [person setValue:dob.text forKey:@"DOB"];
    [person setValue:email.text forKey:@"Email"];
    NSString *telephone = [NSString stringWithFormat:@"%@%@%@",telephone_1.text,telephone_2.text,telephone_3.text];
    [person setValue:telephone forKey:@"Phone"];
    [person setValue:address_1.text forKey:@"Address1"];
    [person setValue:address_2.text forKey:@"Address2"];
    [person setValue:city.text forKey:@"City"];
    [person setValue:state.text forKey:@"StateProvince"];
    [person setValue:zip.text forKey:@"PostalCode"];
    if(optIn.selected){
        [person setValue:@"Y" forKey:@"Opt_In"];
    }else{
        [person setValue:@"N" forKey:@"Opt_In"];
    }
}

-(void)savePerson
{
    NSError *errorSavingPerson = nil;
    if (person!=nil && [context save:errorSavingPerson] == NO) {
        [context deleteObject:person];
        
        person = nil;
    }
    
    NSLog(@"");
}


-(void)dismissFirstResponder
{
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    UIView *masterScroll = [[appDelegate rootVC] scrollView];
    id firstResponder = [masterScroll findFirstResonder];
    NSLog(@"firstResponder: %@",firstResponder);
    if(firstResponder) [firstResponder resignFirstResponder];
}

#pragma UIPopoverDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"popoverControllerDidDismissPopover:");
    //[popoverController.contentViewController.view resignFirstResponder];
    [self dismissFirstResponder];
}

@end

//
//  DataCollection_Abbr_ViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/16/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "DataCollection_Abbr_ViewController.h"
#import "PhotoConsentViewController.h"
#import "RootViewController.h"

@implementation DataCollection_Abbr_ViewController

@synthesize content,firstName,lastName,day,month,year,email,telephone_1,telephone_2,telephone_3,zip,accountName,optIn,next_btn,disclaimer,isEditing,keyboardIsShown,context,person,person_update,person_archive,disclaimerText,currentOffset,popoverY,rightSide,popoverShown, dob;

BOOL keyBoardIsOpen1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
        da = [appDelegate da];
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self _layoutPage];
    optIn.selected = YES;
    keyBoardIsOpen1 = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameChangeNotification:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    firstName.delegate=self;
    
    /*
    firstName.text = @"a";
    lastName.text = @"a";
    email.text = @"a@a.com";
    confirmEmail.text = @"a@a.com";
    telephone_1.text = @"555";
    telephone_2.text = @"555";
    telephone_3.text = @"5555";
    day.text = @"11";
    month.text = @"11";
    year.text = @"11";
    //*/
    
    // Do any additional setup after loading the view from its nib.
    isEditing = NO;
    keyboardIsShown = NO;
    optIn.selected = YES;
    
    disclaimerText = @"Yes, I would like to receive marketing materials, communications and other materials from Kahlua.";
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    person = nil;
    person_update = nil;
    
    
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    CGRect frame = [[[appDelegate rootVC] scrollView] frame];
    CGSize scrollContentSize = CGSizeMake(frame.size.width, (frame.size.height*2));
    UIScrollView *scroll = [[appDelegate rootVC] scrollView];
    [scroll setContentSize:scrollContentSize];
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
    
   
//    [NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//     


     
    
    
    
    //Set styling on textfields
//    textFields = [[NSArray alloc] initWithObjects:firstName,lastName/*,accountName*/,email,confirmEmail,telephone_1,telephone_2,telephone_3,month,day,year,zip,nil];
    textFields = [[NSArray alloc] initWithObjects:firstName,lastName/*,accountName*/,email,confirmEmail,telephone_1,telephone_2,telephone_3, zip, nil];
	for(UITextField *aTextField in textFields){
		aTextField.borderStyle = UITextBorderStyleBezel;
        aTextField.backgroundColor = [UIColor whiteColor];
	}
    
    [self.next_btn.titleLabel setFont:[UIFont fontWithName:@"TradeGothicLT-BoldCondTwenty" 
                                           size:self.next_btn.titleLabel.font.pointSize]];
    
    //Instantiate PopOvers
    pickerViewController = [[PickerViewController alloc] init];
	pickerViewController.delegate = self;
	popOverControllerWithPicker = [[UIPopoverController alloc] initWithContentViewController:pickerViewController];
    popOverControllerWithPicker.delegate = self;
	popOverControllerWithPicker.popoverContentSize = CGSizeMake(300, 216);
    
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
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    /*
    [self _layoutPage];

    //Register for orientation changes
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(orientationDidChange:) 
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    // Return YES for supported orientations
	return YES;
    */
}

- (void)orientationDidChange:(NSNotification *)note
{
   /* 
    NSLog(@"orientationDidChange -\n  new device orientation = %d \n new statusbar orientation = %d \n", [[UIDevice currentDevice] orientation],[UIApplication sharedApplication].statusBarOrientation);
    //*/

    [self _layoutPage];
}

-(void)_layoutPage
{
    //*
   NSLog(@"_layoutPage -\n  new device orientation = %d \n new statusbar orientation = %d \n", [[UIDevice currentDevice] orientation],[UIApplication sharedApplication].statusBarOrientation);
    //*/
    
    //Manually center content
    CGRect rightFrame = rightSide.frame;
    CGRect frame = content.frame;
    CGRect viewFrame = self.view.frame;
    NSNumber *newWidth;
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || 
       [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)// || 
       //[[UIDevice currentDevice] orientation] == 0)
    {
        newWidth = [NSNumber numberWithFloat:280.0f];
        frame.origin.y = 33.0f;
        frame.origin.x = 0.0f;
        /*if([[UIDevice currentDevice] orientation] != 0)*/ 
        [self setDisclaimerTextView:[NSNumber numberWithInt:1]];
        rightFrame.origin.x = 464.0f - (320.0f - [newWidth floatValue]);// - 60.0f;
        viewFrame.size.width = 748.0f;
    }
    else
    {
        newWidth = [NSNumber numberWithFloat:320.0f];
        frame.origin.y = 33.0f;
        frame.origin.x = 84.0f;
        [self setDisclaimerTextView:[NSNumber numberWithInt:2]];
        rightFrame.origin.x = 464.0f;
        viewFrame.size.width = 1024.0f;
    }
    
    self.view.frame = viewFrame;
    rightSide.frame = rightFrame;
    content.frame = frame;
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
                 repeats:NO];//*/
            }
        }
    }
    
    
    [content setNeedsDisplay];
    [content setNeedsLayout];
}

#pragma mark -



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
        NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
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
     
}

-(IBAction)clickedDOB
{
    [self displayPickerPopover];
}

-(void)valuesDidChangeTo:(NSDictionary*)values
{
    NSLog(@"New Values: %@",values);
    [dob setTitle:[self parseDate:[values objectForKey:@"date"]] forState:UIControlStateNormal];
//    [popOverControllerWithPicker dismissPopoverAnimated:YES];
//    [self popoverShown];
//    [zip becomeFirstResponder];
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
//    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
//    UIScrollView *masterScroll = [[appDelegate rootVC] scrollView];
//    CGPoint contentOffset = masterScroll.contentOffset;
//    
    if (keyboardIsShown) {
        [self keyboardDidHide:notification];
    } else {
        [self keyboardDidShow:notification];
    }
}

-(void) keyboardDidShow:(NSNotification *) notification 
{
    //implement if needed
    keyboardIsShown = YES;
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"keyboard height: %f",kbSize.height);
}

-(void) keyboardDidHide:(NSNotification *) notification 
{

    NSLog(@"keyboard hide notification");
   // NSLog(@"keyboardDidHide with notification: %@",notification);
    if(keyboardIsShown == NO) NSLog(@"keyboard not shown");
     if(![currentTextField isFirstResponder]) NSLog(@"textfield not firstResponder");
    
    
    
    //CGPoint currentOffset;
    if(keyboardIsShown == YES && ![currentTextField isFirstResponder]){
    //if(![currentTextField isFirstResponder]){
        //Uncomment to enable auto scroll
        //*
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
        UIScrollView *masterScroll = [[appDelegate rootVC] scrollView];
        CGPoint offset = CGPointMake(0.0, 0.0);
        NSLog(@"original positionnnnnnnnnnnnnnnnnnnnnnn");
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
                negOffset = newCellFrame.origin.y + newCellFrame.size.height - popoverY + 280.0f;//80.0f;
                
            }//*/
            newCellFrame.origin.y = 220.0f;//newCellFrame.origin.y - currentOffset.y + negOffset;//popoverY; // + currentOffset.y
            [UIView animateWithDuration:0.25 animations:^(void) {
                                                                    popover.frame = newCellFrame;
                                                                } 
                                               /* completion:^(BOOL finished) {
                                                [UIView animateWithDuration:0.25 animation:^(void) {
                                                                                cell.frame = finalCellFrame;
                                                                            }];                    
                                                                        }*/];
            /*NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:0.6
                                                                  target:self
                                                                selector:@selector(displayPickerPopover)
                                                                userInfo:nil
                                                                 repeats:NO];*/
        }
    }
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSLog(@"textFieldShouldReturn ");
    
		
    //Set 'editing' flag
	isEditing = YES;
    //Create index property for textField index
	int index;
	
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]hideErrorMessage];
    //Find current textfield and select the next
	
    if([self indexForTextField:textField] != NO)
    {
        index = [[self indexForTextField:textField]integerValue];
        NSLog(@"index value: %d",index);
        
        if(index < ([textFields count] - 2)){
            [[textFields objectAtIndex:(index + 1)] becomeFirstResponder];
            return YES;
        }/*else{
            if(index == ([textFields count]-2)){
                NSLog(@"Selected DOB, display popover");
                [textField resignFirstResponder];
                //[self dismissFirstResponder];
                NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                                      target:self
                                                                    selector:@selector(displayPickerPopover)
                                                                    userInfo:nil
                                                                     repeats:NO];
            }
        }*/
    }
	
	//Resign focus from current textfield
    //[textField resignFirstResponder];

    if (textField == telephone_3) {
        [NSTimer scheduledTimerWithTimeInterval:0.35 target:self selector:@selector(clickedDOB) userInfo:nil repeats:NO];
    }
    
	//*/
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
	currentTextField = textField;
	NSLog(@"didbeginediting");
	
	isEditing = YES;
    //keyboardIsShown = YES;
    //Find current textfield and return its index
/*
    if(textField == dob){
        NSLog(@"Selected DOB, display popover");
        [textField resignFirstResponder];
        /*[self dismissFirstResponder];*/
     /*   NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                              target:self
                                                            selector:@selector(displayPickerPopover)
                                                            userInfo:nil
                                                             repeats:NO];//*/
                              //[self displayPickerPopover];
    //}else{*/
        //*
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
        UIScrollView *masterScroll = [[appDelegate rootVC] scrollView];
        //[[appDelegate rootVC]hideErrorMessage];
    
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:masterScroll];
        pt = rc.origin;
        pt.x = 0;
        if(pt.y >264){ 
            pt.y -= 264;
            NSLog(@"view downnnnnnnnnnnnnnnnnnnnnnnnnnnnnn");
            [masterScroll setContentOffset:pt animated:YES];
        }
   // }
	//*/
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
	//isEditing = NO;
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog(@"textfieldbeginedittinguuuuuuuuuuuuuu");
    //[[appDelegate rootVC]hideErrorMessage];
    
    
    //[self keyboardDidHide:nil];
    //[self textFieldDidBeginEditing:textField];
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
        if(field != self.telephone_1 && field != self.telephone_2)
        {
            frame = field.frame;
            frame.size.width = [newWidth floatValue];
            
            if(field == self.telephone_3)
            {
                frame.size.width = [newWidth floatValue] - 139.0f;
            }
            
            field.frame = frame;
        }
	}
    
    frame = self.next_btn.frame;
    frame.origin.x = 18.0f + ([newWidth floatValue] - 127.0f);
    self.next_btn.frame = frame;
    
    frame = self.disclaimer.frame;
    frame.size.width = [newWidth floatValue] + 18.0f;
    self.disclaimer.frame = frame;
  */
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
            [zip becomeFirstResponder];
        }
    }
}

-(void)clearFields
{
    //Find current textfield and return its index
	for(UITextField *field in textFields){
		field.text = @"";
	}
    [dob setTitle:@"" forState:UIControlStateNormal];
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
            
            ThankYouViewController *thankYouVC = [[ThankYouViewController alloc] initWithNibName:@"ThankYouViewController" bundle:nil];
            
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField==self.telephone_3){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 4) ? NO : YES;
    }
    else{
        return YES;
    }

}

-(BOOL)numberValid:(UITextField*)textField
{
    for(int j=0;j<[textField.text length];j++)
	{
		NSInteger i =[textField.text characterAtIndex:j];
		
		if(i<48 || i>57)
		{
            return NO;

			
		}
        else{
            return YES;
        
        }
	}


    //return YES;

}

-(Boolean)validateFields
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(language);
    
    
    if([language isEqualToString:@"en"]){ 
    
        //firstName,lastName,dob,email,telephone_1,telephone_2,telephone_3,optIn
        if([firstName.text isEqualToString:@""]){
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
        
        if([[email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
            [[appDelegate rootVC]showErrorMessage:@"Please enter a valid email address."];
            [email becomeFirstResponder];
            email.highlighted = YES;
            return NO;
        }
        
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        
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
        if (self.dob.titleLabel.text==nil || [[self.dob.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
            [[appDelegate rootVC]showErrorMessage:@"Please enter a valid date of birth."];
            return NO;
        }
        if(!([self numberValid:self.telephone_3]||[self numberValid:self.zip]))
        {
            NSLog(@"not valid numberrrrrrr");
        [[appDelegate rootVC]showErrorMessage:@"Please enter a nummber"];
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
//        }
        if([telephone_1.text isEqualToString:@""]){
            telephone_1.text = @" ";
        }
        if([telephone_2.text isEqualToString:@""]){
            telephone_2.text = @" ";
        }
        if([telephone_3.text isEqualToString:@""]){
            telephone_3.text = @" ";
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
    }else{
        //firstName,lastName,dob,email,telephone_1,telephone_2,telephone_3,optIn
        if([firstName.text isEqualToString:@""]){
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
        
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        
        //NSPredicate *regexMail = [NSPredicate predicateWithFormat:@"SELF MATCHES '\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b'"];
        
        if([[email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
            [[appDelegate rootVC]showErrorMessage:@"Por favor ingresa una dirección de correo electrónico válida."];
            [email becomeFirstResponder];
            email.highlighted = YES;
            return NO;
        }
        
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
//        }
 
        if (self.dob.titleLabel.text==nil || [self.dob.titleLabel.text isEqualToString:@""]) {
            [[appDelegate rootVC]showErrorMessage:@"Por favor ingresa una fecha de nacimiento válida."];
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
    
    // girish
    //[[NSUserDefaults standardUserDefaults] setString:email.text forKey:@"user_email"];
    // end
    
    
    return YES;
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
    person_archive = nil;
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *GUID = [da generateUuidString];
    
    //CREATE MAIN PERSON ENTITY
    person = [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:context];
    
    [person setValue:firstName.text forKey:@"FirstName"];
    [person setValue:lastName.text forKey:@"LastName"];    
    
    NSDate *dt = [self parseDateString1:dob.titleLabel.text];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:dt];
     NSInteger day1 = [components day];    
     NSInteger month1 = [components month];
     NSInteger year1 = [components year];

    
    [person setValue:[[NSString alloc] initWithFormat:@"%d/%d/%d",month1,day1,year1] forKey:@"DOB"];
    [person setValue:email.text forKey:@"Email"];
    //[person setValue: forKey:@"imageUploaded"]
    //[person setValue:email.text forKey:@"imageCaptured"];;
    [appDelegate rootVC].emailAddress = email.text;
    
    NSString *telephone = [NSString stringWithFormat:@"%@%@%@",telephone_1.text,telephone_2.text,telephone_3.text];
    [person setValue:telephone forKey:@"Phone"];
    [person setValue:da.currentSession forKey:@"TimeID"];
    [person setValue:@"false" forKey:@"Sent"];
    if(appDelegate.optIn){
        [person setValue:[[NSString alloc] initWithString:@"true"] forKey:@"Opt_In"];
    }else{
        [person setValue:[[NSString alloc] initWithString:@"false"] forKey:@"Opt_In"];
    }
    [person setValue:zip.text forKey:@"PostalCode"];
    //[person setValue:[NSString stringWithFormat:@"JBB Account Name %@",accountName.text] forKey:@"AccountName"];
    [person setValue:GUID forKey:@"RemoteSystemID"];
    [person setValue:da.brandID forKey:@"BrandID"];
    
    //CREATE UPDATE (queued for webservices) PERSON ENTITY
    person_update = [NSEntityDescription insertNewObjectForEntityForName:@"Trans_Queue_Author" inManagedObjectContext:context];
    
    [person_update setValue:firstName.text forKey:@"FirstName"];
    [person_update setValue:lastName.text forKey:@"LastName"];
    [person_update setValue:[[NSString alloc] initWithFormat:@"%d/%d/%d",month1,day1,year1] forKey:@"DOB"];
    [person_update setValue:email.text forKey:@"Email"];
    [person_update setValue:telephone forKey:@"Phone"];
    [person_update setValue:da.currentSession forKey:@"TimeID"];
    [person_update setValue:@"false" forKey:@"Sent"];
    if(appDelegate.optIn){
        [person_update setValue:[[NSString alloc] initWithString:@"true"] forKey:@"Opt_In"];
    }else{
        [person_update setValue:[[NSString alloc] initWithString:@"false"] forKey:@"Opt_In"];
    }
    [person_update setValue:zip.text forKey:@"PostalCode"];
    //[person_update setValue:[NSString stringWithFormat:@"JBB Account Name %@",accountName.text] forKey:@"AccountName"];
    [person_update setValue:GUID forKey:@"RemoteSystemID"];
    [person_update setValue:da.brandID forKey:@"BrandID"];
    
    //CREATE ARCHIVE (permanent) PERSON ENTITY
    person_archive = [NSEntityDescription insertNewObjectForEntityForName:@"Trans_Archive_Author" inManagedObjectContext:context];
    
    [person_archive setValue:firstName.text forKey:@"FirstName"];
    [person_archive setValue:lastName.text forKey:@"LastName"];
    [person_archive setValue:[[NSString alloc] initWithFormat:@"%d/%d/%d",month1,day1,year1] forKey:@"DOB"];
    [person_archive setValue:email.text forKey:@"Email"];
    [person_archive setValue:telephone forKey:@"Phone"];
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
    NSLog(@"gender: %@ /n language: %@ /n preferences: %@ /n ideas: %@",genderString,languageString,preferencesString,ideasString);
    if(person != nil){
        [person setValue:genderString forKey:@"Gender"];
        [person setValue:languageString forKey:@"LanguagePreferences"];
        [person setValue:preferencesString forKey:@"DrinkingPreferences"];
        [person setValue:ideasString forKey:@"DrinkingIdeas"];
    }
}

-(void)didOrder
{
    if(person!=nil){
        NSLog(@"%@", person);
        [person setValue:[[NSString alloc] initWithString:@"true"] forKey:@"Ordered"];
    }
}

-(void)cancelOrder
{
    if(person!=nil){
        @try {
            [person setValue:[[NSString alloc] initWithString:@"false"] forKey:@"Ordered"];
        }
        @catch (NSException *exception) {
            NSLog([exception description]);
        }
    }
}

-(void)savePerson
{
    [person_update setValue:[NSDate date] forKey:@"Modified"];
    [person_archive setValue:[NSDate date] forKey:@"Modified"];
    [person setValue:[NSDate date] forKey:@"Modified"];
    NSError *errorSavingPerson = nil;
    if (person!=nil && [context save:errorSavingPerson] == NO) {
        person = nil;
    }
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
    //[self dismissFirstResponder];
}

//- (void)popoverController

- (IBAction)chooseDOB:(id)sender {
    [self clickedDOB];
}

- (void) doneClicked {
    [self popoverShown];
    [popOverControllerWithPicker dismissPopoverAnimated:NO];
    [zip becomeFirstResponder];
}


@end

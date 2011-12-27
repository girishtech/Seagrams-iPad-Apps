//
//  DataCollection_Question_ViewController.m
//  ForceMultiplier
//
//  Created by Glenn Smits on 7/14/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "DataCollection_Question_ViewController.h"


@implementation DataCollection_Question_ViewController

@synthesize brandQuestion, answerView, answerIdeasView,genderView,languageView, nextBtn, questionLabel, answerBtns,genderBtns,languageBtns,otherTextField,allBtn,currentOffset,isEditing,keyboardIsShown;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        answerBtns = [[NSMutableArray alloc] initWithCapacity:0]; 
        ideaAnswerBtns = [[NSMutableArray alloc] initWithCapacity:0];
        genderBtns = [[NSMutableArray alloc] initWithCapacity:0]; 
        languageBtns = [[NSMutableArray alloc] initWithCapacity:0];
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
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:@"I ENJOY:" forKey:@"question"];
    
    NSArray *answers = [[NSArray alloc] initWithObjects:@"Brunch",@"Dinner Parties",@"Cooking / Baking",@"Watching Sports",@"Social Networking",@"Live Music",@"Picnics",@"Snow Skiing / Boarding",@"Going to the Beach",@"Other", nil];
    [dict setValue:answers forKey:@"answers"];
    [dict setValue:@"multi" forKey:@"type"];
    
    brandQuestion = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [self buildAnswers];
    
    NSMutableDictionary *questionsDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [questionsDict setValue:@"I'M INTERESTED IN KAHLÚA DRINK IDEAS:" forKey:@"question"];
    
    NSArray *ideaAnswers = [[NSArray alloc] initWithObjects:@"For entertaining at home",@"To order when I'm out", nil];
    [questionsDict setValue:ideaAnswers forKey:@"answers"];
    [questionsDict setValue:@"multi" forKey:@"type"];

    brandDrinkingIdeasQuestion = [[NSMutableDictionary alloc] initWithDictionary:questionsDict];
    [self buildIdeaAnswers];
    
    //Build gender/language selectors
    [self buildLanguageSelector];
    [self buildGenderSelector];
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

#pragma keyboard notifications

-(void) keyboardDidShow:(NSNotification *) notification 
{
    //implement if needed
    keyboardIsShown = YES;
    //NSDictionary* info = [notification userInfo];
    //CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //NSLog(@"keyboard height: %f",kbSize.height);
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
        currentOffset = [masterScroll contentOffset];
        [masterScroll setContentOffset:offset animated:YES];
        //*//*
        
        // [masterScroll setContentOffset:0.0 animated:YES];
        keyboardIsShown = NO;
    }
    /*
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
     /*       newCellFrame.origin.y = 220.0f;//newCellFrame.origin.y - currentOffset.y + negOffset;//popoverY; // + currentOffset.y
            [UIView animateWithDuration:0.25 animations:^(void) {
                popover.frame = newCellFrame;
            } 
             /* completion:^(BOOL finished) {
              [UIView animateWithDuration:0.25 animation:^(void) {
              cell.frame = finalCellFrame;
              }];                    
              }*///];
            /*NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:0.6
             target:self
             selector:@selector(displayPickerPopover)
             userInfo:nil
             repeats:NO];*/
   //     }
   // }
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSLog(@"textField return");
    
    
    //Set 'editing' flag
	isEditing = YES;
    //Create index property for textField index
	int index;
	
    //Find current textfield and select the next
	/*
    if([self indexForTextField:textField]!=NO)
    {
        index = [[self indexForTextField:textField]integerValue];
        NSLog(@"index value: %d",index);
        
        if(index < ([textFields count]-1)){//-2)){
            [[textFields objectAtIndex:(index+1)] becomeFirstResponder];
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
    //}
	
	//Resign focus from current textfield
    [textField resignFirstResponder];
    
    
	//*/
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
	currentTextField = textField;
	NSLog(@"didbeginediting");
	
	isEditing = YES;
    
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
    
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:masterScroll];
    pt = rc.origin;
    pt.x = 0;
    if(pt.y >264){ 
        pt.y -= 310;
        [masterScroll setContentOffset:pt animated:YES];
    }
    // }
	//*/
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	//isEditing = NO;
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]hideErrorMessage];
}

#pragma mark - 



#pragma mark - nagivation, validation and persistance

/*
-(void)setBrandQuestion:(NSDictionary *)brandQuestion
{
    //questionLabel.text = [brandQuestion valueForKey:@"question"];
    //[self buildAnswers];
}
*/
-(void)buildAnswers
{
    int idx = 1;
    
    allBtn = [[UIButton alloc] initWithFrame:CGRectMake(100.0f, 38, 25.0f, 25.0f)];
    [allBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateSelected];
    [allBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateHighlighted];
    [allBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateNormal];
    [allBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateDisabled];
    allBtn.selected = NO;
    [allBtn addTarget:self 
                  action:@selector(selectedAll:) 
        forControlEvents:UIControlEventTouchUpInside];
    
    //[allBtns addObject:allBtn];
    
    UILabel *allLabel = [[UILabel alloc] initWithFrame:CGRectMake(140.0f, 28, 400.0f, 40.0f)];
    [allLabel setBackgroundColor:[UIColor clearColor]];
    [allLabel setTextColor:[UIColor colorWithRed:1.0 green:0.866 blue:0.0 alpha:1.0]];
    allLabel.text = @"Select All";
    
    [self.answerView addSubview:allBtn];
    [self.answerView addSubview:allLabel];
    
    for(NSString *answer in [brandQuestion objectForKey:@"answers"])
    {
        UIButton *answerBtn = [[UIButton alloc] initWithFrame:CGRectMake(5.0f, (38 * idx), 25.0f, 25.0f)];
        [answerBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateSelected];
        [answerBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateHighlighted];
        [answerBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateNormal];
        [answerBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateDisabled];
        answerBtn.selected = NO;
        [answerBtn addTarget:self 
                      action:@selector(selectedAnswer:) 
            forControlEvents:UIControlEventTouchUpInside];
        
        [answerBtns addObject:answerBtn];
        
        UILabel *answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, (38 * idx)-10, 400.0f, 40.0f)];
        [answerLabel setBackgroundColor:[UIColor clearColor]];
        [answerLabel setTextColor:[UIColor colorWithRed:1.0 green:0.866 blue:0.0 alpha:1.0]];
        answerLabel.text = answer;
        
        [self.answerView addSubview:answerBtn];
        [self.answerView addSubview:answerLabel];
        
        if([answer isEqualToString:@"Other"]){
            NSLog(@"build 'other' textfield");
            otherTextField = [[UITextField alloc] initWithFrame:CGRectMake(90.0f, (38 * idx)-2, 120.0f, 30.0f)];
            otherTextField.borderStyle = UITextBorderStyleRoundedRect;
            otherTextField.delegate = self;
            //[answerLabel setBackgroundColor:[UIColor whiteColor]];
            //[otherTextField set
            [otherTextField addTarget:self 
                          action:@selector(selectedOther:) 
                forControlEvents:UIControlEventEditingDidBegin];
            [self.answerView addSubview:otherTextField];
        }
        
        idx++;
    }
}


-(void)buildIdeaAnswers
{
    int idx = 1;
    
    for(NSString *answer in [brandDrinkingIdeasQuestion objectForKey:@"answers"])
    {
        UIButton *answerBtn = [[UIButton alloc] initWithFrame:CGRectMake(5.0f, (38 * idx), 25.0f, 25.0f)];
        [answerBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateSelected];
        [answerBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateHighlighted];
        [answerBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateNormal];
        [answerBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateDisabled];
        answerBtn.selected = NO;
        [answerBtn addTarget:self 
                      action:@selector(selectedIdeaAnswer:) 
            forControlEvents:UIControlEventTouchUpInside];
        
        [ideaAnswerBtns addObject:answerBtn];
        
        UILabel *answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, (38 * idx)-10, 400.0f, 40.0f)];
        [answerLabel setBackgroundColor:[UIColor clearColor]];
        [answerLabel setTextColor:[UIColor colorWithRed:1.0 green:0.866 blue:0.0 alpha:1.0]];
        answerLabel.text = answer;
        
        [self.answerIdeasView addSubview:answerBtn];
        [self.answerIdeasView addSubview:answerLabel];
        
        idx++;
    }
}

-(void)buildGenderSelector
{
    UIButton *maleBtn = [[UIButton alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 25.0f, 25.0f)];
    [maleBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateSelected];
    [maleBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateHighlighted];
    [maleBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateNormal];
    [maleBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateDisabled];
    maleBtn.selected = NO;
    [maleBtn addTarget:self 
                action:@selector(selectedGender:) 
      forControlEvents:UIControlEventTouchUpInside];
    
    [genderBtns addObject:maleBtn];
    
    UILabel *maleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, -5.0f, 400.0f, 40.0f)];
    [maleLabel setBackgroundColor:[UIColor clearColor]];
    [maleLabel setTextColor:[UIColor colorWithRed:1.0 green:0.866 blue:0.0 alpha:1.0]];
    maleLabel.text = @"Male";
    
    [self.genderView addSubview:maleBtn];
    [self.genderView addSubview:maleLabel];
    
    UIButton *femaleBtn = [[UIButton alloc] initWithFrame:CGRectMake(100.0f, 5.0f, 25.0f, 25.0f)];
    [femaleBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateSelected];
    [femaleBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateHighlighted];
    [femaleBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateNormal];
    [femaleBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateDisabled];
    femaleBtn.selected = NO;
    [femaleBtn addTarget:self 
                  action:@selector(selectedGender:) 
        forControlEvents:UIControlEventTouchUpInside];
    
    [genderBtns addObject:femaleBtn];
    
    UILabel *femaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(140.0f, -5.0f, 400.0f, 40.0f)];
    [femaleLabel setBackgroundColor:[UIColor clearColor]];
    [femaleLabel setTextColor:[UIColor colorWithRed:1.0 green:0.866 blue:0.0 alpha:1.0]];
    femaleLabel.text = @"Female";
    
    [self.genderView addSubview:femaleBtn];
    [self.genderView addSubview:femaleLabel];
}

-(void)buildLanguageSelector
{
    UIButton *englishBtn = [[UIButton alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 25.0f, 25.0f)];
    [englishBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateSelected];
    [englishBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateHighlighted];
    [englishBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateNormal];
    [englishBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateDisabled];
    englishBtn.selected = NO;
    [englishBtn addTarget:self 
                action:@selector(selectedLanguage:) 
      forControlEvents:UIControlEventTouchUpInside];
    
    [languageBtns addObject:englishBtn];
    
    UILabel *englishLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, -5.0f, 400.0f, 40.0f)];
    [englishLabel setBackgroundColor:[UIColor clearColor]];
    [englishLabel setTextColor:[UIColor colorWithRed:1.0 green:0.866 blue:0.0 alpha:1.0]];
    englishLabel.text = @"I Speak English";
    
    [self.languageView addSubview:englishBtn];
    [self.languageView addSubview:englishLabel];
    
    UIButton *espanolBtn = [[UIButton alloc] initWithFrame:CGRectMake(180.0f, 5.0f, 25.0f, 25.0f)];
    [espanolBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateSelected];
    [espanolBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateHighlighted];
    [espanolBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateNormal];
    [espanolBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateDisabled];
    espanolBtn.selected = NO;
    [espanolBtn addTarget:self 
                  action:@selector(selectedLanguage:) 
        forControlEvents:UIControlEventTouchUpInside];
    
    [languageBtns addObject:espanolBtn];
    
    UILabel *espanolLabel = [[UILabel alloc] initWithFrame:CGRectMake(220.0f, -5.0f, 400.0f, 40.0f)];
    [espanolLabel setBackgroundColor:[UIColor clearColor]];
    [espanolLabel setTextColor:[UIColor colorWithRed:1.0 green:0.866 blue:0.0 alpha:1.0]];
    espanolLabel.text = @"Yo Habla Espanol";
    
    [self.languageView addSubview:espanolBtn];
    [self.languageView addSubview:espanolLabel];
}

-(IBAction)nextView
{
    //if fields validate, set person values
    if([self validateFields])
    {
        [self createPersonSurveyResponse];
        
        TabbedViewController *tabbedVC = [[self.navigationController viewControllers]objectAtIndex:1];
        [[tabbedVC dc_abbrVC]clearFields];
        
        ThankYouPurchaseViewController *thankYouVC = [[ThankYouPurchaseViewController alloc] initWithNibName:@"ThankYouPurchaseViewController" bundle:nil];
        
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
        [[appDelegate rootVC] hideErrorMessage];
        
        [[[appDelegate rootVC] navController] pushViewController:thankYouVC animated:YES];
    }
}

-(Boolean)validateFields
{
    return YES;
}

-(void)createPersonSurveyResponse
{
    //TODO: Add persistance to the data store here
    TabbedViewController *tabbedVC = [[self.navigationController viewControllers]objectAtIndex:1];
    
    NSString *genderString = @"";
    NSString *languageString = @"";
    NSMutableString *preferencesString = [[NSMutableString alloc] initWithCapacity:0];
    NSMutableString *ideasString = [[NSMutableString alloc] initWithCapacity:0];;
    
    if([[genderBtns objectAtIndex:0] isSelected] == YES){
        genderString = @"M";
    }
    if([[genderBtns objectAtIndex:1] isSelected] == YES){
        genderString = @"F";
    }
    
    if([[languageBtns objectAtIndex:0] isSelected] == YES){
        languageString = @"en-us";
    }
    if([[languageBtns objectAtIndex:1] isSelected] == YES){
        languageString = @"es";    
    }
    
    int idx = 0;
    BOOL first = NO;
    for(UIButton *btn in answerBtns){
        if(btn.selected){
            if(!first){
                [preferencesString appendString:[[brandQuestion objectForKey:@"answers"]objectAtIndex:idx]];
                first = YES;
            }else{
                if([[[brandQuestion objectForKey:@"answers"]objectAtIndex:idx] isEqualToString:@"Other"]){
                    [preferencesString appendFormat:@"%@[Other(%@)]",@",",otherTextField.text];
                }else{
                    [preferencesString appendFormat:@"%@%@",@",",[[brandQuestion objectForKey:@"answers"]objectAtIndex:idx]];
                }
                
            }
        }
        idx++;
    }
    
    idx = 0;
    first = NO;
    for(UIButton *btn2 in ideaAnswerBtns){
        if(btn2.selected){
            if(!first){
                [ideasString appendString:[[brandDrinkingIdeasQuestion objectForKey:@"answers"]objectAtIndex:idx]];
                first = YES;
            }else{
                [ideasString appendFormat:@"%@%@",@",",[[brandDrinkingIdeasQuestion objectForKey:@"answers"]objectAtIndex:idx]];
            }
        }
        idx++;
    }
    
     NSLog(@"gender: %@ /n language: %@ /n preferences: %@ /n ideas: %@",genderString,languageString,preferencesString,ideasString);
    
    [[tabbedVC dc_abbrVC]answeredQuestionsForGender:[genderString stringByReplacingOccurrencesOfString:@"'" withString:@""]
                                           Language:[languageString stringByReplacingOccurrencesOfString:@"'" withString:@""] 
                                        Preferences:[preferencesString stringByReplacingOccurrencesOfString:@"'" withString:@""] 
                                              Ideas:[ideasString stringByReplacingOccurrencesOfString:@"'" withString:@""]];
    [[tabbedVC dc_abbrVC]clearFields];
    [[tabbedVC dc_abbrVC]savePerson];
    
    [[tabbedVC dc_fullVC]answeredQuestionsForGender:[genderString stringByReplacingOccurrencesOfString:@"'" withString:@""]
                                           Language:[languageString stringByReplacingOccurrencesOfString:@"'" withString:@""] 
                                        Preferences:[preferencesString stringByReplacingOccurrencesOfString:@"'" withString:@""] 
                                              Ideas:[ideasString stringByReplacingOccurrencesOfString:@"'" withString:@""]];
    [[tabbedVC dc_fullVC]clearFields];
    [[tabbedVC dc_fullVC]savePerson];
}

-(IBAction)selectedIdeaAnswer:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    //If question allows multiple selection
    if([[brandDrinkingIdeasQuestion objectForKey:@"type"] isEqualToString:@"multi"])
    {
        if(btn.selected == YES)
        {
            btn.selected = NO;
        }
        else
        {
            btn.selected = YES;
        }
    }
    //If question allows single selection
    else
    {
        for(UIButton *tmp in answerBtns)
        {
            if(tmp != btn)
            {
                tmp.selected = NO;
            }
        }
    }
}

-(IBAction)selectedAnswer:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    //If question allows multiple selection
    if([[brandQuestion objectForKey:@"type"] isEqualToString:@"multi"])
    {
        if(btn.selected == YES)
        {
            btn.selected = NO;
        }
        else
        {
            btn.selected = YES;
        }
    }
    //If question allows single selection
    else
    {
        for(UIButton *tmp in answerBtns)
        {
            if(tmp != btn)
            {
                tmp.selected = NO;
            }
        }
    }
}

-(IBAction)selectedAll:(id)sender
{
    NSLog(@"selectedAll:");
    BOOL newSelected = NO;
    UIButton *btn = (UIButton*)sender;
    if(btn.selected == YES){
        newSelected = NO;
    }else{
        newSelected = YES;
    }
    
    btn.selected = newSelected;
    
    for(UIButton *tmp in answerBtns)
    {
        tmp.selected = newSelected;
    }
}

-(IBAction)selectedOther:(id)sender
{
    UITextField *btn = (UITextField*)sender;
    
    [[answerBtns lastObject]setSelected:YES];
}

-(IBAction)selectedGender:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    //If question allows multiple selection
    if(btn == [genderBtns objectAtIndex:0])
    {
        [[genderBtns objectAtIndex:0] setSelected:YES];
        [[genderBtns objectAtIndex:1] setSelected:NO];
    }
    //If question allows single selection
    else
    {
        [[genderBtns objectAtIndex:0] setSelected:NO];
        [[genderBtns objectAtIndex:1] setSelected:YES];    
    }
}

-(IBAction)selectedLanguage:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    //If question allows multiple selection
    if(btn == [languageBtns objectAtIndex:0])
    {
        [[languageBtns objectAtIndex:0] setSelected:YES];
        [[languageBtns objectAtIndex:1] setSelected:NO];
    }
    //If question allows single selection
    else
    {
        [[languageBtns objectAtIndex:0] setSelected:NO];
        [[languageBtns objectAtIndex:1] setSelected:YES];    
    }
}

@end

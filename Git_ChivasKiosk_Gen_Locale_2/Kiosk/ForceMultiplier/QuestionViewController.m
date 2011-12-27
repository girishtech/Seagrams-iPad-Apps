//
//  QuestionViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 8/12/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "QuestionViewController.h"

#import "DataCollection_Abbr_ViewController.h"


@implementation QuestionViewController

@synthesize data, HORIZONTAL_SPREAD, VERTICAL_SPREAD, answerBtns, otherTextField, answerView, delegate,questionLbl,greetingLbl, keyboardIsShown, currentOffset, currentTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        data = nil;
        answerBtns = [[NSMutableArray alloc] initWithCapacity:0];
        otherTextField = nil;
    }
    return self;
}

- (void)loadQuestion:(NSDictionary*)newData
{
    self.data = [newData retain];
    NSLog(@"Question Data: %@",data);
    
    self.HORIZONTAL_SPREAD = [NSNumber numberWithFloat:250.0f];
    self.VERTICAL_SPREAD = [NSNumber numberWithFloat:45.0f];
    
    if([data objectForKey:@"HORIZONTAL_SPREAD"]!=nil) self.HORIZONTAL_SPREAD = [data objectForKey:@"HORIZONTAL_SPREAD"];
    if([data objectForKey:@"VERTICAL_SPREAD"]!=nil) self.VERTICAL_SPREAD = [data objectForKey:@"VERTICAL_SPREAD"];
    if([data objectForKey:@"greeting"]!=nil)
    {
        [self.greetingLbl setFont:[UIFont fontWithName:@"Gotham-Light" size:self.greetingLbl.font.pointSize]];
        self.greetingLbl.hidden = NO;
        self.greetingLbl.text = [data objectForKey:@"greeting"];
    }
    
    [self buildAnswers:[data objectForKey:@"answers"] forColumns:[data objectForKey:@"columns"]];
}

- (void)dealloc
{
    [super dealloc];
    [data dealloc];
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
}



- (void)buildAnswers:(NSArray*)answers forColumns:(NSNumber*)cols
{
    //Populate question label
    NSLog(@"Question Text: %@", [data objectForKey:@"question"]);
    NSLog(@"Label Text: %@", self.questionLbl.text);
    NSLog(@"Label: %@", self.questionLbl);
    
    self.questionLbl.text = (NSString*)[data objectForKey:@"question"];
    [self.questionLbl setFont:[UIFont fontWithName:@"Gotham-Light" size:self.questionLbl.font.pointSize]];
    
    //Determine the number of answers per row
    int answersPerCol;
    int answerCount = [answers count];
    if([cols integerValue]>1)
    {
        while(answerCount%[cols integerValue] != 0)
        {
            answerCount++;
        }
        answersPerCol = answerCount/[cols integerValue];
    }else{
        answersPerCol = answerCount;
    }
    
    CGFloat textWidth = (self.answerView.frame.size.width / [cols floatValue]) - 40.0f;
    CGFloat X_OFFSET = 120.0f;//(self.answerView.frame.size.width / 2) - (([HORIZONTAL_SPREAD floatValue] * [cols floatValue])/2);
    NSLog(@"X_OFFSET: %f",X_OFFSET);
    //self.HORIZONTAL_SPREAD = [NSNumber numberWithFloat:(CGFloat)(self.answerView.bounds.size.width / [cols floatValue])];
    
    int currentColumn = 0;
    int currentRow = 1;
    int idx = 1;
    
    id answer;
    for(answer in answers)
    {
        
        NSString *className = NSStringFromClass([answer class]);
        if([[answer objectForKey:@"answer"]isEqualToString:@"OTHER"])//[className isEqualToString:@"NSString"] || [className isEqualToString:@"NSCFString"])
        {
            UIButton *answerBtn = [[UIButton alloc] initWithFrame:CGRectMake(X_OFFSET+([HORIZONTAL_SPREAD floatValue] * currentColumn), ([VERTICAL_SPREAD floatValue] * (CGFloat)currentRow), 25.0f, 25.0f)];
            [answerBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateSelected];
            [answerBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateHighlighted];
            [answerBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateNormal];
            [answerBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateDisabled];
            answerBtn.selected = NO;
            [answerBtn addTarget:self 
                          action:@selector(selectedAnswer:) 
                forControlEvents:UIControlEventTouchUpInside];
            
            [answerBtns addObject:answerBtn];
            
            UILabel *answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_OFFSET+([HORIZONTAL_SPREAD floatValue] * currentColumn)+35.0f, ([VERTICAL_SPREAD floatValue] * currentRow)-7, textWidth, 40.0f)];
            [answerLabel setFont:[UIFont fontWithName:@"Gotham-Light" size:answerLabel.font.pointSize]];
            [answerLabel setBackgroundColor:[UIColor clearColor]];
            //[answerLabel setTextColor:[UIColor colorWithRed:1.0 green:0.866 blue:0.0 alpha:1.0]];
            [answerLabel setTextColor:[UIColor whiteColor]];
            [answerLabel setLineBreakMode:UILineBreakModeWordWrap];
            [answerLabel setNumberOfLines:2];
            answerLabel.text = [answer objectForKey:@"answer"];
            
            [self.answerView addSubview:answerBtn];
            [self.answerView addSubview:answerLabel];
            
           // if([answer isEqualToString:@"OTHER"])
            //{
                NSLog(@"build 'other' textfield");
                otherTextField = [[UITextField alloc] initWithFrame:CGRectMake(X_OFFSET+([HORIZONTAL_SPREAD floatValue] * currentColumn)+115.0f, ([VERTICAL_SPREAD floatValue] * currentRow)-2, 120.0f, 30.0f)];
                otherTextField.borderStyle = UITextBorderStyleRoundedRect;
                otherTextField.delegate = self;
                //[answerLabel setBackgroundColor:[UIColor whiteColor]];
                //[otherTextField set
                [otherTextField addTarget:self 
                                   action:@selector(selectedOther:) 
                         forControlEvents:UIControlEventEditingDidBegin];
                [self.answerView addSubview:otherTextField];
           // }
        }else{
            NSLog(@"Build Answer for: '%@'",[answer objectForKey:@"answer"]);
            UIButton *answerBtn = [[UIButton alloc] initWithFrame:CGRectMake(X_OFFSET+([HORIZONTAL_SPREAD floatValue] * currentColumn), ([VERTICAL_SPREAD floatValue] * currentRow), 25.0f, 25.0f)];
            [answerBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateSelected];
            [answerBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateHighlighted];
            [answerBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateNormal];
            [answerBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateDisabled];
            answerBtn.selected = NO;
            [answerBtn addTarget:self 
                          action:@selector(selectedAnswer:) 
                forControlEvents:UIControlEventTouchUpInside];
            
            [answerBtns addObject:answerBtn];
            
            UILabel *answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_OFFSET+([HORIZONTAL_SPREAD floatValue] * currentColumn)+35.0f, ([VERTICAL_SPREAD floatValue] * currentRow)-7, textWidth, 40.0f)];
            [answerLabel setFont:[UIFont fontWithName:@"Gotham-Light" size:answerLabel.font.pointSize]];
            [answerLabel setBackgroundColor:[UIColor clearColor]];
            //[answerLabel setTextColor:[UIColor colorWithRed:1.0 green:0.866 blue:0.0 alpha:1.0]];
            [answerLabel setTextColor:[UIColor whiteColor]];
            [answerLabel setLineBreakMode:UILineBreakModeWordWrap];
            [answerLabel setNumberOfLines:2];
            answerLabel.text = [answer objectForKey:@"answer"];
            
            [self.answerView addSubview:answerBtn];
            [self.answerView addSubview:answerLabel];
        }
        //*
        if(idx % answersPerCol == 0){ 
            currentColumn++;
            currentRow = 0;
        }//*/
        currentRow++;
        idx++;
    }
    
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
    [self.answerView setNeedsLayout];
    [self.answerView setNeedsDisplay];
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
                
- (IBAction)nextView
{
    // Girish Start
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    
 //   ThankYouPurchaseViewController *thankYouVC = [[ThankYouPurchaseViewController alloc] initWithNibName:@"ThankYouPurchaseViewController" bundle:nil];
    
//    [[[appDelegate rootVC] navController] pushViewController:thankYouVC animated:YES];    return;
    // End
    
    
    
    
    NSMutableArray *selectedAnswers = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *otherTextFieldAnswer = nil;
    int index = 0;
    
    for(UIButton *btn in answerBtns)
    {
        if(btn.selected){
            [selectedAnswers addObject:[NSNumber numberWithInt:index]];
        }
        index++;
    }
    
    if(otherTextField)
    {
        otherTextFieldAnswer = otherTextField.text;
    }
    
//    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if([selectedAnswers count]>=[[data objectForKey:@"min"]integerValue])
    {
        [[appDelegate rootVC]hideErrorMessage];
        [self.delegate saveAnswers:selectedAnswers andOther:otherTextFieldAnswer];
    }else{
        [[appDelegate rootVC]showErrorMessage:@"Please make a selection."];
    }
}


- (IBAction)selectedAnswer:(id)sender
{
    UIButton *tmpBtn = (UIButton*)sender;
    
    if(tmpBtn.selected)
    {
        tmpBtn.selected = NO;
    }else{
        int count = 0;
        for(UIButton *btn in answerBtns)
        {
            if(btn.selected){
                if([[data objectForKey:@"max"] integerValue] == 1)
                {
                    btn.selected = NO;
                }else{
                    count++;
                }
            }
        }
        
        NSLog(@"\n count: %d \n max: %d", count, [[data objectForKey:@"max"]integerValue]);
        
        if(count < [[data objectForKey:@"max"]integerValue])
        {
            tmpBtn.selected = YES;
        }
    }
}

-(IBAction)selectedOther:(id)sender
{
    UITextField *btn = (UITextField*)sender;
    
    [[answerBtns lastObject]setSelected:YES];
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
  
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	NSLog(@"textField return");
    
    
    //Set 'editing' flag
	isEditing = YES;
    
	//Resign focus from current textfield
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
	currentTextField = textField;
	NSLog(@"didbeginediting");
	
	isEditing = YES;
    
    //Find current textfield and return its index
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

@end

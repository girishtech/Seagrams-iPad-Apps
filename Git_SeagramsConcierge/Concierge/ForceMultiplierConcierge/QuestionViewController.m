//
//  QuestionViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 8/12/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "QuestionViewController.h"


@implementation QuestionViewController

@synthesize data, HORIZONTAL_SPREAD, VERTICAL_SPREAD, otherTextField, delegate,greetingLbl, keyboardIsShown, currentOffset, currentTextField,backBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        data = nil;
        answer1Btns = [[NSMutableArray alloc] initWithCapacity:0];
        answer2Btns = [[NSMutableArray alloc] initWithCapacity:0];
        answer3Btns = [[NSMutableArray alloc] initWithCapacity:0];
        answer1TextFields = [[NSMutableArray alloc] initWithCapacity:0];
        answer2TextFields = [[NSMutableArray alloc] initWithCapacity:0];
        answer3TextFields = [[NSMutableArray alloc] initWithCapacity:0];
        otherTextField = nil;
    }
    return self;
}

- (void)loadQuestion:(NSArray*)newData
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    self.data = [newData retain];
    NSLog(@"Question Data: %@",data);
    
    NSInteger idx = 0;
    
    if([self.data count] == 2){
        question2Lbl.hidden = NO;
    }else{
        question2Lbl.hidden = YES;
        answer2View.hidden = YES;
    }
    
    for(NSDictionary *question in self.data){
        self.HORIZONTAL_SPREAD = [NSNumber numberWithFloat:250.0f];
        self.VERTICAL_SPREAD = [NSNumber numberWithFloat:45.0f];
        
        if([question objectForKey:@"HORIZONTAL_SPREAD"]!=nil) self.HORIZONTAL_SPREAD = [question objectForKey:@"HORIZONTAL_SPREAD"];
        if([question objectForKey:@"VERTICAL_SPREAD"]!=nil) self.VERTICAL_SPREAD = [question objectForKey:@"VERTICAL_SPREAD"];
        if([question objectForKey:@"greeting"]!=nil)
        {
            [self.greetingLbl setFont:[UIFont fontWithName:@"Gotham-Light" size:self.greetingLbl.font.pointSize]];
            self.greetingLbl.hidden = NO;
            self.greetingLbl.text = [question objectForKey:@"greeting"];
            self.backBtn.hidden = YES;
        }
        
        [self buildAnswers:[question objectForKey:@"answers"] forColumns:[question objectForKey:@"columns"] forQuestion:idx];
        idx++;
    }
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



- (void)buildAnswers:(NSArray*)answers forColumns:(NSNumber*)cols forQuestion:(NSInteger)questionIdx
{
    //Populate question label
   // NSLog(@"Question Text: %@", [data objectForKey:@"question"]);
   // NSLog(@"Label Text: %@", self.questionLbl.text);
   // NSLog(@"Label: %@", self.questionLbl);
    
    UILabel *questionLbl;
    UIView *answerView;
    NSMutableArray *answerBtns;
    NSMutableArray *textFields;
    
    if(questionIdx == 0){
        questionLbl = question1Lbl;
        answerView = answer1View;
        answerBtns = answer1Btns;
        textFields = answer1TextFields;
    }else if(questionIdx == 1){
        questionLbl = question2Lbl;
        answerView = answer2View;
        answerBtns = answer2Btns;
        textFields = answer2TextFields;
    }else if(questionIdx == 2){
        questionLbl = question3Lbl;
        answerView = answer3View;
        answerBtns = answer3Btns;
        textFields = answer3TextFields;
    }
    
    questionLbl.text = (NSString*)[[data objectAtIndex:questionIdx] objectForKey:@"question"];
    [questionLbl setFont:[UIFont fontWithName:@"Gotham-Light" size:questionLbl.font.pointSize]];
    
    //Determine the number of answers per row
    int answerCount = [answers count];
    int answersPerCol = answerCount;
    
    if([cols integerValue]>1)
    {
        while(answerCount%[cols integerValue] != 0)
        {
            answerCount++;
        }
        answersPerCol = answerCount/[cols integerValue];
    }
    
    CGFloat textWidth = (answerView.frame.size.width / [cols floatValue]) - 40.0f;
    CGFloat X_OFFSET = 120.0f;//(self.answerView.frame.size.width / 2) - (([HORIZONTAL_SPREAD floatValue] * [cols floatValue])/2);
    NSLog(@"X_OFFSET: %f",X_OFFSET);
    //self.HORIZONTAL_SPREAD = [NSNumber numberWithFloat:(CGFloat)(self.answerView.bounds.size.width / [cols floatValue])];
    
    int currentColumn = 0;
    int currentRow = 1;
    int idx = 1;
    CGFloat letterSpacing = 11.0f;
    
    if([HORIZONTAL_SPREAD isEqualToNumber:[NSNumber numberWithInt:420]]){
        NSLog(@"WIDE LOAD");
        CGRect frame = answerView.frame;
        frame.origin.x = frame.origin.x - 150;
        answerView.frame = frame;
        letterSpacing = 10.0f;
        textWidth = textWidth - 100.0f;
    }
    if([HORIZONTAL_SPREAD isEqualToNumber:[NSNumber numberWithInt:400]]){
        NSLog(@"WIDE LOAD");
        letterSpacing = 9.1f;
    }
    
    id answer;
    for(answer in answers)
    {
        if([[[data objectAtIndex:questionIdx] objectForKey:@"type"] isEqualToNumber:[NSNumber numberWithInt:1]])
        {
            UILabel *answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_OFFSET+([HORIZONTAL_SPREAD floatValue] * currentColumn), ([VERTICAL_SPREAD floatValue] * currentRow)-7, textWidth, 40.0f)];
            [answerLabel setFont:[UIFont fontWithName:@"Gotham-Light" size:answerLabel.font.pointSize]];
            [answerLabel setBackgroundColor:[UIColor clearColor]];
            //[answerLabel setTextColor:[UIColor colorWithRed:1.0 green:0.866 blue:0.0 alpha:1.0]];
            [answerLabel setTextColor:[UIColor whiteColor]];
            [answerLabel setLineBreakMode:UILineBreakModeWordWrap];
            [answerLabel setNumberOfLines:2];
            answerLabel.text = [answer objectForKey:@"answer"];
            [answerView addSubview:answerLabel];
            NSLog(@"Build Answer for: '%@'",[answer objectForKey:@"answer"]);
          
            
            for(int i=0;i<5;i++){
                UIButton *answerBtn = [[UIButton alloc] initWithFrame:CGRectMake(115.0f+(i*65.0f)+X_OFFSET+([HORIZONTAL_SPREAD floatValue] * currentColumn), ([VERTICAL_SPREAD floatValue] * currentRow), 25.0f, 25.0f)];
                [answerBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateSelected];
                [answerBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateHighlighted];
                [answerBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateNormal];
                [answerBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateDisabled];
                answerBtn.selected = NO;
                [answerBtn addTarget:self 
                              action:@selector(selectedAnswer:) 
                    forControlEvents:UIControlEventTouchUpInside];
                
                [answerBtns addObject:answerBtn];
                [answerView addSubview:answerBtn];
                
                UILabel *answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0f+(i*65.0f)+X_OFFSET+([HORIZONTAL_SPREAD floatValue] * currentColumn), ([VERTICAL_SPREAD floatValue] * currentRow)-7, textWidth, 40.0f)];
                [answerLabel setFont:[UIFont fontWithName:@"Gotham-Light" size:answerLabel.font.pointSize]];
                [answerLabel setBackgroundColor:[UIColor clearColor]];
                //[answerLabel setTextColor:[UIColor colorWithRed:1.0 green:0.866 blue:0.0 alpha:1.0]];
                [answerLabel setTextColor:[UIColor whiteColor]];
                [answerLabel setLineBreakMode:UILineBreakModeWordWrap];
                [answerLabel setNumberOfLines:2];
                answerLabel.text = [[NSNumber numberWithInt:(i+1)]stringValue];
                [answerView addSubview:answerLabel];
            }
            
            
        }else{
            if([answer objectForKey:@"freeResponse"]!=nil)//[className isEqualToString:@"NSString"] || [className isEqualToString:@"NSCFString"])
            {
                UIButton *answerBtn = [[UIButton alloc] initWithFrame:CGRectMake(X_OFFSET+([HORIZONTAL_SPREAD floatValue] * currentColumn), ([VERTICAL_SPREAD floatValue] * (CGFloat)currentRow), 25.0f, 25.0f)];
                [answerBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateSelected];
                [answerBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateHighlighted];
                [answerBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateNormal];
                [answerBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateDisabled];
                answerBtn.selected = NO;
                answerBtn.tag = idx;
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
                
                [answerView addSubview:answerBtn];
                [answerView addSubview:answerLabel];
                
                // if([answer isEqualToString:@"OTHER"])
                //{
                NSLog(@"build 'other' textfield");
                otherTextField = [[UITextField alloc] initWithFrame:CGRectMake(X_OFFSET+([HORIZONTAL_SPREAD floatValue] * currentColumn)+([[answer objectForKey:@"answer"]length]*letterSpacing)/*115.0f*/, ([VERTICAL_SPREAD floatValue] * (currentRow))-2, 120.0f, 30.0f)];
                otherTextField.borderStyle = UITextBorderStyleRoundedRect;
                otherTextField.delegate = self;
                otherTextField.tag = idx;
                //[answerLabel setBackgroundColor:[UIColor whiteColor]];
                //[otherTextField set
                [otherTextField addTarget:self 
                                   action:@selector(selectedOther:) 
                         forControlEvents:UIControlEventEditingDidBegin];
                [textFields addObject:otherTextField];
                [answerView addSubview:otherTextField];
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
                
                [answerView addSubview:answerBtn];
                [answerView addSubview:answerLabel];
            } 
        }
        
        NSLog(@"idx: %d  answersPerCol: %d",idx, answersPerCol);
        if(idx % answersPerCol == 0){ 
            currentColumn++;
            currentRow = 0;
        }
        currentRow++;
        idx++;
    }
    
    NSLog(@"answerBtns1: %@", answer1Btns);
    NSLog(@"answerBtns2: %@", answer2Btns);
    
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
    [answerView setNeedsLayout];
    [answerView setNeedsDisplay];
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

- (IBAction)nextView
{
    int questionIdx = 0;
    
    
    UILabel *questionLbl;
    UIView *answerView;
    NSMutableArray *answerBtns;
    NSMutableArray *textFields;
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    for(NSDictionary *question in data){
        int index = 0;
        NSMutableArray *selectedAnswers = [[NSMutableArray alloc] initWithCapacity:0];
        NSString *otherTextFieldAnswer = nil;
        
        if(questionIdx == 0){
            questionLbl = question1Lbl;
            answerView = answer1View;
            answerBtns = answer1Btns;
            textFields = answer1TextFields;
        }else if(questionIdx == 1){
            questionLbl = question2Lbl;
            answerView = answer2View;
            answerBtns = answer2Btns;
            textFields = answer2TextFields;
        }else if(questionIdx == 2){
            questionLbl = question3Lbl;
            answerView = answer3View;
            answerBtns = answer3Btns;
            textFields = answer3TextFields;
        }
        NSMutableArray *answers = [[NSMutableArray alloc] initWithCapacity:0];
        
        if([[question objectForKey:@"type"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            [selectedAnswers addObject:[NSNumber numberWithInt:0]];
            int idx = 1;
            int count = 0;
            int answerNum = 0;
            for(UIButton *btn in answerBtns)
            {
                
                if(btn.selected){
                    NSLog(@"found it: %d", idx);
                    [self.delegate saveAnswers:selectedAnswers andOther:[NSString stringWithFormat:@"%d",(count - 1)] forQuestion:questionIdx];
                }
                if(idx % 5 == 0){
                    answerNum++;
                    count = 1;
                    [selectedAnswers removeAllObjects];
                    [selectedAnswers addObject:[NSNumber numberWithInt:answerNum]];
                }
                NSLog(@"answerNum: %d",answerNum);
                idx++;
                count++;
            }
            
            
        }else{
            index = 0;
            NSString *value = @"";
            for(UIButton *btn in answerBtns)
            {
                if(btn.selected){
                    [selectedAnswers addObject:[NSNumber numberWithInt:index]];
                    if([[[[data objectAtIndex:questionIdx] objectForKey:@"answers"] objectAtIndex:index]objectForKey:@"freeResponse"]){
                        NSLog(@"a free response question");
                        for(UITextField *tf in textFields){
                            NSLog(@"a textfield: %@",tf.text);
                            if(btn.tag == tf.tag){
                                value = tf.text;
                            }
                        }
                    }
                }
                index++;
            }
            
            if(otherTextField)
            {
                otherTextFieldAnswer = otherTextField.text;
            }
            
            if([selectedAnswers count]>=[[[data objectAtIndex:questionIdx] objectForKey:@"min"]integerValue])
            {
                [[appDelegate rootVC]hideErrorMessage];
                [self.delegate saveAnswers:selectedAnswers andOther:value forQuestion:questionIdx];
            }else{
                [[appDelegate rootVC]showErrorMessage:@"Please make a selection."];
                return;
            }
        }
        questionIdx++;
    }
}


- (IBAction)saveView
{
    int questionIdx = 0;
    
    
    UILabel *questionLbl;
    UIView *answerView;
    NSMutableArray *answerBtns;
    NSMutableArray *textFields;
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    for(NSDictionary *question in data){
        int index = 0;
        NSMutableArray *selectedAnswers = [[NSMutableArray alloc] initWithCapacity:0];
        NSString *otherTextFieldAnswer = nil;
        
        if(questionIdx == 0){
            questionLbl = question1Lbl;
            answerView = answer1View;
            answerBtns = answer1Btns;
            textFields = answer1TextFields;
        }else if(questionIdx == 1){
            questionLbl = question2Lbl;
            answerView = answer2View;
            answerBtns = answer2Btns;
            textFields = answer2TextFields;
        }else if(questionIdx == 2){
            questionLbl = question3Lbl;
            answerView = answer3View;
            answerBtns = answer3Btns;
            textFields = answer3TextFields;
        }
        NSMutableArray *answers = [[NSMutableArray alloc] initWithCapacity:0];
        
        if([[question objectForKey:@"type"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            [selectedAnswers addObject:[NSNumber numberWithInt:0]];
            int idx = 1;
            int count = 0;
            int answerNum = 0;
            for(UIButton *btn in answerBtns)
            {
                
                if(btn.selected){
                    NSLog(@"found it: %d", idx);
                    [self.delegate saveAnswers:selectedAnswers andOther:[NSString stringWithFormat:@"%d",(count - 1)] forQuestion:questionIdx];
                }
                if(idx % 5 == 0){
                    answerNum++;
                    count = 1;
                    [selectedAnswers removeAllObjects];
                    [selectedAnswers addObject:[NSNumber numberWithInt:answerNum]];
                }
                NSLog(@"answerNum: %d",answerNum);
                idx++;
                count++;
            }
            
            
        }else{
            index = 0;
            NSString *value = @"";
            for(UIButton *btn in answerBtns)
            {
                if(btn.selected){
                    [selectedAnswers addObject:[NSNumber numberWithInt:index]];
                    if([[[[data objectAtIndex:questionIdx] objectForKey:@"answers"] objectAtIndex:index]objectForKey:@"freeResponse"]){
                        for(UITextField *tf in textFields){
                            NSLog(@"a textfield: %@",tf.text);
                            if(btn.tag == tf.tag){
                                value = tf.text;
                            }
                        }
                    }
                }
                index++;
            }
            
            if(otherTextField)
            {
                otherTextFieldAnswer = otherTextField.text;
            }
            
            if([selectedAnswers count]>=[[[data objectAtIndex:questionIdx] objectForKey:@"min"]integerValue])
            {
                [[appDelegate rootVC]hideErrorMessage];
                [self.delegate saveAnswersAndExit:selectedAnswers andOther:otherTextFieldAnswer forQuestion:questionIdx];
            }else{
                //[[appDelegate rootVC]showErrorMessage:@"Please make a selection."];
                [self.delegate saveAnswersAndExit:selectedAnswers andOther:otherTextFieldAnswer forQuestion:questionIdx];
                return;
            }
        }
        questionIdx++;
    }
}

- (IBAction)cancel
{
    [self.delegate cancel];
}

- (IBAction)selectedAnswer:(id)sender
{
    UILabel *questionLbl;
    UIView *answerView;
    NSMutableArray *answerBtns;
    NSInteger questionIdx = 0;
    
    UIButton *tmpBtn = (UIButton*)sender;

    if([(UIView*)tmpBtn superview] == answer1View){
        questionIdx = 0;
        questionLbl = question1Lbl;
        answerView = answer1View;
        answerBtns = answer1Btns;
    }else if([(UIView*)tmpBtn superview] == answer2View){
        questionIdx = 1;
        questionLbl = question2Lbl;
        answerView = answer2View;
        answerBtns = answer2Btns;
    }else if([(UIView*)tmpBtn superview] == answer3View){
        questionIdx = 2;
        questionLbl = question3Lbl;
        answerView = answer3View;
        answerBtns = answer3Btns;
    }
    
    if(tmpBtn.selected)
    {
        tmpBtn.selected = NO;
    }else{
        if([[[data objectAtIndex:questionIdx] objectForKey:@"type"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            int idx = 1;
            int count = 0;
            int answerNum = 0;
            for(UIButton *btn in answerBtns)
            {
                
                if(btn == tmpBtn){
                    NSLog(@"found it: %d", idx);
                    break;
                }
                if(idx % 5 == 0){
                    answerNum++;
                }
                NSLog(@"answerNum: %d",answerNum);
                idx++;
            }
            
            int start = (answerNum * 5);
            if(answerNum == 0) start = 0;
            int end = start + 5;
            //if(start == 9) end = start + 5;
            
            NSLog(@"start: %d",start);
            for(int i=start;i<end;i++)
            {
                if([(UIButton*)[answerBtns objectAtIndex:i]isSelected]){
                    if([[[data objectAtIndex:questionIdx] objectForKey:@"max"] integerValue] == 1)
                    {
                        NSLog(@"deselect idx: %d",i);
                        [(UIButton*)[answerBtns objectAtIndex:i]setSelected:NO];
                    }else{
                        count++;
                    }
                }
            }
            if(count < [[[data objectAtIndex:questionIdx] objectForKey:@"max"]integerValue])
            {
                tmpBtn.selected = YES;
            }

        }else{
            int count = 0;
            for(UIButton *btn in answerBtns)
            {
                if(btn.selected){
                    if([[[data objectAtIndex:questionIdx] objectForKey:@"max"] integerValue] == 1)
                    {
                        btn.selected = NO;
                    }else{
                        count++;
                    }
                }
            }
            if(count < [[[data objectAtIndex:questionIdx] objectForKey:@"max"]integerValue])
            {
                tmpBtn.selected = YES;
            }
        }
        
      //  NSLog(@"\n count: %d \n max: %d", count, [[[data objectAtIndex:questionIdx] objectForKey:@"max"]integerValue]);
        
       
    }
}

-(IBAction)selectedOther:(id)sender
{
    UITextField *btn = (UITextField*)sender;
    
    UILabel *questionLbl;
    UIView *answerView;
    NSMutableArray *answerBtns;
    
    if([(UIView*)btn superview] == answer1View){
        questionLbl = question1Lbl;
        answerView = answer1View;
        answerBtns = answer1Btns;
    }else if([(UIView*)btn superview] == answer2View){
        questionLbl = question2Lbl;
        answerView = answer2View;
        answerBtns = answer2Btns;
    }else if([(UIView*)btn superview] == answer3View){
        questionLbl = question3Lbl;
        answerView = answer3View;
        answerBtns = answer3Btns;
    }
    
    [btn setSelected:YES];
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
    
    
    
    UILabel *questionLbl;
    UIView *answerView;
    NSMutableArray *answerBtns;
    
    if([textField superview] == answer1View){
        questionLbl = question1Lbl;
        answerView = answer1View;
        answerBtns = answer1Btns;
    }else if([textField superview] == answer2View){
        questionLbl = question2Lbl;
        answerView = answer2View;
        answerBtns = answer2Btns;
    }else if([textField superview] == answer3View){
        questionLbl = question3Lbl;
        answerView = answer3View;
        answerBtns = answer3Btns;
    }
    
    for(UIButton *btn in answerBtns){
        if(btn.tag == textField.tag){
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	//isEditing = NO;
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]hideErrorMessage];
}

@end

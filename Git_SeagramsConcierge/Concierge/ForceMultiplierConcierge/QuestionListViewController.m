//
//  QuestionListViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 8/11/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "QuestionListViewController.h"


@implementation QuestionListViewController

@synthesize nav, questions, currentQuestion, answers, flags;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Survey" ofType:@"plist"];
        NSLog(@"Plist Path: %@", plistPath);
        
        self.questions = [[NSArray alloc] initWithArray:[[NSDictionary dictionaryWithContentsOfFile:plistPath]objectForKey:@"questions"]];
        NSLog(@"All Questions: %@", self.questions);
        
        
        self.currentQuestion = 0;
        self.answers = [[NSMutableString alloc] initWithCapacity:0];
        self.flags = [[NSMutableArray alloc] initWithCapacity:0];
        self.nav = nil;
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
    
    //load first question
    [self loadQuestion];
}

- (void)loadQuestion
{
    NSLog(@"\ncurrentQuestion: %d \nquestionCount: %d",self.currentQuestion, [self.questions count]);
    //Make next question view
    QuestionViewController *questionVC = [[QuestionViewController alloc] initWithNibName:@"QuestionViewController" bundle:nil];
    
    
    //Build nav controller or push onto the stack
    if(self.nav == nil)
    {
        self.nav = [[UINavigationController alloc] initWithRootViewController:questionVC];
        [nav setNavigationBarHidden:YES];
        
        CGRect frame = self.view.frame;
        frame.origin.x = 0.0f;
        frame.origin.y = 0.0f;
        self.nav.view.frame = frame;
        [self.view addSubview:self.nav.view];
        
        [self.view setNeedsLayout];
        [self.view setNeedsDisplay];
        
        [self.nav.view setNeedsLayout];
        [self.nav.view setNeedsDisplay];
        
        [questionVC.view setNeedsLayout];
        [questionVC.view setNeedsDisplay];
    }else{
        [self.nav pushViewController:questionVC animated:YES];
    }
    
    NSMutableArray *questionsArr = [[NSMutableArray alloc] initWithCapacity:0];
    [questionsArr addObject:[self.questions objectAtIndex:currentQuestion]];
    if(([self.questions count]-1) > currentQuestion+1) [questionsArr addObject:[self.questions objectAtIndex:currentQuestion+1]];
    //if([self.questions count] > currentQuestion+2) [questionsArr addObject:[self.questions objectAtIndex:currentQuestion+2]];
    
    [questionVC loadQuestion:questionsArr];
    [questionVC setDelegate:self];
}

- (void)saveAnswers:(NSMutableArray*)answers andOther:(NSString*)otherAnswer forQuestion:(NSInteger)questionIdx
{
    NSLog(@"answers: %@",answers);
    
    if([self.questions count]-1 >= currentQuestion+questionIdx){
        NSDictionary *question = [self.questions objectAtIndex:currentQuestion+questionIdx];
        
        for(NSNumber *answerIDX in answers)
        {
            NSDictionary *answer = [[question objectForKey:@"answers"] objectAtIndex:[answerIDX integerValue]];
            if(![NSStringFromClass([answer class]) isEqualToString:@"NSCFString"])[flags addObjectsFromArray:[answer objectForKey:@"childrenQuestions"]];
            
            ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
            [[appDelegate da] saveAnswerID:[answer valueForKey:@"answerID"] Value:otherAnswer];
            [[appDelegate da] updateSurveyForAuthorID:[[appDelegate da] currentAuthorID]];
        }
        
        NSLog(@"flags array: %@",flags);
        
        //increment the question
        if(questionIdx == 1 || (questionIdx+currentQuestion+2)>=[questions count]-1 ){
            self.currentQuestion=self.currentQuestion + 2;
            [self loadNextQuestion];
        }
    }else{
        self.currentQuestion=self.currentQuestion + 2;
        [self loadNextQuestion];
    }
    
    //NSLog(@"\ncurrentQuestion: %d \nquestionCount: %d",self.currentQuestion, [self.questions count]);
    
}

- (void)saveAnswersAndExit:(NSMutableArray*)answers andOther:(NSString*)otherAnswer forQuestion:(NSInteger)questionIdx
{
    NSLog(@"answers: %@",answers);
    
    if([self.questions count]-1 >= currentQuestion+questionIdx){
        NSDictionary *question = [self.questions objectAtIndex:currentQuestion+questionIdx];
        
        for(NSNumber *answerIDX in answers)
        {
            NSDictionary *answer = [[question objectForKey:@"answers"] objectAtIndex:[answerIDX integerValue]];
            if(![NSStringFromClass([answer class]) isEqualToString:@"NSCFString"])[flags addObjectsFromArray:[answer objectForKey:@"childrenQuestions"]];
            
            ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
            [[appDelegate da] saveAnswerID:[answer valueForKey:@"answerID"] Value:otherAnswer];
        }
        
        NSLog(@"flags array: %@",flags);
        
        //increment the question
        if(questionIdx == 1 || (questionIdx+currentQuestion+2)>=[questions count]-1 ){
            self.currentQuestion=self.currentQuestion + 2;
            [self loadNextQuestion];
        }
    }else{
        self.currentQuestion=self.currentQuestion + 2;
        [self loadNextQuestion];
    }
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
    //NSLog(@"\ncurrentQuestion: %d \nquestionCount: %d",self.currentQuestion, [self.questions count]);
    
}

-(void)cancel
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)loadNextQuestion
{
    NSLog(@"loadNextQuestion");
    BOOL showQuestion = NO;
    while(!showQuestion)
    {
        
        if(self.currentQuestion < [self.questions count]-1)
        {
            NSDictionary *question = [self.questions objectAtIndex:currentQuestion];
            NSLog(@"next Question: %@",question);
            NSLog(@"next Question Dependent Flag type: %@",NSStringFromClass([[question valueForKey:@"dependent"] class]));
            if([[question valueForKey:@"dependent"]boolValue])
            {
                
                for(NSNumber *dependency in flags)
                {
                    if([dependency isEqualToNumber:[NSNumber numberWithInt:currentQuestion]])
                    {
                        NSLog(@"dependency found");
                        [self loadQuestion];
                        return;
                    }
                }
                NSLog(@"dependency not found");
                currentQuestion++;
                
            }else{
                //load next question
                NSLog(@"no dependency");
                [self loadQuestion];
                return;
            }
            
        }else{
            //if fields validate, set person values
            if([self validateFields])
            {
                //[self createPersonSurveyResponse];
                [self.navigationController.tabBarController.tabBar setHidden:NO];
                [self.navigationController popToRootViewControllerAnimated:YES];
                /*
                TabbedViewController *tabbedVC = [[self.navigationController viewControllers]objectAtIndex:1];
                [[tabbedVC dc_abbrVC]clearFields];
                
                ThankYouPurchaseViewController *thankYouVC = [[ThankYouPurchaseViewController alloc] initWithNibName:@"ThankYouPurchaseViewController" bundle:nil];
                
                ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
                [[appDelegate rootVC] hideErrorMessage];
                
                [[[appDelegate rootVC] navController] pushViewController:thankYouVC animated:YES];*/
            } 
            return;
        }
    }
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

-(Boolean)validateFields
{
    return YES;
}

@end

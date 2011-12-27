//
//  DataCollection_Question_ViewController.h
//  ForceMultiplier
//
//  Created by Glenn Smits on 7/14/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThankYouPurchaseViewController.h"


@interface DataCollection_Question_ViewController : UIViewController <UITextFieldDelegate> {
    NSMutableDictionary *brandQuestion;
    NSMutableDictionary *brandDrinkingIdeasQuestion;
    NSMutableArray *answerBtns;
    NSMutableArray *ideaAnswerBtns;
    NSMutableArray *genderBtns;
    NSMutableArray *languageBtns;
    
    IBOutlet UIView *answerView;
    IBOutlet UIView *answerIdeasView;
    IBOutlet UIView *genderView;
    IBOutlet UIView *languageView;
    IBOutlet UIButton *nextBtn;
    IBOutlet UIButton *allBtn;
    IBOutlet UILabel *questionLabel;
    
    IBOutlet UISegmentedControl *gender;
    IBOutlet UISegmentedControl *language;
    
    UITextField *otherTextField;
    
    UITextField *currentTextField;
	Boolean keyboardIsShown;
	Boolean isEditing;
}

@property (nonatomic, retain) NSMutableDictionary *brandQuestion;
@property (nonatomic, retain) NSMutableDictionary *brandDrinkingIdeasQuestion;
@property (nonatomic, retain) NSMutableArray *answerBtns;
@property (nonatomic, retain) NSMutableArray *ideaAnswerBtns;
@property (nonatomic, retain) NSMutableArray *genderBtns;
@property (nonatomic, retain) NSMutableArray *languageBtns;

@property (nonatomic, retain) IBOutlet UIView *answerView;
@property (nonatomic, retain) IBOutlet UIView *answerIdeasView;
@property (nonatomic, retain) IBOutlet UIView *genderView;
@property (nonatomic, retain) IBOutlet UIView *languageView;
@property (nonatomic, retain) IBOutlet UIButton *nextBtn;
@property (nonatomic, retain) IBOutlet UILabel *questionLabel;

@property (nonatomic, retain) UITextField *otherTextField;
@property (nonatomic, retain) UIButton *allBtn;

@property (nonatomic) Boolean keyboardIsShown;
@property (nonatomic) Boolean isEditing;
@property (nonatomic) CGPoint currentOffset;

-(IBAction)nextView;
-(void)createPersonSurveyResponse;
-(Boolean)validateFields;

@end

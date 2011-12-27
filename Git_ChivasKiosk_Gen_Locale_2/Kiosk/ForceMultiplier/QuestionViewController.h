//
//  QuestionViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 8/12/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

//#import <UIKit/UIKit.h>
//@class ForceMultiplierAppDelegate;

#import <UIKit/UIKit.h>
#import "DataCollection_Question_ViewController.h"
#import "QuestionListViewController.h"
#import "ForceMultiplierAppDelegate.h"
#import "PickerViewController.h"
#import "UIView+findFirstResponder.h"


@interface QuestionViewController : UIViewController <UITextFieldDelegate> {
    NSNumber *VERTICAL_SPREAD;
    NSNumber *HORIZONTAL_SPREAD;
    
    NSDictionary *data;
    NSMutableArray *answerBtns;
    
    IBOutlet UIButton *nextBtn;
    IBOutlet UILabel *questionLbl;
    IBOutlet UILabel *greetingLbl;
    IBOutlet UIView *answerView;
    UITextField *otherTextField;
    
    Boolean keyboardIsShown;
	Boolean isEditing;
    UITextField *currentTextField;
    
    id *delegate;
}

@property (nonatomic,retain) NSDictionary *data;
@property (nonatomic,retain) NSNumber *VERTICAL_SPREAD;
@property (nonatomic,retain) NSNumber *HORIZONTAL_SPREAD;

@property (nonatomic,retain) UITextField *otherTextField;
@property (nonatomic,retain) NSMutableArray *answerBtns;

@property (nonatomic,retain) IBOutlet UIButton *nextBtn;
@property (nonatomic,retain) IBOutlet UILabel *questionLbl;
@property (nonatomic,retain) IBOutlet UILabel *greetingLbl;
@property (nonatomic,retain) IBOutlet UIView *answerView;

@property (nonatomic) id *delegate;

@property (nonatomic) Boolean keyboardIsShown;
@property (nonatomic) Boolean isEditing;
@property (nonatomic) CGPoint currentOffset;
@property (nonatomic,retain) UITextField *currentTextField;

- (IBAction)nextView;
@end

//
//  QuestionViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 8/12/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ForceMultiplierAppDelegate;

@interface QuestionViewController : UIViewController <UITextFieldDelegate> {
    NSNumber *VERTICAL_SPREAD;
    NSNumber *HORIZONTAL_SPREAD;
    
    NSArray *data;
    NSMutableArray *answer1Btns;
    NSMutableArray *answer2Btns;
    NSMutableArray *answer3Btns;
    
    NSMutableArray *answer1TextFields;
    NSMutableArray *answer2TextFields;
    NSMutableArray *answer3TextFields;
    
    IBOutlet UIButton *nextBtn;
    IBOutlet UIButton *saveBtn;
    IBOutlet UIButton *backBtn;
    IBOutlet UILabel *question1Lbl;
    IBOutlet UIView *answer1View;
    IBOutlet UILabel *question2Lbl;
    IBOutlet UIView *answer2View;
    IBOutlet UILabel *question3Lbl;
    IBOutlet UIView *answer3View;
    
    IBOutlet UILabel *greetingLbl;
    UITextField *otherTextField;
    
    Boolean keyboardIsShown;
	Boolean isEditing;
    UITextField *currentTextField;
    
    id *delegate;
}

@property (nonatomic,retain) NSArray *data;
@property (nonatomic,retain) NSNumber *VERTICAL_SPREAD;
@property (nonatomic,retain) NSNumber *HORIZONTAL_SPREAD;

@property (nonatomic,retain) UITextField *otherTextField;
@property (nonatomic,retain) NSMutableArray *answer1Btns;
@property (nonatomic,retain) NSMutableArray *answer2Btns;
@property (nonatomic,retain) NSMutableArray *answer3Btns;

@property (nonatomic,retain) NSMutableArray *answer1TextFields;
@property (nonatomic,retain) NSMutableArray *answer2TextFields;
@property (nonatomic,retain) NSMutableArray *answer3TextFields;

@property (nonatomic,retain) IBOutlet UIButton *nextBtn;
@property (nonatomic,retain) IBOutlet UIButton *saveBtn;
@property (nonatomic,retain) IBOutlet UIButton *backBtn;
@property (nonatomic,retain) IBOutlet UILabel *question1Lbl;
@property (nonatomic,retain) IBOutlet UILabel *question2Lbl;
@property (nonatomic,retain) IBOutlet UILabel *question3Lbl;
@property (nonatomic,retain) IBOutlet UILabel *greetingLbl;
@property (nonatomic,retain) IBOutlet UIView *answer1View;
@property (nonatomic,retain) IBOutlet UIView *answer2View;
@property (nonatomic,retain) IBOutlet UIView *answer3View;

@property (nonatomic,retain) id *delegate;

@property (nonatomic) Boolean keyboardIsShown;
@property (nonatomic) Boolean isEditing;
@property (nonatomic) CGPoint currentOffset;
@property (nonatomic,retain) UITextField *currentTextField;

- (IBAction)nextView;
- (IBAction)saveView;
- (IBAction)cancel;

@end

//
//  EventAddAttendeeViewController.h
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/22/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForceMultiplierConciergeAppDelegate.h"
#import "PickerViewController.h"
#import "UIView+findFirstResponder.h"


@interface EventAddAttendeeViewController : UIViewController <UIPopoverControllerDelegate,PopoverPickerDelegate,UITextFieldDelegate> {
    //Views
    IBOutlet UIView *content;
    IBOutlet UIView *rightSide;
    IBOutlet UIView *addressBox;
    IBOutlet UIScrollView *scrollView;
    
    //Fields
    IBOutlet UITextField *firstName;
	IBOutlet UITextField *lastName;
	IBOutlet UITextField *dob;
	IBOutlet UITextField *email;
	IBOutlet UITextField *confirmEmail;
	IBOutlet UITextField *telephone_1;
    IBOutlet UITextField *telephone_2;
    IBOutlet UITextField *telephone_3;
    IBOutlet UITextField *address_1;
    IBOutlet UITextField *address_2;
    IBOutlet UITextField *city;
    IBOutlet UITextField *state;
    IBOutlet UITextField *zip;
	IBOutlet UIButton *optIn;
    IBOutlet UIButton *next_btn;
    IBOutlet UIWebView *disclaimer;
    
}


@property (nonatomic, retain) IBOutlet UIView *content;
@property (nonatomic, retain) IBOutlet UIView *rightSide;
@property (nonatomic, retain) IBOutlet UIView *addressBox;
@property (nonatomic, retain) IBOutlet UITextField *firstName;
@property (nonatomic, retain) IBOutlet UITextField *lastName;
@property (nonatomic, retain) IBOutlet UITextField *dob;
@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) IBOutlet UITextField *confirmEmail;
@property (nonatomic, retain) IBOutlet UITextField *telephone_1;
@property (nonatomic, retain) IBOutlet UITextField *telephone_2;
@property (nonatomic, retain) IBOutlet UITextField *telephone_3;
@property (nonatomic, retain) IBOutlet UITextField *address_1;
@property (nonatomic, retain) IBOutlet UITextField *address_2;
@property (nonatomic, retain) IBOutlet UITextField *city;
@property (nonatomic, retain) IBOutlet UITextField *state;
@property (nonatomic, retain) IBOutlet UITextField *zip;
@property (nonatomic, retain) IBOutlet UIButton *optIn;
@property (nonatomic, retain) IBOutlet UIButton *next_btn;
@property (nonatomic, retain) IBOutlet UIWebView *disclaimer;

-(IBAction)togglePopOverController;
-(IBAction)selectOptIn;
-(IBAction)nextView;
-(IBAction)clickedDOB;
-(IBAction)textFieldChanged:(id)sender;


@end

//
//  AttendeeProfileViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/16/11.
//  Contributions by Dustin Fineout.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.

//

#import <UIKit/UIKit.h>
#import "ForceMultiplierConciergeAppDelegate.h"
//#import "ThankYouViewController.h"
#import "PickerViewController.h"
#import "UIView+findFirstResponder.h"

@interface AttendeeProfileViewController : UIViewController <UIPopoverControllerDelegate,PopoverPickerDelegate,UITextFieldDelegate>{
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
    
    //Picker
    UIPopoverController *popOverControllerWithPicker;
	PickerViewController *pickerViewController;
    
    NSArray *textFields;
    
    UITextField *currentTextField;
	Boolean keyboardIsShown;
	Boolean isEditing;
	CGPoint svos;
    
    //CoreData
    NSManagedObject *person;
    NSManagedObjectContext *context;
    
    //Data
    NSString *disclaimerText;
    
    CGPoint currentOffset;
    CGFloat popoverY;

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
@property (nonatomic) Boolean keyboardIsShown;
@property (nonatomic) Boolean isEditing;
@property (nonatomic) CGPoint currentOffset;
@property (nonatomic) CGFloat popoverY;

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSManagedObject *person;

@property (nonatomic, retain) NSString *disclaimerText;

-(IBAction)togglePopOverController;
-(IBAction)selectOptIn;
-(IBAction)clickedDOB;
-(IBAction)textFieldChanged:(id)sender;

-(void)didTap:(NSString *)string;
-(void)displayPickerPopover;
-(void)_layoutPage;
- (id)indexForTextField:(UITextField *)textField;
- (void)resizeTextFields:(NSNumber*)newWidth;
-(void)clearFields;
-(void)setDisclaimerTextView:(NSNumber*)size;
-(IBAction)nextView;
-(NSString*) parseDate:(NSDate*)aDate;
-(BOOL)validateFields;
-(void)createPerson;
-(void)savePerson;
-(void)dismissFirstResponder;


@end

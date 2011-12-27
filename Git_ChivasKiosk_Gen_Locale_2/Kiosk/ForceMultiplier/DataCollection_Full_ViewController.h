//
//  DataCollection_Full_ViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/16/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForceMultiplierAppDelegate.h"
#import "DataCollection_Question_ViewController.h"
#import "QuestionListViewController.h"
#import "PickerViewController.h"
#import "UIView+findFirstResponder.h"

@interface DataCollection_Full_ViewController : UIViewController <UIPopoverControllerDelegate,PopoverPickerDelegate,UITextFieldDelegate>{
    //Views
    IBOutlet UIView *content;
    IBOutlet UIView *rightSide;
    IBOutlet UIView *addressBox;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *dob;

    //Fields
    IBOutlet UITextField *firstName;
	IBOutlet UITextField *lastName;
	IBOutlet UITextField *day;
    IBOutlet UITextField *month;
    IBOutlet UITextField *year;
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
    IBOutlet UITextField *accountName;
	IBOutlet UIButton *optIn;
    IBOutlet UIButton *next_btn;
    IBOutlet UIWebView *disclaimer;

    
    //Picker
    UIPopoverController *popOverControllerWithPicker;
	PickerViewController *pickerViewController;
    NSString *currentPicker;
    
    NSArray *textFields;
    
    UITextField *currentTextField;
	Boolean keyboardIsShown;
	Boolean isEditing;
	CGPoint svos;
    
    //CoreData
    NSManagedObject *person;
    NSManagedObject *person_update;
    NSManagedObject *person_archive;
    NSManagedObjectContext *context;
    
    //Data
    NSString *disclaimerText;
    
    CGPoint currentOffset;
    CGFloat popoverY;
    
    NSDictionary *states;
    
     DataAccess *da;
    
    BOOL popoverShown;
    BOOL popoverBuilding;
}

@property (nonatomic, retain) IBOutlet UIView *content;
@property (nonatomic, retain) IBOutlet UIView *rightSide;
@property (nonatomic, retain) IBOutlet UIView *addressBox;
@property (nonatomic, retain) IBOutlet UITextField *firstName;
@property (nonatomic, retain) IBOutlet UITextField *lastName;
@property (nonatomic, retain) IBOutlet UITextField *day;
@property (nonatomic, retain) IBOutlet UITextField *month;
@property (nonatomic, retain) IBOutlet UITextField *year;
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
@property (nonatomic, retain) IBOutlet UITextField *accountName;
@property (nonatomic, retain) IBOutlet UIButton *optIn;
@property (nonatomic, retain) IBOutlet UIButton *next_btn;
@property (nonatomic, retain) IBOutlet UIWebView *disclaimer;
@property (nonatomic) Boolean keyboardIsShown;
@property (nonatomic) Boolean isEditing;
@property (nonatomic) CGPoint currentOffset;
@property (nonatomic) CGFloat popoverY;
@property (nonatomic, retain) NSString *currentPicker;
@property (nonatomic) IBOutlet UIButton *dob;

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSManagedObject *person;
@property (nonatomic, retain) NSManagedObject *person_update;
@property (nonatomic, retain) NSManagedObject *person_archive;

@property (nonatomic, retain) NSString *disclaimerText;
@property (nonatomic, retain) DataAccess *da;
@property (nonatomic, retain) NSDictionary *states;

@property (nonatomic) BOOL popoverShown;
@property (nonatomic) BOOL popoverBuilding;

-(IBAction)togglePopOverController;
-(IBAction)selectOptIn;
-(IBAction)nextView;
-(IBAction)clickedDOB;
-(IBAction)clickedState;
-(IBAction)textFieldChanged:(id)sender;


-(void)didTap:(NSString *)string;
-(void)displayPickerPopover;
-(id)indexForTextField:(UITextField *)textField;

-(void)clearFields;
- (IBAction)chooseDOB:(id)sender;

@end

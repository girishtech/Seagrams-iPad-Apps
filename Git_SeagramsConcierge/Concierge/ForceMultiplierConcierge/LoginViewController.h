//
//  LoginViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/11/11.
//  Contributions by Dustin Fineout.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDetailViewController.h"
#import "ForceMultiplierConciergeAppDelegate.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>{
    //KioskSettingsViewController *settingsVC;
    EventDetailViewController *eventDetailVC;
    
    IBOutlet UITextField *user;
    IBOutlet UITextField *pass;
    IBOutlet UITextField *lang;
    IBOutlet UITextField *webAddress;
    UITextField *currentTextField;
	
    Boolean keyboardIsShown;
	Boolean isEditing;
    
    NSArray *textFields;
}

@property (nonatomic,retain) EventDetailViewController *eventDetailVC;

@property (nonatomic,retain) IBOutlet UITextField *user;
@property (nonatomic,retain) IBOutlet UITextField *pass;
@property (nonatomic,retain) IBOutlet UITextField *lang;
@property (nonatomic,retain) IBOutlet UITextField *webAddress;
@property (nonatomic,retain) UITextField *currentTextField;

@property (nonatomic) Boolean keyboardIsShown;
@property (nonatomic) Boolean isEditing;


@end

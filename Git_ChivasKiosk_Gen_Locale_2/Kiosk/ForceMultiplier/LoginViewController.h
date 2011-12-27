//
//  LoginViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/11/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KioskSettingsViewController.h"
@class DataAccess;

@interface LoginViewController : UIViewController <UITextFieldDelegate>{
    KioskSettingsViewController *settingsVC;
    IBOutlet UITextField *user;
    IBOutlet UITextField *pass;
    UITextField *currentTextField;
	Boolean keyboardIsShown;
	Boolean isEditing;
    
    NSArray *textFields;
    
    DataAccess *da;
}

@property (nonatomic,retain) KioskSettingsViewController *settingsVC;
@property (nonatomic,retain) IBOutlet UITextField *user;
@property (nonatomic,retain) IBOutlet UITextField *pass;
@property (nonatomic,retain) UITextField *currentTextField;

@property (nonatomic) Boolean keyboardIsShown;
@property (nonatomic) Boolean isEditing;

@property (nonatomic,retain) DataAccess *da;

@end

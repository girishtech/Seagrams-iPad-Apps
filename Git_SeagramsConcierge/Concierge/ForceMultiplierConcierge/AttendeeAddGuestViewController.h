//
//  AttendeeAddGuestViewController.h
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/22/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AttendeeAddGuestViewController : UIViewController <UITextFieldDelegate>{
    IBOutlet UILabel *invitedByName;
    IBOutlet UILabel *eventName;
    IBOutlet UILabel *eventDate;
    IBOutlet UITextField *guestFirstName;
    IBOutlet UITextField *guestLastName;
    IBOutlet UITextField *guestEmail;
    IBOutlet UITextField *guestEmailConfirm;
    IBOutlet UISegmentedControl *guestCheckedInSegmentedControl;
    IBOutlet UIButton *submitButton;
}

@property (nonatomic, retain) IBOutlet UILabel *invitedByName;
@property (nonatomic, retain) IBOutlet UILabel *eventName;
@property (nonatomic, retain) IBOutlet UILabel *eventDate;
@property (nonatomic, retain) IBOutlet UITextField *guestFirstName;
@property (nonatomic, retain) IBOutlet UITextField *guestLastName;
@property (nonatomic, retain) IBOutlet UITextField *guestEmail;
@property (nonatomic, retain) IBOutlet UITextField *guestEmailConfirm;
@property (nonatomic, retain) IBOutlet UISegmentedControl *guestCheckedInSegmentedControl;
@property (nonatomic, retain) IBOutlet UIButton *submitButton;

- (IBAction)submit:(id)sender;
- (IBAction)selectGuestCheckedIn:(id)sender;

@end

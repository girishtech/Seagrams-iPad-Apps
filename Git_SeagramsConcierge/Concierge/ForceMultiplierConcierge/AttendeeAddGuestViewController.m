//
//  AttendeeAddGuestViewController.m
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/22/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import "AttendeeAddGuestViewController.h"


@implementation AttendeeAddGuestViewController

@synthesize invitedByName, eventDate, eventName, guestLastName, guestFirstName, guestCheckedInSegmentedControl, guestEmail, guestEmailConfirm, submitButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (IBAction)submit:(id)sender
{
    // not implemented
    NSLog(@"AttendeeAddGuestViewController - submit not implemented.");
}

- (IBAction)selectGuestCheckedIn:(id)sender
{
    // not implemented
    NSLog(@"AttendeeAddGuestViewController - selectGuestCheckedIn not implemented.");
}
@end

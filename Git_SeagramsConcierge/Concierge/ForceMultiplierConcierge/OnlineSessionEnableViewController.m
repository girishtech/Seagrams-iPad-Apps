//
//  OnlineSessionEnableViewController.m
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/24/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import "OnlineSessionEnableViewController.h"


@implementation OnlineSessionEnableViewController

//@synthesize tabbedVC;
@synthesize gridController, brand, context, person;
@synthesize da;

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
    NSLog(@"OnlineSessionEnableViewController - viewDidLoad");
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

- (IBAction)enableEvent
{
    NSLog(@"OnlineSessionEnableViewController - enableEvent is not implemented.");
}

@end

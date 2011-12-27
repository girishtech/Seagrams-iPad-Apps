//
//  UIPickerViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 7/1/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "UIPickerViewController.h"


@implementation UIPickerViewController

@synthesize delegate, pickerView;

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
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - Table view delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
    int rowCount = 0;
        NSLog(@"rowCount: %d",rowCount);
    rowCount = [delegate picker:self numberOfRowsInComponent:component];
    return rowCount;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
    NSString *label;
    label = [delegate picker:self titleForRow:row forComponent:component];    
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [delegate picker:self didSelectRow:row inComponent:component];
}


@end

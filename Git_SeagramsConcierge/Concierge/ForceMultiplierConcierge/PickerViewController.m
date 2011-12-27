    //
//  PickerViewController.m
//  PopApp
//
//  Created by Matthew Casey on 13/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PickerViewController.h"
#define componentCount 3
#define firstDigit 0
#define secondDigit 1
#define thirdDigit 2

@implementation PickerViewController

@synthesize thePickerView, theDatePickerView, delegate, components;

//PickerView

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return [components count];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
    int idx = 0;
    NSString *componentKey;
    for(componentKey in components)
    {
        NSLog(@"componentKey: %@ count: %d",componentKey,[[components objectForKey:componentKey] count]); 
        if(idx!=component){
            idx++;
        }else{
            break;
        }
    }
    
    return [[components objectForKey:componentKey] count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
    int idx = 0;
    NSString *componentKey;
    for(componentKey in components)
    {
        if(idx!=component){
            idx++;
        }else{
            break;
        }
    }
    
    return [[components objectForKey:componentKey] objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	int idx = 0;
    NSMutableDictionary *selectedValues = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString *componentKey;
    for(componentKey in components)
    {
        [selectedValues setObject:[[components objectForKey:componentKey] objectAtIndex:[thePickerView selectedRowInComponent:idx]] forKey:componentKey];
        idx++;
    }
    
    [self didChangeSelection:selectedValues];
}

-(IBAction)dateChanged
{
    NSMutableDictionary *selectedValues = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [selectedValues setObject:[theDatePickerView date] forKey:@"date"];
   
    [self didChangeSelection:selectedValues];
}

-(void)didChangeSelection:(NSMutableDictionary *)values {
	[self.delegate valuesDidChangeTo:values];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *values = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [values setObject:[theDatePickerView date] forKey:@"date"];
    [self.delegate valuesDidChangeTo:[values autorelease]];
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.delegate popoverShown];
}


- (void)dealloc {
	[components release];
    [super dealloc];
}

-(void)changeMode:(NSInteger)mode
{
    if(mode==0){
        [self.view bringSubviewToFront:theDatePickerView];
    }else{
        [self.view bringSubviewToFront:thePickerView];
    }
}

@end

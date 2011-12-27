//
//  RetailerResultsViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/31/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "RetailerResultsViewController.h"


@implementation RetailerResultsViewController

@synthesize gridController;

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
    NSArray *retailerNames = [[NSArray alloc] initWithObjects:@"Retailer 1",
                                                              @"Retailer 2",
                                                              @"Retailer 3",
                                                              @"Retailer 4",
                                                              @"Retailer 5",
                                                              @"Retailer 6",nil];
    NSArray *retailerAddresses = [[NSArray alloc] initWithObjects:@"123 Americas Ave\n New York, NY 12345\n 111-123-1234",
                                                                    @"123 Americas Ave\n New York, NY 12345\n 111-123-1234",
                                                                    @"123 Americas Ave\n New York, NY 12345\n 111-123-1234",
                                                                    @"123 Americas Ave\n New York, NY 12345\n 111-123-1234",
                                                                    @"123 Americas Ave\n New York, NY 12345\n 111-123-1234",
                                                                    @"123 Americas Ave\n New York, NY 12345\n 111-123-1234",nil];
    NSArray *retailerDistances = [[NSArray alloc] initWithObjects:@".5 miles",
                                                                  @".5 miles",
                                                                  @".5 miles",
                                                                  @".5 miles",
                                                                  @".5 miles",
                                                                  @".5 miles",nil];
    NSArray *retailerPreorders = [[NSArray alloc] initWithObjects:@"Preorder",
                                                                  @"Preorder",
                                                                  @"Preorder",
                                                                  @"Preorder",
                                                                  @"Preorder",
                                                                  @"Preorder",nil];
    
    NSMutableArray *retailerPreorderButtons = [[NSMutableArray alloc] initWithCapacity:0];
    
    int index = 0;
    NSString *buttonTitle;
    for(buttonTitle in retailerPreorders){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self 
                   action:@selector(preorder:)
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [retailerPreorderButtons addObject:button];
        index++;
    }
    
    GSOrderedDictionary *dataCollection = [[GSOrderedDictionary alloc] init];
    [dataCollection setObject:retailerNames forKey:@"Retailer"];
    [dataCollection setObject:retailerAddresses forKey:@"Address"];
    [dataCollection setObject:retailerDistances forKey:@"Distance"];
    [dataCollection setObject:retailerPreorderButtons forKey:@"Preorder"];
    
    [gridController setDataCollection:dataCollection];
    //[gridController setRowHeight:[NSNumber numberWithInt:50]];
    [gridController loadHeader];
    [[[self gridController] theTableView] reloadData];
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
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

-(IBAction)preorder:(id)sender
{
    UIButton *button = sender;
    NSLog(@"preorder from retailer #%d",button.tag); 
    
    [self nextView];
}

-(void)nextView
{
    OrderViewController *orderVC = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];

    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
    [[[appDelegate rootVC] navController] pushViewController:orderVC animated:YES];
}
@end

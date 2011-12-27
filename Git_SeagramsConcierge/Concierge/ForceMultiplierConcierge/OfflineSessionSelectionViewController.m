//
//  OfflineSessionSelectionViewController.m
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/24/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import "OfflineSessionSelectionViewController.h"
#import "EventDetailViewController.h"
#import "BrandEventSessionSelectionViewController.h"

@implementation OfflineSessionSelectionViewController

//@synthesize tabbedVC;
@synthesize gridController,brand,context,person;
@synthesize da;
@synthesize eventViewCnt, eventSelectBtn;
//added to test the table views
@synthesize tempData;

-(IBAction)eventItemSelect:(id)sender{
    NSLog(@"eventViewCnt - eventItemSelect");
    if(eventViewCnt == nil){
       EventDetailViewController *eventViewCntInit = [[EventDetailViewController alloc] initWithNibName:@"EventDetailViewController_Landscape" bundle:nil];    
        self.eventViewCnt = eventViewCntInit;
        [eventViewCntInit release];
    }
    eventViewCnt.title = @"Selected Event";
    [self.navigationController pushViewController:eventViewCnt animated:YES];
    //BrandEventSessionSelectionViewController *delegateClass = [[UIApplication sharedApplication] delegate];
    //delegateClass.tabBarController 
//    if(eventViewCnt == nil){
//        eventViewCnt = [[EventDetailViewController alloc] initWithNibName:@"EventDetailViewController_Landscape" bundle:nil];
//    }
//    [self.navigationController pushViewController:eventViewCnt animated:YES];

}


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
    NSLog(@"OfflineSessionSelectionViewController - viewDidLoad");
//    self.title = NSLocalizedString(@"Test" , @"Testing table view");
//    NSMutableArray *testArray =[[NSArray alloc] initWithObjects:@"Test Line One",@"Test Line Two",@"test Line Three", nil];
//    self.tempData = testArray;
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

- (IBAction) selectEvent
{
    NSLog(@"OfflineSessionSelectionViewController - selectEvent is not implemented.");
}

- (IBAction) syncEvent
{
    NSLog(@"OfflineSessionSelectionViewController - syncEvent is not implemented.");
}

- (IBAction) syncAll
{
    NSLog(@"OfflineSessionSelectionViewController - syncAll is not implemented.");
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
//    return [self.tempData count];
//    
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
//    
//    // Configure the cell...
//    NSUInteger row = [indexPath row];
//    cell.text = [tempData objectAtIndex:row]; 
//    
//    return cell;
//}

@end

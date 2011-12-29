//
//  KioskSettingsViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/27/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "KioskSettingsViewController.h"


@implementation KioskSettingsViewController

@synthesize tabbedVC;
@synthesize gridController,modeControl,brand,localCount,serverCount,context,person,selectedRow;
@synthesize da,rawDataSet,syncDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
        da = [appDelegate da];
        rawDataSet = [[NSDictionary alloc]init];
        if(!selectedRow) selectedRow = [[NSNumber alloc] initWithInt:1];
        
        //NSLog(@"dataCollection in KioskSettings: %@",dataCollection);
        //NSLog(@"dataCollection in gridController: %@",self.gridController.dataCollection);
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
    
    [gridController setDelegate:self];
    
    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y - 20.0f;
    self.view.frame = frame;
    
    //Background color tint override
    modeControl.tintColor = [UIColor colorWithRed:.619 green:0.227 blue:0.003 alpha:1.0];
    modeControl.selectedSegmentIndex = [[da getMode]integerValue];
    
    NSLog(@"current mode:%d",[[da getMode]integerValue]);
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    //AuthorizedConnector *auth = [appDelegate web];
    
    [[appDelegate rootVC] hideErrorMessage];
    //[self fetchRecordCount];
    
    //ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    person = nil;
    /*[self fetchRecordCount];
    
    // Do any additional setup after loading the view from its nib.
    // Custom initialization
    [self reloadGrid];*/
    [self _updateDisplay];
    
    if(da.currentTimeID != nil){
        //serverCount.text = [[rawDataSet objectForKey:@"eventCounts"]objectAtIndex:selectedRow];
    }else{
        //serverCount.text = @"N/A";
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[[self gridController] theTableView] reloadData];
    modeControl.selectedSegmentIndex = [[da getMode]integerValue];
    [self fetchRecordCount];
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UIScrollView *scrollvw = (UIScrollView*)[[appDelegate rootVC] scrollView];
    [scrollvw setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];

    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)hideMessage
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC] hideErrorMessage];
    [[appDelegate rootVC] hideSyncStatus];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)orientationDidChange:(NSNotification *)note
{
    
}

-(void)fetchRecordCount
{
    //Fix this
    
    NSError *errorFetchingPeople = nil;
    NSArray *people = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *personEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
    
    NSFetchRequest *allPeopleRequest = [[NSFetchRequest alloc] init];
    [allPeopleRequest setEntity:personEntity];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    people = [context executeFetchRequest:allPeopleRequest error:errorFetchingPeople];
    
    localCount.text = [NSString stringWithFormat:@"%d",[people count]];
    
    [allPeopleRequest release];
    
}

-(void)didSelectRow:(NSNumber*)rowID
{
    [self hideMessage];
    if(rawDataSet != nil)
    {
        NSLog(@"selected row: %d",rowID);
        selectedRow = [[NSNumber alloc] initWithInteger:[rowID integerValue]];
        da.currentTimeID = [[rawDataSet objectForKey:@"eventIDs"]objectAtIndex:[rowID integerValue]];
        
        if(da.currentTimeID != nil){
            if(![da.currentTimeID isEqualToString:@""]){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:da.currentTimeID forKey:@"currentTimeID"];
            }
        }
        ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
        [[[appDelegate rootVC] eventDetailVC] setEventNameLabel:[[rawDataSet objectForKey:@"names"]objectAtIndex:[rowID integerValue]]];
        
        NSLog(@"currentTimeIDs: %@",[rawDataSet objectForKey:@"eventIDs"]);
        NSLog(@"currentTimeID: %@",da.currentTimeID);
        //serverCount.text = [[rawDataSet objectForKey:@"eventCounts"]objectAtIndex:selectedRow];
        [self _updateDisplay];
    }
}

-(void)reloadGrid
{
    NSLog(@"reloadGrid");
    if(rawDataSet) [rawDataSet release];
    rawDataSet = [[NSDictionary alloc] initWithDictionary:[da allSessions]]; //initWithDictionary:[da allSessions]];
    
    GSOrderedDictionary *dataCollection = [[GSOrderedDictionary alloc] init];
    [dataCollection setObject:[rawDataSet objectForKey:@"names"] forKey:@"Event Name"];
    [dataCollection setObject:[rawDataSet objectForKey:@"markets"] forKey:@"Market"];
    [dataCollection setObject:[rawDataSet objectForKey:@"sessionNames"] forKey:@"Session Name"];
    //[dataCollection setObject:[rawDataSet objectForKey:@"venueNames"] forKey:@"Venue Name"];
    
    [dataCollection setObject:[rawDataSet objectForKey:@"dates"] forKey:@"Session Date"];
    [dataCollection setObject:[rawDataSet objectForKey:@"times"] forKey:@"Time"];
    
    
    [gridController setDataCollection:dataCollection];
    [gridController loadHeader];
    [[gridController theTableView] reloadData];
    [dataCollection release];
    //[rawDataSet release];
    /*if(selectedRow){
        [[gridController theTableView] selectRowAtIndexPath:[NSIndexPath indexPathWithIndex:selectedRow] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }*/
}

-(void)_updateDisplay
{
    if([da getNewSyncTS]){
        syncDate.text = [self parseDate:[da getNewSyncTS]];
    }else{
        syncDate.text = @"N/A";
    }
    if(da.currentTimeID != nil){
        if([rawDataSet count]>0){
            if([[rawDataSet objectForKey:@"eventCounts"]count]>0){
                serverCount.text = [NSString stringWithFormat:@"%d",[[[rawDataSet objectForKey:@"eventCounts"]objectAtIndex:[selectedRow integerValue]]integerValue]];
            }
        }
       
    }else{
        serverCount.text = @"N/A";
    }
    [self fetchRecordCount];
    //[self reloadGrid];
    [self performSelectorOnMainThread:@selector(reloadGrid) withObject:nil waitUntilDone:YES];
    [self.view setNeedsLayout];
    [self.view setNeedsDisplay];
}

-(void)updateDisplay
{
    //[self _updateDisplay];
    [self performSelector:@selector(_updateDisplay) withObject:nil afterDelay:1.0];
    NSLog(@"eventlist updatedisplay");
}

-(NSString*) parseDate:(NSDate*)aDate{
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM/dd/yyyy'\n'HH:mm:ss"];
    
    NSString *newDateString = [outputFormatter stringFromDate:aDate];
    
    
	[outputFormatter release];
	
    return newDateString;
    // For US English, the output is:
    // newDateString 10:30 on Sunday July 11
}

-(IBAction)sync
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC] lockScreen];
    AuthorizedConnector *auth = [appDelegate web];
    [auth getEventTimes];
    [auth addPeople];
    [self fetchRecordCount];
    [self reloadGrid];
    [pool release];
}

-(IBAction)changeMode:(id)sender
{
    /*[da changeMode:[NSNumber numberWithInt:modeControl.selectedSegmentIndex]];
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    TabbedViewController *tabbed = [[[[appDelegate rootVC]navController]viewControllers]objectAtIndex:0];
    [tabbed _updateView];*/
}

-(IBAction)selectEvent
{
    
}

- (void)loadNextView
{
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]hideErrorMessage];
    [[appDelegate rootVC]hideSyncStatus];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[[self.navigationController viewControllers]objectAtIndex:0]_layoutPage];
    modeControl.selectedSegmentIndex = [[da getMode]integerValue];
}

-(IBAction)clickedSave
{
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    if(da.currentTimeID != nil)
    {
        [[appDelegate rootVC]hideErrorMessage];
        
        [da changeMode:[NSNumber numberWithInt:modeControl.selectedSegmentIndex]];
        
        TabbedViewController *tabbed = [[[[appDelegate rootVC]navController]viewControllers]objectAtIndex:0];
        [tabbed _updateView];
        
        [self loadNextView];
        [[appDelegate rootVC] switchButtons];
    }else{
        [[appDelegate rootVC]showErrorMessage:@"Please Select a Session"];
        [[appDelegate rootVC]hideSyncStatus];
    }
}

-(IBAction)clickedCancel
{
    [self loadNextView];
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC] switchButtons];
}

@end

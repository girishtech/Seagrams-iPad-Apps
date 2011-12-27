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
@synthesize gridController,modeControl,diagnosticModeControl,brand,localCount,serverCount,context,person,selectedRow,version,webAddress;
@synthesize da,rawDataSet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
        da = [appDelegate da];
        rawDataSet = [[NSDictionary alloc]init];
    
        
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
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    AuthorizedConnector *auth = [appDelegate web];
    
    [gridController setDelegate:self];
    
    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y - 20.0f;
    self.view.frame = frame;
    
    //Background color tint override
    modeControl.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    modeControl.selectedSegmentIndex = [[da getMode]integerValue];
    
    /*
    diagnosticModeControl.tintColor = [UIColor colorWithRed:.87 green:0.36 blue:0.023 alpha:1.0];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"kiosk_diagnostic"]!=nil){
        if([[defaults objectForKey:@"kiosk_diagnostic"]isEqualToString:@"Y"]){
            auth.diagnosticMode = YES;
            diagnosticModeControl.selectedSegmentIndex = 0;
        }else{
            auth.diagnosticMode = NO;
            diagnosticModeControl.selectedSegmentIndex = 1;
        }
    }
    //*/
    
    NSLog(@"current mode:%d",[[da getMode]integerValue]);
    
    
    //[auth getEventTimes];
    [[appDelegate rootVC] hideErrorMessage];
    //[self fetchRecordCount];
    
    //ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    person = nil;
    [self fetchRecordCount];
    
    // Do any additional setup after loading the view from its nib.
    // Custom initialization
    [self reloadGrid];
    
    if(da.currentSession != nil){
        //serverCount.text = [[rawDataSet objectForKey:@"eventCounts"]objectAtIndex:selectedRow];
    }else{
        //serverCount.text = @"N/A";
    }
    
    version.text = [NSString stringWithFormat:@"Version: %@",CURRENTVERSION];
    webAddress.text = [[appDelegate web] WS_URL];

}

- (void)viewDidAppear:(BOOL)animated{
    [[[self gridController] theTableView] reloadData];
    modeControl.selectedSegmentIndex = [[da getMode]integerValue];
    [self fetchRecordCount];
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

- (void)orientationDidChange:(NSNotification *)note
{
    
}

-(void)fetchRecordCount
{
    //Fix this
    
    NSError *errorFetchingPeople = nil;
    NSArray *people = nil;
    NSManagedObjectContext *moc = [[[NSManagedObjectContext alloc] init] autorelease];
    [moc setPersistentStoreCoordinator:[context persistentStoreCoordinator]];
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *personEntity = [NSEntityDescription entityForName:@"Trans_Queue_Author" inManagedObjectContext:moc];
    
    NSFetchRequest *allPeopleRequest = [[NSFetchRequest alloc] init];
    [allPeopleRequest setEntity:personEntity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"TimeID = %@",da.currentSession];
    [allPeopleRequest setPredicate:pred];
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    people = [moc executeFetchRequest:allPeopleRequest error:errorFetchingPeople];
    
    localCount.text = [NSString stringWithFormat:@"%d",[people count]];
    
    //Using this
    
    /*
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
    [request setEntity:entity];
    
    // Specify that the request should return dictionaries.
    [request setResultType:NSDictionaryResultType];
    
    // Create an expression for the key path.
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"firstName"];
    
    // Create an expression to represent the minimum value at the key path 'creationDate'
    NSExpression *countExpression = [NSExpression expressionForFunction:@"count:" arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    // Create an expression description using the minExpression and returning a date.
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    // The name is the key that will be used in the dictionary for the return value.
    [expressionDescription setName:@"recordCount"];
    [expressionDescription setExpression:countExpression];
    [expressionDescription setExpressionResultType:NSInteger16AttributeType];
    
    // Set the request's properties to fetch just the property represented by the expressions.
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    // Execute the fetch.
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        // Handle the error.
    }
    else 
    {
        if ([objects count] > 0) {
            NSLog(@"Record Count: %@", [[objects objectAtIndex:0] valueForKey:@"recordCount"]);
        }
    }
                  
    [expressionDescription release];
    [request release];
     
     //*/
}

-(void)didSelectRow:(NSNumber*)rowID
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]hideSyncStatus];

    if(rawDataSet != nil)
    {
        NSLog(@"selected row: %d",rowID);
        selectedRow = rowID;
        da.currentSession = [[rawDataSet objectForKey:@"eventIDs"]objectAtIndex:rowID];
        
       
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:da.currentSession forKey:@"kiosk_currentSession"];
                
                
                [defaults setObject:[[rawDataSet objectForKey:@"names"]objectAtIndex:rowID] forKey:@"kiosk_currentSessionName"];
        
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.rootVC setEventNameText:[[rawDataSet objectForKey:@"names"]objectAtIndex:rowID]];
        
        NSLog(@"currentSessions: %@",[rawDataSet objectForKey:@"eventIDs"]);
        NSLog(@"currentSession: %@",da.currentSession);
        //serverCount.text = [[rawDataSet objectForKey:@"eventCounts"]objectAtIndex:selectedRow];
        [self _updateDisplay];
    }
}

-(void)reloadGrid
{
    NSLog(@"reloadGrid");
    rawDataSet = [[NSDictionary alloc] initWithDictionary:[da allSessions]]; //initWithDictionary:[da allSessions]];
    
    GSOrderedDictionary *dataCollection = [[GSOrderedDictionary alloc] init];
    [dataCollection setObject:[rawDataSet objectForKey:@"names"] forKey:@"Event Name"];
    [dataCollection setObject:[rawDataSet objectForKey:@"sessionNames"] forKey:@"Session Name"];
    [dataCollection setObject:[rawDataSet objectForKey:@"markets"] forKey:@"Market"];
    [dataCollection setObject:[rawDataSet objectForKey:@"dates"] forKey:@"Session Date"];
    [dataCollection setObject:[rawDataSet objectForKey:@"times"] forKey:@"Time"];
    
    
    [gridController setDataCollection:dataCollection];
    [gridController loadHeader];
    [[gridController theTableView] reloadData];
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    version.text = [NSString stringWithFormat:@"Version: %@",CURRENTVERSION];
    webAddress.text = [[appDelegate web] WS_URL];

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
    if(da.currentSession != nil){
        if([[rawDataSet objectForKey:@"eventCounts"]count]>0)
        {
            serverCount.text = [NSString stringWithFormat:@"%d",[[[rawDataSet objectForKey:@"eventCounts"]objectAtIndex:selectedRow]integerValue]];
        }
    }else{
        serverCount.text = @"N/A";
    }
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    version.text = [NSString stringWithFormat:@"Version: %@",CURRENTVERSION];
    webAddress.text = [[appDelegate web] WS_URL];
    [self fetchRecordCount];
    [self reloadGrid];
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

- (IBAction)changeWebAddress
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[appDelegate da] setWebAddress:webAddress.text];
} 

- (IBAction)resetWebAddress
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *ws_url;
    ws_url = WS_PROD;
    //DEV
	if(RELEASE == 0) ws_url = WS_DEV;
    //STAGING
    if(RELEASE == 1) ws_url = WS_STG;
    //PRODUCTION
    if(RELEASE == 2) ws_url = WS_PROD;
    
    [[appDelegate da] setWebAddress:ws_url];
    webAddress.text = [[appDelegate web] WS_URL];
} 

-(IBAction)syncPush
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]hideSyncStatus];
    
    [appDelegate.rootVC performSelectorOnMainThread:@selector(lockScreenPush:) withObject:self waitUntilDone:YES];
}

-(IBAction)syncPull
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]hideSyncStatus];
    
    [appDelegate.rootVC performSelectorOnMainThread:@selector(lockScreenPull:) withObject:self waitUntilDone:YES];
}

-(IBAction)testsync
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]hideSyncStatus];
    [appDelegate.rootVC performSelectorOnMainThread:@selector(lockScreenTest:) withObject:self waitUntilDone:YES];
}

-(void)_syncPush
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    AuthorizedConnector *auth = [appDelegate web];
    [auth dumpRegistrationsToServer];
    //[auth performSelectorInBackground:@selector(dumpRegistrationsToServer) withObject:nil];
    //[self fetchRecordCount];
    //[self reloadGrid];
    
    [pool release];
}

-(void)_syncPull
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    AuthorizedConnector *auth = [appDelegate web];
    
    [auth performSelectorInBackground:@selector(getEventTimes) withObject:nil];
    
    //[self fetchRecordCount];
    //[self reloadGrid];
    
    [pool release];
}

-(void)_syncTest
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [da createTestAuthors];
        
    [self fetchRecordCount];
    [self reloadGrid];
    
    [pool release];
}

-(IBAction)changeMode:(id)sender
{
    //NSLog(@"");
    
    [da changeMode:[NSNumber numberWithInt:(2-modeControl.selectedSegmentIndex)]];
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    TabbedViewController *tabbed = [[[[appDelegate rootVC]navController]viewControllers]objectAtIndex:0];
    //[tabbed _updateView];//
}

-(IBAction)changeDiagnosticMode:(id)sender
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]hideSyncStatus];
    AuthorizedConnector *auth = [appDelegate web];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([(UISegmentedControl*)sender selectedSegmentIndex] == 0){
        [defaults setObject:@"Y" forKey:@"kiosk_diagnostic"];
        auth.diagnosticMode = YES;
    }else{
        [defaults setObject:@"N" forKey:@"kiosk_diagnostic"];
        auth.diagnosticMode = NO;
    }
}

-(IBAction)selectEvent
{
    
}

- (void)loadNextView
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rootVC showSettings];
    [[appDelegate rootVC]hideErrorMessage];
    [[appDelegate rootVC]hideSyncStatus];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[[self.navigationController viewControllers]objectAtIndex:0]_layoutPage];
    modeControl.selectedSegmentIndex = [[da getMode]integerValue];
}

-(IBAction)clickedSave
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    if(da.currentSession != nil)
    {
        [[appDelegate rootVC]hideErrorMessage];
        
        [da changeMode:[NSNumber numberWithInt:modeControl.selectedSegmentIndex]];
        
        //TabbedViewController *tabbed = [[[[appDelegate rootVC]navController]viewControllers]objectAtIndex:0];
        //[tabbed _updateView];
        
        [self loadNextView];
        //[[appDelegate rootVC] switchButtons];
    }else{
        [[appDelegate rootVC]showErrorMessage:@"Please Select a Session"];
        [[appDelegate rootVC]hideSyncStatus];
    }
}

-(IBAction)clickedCancel
{
    [self loadNextView];
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[[appDelegate rootVC] switchButtons];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

@end

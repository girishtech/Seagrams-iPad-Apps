//
//  EventAttendeeListViewController.m
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/22/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import "EventAttendeeListViewController.h"

#import "AttendeeDetailViewController.h"
#import "DataAccess.h"
#import "ForceMultiplierConciergeAppDelegate.h"

@implementation EventAttendeeListViewController

@synthesize gridController, firstName, lastName, email, filterButton, addAttendeeButton;

@synthesize attendeeSelectBtn, eventAttendeeDetailViewCnt,da,sortedDataSet,rawDataSet,DataSet,filterBtns,eventTimeAuthorOptions,authorOptions,selectedRow;

@synthesize invitedLbl,RSVPLbl,cancelledLbl,attendedLbl,guestLbl;

//added to test the table views
@synthesize tempData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate setCurrentVC:self];
        da = [appDelegate da];
        rawDataSet = [[GSOrderedDictionary alloc]init];
        eventTimeAuthorOptions = [[NSMutableArray alloc] initWithCapacity:0];
        //[eventTimeAuthorOptions addObject:@"(Attended == 1)"];
        authorOptions = [[NSMutableArray alloc] initWithCapacity:0];
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
    [gridController setDelegate:self];
    
    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y - 20.0f;
    self.view.frame = frame;
    
    [self hideMessage];
   
    // Do any additional setup after loading the view from its nib.
    // Custom initialization
    
    [self buildCheckBoxes];
    
    
    [self updateDisplay];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[[self gridController] theTableView] reloadData];
}

-(void)hideMessage
{
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC] hideErrorMessage];
    [[appDelegate rootVC] hideSyncStatus];
}

-(void)updateDisplay
{
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[appDelegate.rootVC lockScreen];
    id rootVC = appDelegate.rootVC;
    [rootVC performSelectorOnMainThread:@selector(lockScreen) withObject:nil waitUntilDone:YES];
    
    [self performSelector:@selector(buildDataSet) withObject:nil afterDelay:0.25];
    
    
    //[[[self gridController] theTableView] reloadData];
}

-(void)buildCheckBoxes
{
    int idx = 1;
    CGRect frame;
    
    filterBtns = [[NSMutableArray alloc] initWithCapacity:0];
    
    for(UILabel *label in [NSArray arrayWithObjects:invitedLbl,RSVPLbl,cancelledLbl,attendedLbl,guestLbl, nil])
    {
        frame = label.frame;
        frame.origin.y = label.frame.origin.y + 25;
        UIButton *filterBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 25.0f, 25.0f)];
        [filterBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateSelected];
        [filterBtn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateHighlighted];
        [filterBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateNormal];
        [filterBtn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateDisabled];
        //filterBtn.hidden = YES;
        //if(idx == 4 || idx == 5) filterBtn.hidden = NO;
        filterBtn.selected = NO;
        [filterBtn addTarget:self 
                      action:@selector(selectedFilter:) 
            forControlEvents:UIControlEventTouchUpInside];
        
        [filterBtns addObject:filterBtn];
        
        [self.view addSubview:filterBtn];
        
        [filterBtn release];
        
        idx++;
    }
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

-(void)didSelectRow:(NSNumber*)rowID
{
    [self hideMessage];
    if(rawDataSet != nil)
    {
        NSLog(@"selected row: %d",rowID);
       // selectedRow = rowID;
        /*da.currentTimeID = [[rawDataSet objectForKey:@"eventIDs"]objectAtIndex:rowID];
        NSLog(@"currentTimeIDs: %@",[rawDataSet objectForKey:@"eventIDs"]);
        NSLog(@"currentTimeID: %@",da.currentTimeID);
         */
        //serverCount.text = [[rawDataSet objectForKey:@"eventCounts"]objectAtIndex:selectedRow];
        [self _updateDisplay];
    }
}

-(void)buildDataSet
{
    DataSet = [[da allAuthorsForCurrentTime:eventTimeAuthorOptions AuthorOptions:authorOptions] retain]; //initWithDictionary:[da allSessions]];
    sortedDataSet = [[GSOrderedDictionary alloc] init];
    
   // NSLog(@"rawDataSet = %@", DataSet);
    
    NSMutableArray *attendedBtns = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *optInBtns = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *guestBtns = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *regCountBtns = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *DOBBtns = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    for(int i=0;i<[[DataSet objectForKey:@"AuthorID"]count];i++){
        //NSLog(@"[[DataSet objectForKey:\"Attended\"]objectAtIndex:i] = %@",[DataSet objectForKey:@"Attended"]);
        
        
        [attendedBtns addObject:[self buildCheckBox:[[[DataSet objectForKey:@"Attended"]objectAtIndex:i]boolValue] forColumn:@"Attended" Row:[NSNumber numberWithInt:i]]];
        
        
        
        
        [optInBtns addObject:[self buildCheckBox:[[[DataSet objectForKey:@"optIn"]objectAtIndex:i]boolValue] forColumn:@"Opt_In" Row:[NSNumber numberWithInt:i]]];
        
        // commented girish
 //       [guestBtns addObject:[self buildGuestButton:[[DataSet objectForKey:@"Guests"]objectAtIndex:i] forRow:[NSNumber numberWithInt:i]]];
        // end
        
        int regCount = [[[DataSet objectForKey:@"RegistrationCount"]objectAtIndex:i]integerValue];
        if(regCount > 0){
            if([[[DataSet objectForKey:@"Attended"]objectAtIndex:i]boolValue] == YES){
                regCount = regCount - 1;
            }
        }
        
        [regCountBtns addObject:[self buildRegCountButton:[NSString stringWithFormat:@"%d",regCount] forRow:[NSNumber numberWithInt:i]]];//*/
        [DOBBtns addObject:[self buildDOBButton:[[DataSet objectForKey:@"AuthorDOB"]objectAtIndex:i] forRow:[NSNumber numberWithInt:i]]];
    }
    
    [sortedDataSet setObject:[DataSet objectForKey:@"AuthorLastName"] forKey:@"Last"];
    [sortedDataSet setObject:[DataSet objectForKey:@"AuthorFirstName"] forKey:@"First"];
    [sortedDataSet setObject:[DataSet objectForKey:@"AuthorEmail"] forKey:@"Email"];
    [sortedDataSet setObject:DOBBtns forKey:@"DOB"];
    
    // commented girish
    /*
    [sortedDataSet setObject:guestBtns forKey:@"Guests"];
    */
    // end
    [sortedDataSet setObject:attendedBtns forKey:@"Attended"];
    
    
    
    [sortedDataSet setObject:optInBtns forKey:@"Opt In"];
    //[sortedDataSet setObject:regCountBtns forKey:@"Events Attended"];
    
    [attendedBtns release];
    [optInBtns release];
    [self performSelector:@selector(reloadGrid) withObject:nil afterDelay:0.25];
}

-(UIButton*)buildCheckBox:(BOOL)selected forColumn:(NSString*)column Row:(NSNumber*)row
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [btn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateDisabled];
    [btn setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateReserved];
    if(selected){
        btn.selected = YES;
    }else{
        btn.selected = NO;
    }
    btn.tag = [row integerValue];
    if([column isEqualToString:@"Attended"]){
        [btn addTarget:self 
                action:@selector(selectedAttended:) 
      forControlEvents:UIControlEventTouchUpInside]; 
    }else{
        [btn addTarget:self 
                action:@selector(selectedOptIn:) 
      forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

-(UIButton*)buildGuestButton:(NSString*)number forRow:(NSNumber*)row
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [btn setTitle:number forState:UIControlStateNormal];
    [btn setTitle:number forState:UIControlStateHighlighted];
    [btn setTitle:number forState:UIControlStateSelected];
    [btn setTitle:number forState:UIControlStateDisabled];
    [btn setTitle:number forState:UIControlStateReserved];
    
    
    btn.tag = [row integerValue];
    
    
    if(![number isEqualToString:@"0"]){
        [btn addTarget:self 
                action:@selector(selectedGuests:) 
      forControlEvents:UIControlEventTouchUpInside]; 
    }
    
    return btn;
}

-(UIButton*)buildRegCountButton:(NSString*)number forRow:(NSNumber*)row
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [btn setTitle:number forState:UIControlStateNormal];
    [btn setTitle:number forState:UIControlStateHighlighted];
    [btn setTitle:number forState:UIControlStateSelected];
    [btn setTitle:number forState:UIControlStateDisabled];
    [btn setTitle:number forState:UIControlStateReserved];
    
    
    btn.tag = [row integerValue];
    
    if([number isEqualToString:@"1"]){
        [btn addTarget:self 
                action:@selector(selectedRegCount:) 
      forControlEvents:UIControlEventTouchUpInside]; 
    }
    
    
    return btn;
}

-(UIButton*)buildDOBButton:(NSString*)dob forRow:(NSNumber*)row
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [btn setTitle:dob forState:UIControlStateNormal];
    [btn setTitle:dob forState:UIControlStateHighlighted];
    [btn setTitle:dob forState:UIControlStateSelected];
    [btn setTitle:dob forState:UIControlStateDisabled];
    [btn setTitle:dob forState:UIControlStateReserved];
    
    
    btn.tag = [row integerValue];
    
    if([dob isEqualToString:@""]){
        [btn setTitle:@"No DOB" forState:UIControlStateNormal];
        [btn setTitle:@"No DOB" forState:UIControlStateHighlighted];
        [btn setTitle:@"No DOB" forState:UIControlStateSelected];
        [btn setTitle:@"No DOB" forState:UIControlStateDisabled];
        [btn setTitle:@"No DOB" forState:UIControlStateReserved];
        [btn addTarget:self 
                action:@selector(selectedDOB:) 
      forControlEvents:UIControlEventTouchUpInside]; 
    }else{
        [btn setTitle:dob forState:UIControlStateNormal];
        [btn setTitle:dob forState:UIControlStateHighlighted];
        [btn setTitle:dob forState:UIControlStateSelected];
        [btn setTitle:dob forState:UIControlStateDisabled];
        [btn setTitle:dob forState:UIControlStateReserved];
        [btn addTarget:self 
                action:@selector(selectedDOB:) 
      forControlEvents:UIControlEventTouchUpInside]; 
    }
    
    
    return btn;
}

-(void)reloadGrid
{
    NSLog(@"reloadGrid");
   // NSLog(@"sortedDataSet: %@", sortedDataSet.dict);
    [gridController setAllowsSelection:NO];
    [gridController setDataCollection:sortedDataSet];
    [gridController loadHeader];
    [[gridController theTableView] reloadData];
    /*
    if(selectedRow){
        [[gridController theTableView] selectRowAtIndexPath:[NSIndexPath indexPathWithIndex:selectedRow] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
     */
    //ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[appDelegate.rootVC lockScreen];
    //id rootVC = appDelegate.rootVC;
    [self performSelector:@selector(unlockScreen) withObject:nil afterDelay:0.25];    
}

-(void)_updateDisplay
{
    [self updateDisplay];
}

-(void)unlockScreen{
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[appDelegate.rootVC lockScreen];
    id rootVC = appDelegate.rootVC;
    [rootVC performSelectorOnMainThread:@selector(unlockScreen) withObject:nil waitUntilDone:YES];
    [rootVC performSelectorOnMainThread:@selector(updateChangeCount) withObject:nil waitUntilDone:YES];

}
     
-(void)updateOptInForRow:(NSNumber*)row withValue:(BOOL)val
{
    [[DataSet objectForKey:@"Opt_In"] replaceObjectAtIndex:row withObject:[NSNumber numberWithBool:val]];
    //TODO fill in here
    [da updateOptInForAuthorID:[[DataSet objectForKey:@"AuthorID"] objectAtIndex:[row integerValue]] withValue:val];
}

-(void)updateAttendedForRow:(NSNumber*)row withValue:(BOOL)val
{
    [[DataSet objectForKey:@"Attended"] replaceObjectAtIndex:[row integerValue] withObject:[NSNumber numberWithBool:val]];
    [da updateAttendedForAuthorID:[[DataSet objectForKey:@"AuthorID"] objectAtIndex:[row integerValue]] withValue:val];
}

-(IBAction)selectedGuests:(id)sender
{
    [self hideMessage];
    UIButton *btn = (UIButton*)sender;
    
    EventGuestListViewController *guestVC = 
    [[EventGuestListViewController alloc] initWithNibName:@"EventGuestListViewController_Landscape" 
                                                   bundle:nil 
                                          forTimeAuthorID:[[DataSet objectForKey:@"TimeAuthorID"] 
                                                           objectAtIndex:[[NSNumber numberWithInt:btn.tag] integerValue]]
                                           withAuthorName:[NSString stringWithFormat:@"%@ %@",[[DataSet objectForKey:@"AuthorFirstName"] 
                                                                                               objectAtIndex:[[NSNumber numberWithInt:btn.tag] integerValue]],
                                                           [[DataSet objectForKey:@"AuthorLastName"] 
                                                            objectAtIndex:[[NSNumber numberWithInt:btn.tag] integerValue]]]];
    
    [self.navigationController pushViewController:guestVC animated:YES];
    //[self updateOptInForRow:[NSNumber numberWithInt:btn.tag] withValue:btn.selected];
}

-(IBAction)selectedRegCount:(id)sender
{
    [self hideMessage];
    UIButton *btn = (UIButton*)sender;
    
    QuestionListViewController *questionListVC = 
    [[QuestionListViewController alloc] initWithNibName:@"QuestionListViewController" bundle:nil]; 
    /*  forTimeAuthorID:[[DataSet objectForKey:@"TimeAuthorID"] 
     objectAtIndex:[[NSNumber numberWithInt:btn.tag] integerValue]]
     withAuthorName:[NSString stringWithFormat:@"%@ %@",[[DataSet objectForKey:@"AuthorFirstName"] 
     objectAtIndex:[[NSNumber numberWithInt:btn.tag] integerValue]],
     [[DataSet objectForKey:@"AuthorLastName"] 
     objectAtIndex:[[NSNumber numberWithInt:btn.tag] integerValue]]]];
     */
    da.currentAuthorID = [[DataSet objectForKey:@"AuthorID"] objectAtIndex:btn.tag];
    [self.navigationController pushViewController:questionListVC animated:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    //[self updateOptInForRow:[NSNumber numberWithInt:btn.tag] withValue:btn.selec]ted];
    [questionListVC.view setNeedsLayout];
    [questionListVC.view setNeedsDisplay];
}

-(IBAction)selectedDOB:(id)sender
{
    [self hideMessage];
    UIButton *btn = (UIButton*)sender;
    /*
    QuestionListViewController *questionListVC = 
    [[QuestionListViewController alloc] initWithNibName:@"QuestionListViewController" bundle:nil]; 
    /*  forTimeAuthorID:[[DataSet objectForKey:@"TimeAuthorID"] 
     objectAtIndex:[[NSNumber numberWithInt:btn.tag] integerValue]]
     withAuthorName:[NSString stringWithFormat:@"%@ %@",[[DataSet objectForKey:@"AuthorFirstName"] 
     objectAtIndex:[[NSNumber numberWithInt:btn.tag] integerValue]],
     [[DataSet objectForKey:@"AuthorLastName"] 
     objectAtIndex:[[NSNumber numberWithInt:btn.tag] integerValue]]]];
     */
    self.selectedRow = [[NSNumber numberWithInt:btn.tag] integerValue];
    da.currentAuthorID = [[DataSet objectForKey:@"AuthorID"] objectAtIndex:btn.tag];
    
    datePickerView = [[TDDatePickerController alloc]
                                              initWithNibName:@"TDDatePickerController"
                                              bundle:nil];
    datePickerView.delegate = self;

    //[datePicker setMinimumDate:minDate];
    
    //[self.navigationController pushViewController:questionListVC animated:YES];
    //[self.navigationController.tabBarController.tabBar setHidden:YES];
        [self presentSemiModalViewController:datePickerView];
    
    NSString *dateString = btn.titleLabel.text;
    
    if(![dateString isEqualToString:@"No DOB"]){
        NSDate *dob = [self parseDateString:dateString];
        [datePickerView.datePicker setDate:dob animated:YES];
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-21];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [comps release];
    [calendar release];
    
    [datePickerView.datePicker setMaximumDate:maxDate];
    //[self updateOptInForRow:[NSNumber numberWithInt:btn.tag] withValue:btn.selec]ted];
}

-(NSDate*) parseDateString:(NSString*)aDateString{
    //if([aDateString length] > 18) aDateString = [aDateString substringToIndex:18];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *newDate = [outputFormatter dateFromString:aDateString];
    [outputFormatter release];
    
    return newDate;
    // For US English, the output is:
    // newDateString 10:30 on Sunday July 11
}

-(IBAction)selectedOptIn:(id)sender
{
    [self hideMessage];
    UIButton *btn = (UIButton*)sender;
    if(btn.selected)
    {
        btn.selected = NO;
    }
    else
    {
        btn.selected = YES;
    }
    
    [self updateOptInForRow:[NSNumber numberWithInt:btn.tag] withValue:btn.selected];
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[appDelegate.rootVC lockScreen];
    id rootVC = appDelegate.rootVC;
    [rootVC performSelectorOnMainThread:@selector(updateChangeCount) withObject:nil waitUntilDone:YES];
}

-(IBAction)selectedAttended:(id)sender
{
    [self hideMessage];
    UIButton *btn = (UIButton*)sender;
    if(btn.selected)
    {
        btn.selected = NO;
    }
    else
    {
        btn.selected = YES;
    }
    [self updateAttendedForRow:[NSNumber numberWithInt:btn.tag] withValue:btn.selected];
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[appDelegate.rootVC lockScreen];
    id rootVC = appDelegate.rootVC;
    [rootVC performSelectorOnMainThread:@selector(lockScreen) withObject:nil waitUntilDone:YES];
    
    [self performSelector:@selector(updateDisplay) withObject:nil afterDelay:0.25];
    
    [rootVC performSelectorOnMainThread:@selector(updateChangeCount) withObject:nil waitUntilDone:YES];
    
}

-(IBAction)filter:(id)sender
{
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[appDelegate.rootVC lockScreen];
    id rootVC = appDelegate.rootVC;
    [rootVC performSelectorOnMainThread:@selector(lockScreen) withObject:nil waitUntilDone:YES];
    
    [self hideMessage];
    [self performSelector:@selector(_filter) withObject:nil afterDelay:0.25];
}

-(IBAction)clearFilters:(id)sender
{
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[appDelegate.rootVC lockScreen];
    id rootVC = appDelegate.rootVC;
    [rootVC performSelectorOnMainThread:@selector(lockScreen) withObject:nil waitUntilDone:YES];
    
    [self performSelector:@selector(_clearFilters) withObject:nil afterDelay:0.25];
}

-(void)_clearFilters
{
    [self hideMessage];
    
     for(UIButton *btn in filterBtns){
         btn.selected = NO;
     }
     
    firstName.text = @"";
    lastName.text = @"";
    email.text = @"";
    
    
    [self _filter];
}

-(void)_filter
{
    authorOptions = [[NSMutableArray alloc] initWithCapacity:0];
    eventTimeAuthorOptions = [[NSMutableArray alloc] initWithCapacity:0];
    
    // not implemented
    NSLog(@"EventAttendeeListViewController - filter not implemented.");
    //*
    if([[filterBtns objectAtIndex:0] isSelected] )
    {
        [eventTimeAuthorOptions addObject:@"(Invited == 1)"];
    }
    if([[filterBtns objectAtIndex:1] isSelected])
    {
        [eventTimeAuthorOptions addObject:@"(isAttending == 1)"];
    }
    if([[filterBtns objectAtIndex:3] isSelected])
    {
        [eventTimeAuthorOptions addObject:@"(Attended == 0)"];
    }/*
    if([[filterBtns objectAtIndex:4] isSelected])
    {
        [eventTimeAuthorOptions addObject:@"(Attended == 1)"];
    }*/
    if([[filterBtns objectAtIndex:4] isSelected])
    {
        [eventTimeAuthorOptions addObject:[NSString stringWithFormat:@"((ParentTimeAuthorID != \"%@\") AND (ParentTimeAuthorID != \"%@\"))",nil,@""]];
    }
     //*/
    
    if(![firstName.text isEqualToString:@""])
    {
        [authorOptions addObject:[NSString stringWithFormat:@"(AuthorFirstName CONTAINS[cd] \"%@\")",firstName.text]];
    }
    
    if(![lastName.text isEqualToString:@""])
    {
        [authorOptions addObject:[NSString stringWithFormat:@"(AuthorLastName CONTAINS[cd] \"%@\")",lastName.text]];
    }
    
    if(![email.text isEqualToString:@""])
    {
        [authorOptions addObject:[NSString stringWithFormat:@"(AuthorEmail CONTAINS[cd] \"%@\")",email.text]];
    }
    
    [self updateDisplay];
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[appDelegate.rootVC lockScreen];
    id rootVC = appDelegate.rootVC;
    [rootVC performSelectorOnMainThread:@selector(updateChangeCount) withObject:nil waitUntilDone:YES];
}

-(IBAction)showHideAttendees
{
    authorOptions = [[NSMutableArray alloc] initWithCapacity:0];
    eventTimeAuthorOptions = [[NSMutableArray alloc] initWithCapacity:0];
    
    if(![firstName.text isEqualToString:@""])
    {
        [authorOptions addObject:[NSString stringWithFormat:@"(AuthorFirstName CONTAINS[cd] \"%@\")",firstName.text]];
    }
    
    if(![lastName.text isEqualToString:@""])
    {
        [authorOptions addObject:[NSString stringWithFormat:@"(AuthorLastName CONTAINS[cd] \"%@\")",lastName.text]];
    }
    
    if(![email.text isEqualToString:@""])
    {
        [authorOptions addObject:[NSString stringWithFormat:@"(AuthorEmail CONTAINS[cd] \"%@\")",email.text]];
    }
    /*
    if(showAttended){
        showAttended = NO;
        [eventTimeAuthorOptions addObject:@"(Attended == 1)"];
    }else{
        showAttended = YES;
        [eventTimeAuthorOptions addObject:@"(Attended == 0)"];
    }
     */
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[appDelegate.rootVC lockScreen];
    id rootVC = appDelegate.rootVC;
    [rootVC performSelectorOnMainThread:@selector(lockScreen) withObject:nil waitUntilDone:YES];
    
    [self performSelector:@selector(updateDisplay) withObject:nil afterDelay:0.25];
}

- (IBAction)addAttendee:(id)sender
{
    // not implemented
    NSLog(@"EventAttendeeListViewController - addAttendee not implemented.");
}

-(IBAction)selectedFilter:(id)sender
{
    [self hideMessage];
    NSLog(@"selectedFilter");
    UIButton *btn = (UIButton*)sender;
    
   
    if(btn == [filterBtns objectAtIndex:0])
    {
        [[filterBtns objectAtIndex:0] setSelected:YES];
    }
    else if(btn == [filterBtns objectAtIndex:1])
    {
        [[filterBtns objectAtIndex:1] setSelected:YES];
    }
    else if(btn == [filterBtns objectAtIndex:2])
    {
        [[filterBtns objectAtIndex:2] setSelected:YES];
    }
    else
    if(btn == [filterBtns objectAtIndex:3])
    {
        [[filterBtns objectAtIndex:3] setSelected:YES];
        
    }
    else if(btn == [filterBtns objectAtIndex:4])
    {
        [[filterBtns objectAtIndex:4] setSelected:YES];
        
    }/*
    else if(btn == [filterBtns objectAtIndex:4])
    {
        [[filterBtns objectAtIndex:4] setSelected:YES];
    }
      */  
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

-(void)datePickerSetDate:(TDDatePickerController*)viewController{
    NSLog(@"datePickerSetDate:");
    [da updateDOBForCurrentAuthor:viewController.datePicker.date];
    [self dismissSemiModalViewController:viewController];
    [self updateDisplay];
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    //[appDelegate.rootVC lockScreen];
    id rootVC = appDelegate.rootVC;
    [rootVC performSelectorOnMainThread:@selector(updateChangeCount) withObject:nil waitUntilDone:YES];
}

-(void)datePickerClearDate:(TDDatePickerController*)viewController{
    [self dismissSemiModalViewController:viewController];
}

-(void)datePickerCancel:(TDDatePickerController*)viewController{
    [self dismissSemiModalViewController:viewController];
}

@end

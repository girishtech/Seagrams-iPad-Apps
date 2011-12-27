//
//  TableViewGridController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/27/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "TableViewGridController.h"


@implementation TableViewGridController

@synthesize dataCollection;
@synthesize theTableView;
@synthesize view;
@synthesize rowHeight;
@synthesize delegate;
@synthesize selectedRow;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        selectedRow = 100000;
    }
    return self;
}

- (id)initWithCollection:(GSOrderedDictionary*)aCollection
{
    NSLog(@"- (id)initWithCollection:(NSDictionary*)aCollection");
    self = [super init];
    if (self) {
        // Custom initialization
        self.theTableView.delegate = self;
        self.theTableView.dataSource = self;
        dataCollection = [aCollection retain];
        selectedRow = 100000;
        //self.rowHeight = 22;
    }
    return self;
}

- (id)initWithCollection:(GSOrderedDictionary*)aCollection rowHeight:(NSNumber*)height
{
    NSLog(@"- (id)initWithCollection:(NSDictionary*)aCollection");
    self = [super init];
    if (self) {
        // Custom initialization
        self.theTableView.delegate = self;
        self.theTableView.dataSource = self;
        dataCollection = [aCollection retain];
        selectedRow = 100000;
        //self.rowHeight = height;
        
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

-(void)setAllowsSelection:(BOOL)allow
{
    theTableView.allowsSelection = allow;
}

- (void)loadHeader
{
    NSString *columnName;
    UIView *aView;
    
    //if(self.rowHeight==nil)self.rowHeight=22;
    
    CGFloat tableWidth = self.theTableView.frame.size.width;
    CGFloat tableRowHeight = 22.0f;
    CGFloat labelSpread = (tableWidth / [(id)[dataCollection count]floatValue]);
    CGFloat labelWidth = labelSpread-10.0f;
    CGFloat xOffset = 0.0f;
    int idx = 1;
    
    NSLog(@"tableWidth = %f \n tableRowHeight = %f \n columnCount = %d \n labelSpread = %f \n labelWidth = %f \n xOffset = %f",tableWidth,tableRowHeight,[[dataCollection count]integerValue],labelSpread,labelWidth, xOffset);
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(1.0, 1.0,tableWidth, tableRowHeight)];
    [header setBackgroundColor:[UIColor eventsTableHeader_BackgroundColor]];
    
    
    int count = [[dataCollection count]integerValue];
    NSLog(@"dataCollection count: %d",count);
    for(int i=0;i<count;i++){//columnName in dataCollection){
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(xOffset+10.0, 0.0, labelWidth,tableRowHeight)] autorelease];
        UIColor *fontColor = [UIColor eventsTableHeader_FontColor]; 
        
        label.tag = i;
        label.font = [UIFont systemFontOfSize:12.0];
        label.opaque = NO;
        label.text = [NSString stringWithFormat:@"%@", [dataCollection keyForIndex:i]];
        label.textAlignment = UITextAlignmentLeft;
        label.backgroundColor = [UIColor eventsTableHeader_LabelBackgroundColor];
        label.textColor = fontColor;
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [header addSubview:label]; 
        
        if(i != 0)
        {
            aView = [[UIView alloc] initWithFrame:CGRectMake(xOffset, 0.0, 1.0, tableRowHeight)];
            [aView setBackgroundColor:[UIColor eventsTableHeader_LabelBackgroundColor]];
            [header addSubview:aView];
        }
        
        xOffset = xOffset + labelSpread;
        idx++;
    }
    
    aView = [[UIView alloc] initWithFrame:CGRectMake(0.0, tableRowHeight, tableWidth, 1.0)];
    [aView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [header addSubview:aView];
    
    //[gridHeader drawRect:gridHeader.view.frame];
    [self.view addSubview:header];
    [header setNeedsDisplay];
    [header setNeedsLayout];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"TableViewGridController - viewDidLoad");
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    //NSLog(@"dataCollection: %@",dataCollection);
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView");
    
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section");
    //NSLog(@"IN TABLEVIEW dataCollection: %@",dataCollection.dict);
    
    // Return the number of sections.
    NSString *columnName;
    int rowCount = 0;
    //for(columnName in dataCollection){
    rowCount = [[dataCollection objectAtIndex:0] count];
    /*    break;
     }//*/
    NSLog(@"rowCount: %d",rowCount);
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath");
    
    NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %i", indexPath.row];
    
    //MyTableCell *cell = (MyTableCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    UITableViewCell *cell;// = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    
    //if (cell == nil) {
    //cell = [[[MyTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
    //if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
    //}
    
    CGFloat tableWidth = self.theTableView.frame.size.width;
    CGFloat tableRowHeight = self.theTableView.rowHeight;
    CGFloat labelSpread = (tableWidth / [(id)[dataCollection count]floatValue]);
    CGFloat labelWidth = labelSpread-10.0f;
    
    UIView *aView;
    
    //Background color tint override
    UIColor *fontColor = [UIColor eventsTable_FontColor];
    if((indexPath.row)%2==0){
        //aView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableWidth, tableRowHeight)];
        //[aView setBackgroundColor:[UIColor colorWithRed:.619 green:0.227 blue:0.003 alpha:1.0]];
        [cell.contentView setBackgroundColor:[UIColor eventsTable_OddBackgroundColor]];
        //[cell.contentView addSubview:aView];
        fontColor = [UIColor eventsTable_OddFontColor]; 
    }
    [cell.selectedBackgroundView setBackgroundColor:[UIColor redColor]];
    //if(selectedRow != nil)
    //{
    if(indexPath.row == selectedRow){
        [cell.contentView setBackgroundColor:[UIColor eventsTable_SelectedBackgroundColor]];
        fontColor = [UIColor whiteColor]; 
        //if(self.delegate != nil)[self.delegate didSelectRow:indexPath.row];
    }
    //}
    
    NSString *columnName;
    double xOffset = 0.0;
    int count = [[dataCollection count]integerValue];
    NSLog(@"dataCollection count: %d",count);
    for(int i=0;i<count;i++){//columnName in dataCollection){
        if([[[dataCollection objectAtIndex:i] objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
            UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(xOffset+10.0, 0.0, labelWidth,tableRowHeight)] autorelease];
            
            label.font = [UIFont systemFontOfSize:12.0];
            label.text = [NSString stringWithFormat:@"%@", [[dataCollection objectAtIndex:i] objectAtIndex:indexPath.row]];
            NSLog(@"columnData: %@",[NSString stringWithFormat:@"%@", [[dataCollection objectAtIndex:i] objectAtIndex:indexPath.row]]);
            label.textAlignment = UITextAlignmentLeft;
            label.textColor = fontColor;
            label.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
            label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleHeight;
            [cell.contentView addSubview:label];
        }else if([[[dataCollection objectAtIndex:i] objectAtIndex:indexPath.row] isKindOfClass:[UIButton class]]){
            UIButton *button = [[dataCollection objectAtIndex:i] objectAtIndex:indexPath.row];
            button.frame = CGRectMake(xOffset+5.0, 0.0, labelWidth,tableRowHeight);
            button.tag = indexPath.row;
            button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleHeight;
            [cell.contentView addSubview:button];
        }else if([[[dataCollection objectAtIndex:i] objectAtIndex:indexPath.row] isKindOfClass:[UITextField class]]){
            UITextField *tf = [[dataCollection objectAtIndex:i] objectAtIndex:indexPath.row];
            CGRect frame = tf.frame;
            frame.origin.x = xOffset+5.0;
            frame.size.width = labelWidth;
            tf.frame = frame;
            [cell.contentView addSubview:tf];
        }
        
        
        if(i != 0)
        {
            UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(xOffset, 0.0, 1.0, tableRowHeight)];
            [aView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
            [cell.contentView addSubview:aView];
        }
        
        xOffset = xOffset + labelSpread;
    }
    //}
    [self loadHeader];
    
    //[pool release];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableView:(UITableView *)tableView didSelectRowAtIndexPath:%d",indexPath.row);
    //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    self.selectedRow = indexPath.row;
    [[[tableView cellForRowAtIndexPath:indexPath] contentView] setBackgroundColor:[UIColor redColor]];
    if(self.delegate != nil)[self.delegate didSelectRow:indexPath.row];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end

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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)initWithCollection:(NSDictionary*)aCollection
{
    NSLog(@"- (id)initWithCollection:(NSDictionary*)aCollection");
    self = [super init];
    if (self) {
        // Custom initialization
        self.theTableView.delegate = self;
        self.theTableView.dataSource = self;
        dataCollection = [aCollection retain];//[[NSMutableDictionary alloc] initWithCapacity:0];
        //[dataCollection addEntriesFromDictionary:aCollection];
        [dataCollection retain];
        //[theTableView reloadData];
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

- (void)loadHeader
{
    NSString *columnName;
    UIView *aView;
    
    double tableWidth = self.theTableView.frame.size.width;
    double labelSpread = tableWidth / [dataCollection count];
    double labelWidth = labelSpread-10.0;
    double xOffset = 0.0;
    int idx = 1;
    
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(1.0, 1.0,tableWidth, 22.0)];
    [header setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    
    
    int count = [dataCollection count];
    NSLog(@"dataCollection count: %d",count);
    for(columnName in dataCollection){
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(xOffset+10.0, 0.0, labelWidth,22.0)] autorelease];
        UIColor *fontColor = [UIColor blueColor]; 
        
        //label.tag = i;
        label.font = [UIFont systemFontOfSize:12.0];
        label.opaque = NO;
        label.text = [NSString stringWithFormat:@"%@", columnName];
        label.textAlignment = UITextAlignmentLeft;
        label.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];;
        label.textColor = fontColor;
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [header addSubview:label]; 
        
        aView = [[UIView alloc] initWithFrame:CGRectMake(xOffset, 0.0, 1.0, 22.0)];
        [aView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
        [header addSubview:aView];
        
        xOffset = xOffset + labelSpread;
        idx++;
    }
    
    aView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 22.0, tableWidth, 1.0)];
    [aView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [header addSubview:aView];
    
    //[gridHeader drawRect:gridHeader.view.frame];
    [self.view addSubview:header];
    [header setNeedsDisplay];
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
	return YES;
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
     //NSLog(@"dataCollection: %@",dataCollection);
    
    // Return the number of sections.
    NSString *columnName;
    int rowCount = 0;
    for(columnName in dataCollection){
        rowCount = [[dataCollection objectForKey:columnName] count];
        break;
    }//*/
    NSLog(@"rowCount: %d",rowCount);
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath");
    
    NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %i", indexPath.row];
    
    MyTableCell *cell = (MyTableCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        cell = [[[MyTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
        
        double tableWidth = self.theTableView.frame.size.width;
        double tableRowHeight = tableView.rowHeight;
        double labelSpread = tableWidth / [dataCollection count];
        double labelWidth = labelSpread-10.0;
        UIView *aView;
        
        UIColor *fontColor = [UIColor blueColor];
        if((indexPath.row)%2==0){
            aView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableWidth, tableRowHeight)];
            [aView setBackgroundColor:[UIColor blueColor]];
            [cell.contentView addSubview:aView];
            fontColor = [UIColor whiteColor]; 
        }
        
        NSString *columnName;
        double xOffset = 0.0;
        int count = [dataCollection count];
        NSLog(@"dataCollection count: %d",count);
        for(columnName in dataCollection){
            if([[[dataCollection objectForKey:columnName] objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
                UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(xOffset+10.0, 0.0, labelWidth,tableRowHeight)] autorelease];
                
                label.font = [UIFont systemFontOfSize:12.0];
                label.text = [NSString stringWithFormat:@"%@", [[dataCollection objectForKey:columnName] objectAtIndex:indexPath.row]];
                NSLog(@"columnData: %@",[NSString stringWithFormat:@"%@", [[dataCollection objectForKey:columnName] objectAtIndex:indexPath.row]]);
                label.textAlignment = UITextAlignmentLeft;
                label.textColor = fontColor;
                label.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
                label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
                UIViewAutoresizingFlexibleHeight;
                [cell.contentView addSubview:label];
            }else if([[[dataCollection objectForKey:columnName] objectAtIndex:indexPath.row] isKindOfClass:[UIButton class]]){
                UIButton *button = [[dataCollection objectForKey:columnName] objectAtIndex:indexPath.row];
                button.frame = CGRectMake(xOffset+10.0, 0.0, labelWidth,tableRowHeight);
                button.tag = indexPath.row;
                button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
                UIViewAutoresizingFlexibleHeight;
                [cell.contentView addSubview:button];
            }
            
            UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(xOffset, 0.0, 1.0, tableRowHeight)];
            [aView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
            [cell.contentView addSubview:aView];
            
            xOffset = xOffset + labelSpread;
        }
    }
    
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

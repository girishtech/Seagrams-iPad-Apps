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
        selectedRow = (NSInteger*)100000;
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
        selectedRow = (NSInteger*)100000;
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
        selectedRow = (NSInteger*)100000;
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
    
    UIView *aView;
    
    //if(self.rowHeight==nil)self.rowHeight=22;
    
    double tableWidth = self.theTableView.frame.size.width;
    double tableRowHeight = 22.0;
    double labelSpread = tableWidth / [[NSNumber numberWithInt:[dataCollection count]]doubleValue];
    double labelWidth = labelSpread-10.0;
    double xOffset = 0.0;
    int idx = 1;
    
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(1.0, 1.0,tableWidth, tableRowHeight)];
    [header setBackgroundColor:[UIColor eventsTableHeader_BackgroundColor]];
    
    
    int count = [[NSNumber numberWithInt:[dataCollection count]]integerValue];
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
            [aView release];
        }
        
        xOffset = xOffset + labelSpread;
        idx++;
    }
    
    aView = [[UIView alloc] initWithFrame:CGRectMake(0.0, tableRowHeight, tableWidth, 1.0)];
    [aView setBackgroundColor:[UIColor blackColor]];
    [header addSubview:aView];
    [aView release];
    
    //[gridHeader drawRect:gridHeader.view.frame];
    [self.view addSubview:header];
    [header setNeedsDisplay];
    [header setNeedsLayout];
    
    [header release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"TableViewGridController - viewDidLoad");
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    NSLog(@"- (NSInteger*)numberOfSectionsInTableView:(UITableView *)tableView");
    // Return the number of sections.
    return (NSUInteger)1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"- (NSInteger*)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger*)section");
    //NSLog(@"IN TABLEVIEW dataCollection: %@",dataCollection.dict);
    
    // Return the number of sections.
    int rowCount = 0;
    rowCount = [[dataCollection objectAtIndex:0] count];
    NSLog(@"rowCount: %d",rowCount);

    return (NSInteger)rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath");
    
    NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %i", indexPath.row];
    
    MyTableCell *cell; //= (MyTableCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
   
    cell = [[[MyTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
    
    double tableWidth = self.theTableView.frame.size.width;
    double tableRowHeight = self.theTableView.rowHeight;
    double labelSpread = tableWidth / [[NSNumber numberWithInt:[dataCollection count]]doubleValue];
    double labelWidth = labelSpread-10.0;
  
    
    
    
    
    double xOffset = 0.0;
    int count = [[NSNumber numberWithInt:[dataCollection count]]integerValue];
    NSLog(@"dataCollection count: %d",count);
    for(int i=0;i<count;i++){//columnName in dataCollection){
        
        //Background color tint override
        UIColor *fontColor = [UIColor eventsTable_FontColor];
        UIColor *highlightColor = [UIColor whiteColor];
        
        if((indexPath.row)%2==0){
            
            [cell.contentView setBackgroundColor:[UIColor eventsTable_OddBackgroundColor]];
            
            fontColor = [UIColor eventsTable_OddFontColor];
            highlightColor = [UIColor colorWithRed:.87 green:0.36 blue:0.023 alpha:1.0];
        }
        
        [cell.selectedBackgroundView setBackgroundColor:[UIColor redColor]];
        
        if((NSInteger*)indexPath.row == selectedRow){
            [cell.contentView setBackgroundColor:[UIColor eventsTable_SelectedBackgroundColor]];
            fontColor = [UIColor whiteColor]; 
            highlightColor = [UIColor colorWithRed:.87 green:0.36 blue:0.023 alpha:1.0]; 
            //if(self.delegate != nil)[self.delegate didSelectRow:indexPath.row];
        }
        
        
        
        if([[dataCollection keyForIndex:i] isEqualToString:@"Events Attended"] || [[dataCollection keyForIndex:i] isEqualToString:@"Guests"] || [[dataCollection keyForIndex:i] isEqualToString:@"DOB"]){
            UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(xOffset, 0.0, labelWidth+10,tableRowHeight)];
            tmpView.backgroundColor = [UIColor grayColor];
            fontColor = [UIColor whiteColor];
            
            [cell.contentView addSubview:tmpView];
            [tmpView release];
        }
         
        
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
            
            [button setTitleColor:fontColor forState:UIControlStateNormal];
            [button setTitleColor:highlightColor forState:UIControlStateHighlighted];
            [button setTitleColor:fontColor forState:UIControlStateSelected];
            [button setTitleColor:fontColor forState:UIControlStateDisabled];
            [button setTitleColor:fontColor forState:UIControlStateReserved];
            
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
            [aView release];
        }
            
        xOffset = xOffset + labelSpread;
        
    }
    
    [self loadHeader];
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableView:(UITableView *)tableView didSelectRowAtIndexPath:%d",indexPath.row);
    
    self.selectedRow = (NSInteger*)indexPath.row;
    [[[tableView cellForRowAtIndexPath:indexPath] contentView] setBackgroundColor:[UIColor redColor]];
    
    if(self.delegate != nil)[self.delegate didSelectRow:[NSNumber numberWithInt:indexPath.row]];
}

@end

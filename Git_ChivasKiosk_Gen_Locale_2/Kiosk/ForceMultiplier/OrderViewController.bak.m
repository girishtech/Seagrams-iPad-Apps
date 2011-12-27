//
//  OrderViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 6/1/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "OrderViewController.h"


@implementation OrderViewController

@synthesize urlField; 
@synthesize webView; 
@synthesize spinner;

@synthesize google,priceDumper,windAndSpirits;

@synthesize productList, retailerList, theRetailerView, theProductView;

@synthesize first,last,street,city,state,zip;

-(IBAction)loadPage{
    theLinkViewContainer.hidden = YES;
	// start spinner in middle of page 
	[spinner startAnimating]; 
	// start spinner in status bar 
	[UIApplication 
	 sharedApplication].networkActivityIndicatorVisible = YES; 
	// create NSURL 
    
	NSURL *url = [[NSURL alloc] initWithString: urlField.text]; 
	// create NSURLRequest with NSURL 
	NSURLRequest *request = [[NSURLRequest alloc] 
							 initWithURL:url]; 
    
    
    
    //NSURL *url = [[NSURL alloc] initWithString: @"http://www.1-877-spirits.com/search.aspx"];
   // NSString *body = [NSString stringWithString: @"ctl00$ctl00$WucHeaderBottom1$txtSearch=Royal"];//, @"val1",@"val2"];
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    //[request setHTTPMethod: @"POST"];
    //[request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    //[webView loadRequest: request];
    
    
	// load request in webView 
	[webView loadRequest:request]; 
	// clean up 
	[request release]; 
	[url release]; 
	NSLog(@"loadPage");
	// hide keyboard
	[urlField resignFirstResponder];
}
-(IBAction)goBack{
	NSLog(@"Go Back");
	[webView goBack];
}
-(IBAction)goForward{
	NSLog(@"Go Forward");
	[webView goForward];
}
-(IBAction)loadRetailer:(id)sender{
	if(sender == google)
    {
        urlField.text = @"http://www.google.com/"; 
    }
    else if(sender == priceDumper)
    {
        urlField.text = @"http://www.priceDumper.com/Royal+Salute+Price"; 
    }
    else if(sender == windAndSpirits)
    {
        urlField.text = @"https://www.crownwineandspirits.com"; 
    }
    else 
    {
        urlField.text = @"http://www.google.com/";    
    }
    [self loadPage];
}

// Implement viewDidLoad to do additional setup after loading 
// the view, typically from a nib. 
- (void)viewDidLoad { 
	NSLog(@"viewDidLoad"); 
	[super viewDidLoad]; // always call the super class 
    
    theLinkViewContainer.hidden = NO;
    [theRetailerView selectRow:-1 inComponent:0 animated:YES];
    
    isSpirits = NO;
    loadedSpirits = NO;
    
    currentProduct = 0;
    currentRetailer = 0;
    
    //theProductView = [[UIPickerView alloc] initWithFrame:CGRectMake(20.0, 202.0, 230.0, 100.0)];
    //theRetailerView = [[UIPickerView alloc] initWithFrame:CGRectMake(20.0, 362.0, 230.0, 100.0)];
    
    theProductView.delegate = self;
    theProductView.dataSource = self;
    theRetailerView.delegate = self;
    theRetailerView.delegate = self;
    
    [self.view addSubview:theProductView];
    [self.view addSubview:theRetailerView];
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
    [[appDelegate rootVC] hideSettings];
    
	webView.scalesPageToFit = YES; 
	webView.delegate = self; 
	spinner.hidesWhenStopped=YES; 
	[spinner stopAnimating]; 
	urlField.delegate = self; 
	// stops the field from clearing every time we edit it 
	urlField.clearsOnBeginEditing = NO;
    
    TabbedViewController *tabbedVC = [[self.navigationController viewControllers]objectAtIndex:0];
    
    NSManagedObject *obj = [[tabbedVC dc_fullVC] person];
    
    NSLog(@"Person: %@",obj);
    
    if(!obj) obj = [[tabbedVC dc_abbrVC] person];
    
    self.first.text = [obj valueForKey:@"FirstName"];
    self.last.text = [obj valueForKey:@"LastName"];
    self.street.text = [obj valueForKey:@"Address1"];
    self.city.text = [obj valueForKey:@"City"];
    self.state.text = [obj valueForKey:@"StateProvince"];
    self.zip.text = [obj valueForKey:@"PostalCode"];
    
    //urlField.text = @"http://www.google.com/"; 
	//[self loadPage];
} 

// Load our default page here 
// Later we can load in the current page from NSUserDefaults 
- (void)viewWillAppear:(BOOL)animated{ 
	NSLog(@"viewWillAppear"); 
	[super viewWillAppear:animated]; 
	
} 

-(void)updateURLfield{ 
	urlField.text = [[webView.request URL] absoluteString];
}

///*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
     
     currentRetailer = 0;
     currentProduct = 0;
     
     retailerList = [[NSDictionary alloc] initWithObjects:  [NSArray arrayWithObjects:[NSArray arrayWithObjects:
                                                                                       @"http://www.google.com/",
                                                                                       @"http://www.nextag.com/",
                                                                                       @"http://1-877-spirits.com/search.aspx",
                                                                                       nil],
                                                             [NSArray arrayWithObjects:
                                                              @"Google",
                                                              @"Nextag",
                                                              @"1-877-Spirits",
                                                              nil],nil]
                                                  forKeys:  [NSArray arrayWithObjects:@"address",@"name",nil]];
     
     productList = [[NSDictionary alloc] initWithObjects:  [NSArray arrayWithObjects:[NSArray arrayWithObjects:
                                                                                       [[NSDictionary alloc] initWithObjects:  [NSArray arrayWithObjects:
                                                                                                                                @"search?q=Royal+Salute",
                                                                                                                                @"Royal-Salute/stores-html",
                                                                                                                                @"Royal Salute",nil]
                                                                                                                     forKeys:[NSArray arrayWithObjects:
                                                                                                                              @"Google",
                                                                                                                              @"Nextag",
                                                                                                                              @"1-877-Spirits",nil]],
                                                                                      
                                                                                      [[NSDictionary alloc] initWithObjects:  [NSArray arrayWithObjects:
                                                                                                                               @"search?q=Royal+Salute+21",
                                                                                                                               @"Royal-Salute-21/stores-html",
                                                                                                                               @"Royal Salute 21",nil]
                                                                                                                    forKeys:[NSArray arrayWithObjects:
                                                                                                                             @"Google",
                                                                                                                             @"Nextag",
                                                                                                                             @"1-877-Spirits",nil]],
                                                                                      [[NSDictionary alloc] initWithObjects:  [NSArray arrayWithObjects:
                                                                                                                               @"search?q=Royal+Salute+38",
                                                                                                                               @"Royal-Salute-38/stores-html",
                                                                                                                               @"Royal Salute 38",nil]
                                                                                                                    forKeys:[NSArray arrayWithObjects:
                                                                                                                             @"Google",
                                                                                                                             @"Nextag",
                                                                                                                             @"1-877-Spirits",nil]],
                                                                                       nil],
                                                             [NSArray arrayWithObjects:
                                                              @"Royal Salute",
                                                              @"Royal Salute 21",
                                                              @"Royal Salute 38",
                                                              nil],nil]
                                                  forKeys:  [NSArray arrayWithObjects:@"address",@"name",nil]];
     
     googleList = [[NSDictionary alloc] initWithObjects:  [NSArray arrayWithObjects:[NSArray arrayWithObjects:
                                                                                                 [[NSDictionary alloc] initWithObjects:  [NSArray arrayWithObjects:
                                                                                                                                          @"http://www.wineglobe.com/10200.html",
                                                                                                                                          @"http://www.productsfromspain.net/scotch-whisky/scotch-whisky",
                                                                                                                                          @"http://www.beerliquors.com/buy/scotch_whisky/royal_salute.htm",
                                                                                                                                          @"http://www.wineglobe.com/10200.html",
                                                                                                                                          @"http://www.productsfromspain.net/scotch-whisky/scotch-whisky",
                                                                                                                                          @"http://www.beerliquors.com/buy/scotch_whisky/royal_salute.htm",
                                                                                                                                          @"http://www.wineglobe.com/10200.html",
                                                                                                                                          @"http://www.productsfromspain.net/scotch-whisky/scotch-whisky",
                                                                                                                                          @"http://www.beerliquors.com/buy/scotch_whisky/royal_salute.htm",
                                                                                                                                          @"http://www.wineglobe.com/10200.html",
                                                                                                                                          @"http://www.productsfromspain.net/scotch-whisky/scotch-whisky",
                                                                                                                                          @"http://www.beerliquors.com/buy/scotch_whisky/royal_salute.htm",nil]
                                                                                                                               forKeys:[NSArray arrayWithObjects:
                                                                                                                                        @"Chivas Regal 'Royal Salute' 21 Year Scotch Whisky - WineGlobe.com",
                                                                                                                                        @"Scotch Whisky. Chivas Regal Gold Signature, Royal Salute ...",
                                                                                                                                        @"Buy Royal Salute online",
                                                                                                                                        @"Chivas Regal 'Royal Salute' 21 Year Scotch Whisky - WineGlobe.com",
                                                                                                                                        @"Scotch Whisky. Chivas Regal Gold Signature, Royal Salute ...",
                                                                                                                                        @"Buy Royal Salute online",
                                                                                                                                        @"Chivas Regal 'Royal Salute' 21 Year Scotch Whisky - WineGlobe.com",
                                                                                                                                        @"Scotch Whisky. Chivas Regal Gold Signature, Royal Salute ...",
                                                                                                                                        @"Buy Royal Salute online",
                                                                                                                                        @"Chivas Regal 'Royal Salute' 21 Year Scotch Whisky - WineGlobe.com",
                                                                                                                                        @"Scotch Whisky. Chivas Regal Gold Signature, Royal Salute ...",
                                                                                                                                        @"Buy Royal Salute online",nil]],
                                                                                                 
                                                                                                 [[NSDictionary alloc] initWithObjects:  [NSArray arrayWithObjects:
                                                                                                                                          @"http://www.thewhiskyexchange.com/P-629.aspx",
                                                                                                                                          @"http://www.thewhiskyexchange.com/P-11784.aspx",
                                                                                                                                          @"http://www.lovescotch.com/p/chivas-regal-royal-salute-21-year-old",
                                                                                                                                          @"http://www.thewhiskyexchange.com/P-629.aspx",
                                                                                                                                          @"http://www.thewhiskyexchange.com/P-11784.aspx",
                                                                                                                                          @"http://www.lovescotch.com/p/chivas-regal-royal-salute-21-year-old",
                                                                                                                                          @"http://www.thewhiskyexchange.com/P-629.aspx",
                                                                                                                                          @"http://www.thewhiskyexchange.com/P-11784.aspx",
                                                                                                                                          @"http://www.lovescotch.com/p/chivas-regal-royal-salute-21-year-old",
                                                                                                                                          @"http://www.thewhiskyexchange.com/P-629.aspx",
                                                                                                                                          @"http://www.thewhiskyexchange.com/P-11784.aspx",
                                                                                                                                          @"http://www.lovescotch.com/p/chivas-regal-royal-salute-21-year-old",nil]
                                                                                                                               forKeys:[NSArray arrayWithObjects:
                                                                                                                                        @"Royal Salute 21 Year Old : Buy Online - The Whisky Exchange",
                                                                                                                                        @"Royal Salute 21 Year Old / Blue Wade Decanter : Buy Online - The ...",
                                                                                                                                        @"Chivas Regal Royal Salute 21 year old - Buy Online - LoveScotch",
                                                                                                                                        @"Royal Salute 21 Year Old : Buy Online - The Whisky Exchange",
                                                                                                                                        @"Royal Salute 21 Year Old / Blue Wade Decanter : Buy Online - The ...",
                                                                                                                                        @"Chivas Regal Royal Salute 21 year old - Buy Online - LoveScotch",
                                                                                                                                        @"Royal Salute 21 Year Old : Buy Online - The Whisky Exchange",
                                                                                                                                        @"Royal Salute 21 Year Old / Blue Wade Decanter : Buy Online - The ...",
                                                                                                                                        @"Chivas Regal Royal Salute 21 year old - Buy Online - LoveScotch",
                                                                                                                                        @"Royal Salute 21 Year Old : Buy Online - The Whisky Exchange",
                                                                                                                                        @"Royal Salute 21 Year Old / Blue Wade Decanter : Buy Online - The ...",
                                                                                                                                        @"Chivas Regal Royal Salute 21 year old - Buy Online - LoveScotch",nil]],
                                                                                                 [[NSDictionary alloc] initWithObjects:  [NSArray arrayWithObjects:
                                                                                                                                          @"http://www.thewhiskyexchange.com/P-5856.aspx",
                                                                                                                                          @"http://www.outofaces.com/royal-salute-38-year-old/",
                                                                                                                                          @"http://for-lovers.com/store/scotch/royal-salute-38-year-old-stone-of-destiny-scotch-whisky-750ml.html?utm_medium=shoppingengine&utm_source=googlebase&cvsfa=1673&cvsfe=2&cvsfhu=73636f2d3030333632&sid=navd00de6epu8sgm759iibg3d2",
                                                                                                                                          @"http://www.thewhiskyexchange.com/P-5856.aspx",
                                                                                                                                          @"http://www.outofaces.com/royal-salute-38-year-old/",
                                                                                                                                          @"http://for-lovers.com/store/scotch/royal-salute-38-year-old-stone-of-destiny-scotch-whisky-750ml.html?utm_medium=shoppingengine&utm_source=googlebase&cvsfa=1673&cvsfe=2&cvsfhu=73636f2d3030333632&sid=navd00de6epu8sgm759iibg3d2",
                                                                                                                                          @"http://www.thewhiskyexchange.com/P-5856.aspx",
                                                                                                                                          @"http://www.outofaces.com/royal-salute-38-year-old/",
                                                                                                                                          @"http://for-lovers.com/store/scotch/royal-salute-38-year-old-stone-of-destiny-scotch-whisky-750ml.html?utm_medium=shoppingengine&utm_source=googlebase&cvsfa=1673&cvsfe=2&cvsfhu=73636f2d3030333632&sid=navd00de6epu8sgm759iibg3d2",
                                                                                                                                          @"http://www.thewhiskyexchange.com/P-5856.aspx",
                                                                                                                                          @"http://www.outofaces.com/royal-salute-38-year-old/",
                                                                                                                                          @"http://for-lovers.com/store/scotch/royal-salute-38-year-old-stone-of-destiny-scotch-whisky-750ml.html?utm_medium=shoppingengine&utm_source=googlebase&cvsfa=1673&cvsfe=2&cvsfhu=73636f2d3030333632&sid=navd00de6epu8sgm759iibg3d2",nil]
                                                                                                                               forKeys:[NSArray arrayWithObjects:
                                                                                                                                        @"Royal Salute 38 Year Old / Stone of Destiny : Buy Online - The ...",
                                                                                                                                        @"Royal Salute 38 Year Old",
                                                                                                                                        @"Royal Salute 38 Year Old Stone of Destiny Scotch Whisky (750mL)",
                                                                                                                                        @"Royal Salute 38 Year Old / Stone of Destiny : Buy Online - The ...",
                                                                                                                                        @"Royal Salute 38 Year Old",
                                                                                                                                        @"Royal Salute 38 Year Old Stone of Destiny Scotch Whisky (750mL)",
                                                                                                                                        @"Royal Salute 38 Year Old / Stone of Destiny : Buy Online - The ...",
                                                                                                                                        @"Royal Salute 38 Year Old",
                                                                                                                                        @"Royal Salute 38 Year Old Stone of Destiny Scotch Whisky (750mL)",
                                                                                                                                        @"Royal Salute 38 Year Old / Stone of Destiny : Buy Online - The ...",
                                                                                                                                        @"Royal Salute 38 Year Old",
                                                                                                                                        @"Royal Salute 38 Year Old Stone of Destiny Scotch Whisky (750mL)",nil]],
                                                                                                 nil],
                                                                       [NSArray arrayWithObjects:
                                                                        @"Royal Salute",
                                                                        @"Royal Salute 21",
                                                                        @"Royal Salute 38",
                                                                        nil],nil]
                                                            forKeys:  [NSArray arrayWithObjects:@"address",@"name",nil]]; }
 return self;
 }
// */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark - 
#pragma mark UIWebViewDelegate protocol methods 
- (void)webViewDidStartLoad:(UIWebView *)webView {
	// write code to start spinners
	[spinner startAnimating];
	NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	// write code to stop spinners
	[spinner stopAnimating];
	NSLog(@"webViewDidFinishLoad");
	[self updateURLfield];
    
    if(isSpirits && !loadedSpirits){
        NSLog(@"spirits!");
        NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementById('ctl00_ctl00_WucHeaderBottom1_txtSearch').value = '%@';document.getElementById('ctl00_ctl00_WucHeaderBottom1_linkGo').onClick = WebForm_DoPostBackWithOptions(new WebForm_PostBackOptions('ctl00$ctl00$WucHeaderBottom1$linkGo', '', false, '', '/Search.aspx', false, true));",[[productList objectForKey:@"name"]objectAtIndex:currentProduct]];
        NSLog(@"jsString: %@",jsString);
        [webView stringByEvaluatingJavaScriptFromString:jsString];
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('ctl00_ctl00_WucHeaderBottom1_linkGo').click();"];
        loadedSpirits = YES;
    }
     
}

- (void)webView:(UIWebView *)webView didFailLoadWithError: (NSError *)error {
	// write code to stop spinners
	[spinner stopAnimating];
	NSLog(@"didFailLoadWithError");
	[self updateURLfield];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest: (NSURLRequest *)request navigationType:(UIWebViewNavigationType) navigationType{
	NSLog(@"webView - shouldStartLoadWithRequest");
	// Need to return YES or the webView won't load
	NSLog(@"webView shouldStartLoadWithRequest");
	return YES;
}
#pragma mark -

#pragma mark - 
#pragma mark UITextFieldDelegate protocol methods - 
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	if(textField == urlField){ 
		[self loadPage];
	} 
	return YES;
}
#pragma mark -

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
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
    //NSString *columnName;
    int rowCount = 0;
    //for(columnName in dataCollection){
    rowCount = [[[googleList objectForKey:@"address"] objectAtIndex:currentProduct] count];

    /*    break;
     }//*/
//    NSLog(@"rowCount: %d",rowCount);
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath");
    
    NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %i", indexPath.row];
    
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        //cell = [[[MyTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        
        UIColor *fontColor = [UIColor colorWithRed:0.776 green:0.674 blue:0.466 alpha:1.0];
        
        //UILabel *label = cell.textLabel;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        NSString *theKey = [[[[googleList objectForKey:@"address"]objectAtIndex:currentProduct]allKeys]objectAtIndex:indexPath.row];
        NSLog(@"theKey: %@",theKey);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", @"•",[[[googleList objectForKey:@"address"]objectAtIndex:currentProduct]valueForKey:theKey]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", @"•",theKey];
        
       // NSLog(@"columnData: %@",[NSString stringWithFormat:@"%@", [[dataCollection objectAtIndex:i] objectAtIndex:indexPath.row]]);
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.textLabel.textColor = fontColor;
        cell.textLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
   
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        isSpirits = NO;
        loadedSpirits = NO;
    NSString *theKey = [NSString stringWithString:[[[[googleList objectForKey:@"address"]objectAtIndex:currentProduct]allKeys]objectAtIndex:indexPath.row]];
    NSLog(@"theAddress: %@", [NSString stringWithFormat:@"%@",[[[googleList objectForKey:@"address"]objectAtIndex:currentProduct]valueForKey:theKey]]);

    urlField.text = [NSString stringWithFormat:@"%@",[[[googleList objectForKey:@"address"]objectAtIndex:currentProduct]valueForKey:theKey]];//[[[[googleList objectForKey:@"address"]objectAtIndex:currentProduct]allKeys]objectAtIndex:indexPath.row];
        
        [self loadPage];
    
    
    
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
    int rowCount = 0;
    //for(columnName in dataCollection){
    if(pickerView == theProductView){
        rowCount = [[productList objectForKey:@"name"] count];
    }else{
        rowCount = [[retailerList objectForKey:@"name"] count];
    }
    /*    break;
     }//*/
    NSLog(@"rowCount: %d",rowCount);
    return rowCount;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
    NSString *label;
    if(pickerView == theProductView){
        label = [NSString stringWithFormat:@"%@ %@", @"•",[[productList objectForKey:@"name"]objectAtIndex:row]];
    }else{
        label = [NSString stringWithFormat:@"%@ %@", @"•",[[retailerList objectForKey:@"name"]objectAtIndex:row]];
    }

    
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if(pickerView == theProductView){
        currentProduct = row;
    }else{
        currentRetailer = row;
        if(currentRetailer == 1){
            theLinkViewContainer.hidden = YES;
            NSLog(@"retailer address: %@ ",[[retailerList objectForKey:@"address"]objectAtIndex:currentRetailer]);
            NSLog(@"retailer name: %@ ",[[retailerList objectForKey:@"name"]objectAtIndex:currentRetailer]);
            NSLog(@"product address: %@ ",[[[productList objectForKey:@"address"]objectAtIndex:currentProduct]valueForKey:[[retailerList objectForKey:@"name"]objectAtIndex:currentRetailer]]);
            
            NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",
                                   [[retailerList objectForKey:@"address"]objectAtIndex:currentRetailer],
                                   [[[productList objectForKey:@"address"]objectAtIndex:currentProduct]valueForKey:[[retailerList objectForKey:@"name"]objectAtIndex:currentRetailer]]];
            
            NSLog(@"address string: %@",urlString);
            
            urlField.text = [[NSString alloc] initWithFormat:@"%@%@",
                             [[retailerList objectForKey:@"address"]objectAtIndex:currentRetailer],
                             [[[productList objectForKey:@"address"]objectAtIndex:currentProduct]valueForKey:[[retailerList objectForKey:@"name"]objectAtIndex:currentRetailer]]];
            
            isSpirits = NO;
            loadedSpirits = NO;
            [self loadPage];
        }else if(currentRetailer == 2){
            theLinkViewContainer.hidden = YES;
            urlField.text = [[retailerList objectForKey:@"address"]objectAtIndex:currentRetailer];
            isSpirits = YES;
            loadedSpirits = NO;
            [self loadPage];
        }
        else if(currentRetailer == 0){
            theLinkViewContainer.hidden = NO;
            [theLinkView reloadData];
            isSpirits = NO;
            loadedSpirits = NO;
            //[pickerView selectRow:-1 inComponent:0 animated:YES];
        }
        
    }
    [theLinkView reloadData];
}


#pragma mark -

-(IBAction)order
{
    TabbedViewController *tabbedVC = [[self.navigationController viewControllers]objectAtIndex:0];
    [[tabbedVC dc_abbrVC]clearFields];
    [[tabbedVC dc_abbrVC]savePerson];
    [[tabbedVC dc_fullVC]clearFields];
    [[tabbedVC dc_fullVC]savePerson];
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
    [[appDelegate rootVC] showSettings];
    [[[appDelegate rootVC] navController] popToRootViewControllerAnimated:YES];
}

-(IBAction)cancelOrder
{
    TabbedViewController *tabbedVC = [[self.navigationController viewControllers]objectAtIndex:0];
    [[tabbedVC dc_abbrVC]clearFields];
    [[tabbedVC dc_abbrVC]savePerson];
    [[tabbedVC dc_fullVC]clearFields];
    [[tabbedVC dc_fullVC]savePerson];
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
    [[appDelegate rootVC] showSettings];
    [[[appDelegate rootVC] navController] popToRootViewControllerAnimated:YES];
}

-(IBAction)loadRetailerSite:(id)sender
{
    urlField.text = @"http://royalsalute.devaddress.com/themes/royal-salute/retailers.php";
    isSpirits = NO;
    loadedSpirits = NO;
    [self loadPage]; 
}

@end

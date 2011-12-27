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
    
    isSpirits = NO;
    loadedSpirits = NO;
    firstLoad = YES;
    
    //fwd.hidden = YES;
    //back.hidden = YES;
    fwd.enabled = NO;
    back.enabled = NO;
    
    theProductView = [[UIPickerViewController alloc] initWithNibName:@"UIPickerViewController" bundle:nil];
    theRetailerView = [[UIPickerViewController alloc] initWithNibName:@"UIPickerViewController" bundle:nil];
    
    theProductView.delegate = self;
    //theProductView.dataSource = self;
    theRetailerView.delegate = self;
    //theRetailerView.delegate = self;
    theProductView.title = @"Expression";
    theRetailerView.title = @"Search";
    
    // Build Nav Controller
    /*
    if(navController == nil)
    {
        NSLog(@"build navController");
        // Create Nav Controller
        navController = [[UINavigationController alloc] initWithRootViewController:theProductView];
        [navControllerContainer addSubview:navController.view];
        
        UIColor *barColor = [UIColor colorWithRed:.619 green:0.227 blue:0.003 alpha:1.0];
        navController.navigationBar.tintColor = barColor;
        
        // Custom resize nav controller to fit in its subview
        CGRect frame = navControllerContainer.frame;
        frame.origin.y = 0.0;
        frame.origin.x = 0.0;
        navController.view.frame = frame;
        
        frame = theProductView.view.frame;
        frame.origin.y = 0.0;
        frame.origin.x = 0.0;
        theProductView.view.frame = frame;
        
        [navController setNavigationBarHidden:NO];
        [navController setDelegate:self];
        
        // Add navcontroller to the main content view
    }
     */

   // [navController pushViewController:theProductView animated:YES];
  // [[self.navController.viewControllers objectAtIndex:0] setTitle:@"Select a Product"];
    
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
    
    
    if(!obj) obj = [[tabbedVC dc_abbrVC] person];
    
    if(obj){
        NSLog(@"Person: %@",obj);

        self.first.text = [obj valueForKey:@"FirstName"];
        self.last.text = [obj valueForKey:@"LastName"];
        self.street.text = [obj valueForKey:@"Address1"];
        self.city.text = [obj valueForKey:@"City"];
        self.state.text = [obj valueForKey:@"StateProvince"];
        self.zip.text = [obj valueForKey:@"PostalCode"];
    }else{
        self.first.text = @"N/A";
        self.last.text = @"N/A";
        self.street.text = @"N/A";
        self.city.text = @"N/A";
        self.state.text = @"N/A";
        self.zip.text = @"N/A";
    }
    
    urlField.text = @"http://royalsalute.devaddress.com/themes/royal-salute/retailers.php";
    isSpirits = NO;
    loadedSpirits = NO;
 
    //Instantiate PopOvers
    /*pickerViewController = [[PickerViewController alloc] init];
	pickerViewController.components = states;
    pickerViewController.delegate = self;*/
	popOverControllerWithPicker = [[UIPopoverController alloc] initWithContentViewController:theProductView];
    popOverControllerWithPicker.delegate = self;
	popOverControllerWithPicker.popoverContentSize = CGSizeMake(220, 199);
    
    retailerPopOverControllerWithPicker = [[UIPopoverController alloc] initWithContentViewController:theRetailerView];
    retailerPopOverControllerWithPicker.delegate = self;
	retailerPopOverControllerWithPicker.popoverContentSize = CGSizeMake(220, 199);
    
	[self loadPage];
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
                                                                                       @" ",
                                                                                       @"http://www.google.com/",
                                                                                       @"http://www.nextag.com/",
                                                                                       @"http://1-877-spirits.com/search.aspx",
                                                                                       nil],
                                                             [NSArray arrayWithObjects:
                                                              @" ",
                                                              @"Google",
                                                              @"Nextag",
                                                              @"1-877-Spirits",
                                                              nil],nil]
                                                  forKeys:  [NSArray arrayWithObjects:@"address",@"name",nil]];
     
     productList = [[NSDictionary alloc] initWithObjects:  [NSArray arrayWithObjects:[NSArray arrayWithObjects:
                                                                                      [[NSArray alloc] init],
                                                                                      [[NSDictionary alloc] initWithObjects:  [NSArray arrayWithObjects:
                                                                                                                               @"search?q=Royal+Salute+21&tbm=shop&hl=en&aq=f",
                                                                                                                               @"Royal-Salute-21/stores-html",
                                                                                                                               @"Royal Salute 21",nil]
                                                                                                                    forKeys:[NSArray arrayWithObjects:
                                                                                                                             @"Google",
                                                                                                                             @"Nextag",
                                                                                                                             @"1-877-Spirits",nil]],
                                                                                      [[NSDictionary alloc] initWithObjects:  [NSArray arrayWithObjects:
                                                                                                                               @"search?q=Royal+Salute+38&tbm=shop&hl=en&aq=f",
                                                                                                                               @"Royal-Salute-38/stores-html",
                                                                                                                               @"Royal Salute 38",nil]
                                                                                                                    forKeys:[NSArray arrayWithObjects:
                                                                                                                             @"Google",
                                                                                                                             @"Nextag",
                                                                                                                             @"1-877-Spirits",nil]],
                                                                                       nil],
                                                             [NSArray arrayWithObjects:
                                                              @" ",
                                                              @"Royal Salute 21",
                                                              @"Royal Salute 38",
                                                              nil],nil]
                                                  forKeys:  [NSArray arrayWithObjects:@"address",@"name",nil]];
 }
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
    
    if(webView.canGoBack){
        //back.hidden = NO;
        back.enabled = YES;
    }else{
        //back.hidden = YES;
        back.enabled = NO;
    }
    
    if(webView.canGoForward){
        //fwd.hidden = NO;
        fwd.enabled = YES;
    }else{
        //fwd.hidden = YES;
        fwd.enabled = NO;
    }
    
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
/*
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
    if(tableView == theProductView){
        rowCount = [[productList objectForKey:@"name"] count];
    }else{
        rowCount = [[retailerList objectForKey:@"name"] count];
    }
    /*    break;
     }//*/
//    NSLog(@"rowCount: %d",rowCount);
//    return rowCount;
//}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath");
    
    NSString *MyIdentifier = [NSString stringWithFormat:@"MyIdentifier %i", indexPath.row];
    
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        //cell = [[[MyTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UIColor *fontColor = [UIColor colorWithRed:.619 green:0.227 blue:0.003 alpha:1.0];
        
        //UILabel *label = cell.textLabel;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        if(tableView == theProductView){
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", @"•",[[productList objectForKey:@"name"]objectAtIndex:indexPath.row]];
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", @"•",[[retailerList objectForKey:@"name"]objectAtIndex:indexPath.row]];
        }
        
       // NSLog(@"columnData: %@",[NSString stringWithFormat:@"%@", [[dataCollection objectAtIndex:i] objectAtIndex:indexPath.row]]);
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.textLabel.textColor = fontColor;
        cell.textLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
   
    }
    
    return cell;
}
*/
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

-(NSInteger)picker:(UIPickerViewController *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
    int rowCount = 0;
    //for(columnName in dataCollection){
    if(pickerView == theProductView){
        rowCount = [[productList objectForKey:@"name"] count];
    }else{
        rowCount = [[retailerList objectForKey:@"name"] count];
    }
   
    NSLog(@"rowCount: %d",rowCount);
    return rowCount;
}
-(NSString *)picker:(UIPickerViewController *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
    NSString *label;
    if(pickerView == theProductView){
        label = [NSString stringWithFormat:@"%@ %@", @"",[[productList objectForKey:@"name"]objectAtIndex:row]];
    }else{
        label = [NSString stringWithFormat:@"%@ %@", @"",[[retailerList objectForKey:@"name"]objectAtIndex:row]];
    }

    
    return label;
}

-(void)picker:(UIPickerViewController *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if(pickerView == theProductView){
        if(row!=0){
            currentProduct = row;
            expression.text = [[productList objectForKey:@"name"] objectAtIndex:row];
        
            if(currentRetailer != 0)
            {
                if(currentRetailer != 3){
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
                }else{
                    urlField.text = [[retailerList objectForKey:@"address"]objectAtIndex:currentRetailer];
                    isSpirits = YES;
                    loadedSpirits = NO;
                }
                [self loadPage];
            }
            //[navController pushViewController:theRetailerView animated:YES];
        }
        //[[self.navController.viewControllers objectAtIndex:1] setTitle:@"Select a Retailer"];
    }else{
        if(row!=0){
            currentRetailer = row;
            if(currentRetailer != 3){
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
            }else{
                urlField.text = [[retailerList objectForKey:@"address"]objectAtIndex:currentRetailer];
                isSpirits = YES;
                loadedSpirits = NO;
            }
            search.text = [[retailerList objectForKey:@"name"] objectAtIndex:row];
            [self loadPage];
        }
    }
}
/*
- (void)pickerView:(UITableView *)pickerView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(pickerView == theProductView){
        currentProduct = indexPath.row;
    }else{
        currentRetailer = indexPath.row;
        if(currentRetailer != 2){
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
        }else{
            urlField.text = [[retailerList objectForKey:@"address"]objectAtIndex:currentRetailer];
            isSpirits = YES;
            loadedSpirits = NO;
        }
        [self loadPage];
    }
        

    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
//}


#pragma mark - 

#pragma Modal Popover methods

-(void)displayPickerPopover
{
    NSLog(@"-(void)displayPickerPopover");
    //OLD WAY
    /*
     [self dismissFirstResponder];
     
     CGFloat newX = dob.frame.origin.x;
     CGFloat newY = dob.frame.origin.y;
     
     CGSize sizeOfPopover = CGSizeMake(300.0, 220.0);
     CGPoint positionOfPopover = CGPointMake(newX, newY);
     [popOverControllerWithPicker presentPopoverFromRect:CGRectMake(positionOfPopover.x, positionOfPopover.y, sizeOfPopover.width, sizeOfPopover.height)
     inView:self.content permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
     //*/
    //[self dismissFirstResponder];
    
    /*
    if([search isFirstResponder]){
        [search resignFirstResponder];
    }else{
        [expression resignFirstResponder];
    }
     */
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    UIScrollView *masterScroll = [[appDelegate rootVC] scrollView];
    
    if([currentPicker isEqualToString:@"expression"]){
       //pickerViewController.thePickerView.hidden = YES;
       // pickerViewController.theDatePickerView.hidden = NO;
        
        CGFloat newX = 35.0f;//dob.frame.origin.x + rightSide.frame.origin.x;
        CGFloat newY = 290.0f;//dob.frame.origin.y - 220.0f + 31.0f +rightSide.frame.origin.y;
        
        CGSize sizeOfPopover = CGSizeMake(220.0, 199.0);
        CGPoint positionOfPopover = CGPointMake(newX, newY);
        
        //NSLog(@"dob y: %f",dob.frame.origin.y);
        
        //CGRect rc = dob.frame;
        //rc = [dob convertRect:rc toView:masterView];
        //popoverY = (self.view.frame.origin.y + content.frame.origin.y + dob.frame.origin.y - masterScroll.contentOffset.y);
        
        
        [popOverControllerWithPicker presentPopoverFromRect:CGRectMake(positionOfPopover.x, positionOfPopover.y, sizeOfPopover.width, sizeOfPopover.height)
                                                     inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }else{
        //pickerViewController.thePickerView.hidden = NO;
        //pickerViewController.theDatePickerView.hidden = YES;
        
        //CGFloat newX = state.frame.origin.x-115.0f;// + rightSide.frame.origin.x;
        //CGFloat newY = state.frame.origin.y;// /*- 220.0f*/ + 31.0f;// +rightSide.frame.origin.y;
        
        CGFloat newX = 35.0f;
        CGFloat newY = 410.0f;
        
        CGSize sizeOfPopover = CGSizeMake(220.0, 199.0);
        CGPoint positionOfPopover = CGPointMake(newX, newY);
        
        //NSLog(@"dob y: %f",state.frame.origin.y);
        
        //CGRect rc = state.frame;
        //rc = [dob convertRect:rc toView:masterView];
        //popoverY = (self.view.frame.origin.y + content.frame.origin.y + state.frame.origin.y - masterScroll.contentOffset.y);
        
        
        [retailerPopOverControllerWithPicker presentPopoverFromRect:CGRectMake(positionOfPopover.x, positionOfPopover.y, sizeOfPopover.width, sizeOfPopover.height)
                                                     inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    NSLog(@"-(void)displayPickerPopover - finished");
}

-(IBAction)clickedExpression
{
    NSLog(@"-(IBAction)clickedExpression");
    //[expression resignFirstResponder];
    //currentPicker = @"expression";
    //[self performSelectorOnMainThread:@selector(displayPickerPopover) withObject:nil waitUntilDone:YES];//[self displayPickerPopover];
}

-(IBAction)clickedSearch
{
    NSLog(@"-(IBAction)clickedSearch");
    //[search resignFirstResponder];
    //currentPicker = @"search";
    //[self performSelectorOnMainThread:@selector(displayPickerPopover) withObject:nil waitUntilDone:YES];//[self displayPickerPopover];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
    
    
    //currentTextField = textField;
	NSLog(@"didbeginediting");
	
	//isEditing = YES;
    
    //Find current textfield and return its index
    
    if(textField == expression){ 
        NSLog(@"Selected expression, display popover");
        [textField resignFirstResponder];
        currentPicker = @"expression";
        [self performSelectorOnMainThread:@selector(displayPickerPopover) withObject:nil waitUntilDone:YES];
    }else if(textField == search){
        NSLog(@"Selected search, display popover");
        [textField resignFirstResponder];
        currentPicker = @"search";
        [self performSelectorOnMainThread:@selector(displayPickerPopover) withObject:nil waitUntilDone:YES];
    }
}


#pragma mark -

-(IBAction)order
{
    TabbedViewController *tabbedVC = [[self.navigationController viewControllers]objectAtIndex:0];
    [[tabbedVC dc_abbrVC]didOrder];
    [[tabbedVC dc_abbrVC]clearFields];
    [[tabbedVC dc_abbrVC]savePerson];
   
    [[tabbedVC dc_fullVC]didOrder];
    [[tabbedVC dc_fullVC]clearFields];
    [[tabbedVC dc_fullVC]savePerson];
    
    ThankYouPurchaseViewController *thankYouPurchaseVC =  [[ThankYouPurchaseViewController alloc] initWithNibName:@"ThankYouPurchaseViewController" bundle:nil];
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
    [[appDelegate rootVC] showSettings];
    [[appDelegate rootVC] hideErrorMessage];
    [[[appDelegate rootVC] navController] pushViewController:thankYouPurchaseVC animated:YES];
}

-(IBAction)cancelOrder
{
    TabbedViewController *tabbedVC = [[self.navigationController viewControllers]objectAtIndex:0];
    [[tabbedVC dc_abbrVC]cancelOrder];
    [[tabbedVC dc_abbrVC]clearFields];
    [[tabbedVC dc_abbrVC]savePerson];
    
    [[tabbedVC dc_fullVC]cancelOrder];
    [[tabbedVC dc_fullVC]clearFields];
    [[tabbedVC dc_fullVC]savePerson];
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
    [[appDelegate rootVC] showSettings];
    [[appDelegate rootVC] hideErrorMessage];
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

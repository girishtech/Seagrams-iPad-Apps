//
//  ThankYouPurchaseViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 6/30/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//


#import "ThankYouPurchaseViewController.h"
#import "TakePhotoViewController.h"
#import "RootViewController.h"
#import "ForceMultiplierAppDelegate.h"
#import "DataAccess.h"


@implementation ThankYouPurchaseViewController

@synthesize imageView;

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
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
    [[appDelegate rootVC] hideErrorMessage];
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
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

-(IBAction)nextView
{
    // shahab open
    
    [self.navigationController popToRootViewControllerAnimated:YES];

    // shahab close
    
    
    // shahab open commented
    
//    TabbedViewController *tabbedVC = [[self.navigationController viewControllers]objectAtIndex:1];
//    /*[[tabbedVC dc_abbrVC]clearFields];
//    [[tabbedVC dc_abbrVC]savePerson];
//    [[tabbedVC dc_fullVC]clearFields];
//    [[tabbedVC dc_fullVC]savePerson];*/
//    [[tabbedVC dc_abbrVC]clearFields];
//    [[tabbedVC dc_abbrVC]savePerson];
//    
//    //[[tabbedVC dc_fullVC]cancelOrder];
//    [[tabbedVC dc_fullVC]clearFields];
//    [[tabbedVC dc_fullVC]savePerson];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    
    // shahab close commented
}
- (NSString*)imagePath {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    /*
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"EventImages"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentDirectory]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:documentDirectory withIntermediateDirectories:NO attributes:nil error:&error];
    }
    // */
    //NSString *fullpath = [documentDirectory stringByAppendingPathComponent:@"Hello.JPEG"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   // NSString *sPath = [defaults valueForKey:@"kiosk_currentSessionName"];
    //   sPath = [sPath stringByAppendingPathComponent:@"_"];
    //   sPath = [sPath stringByAppendingPathComponent:[defaults valueForKey:@"kiosk_currentSessionName"]];
    
    ForceMultiplierAppDelegate *appdelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    DataAccess *da = [appdelegate da];
    NSString *sPath = [NSString stringWithFormat:@"%@_%@.png",da.currentSession,[appdelegate rootVC].emailAddress];
    
    NSString *fullpath = [documentDirectory stringByAppendingPathComponent:sPath];
    NSLog(@"### image path created path of %@", fullpath);
    return fullpath;
}
- (IBAction) viewImage {
    
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfFile:[self imagePath]]];
    
    if (img==nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"hi" message:@"Image not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    UIImageView *imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(380,150, 680, 450)];
    imgVw.image = img;
    [imgVw setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:imgVw];
    [imgVw release];
    
}

@end

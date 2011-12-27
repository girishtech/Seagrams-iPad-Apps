//
//  PhotoConsentViewController.m
//  ForceMultiplier
//
//  Created by Sofian on 14/12/11.
//  Copyright (c) 2011 Rochester Institute of Technology. All rights reserved.
//
#import "PhotoConsentViewController.h"
#import "TabbedViewController.h"
#import "TakePhotoViewController.h"
#import "ForceMultiplierAppDelegate.h"
#import "RootViewController.h"

@implementation PhotoConsentViewController

@synthesize agreeButton, disagreeButton, popoverController, imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    isAgreed = YES;
}

- (void)viewDidUnload
{
    self.imageView = nil;
    self.popoverController = nil;
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

- (void) dealloc {
    [popoverController release];
    [imageView release];
    [agreeButton release];
    [disagreeButton release];
    [super dealloc];
}

- (void) setAgree {
    isAgreed = YES;
    [self.agreeButton setImage:[UIImage imageNamed:@"OptIn_tSelected.png"] forState:UIControlStateNormal];
    [self.disagreeButton setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateNormal];
}

- (void) setDisAgree {
    isAgreed = NO;
    [self.agreeButton setImage:[UIImage imageNamed:@"OptIn_NotSelected.png"] forState:UIControlStateNormal];
    [self.disagreeButton setImage:[UIImage imageNamed:@"OptIn_Selected.png"] forState:UIControlStateNormal];
}

- (IBAction) agreeButtonClicked :(id)sender {
    UIButton *button = (UIButton*)sender;
    switch (button.tag) {
        case 1:
            [self setAgree];
            break;
        case 2:
            [self setDisAgree];
            break;
        default:
            break;
    }
}

- (ForceMultiplierAppDelegate*) appDelegate {
    return (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (IBAction) nextClicked :(id)sender {
    
    if (isAgreed) {
        // Open camera
//        TakePhotoViewController *takePhotoViewController = [[TakePhotoViewController alloc] initWithNibName:@"TakePhotoViewController" bundle:nil];
//        [self.navigationController pushViewController:takePhotoViewController animated:YES];
//        [takePhotoViewController release];
        [[[self appDelegate] rootVC] showTakePhotoViewControllerDelegate:self];
    }
    else {
        // show tahnk you view
        TabbedViewController *tabbedVC = [[self.navigationController viewControllers]objectAtIndex:1];
        [[tabbedVC dc_abbrVC]clearFields];
        
        ThankYouPurchaseViewController *thankYouVC = [[ThankYouPurchaseViewController alloc] initWithNibName:@"ThankYouPurchaseViewController" bundle:nil];
        
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication]delegate];
        [[appDelegate rootVC] hideErrorMessage];
        
        [[[appDelegate rootVC] navController] pushViewController:thankYouVC animated:YES];
        [thankYouVC release];

    }
    
}

- (IBAction) useCamera: (id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker
                                animated:YES];
        [imagePicker release];
        //newMedia = YES;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.popoverController dismissPopoverAnimated:true];
    [popoverController release];
    
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        imageView.image = image;
    }
}

- (NSString*) currentEventId {
    return @"HI";
}

- (NSString*) currentUser {
    return @"iuiu";
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}


- (void) saveImage:(UIImage*)image withName:(NSString*)name {
    //portrait
    image = [self imageWithImage:image scaledToSize:CGSizeMake(384, 464)];
    // landscape
    //image = [self imageWithImage:image scaledToSize:CGSizeMake(464, 384)];
    NSData *data = UIImagePNGRepresentation(image);
   
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    /*
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"EventImages"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentDirectory]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:documentDirectory withIntermediateDirectories:NO attributes:nil error:&error];
    }
    // */
    NSString *fullpath = [documentDirectory stringByAppendingPathComponent:name];
    NSLog(@"### SAVING IMAGE TO PATH: %@", fullpath);
    [[NSFileManager defaultManager] createFileAtPath:fullpath contents:data attributes:nil];
}



- (void) imageRecieved :(UIImage*)image {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    DataAccess *da = [appDelegate da];
    NSString *imagename = [NSString stringWithFormat:@"%@_%@.png",da.currentSession,[appDelegate rootVC].emailAddress];
    NSLog(@"generated image name of: %@", imagename);
    [self saveImage:image withName:imagename];
    
    isAgreed = YES;
    TabbedViewController *tabbedVC = [[self.navigationController viewControllers]objectAtIndex:1];
    [[tabbedVC dc_abbrVC]clearFields];
    
    ThankYouPurchaseViewController *thankYouVC = [[ThankYouPurchaseViewController alloc] initWithNibName:@"ThankYouPurchaseViewController" bundle:nil];

    [[appDelegate rootVC] hideErrorMessage];
    
    [[[appDelegate rootVC] navController] pushViewController:thankYouVC animated:NO];
     [thankYouVC release];
}

- (NSString*)imagePath {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    /*
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"EventImages"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentDirectory]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:documentDirectory withIntermediateDirectories:NO attributes:nil error:&error];
    }
    //NSString *fullpath = [documentDirectory stringByAppendingPathComponent:@"Hello.JPEG"];
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sPath = [defaults valueForKey:@"kiosk_currentSessionName"];


    NSString *fullpath = [documentDirectory stringByAppendingPathComponent:sPath];
    NSLog(@"imagePath method crated image path of: %@", fullpath);
    return fullpath;
}

- (IBAction) viewImage {
    
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfFile:[self imagePath]]];
    
    if (img==nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"hi" message:@"Image not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    UIImageView *imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(10,10, 400, 400)];
    imgVw.image = img;
    [imgVw setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:imgVw];
    [imgVw release];
    
}

@end

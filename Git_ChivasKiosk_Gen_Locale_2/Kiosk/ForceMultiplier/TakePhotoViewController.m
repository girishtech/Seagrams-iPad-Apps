//
//  TakePhotoViewController.m
//  ForceMultiplier
//
//  Created by Sofian on 17/12/11.
//  Copyright (c) 2011 Rochester Institute of Technology. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "LandscapeImagePicker.h"

@implementation TakePhotoViewController

@synthesize imageView, popoverController, delegate, currentViewController;


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

- (void) openCamera {
    [self useCamera:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(openCamera) userInfo:nil repeats:NO];
    // Do any additional setup after loading the view from its nib.
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

- (void)dealloc
{
    [currentViewController release];
    [popoverController release];
    [imageView release];
    [super dealloc];
}


- (IBAction) useCamera: (id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[LandscapeImagePicker alloc] init];
        //UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;

        
        
        [self presentModalViewController:imagePicker animated:YES];
        [imagePicker release];
        newMedia = YES;
    }
}



-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.popoverController dismissPopoverAnimated:true];
    [popoverController release];
    
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:NO];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        imageView.image = image;
        //if (newMedia)
           // UIImageWriteToSavedPhotosAlbum(image,
           //                                self,  
           //                                @selector(image:finishedSavingWithError:contextInfo:),
           //                                nil);
        [self.delegate takePhotoViewController:self imageDidCaptured:image];
        [self dismissModalViewControllerAnimated:NO];
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}
-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}


@end

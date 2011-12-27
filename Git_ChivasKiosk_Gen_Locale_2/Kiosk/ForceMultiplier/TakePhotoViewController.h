//
//  TakePhotoViewController.h
//  ForceMultiplier
//
//  Created by Sofian on 17/12/11.
//  Copyright (c) 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@protocol TakePhotoViewControllerDelegate; 

@interface TakePhotoViewController : UIViewController<UIImagePickerControllerDelegate,
    UINavigationControllerDelegate, UIPopoverControllerDelegate>
{
    UIPopoverController *popoverController;
    UIImageView *imageView;
    BOOL newMedia;
    id <TakePhotoViewControllerDelegate> delegate;
    UIViewController *currentViewController;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) UIPopoverController *popoverController;
@property (nonatomic, retain) id <TakePhotoViewControllerDelegate> delegate;
@property (nonatomic, retain) UIViewController *currentViewController;

- (IBAction)useCamera: (id)sender;


@end

@protocol TakePhotoViewControllerDelegate <NSObject>

- (void) takePhotoViewController:(TakePhotoViewController*)takePhotoViewController imageDidCaptured :(UIImage*)image;

@end
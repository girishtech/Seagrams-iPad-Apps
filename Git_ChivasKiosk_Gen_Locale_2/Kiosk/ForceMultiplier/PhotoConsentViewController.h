//
//  PhotoConsentViewController.h
//  ForceMultiplier
//
//  Created by Sofian on 14/12/11.
//  Copyright (c) 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface PhotoConsentViewController : UIViewController {
    UIButton *agreeButton;
    UIButton *disagreeButton;
    BOOL isAgreed;
    UIPopoverController *popoverController;
    UIImageView *imageView;
}

@property (nonatomic, retain) IBOutlet UIButton *agreeButton;
@property (nonatomic, retain) IBOutlet UIButton *disagreeButton;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;


- (IBAction) agreeButtonClicked :(id)sender;
- (IBAction) nextClicked :(id)sender;
- (void) imageRecieved :(UIImage*)image;
- (IBAction) viewImage;

@end

//
//  ThankYouPurchaseViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 6/30/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
@class TabbedViewController;
@class OrderViewController;
@class ForceMultiplierAppDelegate;

@interface ThankYouPurchaseViewController : UIViewController {
    UIImageView *imageView;
    
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;

-(IBAction)nextView;
- (IBAction) viewImage;
@end

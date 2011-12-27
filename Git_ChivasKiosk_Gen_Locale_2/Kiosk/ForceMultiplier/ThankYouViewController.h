//
//  ThankYouViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 6/1/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabbedViewController;
@class OrderViewController;
@class ForceMultiplierAppDelegate;

@interface ThankYouViewController : UIViewController {
    IBOutlet UIButton *next_btn;
}

@property (nonatomic, retain) IBOutlet UIButton *next_btn;

-(IBAction)nextView;

@end

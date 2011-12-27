//
//  OptinConfirmationViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 8/5/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabbedViewController.h"

@interface OptinConfirmationViewController : UIViewController {
    TabbedViewController *tabbedVC;
    IBOutlet UIButton *optInBtn;
    IBOutlet UILabel *optInLabel;
    IBOutlet UIButton *optInBox;
}

@property (nonatomic,retain) TabbedViewController *tabbedVC;
@property (nonatomic,retain) IBOutlet UIButton *optInBtn;
@property (nonatomic,retain) IBOutlet UILabel *optInLabel;
@property (nonatomic,retain) IBOutlet UIButton *optInBox;

-(IBAction)loadDataEntry;
-(IBAction)selectedOptIn;
@end

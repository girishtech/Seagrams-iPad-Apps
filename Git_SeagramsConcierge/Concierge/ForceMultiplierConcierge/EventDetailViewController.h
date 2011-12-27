//
//  EventDetailViewController.h
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/22/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventDetailViewController : UIViewController <UINavigationControllerDelegate>{
    IBOutlet UILabel *brandName;
    IBOutlet UILabel *eventName;
    IBOutlet UIView *contentView;
    UITabBarController *eventTabBar;
}

@property (nonatomic,retain) IBOutlet UILabel *brandName;
@property (nonatomic,retain) IBOutlet UILabel *eventName;
@property (nonatomic,retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) UITabBarController *eventTabBar;

-(void)updateDisplay;

@end

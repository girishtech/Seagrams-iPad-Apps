//
//  AttendeeDetailViewController.h
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/22/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AttendeeDetailViewController : UIViewController <UINavigationControllerDelegate>{
    IBOutlet UILabel *attendeeName;
    UITabBarController *attendeeTabBar;
}

@property (nonatomic,retain) IBOutlet UILabel *attendeeName;

@property (nonatomic, retain) UITabBarController *attendeeTabBar;

@end

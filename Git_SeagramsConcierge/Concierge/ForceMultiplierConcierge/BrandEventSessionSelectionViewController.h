//
//  BrandEventSessionSelectionViewController.h
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/22/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfflineSessionSelectionViewController.h"
#import "OnlineSessionEnableViewController.h"


@interface BrandEventSessionSelectionViewController : UIViewController <UINavigationControllerDelegate>{
    OfflineSessionSelectionViewController *offlineSelectionVC;
    OnlineSessionEnableViewController *onlineSessionVC;
    UITabBarController *brandTabBar;
    NSArray *offOnLineList;
}
@property (nonatomic, retain) OfflineSessionSelectionViewController *offlineSelectionVC;
@property (nonatomic, retain) OnlineSessionEnableViewController *onlineSessionVC;
@property (nonatomic, retain) UITabBarController *brandTabBar;
@property (nonatomic, retain) NSArray *offOnLineList;

-(IBAction)eventItemSelectBrandVC:(id)sender;


@end

//
//  TabbedViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/16/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "DataCollection_Abbr_ViewController.h"
//#import "BlankViewController.h"
#import "DataAccess.h"
//#import "AttendeeProfileViewController.h"
@class AttendeeProfileViewController;

@interface TabbedViewController : UIViewController <UITabBarControllerDelegate>{
    UITabBarController *tabBarController;
    UITabBarController *settingsTabBarController;
    IBOutlet UITabBar *blankTabBar;
    IBOutlet UIButton *full_btn;
    IBOutlet UIButton *quick_btn;
    IBOutlet UIView *content;
    IBOutlet UIImageView *header;
    NSArray *viewControllers;
    NSArray *buttonData;
    NSMutableArray *buttons;
    //DataCollection_Abbr_ViewController *dc_abbrVC;
    AttendeeProfileViewController *dc_fullVC;
    DataAccess *da;
}

@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) UITabBarController *settingsTabBarController;
@property (nonatomic, retain) IBOutlet UIButton *full_btn;
@property (nonatomic, retain) IBOutlet UIButton *quick_btn;
@property (nonatomic, retain) IBOutlet UIView *content;
@property (nonatomic, retain) AttendeeProfileViewController *dc_fullVC;
@property (nonatomic, retain) IBOutlet UITabBar *blankTabBar;
@property (nonatomic, retain) IBOutlet UIImageView *header;
@property (nonatomic, retain) DataAccess *da;
@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) NSArray *buttonData;
@property (nonatomic, retain) NSMutableArray *buttons;

-(void)_layoutPage;
-(IBAction)selectTab:(id)sender;
-(void)_updateView;
@end

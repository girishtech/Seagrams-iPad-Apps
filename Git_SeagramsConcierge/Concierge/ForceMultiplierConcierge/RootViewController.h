//
//  RootViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/11/11.
//  Contributions by Dustin Fineout.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.

//

#import <UIKit/UIKit.h>


#import "TabbedViewController.h"
#import "LoginViewController.h"
#import "EventDetailViewController.h"
#import "TDDatePickerController.h"
@class ForceMultiplierConciergeAppDelegate;

//#import "DataAccess.h"

@interface RootViewController : UIViewController <UINavigationControllerDelegate,UITabBarControllerDelegate>{
    /////////////////
    // Controllers //
    /////////////////
    
    // View Controllers
    UINavigationController *navController;
    

    TabbedViewController *tabbedVC;
    EventDetailViewController *eventDetailVC;
    LoginViewController *loginVC;

    
    // Data Controllers
    //DataAccess *daController;
    
    ////////////////
    // Properties //
    ////////////////
    
    
    
    ///////////////
    // IBOUTLETS //
    ///////////////
    
    // Views
    //UIView *view;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *mainContentView;
    IBOutlet UIView *headerContentView;
    IBOutlet UIView *theLegal;
    IBOutlet UIView *screenLock;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    // Images
    IBOutlet UIImageView *theLogo;
    IBOutlet UIImageView *theBackground;
    
    
    IBOutlet UIButton *settings;
    IBOutlet UIButton *cancel;
    
    IBOutlet UILabel *sync;
    IBOutlet UILabel *errorMessage;
    
    IBOutlet UILabel *changeCount;
    IBOutlet UILabel *version;
    
    IBOutlet UIButton *syncPushBtn;
    IBOutlet UIButton *syncPullBtn;
    
}

//@property (nonatomic,retain) IBOutlet UIView *view;

// View Controllers
@property (nonatomic,retain) UINavigationController *navController;
@property (nonatomic,retain) TabbedViewController *tabbedVC;
@property (nonatomic,retain)  EventDetailViewController *eventDetailVC;

@property (nonatomic,retain) LoginViewController *loginVC;


// Data Controllers
//@property (nonatomic,retain) DataAccess *daController;

// Properties


// IBOutlets
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic,retain) IBOutlet UIView *mainContentView;
@property (nonatomic,retain) IBOutlet UIView *headerContentView;
@property (nonatomic,retain) IBOutlet UIView *screenLock;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,retain) IBOutlet UIImageView *theLogo;
@property (nonatomic,retain) IBOutlet UIImageView *theBackground;
@property (nonatomic,retain) IBOutlet UIView *theLegal;
@property (nonatomic,retain) IBOutlet UIButton *settings;
@property (nonatomic,retain) IBOutlet UIButton *cancel;
@property (nonatomic,retain) IBOutlet UILabel *sync;
@property (nonatomic,retain) IBOutlet UILabel *errorMessage;
@property (nonatomic,retain) IBOutlet UILabel *changeCount;
@property (nonatomic,retain) IBOutlet UILabel *version;

@property (nonatomic,retain) IBOutlet UIButton *syncPushBtn;
@property (nonatomic,retain) IBOutlet UIButton *syncPullBtn;

//Methods
-(void)_layoutPage;
-(void)lockScreen;
-(void)unlockScreen;
-(void)syncSucceeded;
-(void)hideSyncStatus;
-(void)showErrorMessage:(NSString*)message;
-(void)hideErrorMessage;

-(IBAction)clickedSettings;
-(IBAction)clickedCancel;
-(IBAction)clickedSync;
-(void)switchButtons;

@end

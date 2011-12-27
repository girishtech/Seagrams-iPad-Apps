//
//  RootViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/11/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "OptinConfirmationViewController.h"
#import "LoginViewController.h"
@class OrderViewController;
@class DataAccess;

//#import "DataAccess.h"

@interface RootViewController : UIViewController <UINavigationControllerDelegate>{
    /////////////////
    // Controllers //
    /////////////////
    
    // View Controllers
    UINavigationController *navController;
    

    OptinConfirmationViewController *optInVC;
    LoginViewController *loginVC;
    OrderViewController *orderVC;
    
    // Data Controllers
    DataAccess *da;
    
    ////////////////
    // Properties //
    ////////////////
    
    
    
    ///////////////
    // IBOUTLETS //
    ///////////////
    
    // Views
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
    IBOutlet UILabel *eventName;
    
    IBOutlet UILabel *legal1;
    IBOutlet UILabel *legal2;
    NSString *emailAddress;
    
}

// View Controllers
@property (nonatomic,retain) UINavigationController *navController;
@property (nonatomic,retain) OptinConfirmationViewController *optInVC;
@property (nonatomic,retain) LoginViewController *loginVC;
@property (nonatomic,retain) OrderViewController *orderVC;
@property (nonatomic,retain) NSString *emailAddress;

// Data Controllers
@property (nonatomic,retain) DataAccess *da;

// Properties


// IBOutlets
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic,retain) IBOutlet UIView *mainContentView;
@property (nonatomic,retain) IBOutlet UIView *headerContentView;
@property (nonatomic,retain) IBOutlet UIImageView *theLogo;
@property (nonatomic,retain) IBOutlet UIImageView *theBackground;
@property (nonatomic,retain) IBOutlet UIView *theLegal;
@property (nonatomic,retain) IBOutlet UIButton *settings;
@property (nonatomic,retain) IBOutlet UIButton *cancel;
@property (nonatomic,retain) IBOutlet UILabel *sync;
@property (nonatomic,retain) IBOutlet UILabel *errorMessage;
@property (nonatomic,retain) IBOutlet UILabel *eventName;
@property (nonatomic,retain) IBOutlet UIView *screenLock;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic,retain) IBOutlet UILabel *legal1;
@property (nonatomic,retain) IBOutlet UILabel *legal2;

//Methods
-(void)_layoutPage;

-(IBAction)clickedSettings;
-(IBAction)clickedCancel;
-(void)switchButtons;
-(void)showErrorMessage:(NSString*)message;
- (void) showTakePhotoViewControllerDelegate:(id) photodelegate;

@end

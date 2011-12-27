//
//  OrderViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 6/1/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmAddressViewController.h"
#import "ThankYouPurchaseViewController.h"
#import "ForceMultiplierAppDelegate.h"
#import "UIPickerViewController.h"
#import "PickerViewController.h"


@interface OrderViewController : UIViewController <UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UIPopoverControllerDelegate,PopoverPickerDelegate>{
    
    NSDictionary *retailerList;
    NSDictionary *productList;
    //NSDictionary *googleList;
    NSInteger currentProduct;
    NSInteger currentRetailer;
    BOOL isSpirits;
    BOOL loadedSpirits;
    
    //Picker
    UIPopoverController *popOverControllerWithPicker;
    UIPopoverController *retailerPopOverControllerWithPicker;
	PickerViewController *pickerViewController;
    
    IBOutlet UIPickerViewController *theProductView;
    IBOutlet UIPickerViewController *theRetailerView;
    IBOutlet UIView *navControllerContainer;
    UINavigationController *navController;
    //IBOutlet UITableView *theLinkView;
    //IBOutlet UIView *theLinkViewContainer;
    IBOutlet UITextField *urlField; 
	IBOutlet UIWebView *webView; 
	IBOutlet UIActivityIndicatorView *spinner; 
    IBOutlet UIButton *fwd;
    IBOutlet UIButton *back;
    IBOutlet UIButton *google;
    IBOutlet UIButton *priceDumper;
    IBOutlet UIButton *windAndSpirits;
    
    IBOutlet UILabel *first;
    IBOutlet UILabel *last;
    IBOutlet UILabel *street;
    IBOutlet UILabel *city;
    IBOutlet UILabel *state;
    IBOutlet UILabel *zip;
    
    NSString *currentPicker;
    IBOutlet UITextField *expression;
    IBOutlet UITextField *search;
    
    BOOL firstLoad;
} 
@property (nonatomic, retain) IBOutlet UITextField *urlField; 
@property (nonatomic, retain) IBOutlet UIWebView *webView; 
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UIPickerViewController *theRetailerView;
@property (nonatomic, retain) IBOutlet UIPickerViewController *theProductView;
@property (nonatomic, retain) NSString *currentPicker;
@property (nonatomic, retain) IBOutlet UIView *navControllerContainer;
@property (nonatomic, retain) UINavigationController *navController;

@property (nonatomic, retain) IBOutlet UITextField *expression;
@property (nonatomic, retain) IBOutlet UITextField *search;
//@property (nonatomic, retain) IBOutlet UITableView *theLinkView;
//@property (nonatomic, retain) IBOutlet UIView *theLinkViewContainer;

@property (nonatomic, retain) IBOutlet UIButton *google;
@property (nonatomic, retain) IBOutlet UIButton *priceDumper;
@property (nonatomic, retain) IBOutlet UIButton *windAndSpirits;
@property (nonatomic, retain) IBOutlet UIButton *fwd;
@property (nonatomic, retain) IBOutlet UIButton *back;

@property (nonatomic, retain) NSDictionary *retailerList;
@property (nonatomic, retain) NSDictionary *productList;
@property (nonatomic, retain) NSDictionary *googleList;

@property (nonatomic, retain) IBOutlet UILabel *first;
@property (nonatomic, retain) IBOutlet UILabel *last;
@property (nonatomic, retain) IBOutlet UILabel *street;
@property (nonatomic, retain) IBOutlet UILabel *city;
@property (nonatomic, retain) IBOutlet UILabel *state;
@property (nonatomic, retain) IBOutlet UILabel *zip;

@property (nonatomic) NSInteger *currentProduct;
@property (nonatomic) NSInteger *currentRetailer;
@property (nonatomic) BOOL isSpirits;
@property (nonatomic) BOOL loadedSpirits;
@property (nonatomic) BOOL firstLoad;

-(IBAction)loadPage; 
-(IBAction)goBack; 
-(IBAction)goForward; 
-(IBAction)loadRetailer:(id)sender;
-(IBAction)loadRetailerSite:(id)sender;
-(void)updateURLfield;

@end

//
//  EventGuestListViewController.h
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/22/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewGridController.h"
#import "AttendeeDetailViewController.h"
#import "TDDatePickerController.h"
@class ForceMultiplierConciergeAppDelegate;
@class DataAccess;

@interface EventGuestListViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet TableViewGridController *gridController;
    
    IBOutlet UITextField *firstName;
    IBOutlet UITextField *lastName;
    IBOutlet UITextField *email;
    IBOutlet UIButton *filterButton;
    
    IBOutlet UILabel *attendedLbl;
    IBOutlet UIButton *attendeeNameBtn;
    
    //AttendeeDetailViewController *eventAttendeeDetailViewCnt;
    //added to test
    IBOutlet UIButton *attendeeSelectBtn;
    NSArray *tempData;
    GSOrderedDictionary *rawDataSet;
    GSOrderedDictionary *sortedDataSet;
    NSMutableDictionary *DataSet;
    NSArray *filterBtns;
    
    NSMutableArray *authorOptions;
    NSMutableArray *eventTimeAuthorOptions;
    
    DataAccess *da;
    
    NSString *timeAuthorID;
    NSString *authorName;
    NSUInteger selectedRow;
}


@property (nonatomic,retain) IBOutlet TableViewGridController *gridController;
@property (nonatomic,retain) NSArray *tempData;
@property (nonatomic,retain) IBOutlet UITextField *firstName;
@property (nonatomic,retain) IBOutlet UITextField *lastName;
@property (nonatomic,retain) IBOutlet UITextField *email;
@property (nonatomic,retain) IBOutlet UIButton *filterButton;
@property (nonatomic,retain) IBOutlet UIButton *addAttendeeButton;

@property (nonatomic,retain) IBOutlet UILabel *attendedLbl;
@property (nonatomic,retain) IBOutlet UIButton *attendeeNameBtn;

//test button
@property (nonatomic, retain) IBOutlet UIButton *attendeeSelectBtn;
//@property (nonatomic, retain) AttendeeDetailViewController *eventAttendeeDetailViewCnt;

@property (nonatomic, retain) GSOrderedDictionary *rawDataSet;
@property (nonatomic, retain) GSOrderedDictionary *sortedDataSet;
@property (nonatomic, retain) NSMutableDictionary *DataSet;
@property (nonatomic, retain) NSArray *filterBtns;
@property (nonatomic, retain) DataAccess *da;

@property (nonatomic, retain) NSMutableArray *authorOptions;
@property (nonatomic, retain) NSMutableArray *eventTimeAuthorOptions;

@property (nonatomic, retain) NSString *timeAuthorID;
@property (nonatomic, retain) NSString *authorName;
@property (nonatomic) NSUInteger selectedRow;

-(IBAction)filter:(id)sender;

//added for the temp button

-(void)updateDisplay;
-(void)buildCheckBoxes;
-(void)didSelectRow:(NSNumber*)rowID;
-(void)buildDataSet;
-(UIButton*)buildCheckBox:(BOOL)selected forColumn:(NSString*)column Row:(NSNumber*)row;
-(void)reloadGrid;
-(void)_updateDisplay;
-(void)updateOptInForRow:(NSNumber*)row withValue:(BOOL)val;
-(void)updateAttendedForRow:(NSNumber*)row withValue:(BOOL)val;
-(IBAction)selectedOptIn:(id)sender;
-(IBAction)selectedAttended:(id)sender;
-(IBAction)filter:(id)sender;
-(IBAction)clearFilters:(id)sender;
-(void)_filter;

@end

//
//  KioskSettingsViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/27/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabbedViewController.h"
#import "TableViewGridController.h"
#import "DataAccess.h"


@interface KioskSettingsViewController : UIViewController <UITextFieldDelegate>{
    TabbedViewController *tabbedVC;
    
    IBOutlet UISegmentedControl *modeControl;
    IBOutlet UISegmentedControl *diagnosticModeControl;
    IBOutlet UITextField *brand;
    IBOutlet UILabel *localCount;
    IBOutlet UILabel *serverCount;
    IBOutlet UILabel *syncDate;
    IBOutlet UILabel *version;
    IBOutlet UITextField *webAddress;
    IBOutlet TableViewGridController *gridController;
    
    //CoreData
    NSManagedObject *person;
    NSManagedObjectContext *context;
    NSDictionary *rawDataSet;
    
    DataAccess *da;
    NSInteger selectedRow;
    
}

@property (nonatomic,retain) TabbedViewController *tabbedVC;

@property (nonatomic,retain) IBOutlet UISegmentedControl *modeControl;
@property (nonatomic,retain) IBOutlet UISegmentedControl *diagnosticModeControl;
@property (nonatomic,retain) IBOutlet UITextField *brand;
@property (nonatomic,retain) IBOutlet UILabel *localCount;
@property (nonatomic,retain) IBOutlet UILabel *serverCount;
@property (nonatomic,retain) IBOutlet UILabel *syncDate;
@property (nonatomic,retain) IBOutlet UILabel *version;
@property (nonatomic,retain) IBOutlet UITextField *webAddress;
@property (nonatomic,retain) IBOutlet TableViewGridController *gridController;

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSManagedObject *person;

@property (nonatomic, retain) DataAccess *da;
@property (nonatomic, retain) NSDictionary *rawDataSet;

@property (nonatomic) NSInteger selectedRow;

-(IBAction) clickedSave;
-(IBAction) sync;
-(IBAction) changeMode:(id)sender;
-(IBAction) selectEvent;
-(IBAction) testsync;

-(void)_sync;

@end

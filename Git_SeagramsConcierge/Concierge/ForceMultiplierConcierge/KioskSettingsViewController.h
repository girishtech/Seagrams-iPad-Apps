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

@class ForceMultiplierConciergeAppDelegate;


@interface KioskSettingsViewController : UIViewController{
    TabbedViewController *tabbedVC;
    
    IBOutlet UISegmentedControl *modeControl;
    IBOutlet UITextField *brand;
    IBOutlet UILabel *localCount;
    IBOutlet UILabel *serverCount;
    IBOutlet UILabel *syncDate;
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
@property (nonatomic,retain) IBOutlet UITextField *brand;
@property (nonatomic,retain) IBOutlet UILabel *localCount;
@property (nonatomic,retain) IBOutlet UILabel *serverCount;
@property (nonatomic,retain) IBOutlet UILabel *syncDate;
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

@end

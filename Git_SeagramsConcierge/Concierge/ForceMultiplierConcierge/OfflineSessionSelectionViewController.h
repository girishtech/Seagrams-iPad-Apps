//
//  OfflineSessionSelectionViewController.h
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/24/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewGridController.h"
#import "DataAccess.h"

@class EventDetailViewController;

@interface OfflineSessionSelectionViewController : UIViewController {
    IBOutlet UITextField *brand;
    IBOutlet TableViewGridController *gridController;
    NSArray *tempData;
    //CoreData
    NSManagedObject *person;
    NSManagedObjectContext *context;
    
    DataAccess *da;
    
    //viewcontroller
    
    EventDetailViewController *eventViewCnt;
    UIButton *eventSelectBtn;
}
@property (nonatomic, retain) IBOutlet UIButton *eventSelectBtn;
@property (nonatomic,retain) EventDetailViewController *eventViewCnt;
@property (nonatomic,retain) NSArray *tempData;
@property (nonatomic,retain) IBOutlet UITextField *brand;
@property (nonatomic,retain) IBOutlet TableViewGridController *gridController;

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSManagedObject *person;

@property (nonatomic, retain) DataAccess *da;

//-(IBAction) clickedSave;
//-(IBAction) sync;
//-(IBAction) changeMode:(id)sender;
- (IBAction) selectEvent;
- (IBAction) syncEvent;
- (IBAction) syncAll;
-(IBAction)eventItemSelect:(id)sender;

@end

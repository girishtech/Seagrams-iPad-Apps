//
//  OnlineSessionEnableViewController.h
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/24/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewGridController.h"
#import "DataAccess.h"


@interface OnlineSessionEnableViewController : UIViewController {
    IBOutlet UITextField *brand;
    IBOutlet TableViewGridController *gridController;
    
    //CoreData
    NSManagedObject *person;
    NSManagedObjectContext *context;
    
    DataAccess *da;
}

@property (nonatomic,retain) IBOutlet UITextField *brand;
@property (nonatomic,retain) IBOutlet TableViewGridController *gridController;

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSManagedObject *person;

@property (nonatomic, retain) DataAccess *da;

//-(IBAction) clickedSave;
//-(IBAction) sync;
//-(IBAction) changeMode:(id)sender;
- (IBAction) enableEvent;

@end

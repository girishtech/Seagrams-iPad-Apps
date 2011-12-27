//
//  AttendeeGuestListViewController.h
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/22/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewGridController.h"

@interface AttendeeGuestListViewController : UIViewController {
    IBOutlet TableViewGridController *gridController;
    
}

@property (nonatomic,retain) IBOutlet TableViewGridController *gridController;

@end

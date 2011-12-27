//
//  AttendeeStatsViewController.h
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/22/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewGridController.h"

@interface AttendeeStatsViewController : UIViewController {
    IBOutlet TableViewGridController *gridController;
    
    IBOutlet UILabel *firstAttendedDate;
    IBOutlet UILabel *lastAttendedDate;
    IBOutlet UILabel *age;
}

@property (nonatomic,retain) IBOutlet TableViewGridController *gridController;

@property (nonatomic,retain) IBOutlet UILabel *firstAttendedDate;
@property (nonatomic,retain) IBOutlet UILabel *lastAttendedDate;
@property (nonatomic,retain) IBOutlet UILabel *age;

@end

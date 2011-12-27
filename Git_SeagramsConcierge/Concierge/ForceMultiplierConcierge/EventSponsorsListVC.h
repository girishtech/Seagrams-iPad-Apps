//
//  EventSponsorsListVC.h
//  ForceMultiplierConcierge
//
//  Created by Phil Sacchitella on 7/4/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TableViewGridController.h"

@interface EventSponsorsListVC : UIViewController {
    IBOutlet TableViewGridController *gridController;
}

@property (nonatomic,retain) IBOutlet TableViewGridController *gridController;
@end

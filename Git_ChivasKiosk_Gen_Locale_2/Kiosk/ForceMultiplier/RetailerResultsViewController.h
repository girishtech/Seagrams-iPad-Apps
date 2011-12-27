//
//  RetailerResultsViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/31/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewGridController.h"
#import "GSOrderedDictionary.h"
#import "ForceMultiplierAppDelegate.h"
#import "OrderViewController.h"

@interface RetailerResultsViewController : UIViewController {
    IBOutlet TableViewGridController *gridController;
}

@property (nonatomic,retain) IBOutlet TableViewGridController *gridController;

@end

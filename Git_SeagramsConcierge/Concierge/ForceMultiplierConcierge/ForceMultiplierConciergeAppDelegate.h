@class HomeViewController;
@class BlankViewController;//
//  ForceMultiplierConciergeAppDelegate.h
//  ForceMultiplierConcierge
//
//  Created by Garrett Shearer on 6/17/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AuthorizedConnector.h"
#import "DataAccess.h"
//#import "RootViewController.h" 
@class RootViewController;
@class HomeViewController;
@class BlankViewController;


@interface ForceMultiplierConciergeAppDelegate : NSObject <UIApplicationDelegate> {
    BlankViewController *blankVC;
    RootViewController *rootVC;
    HomeViewController *homeVC;
    AuthorizedConnector *web;
    DataAccess *da;
    UIViewController *currentVC;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) BlankViewController *blankVC;
@property (nonatomic, retain) HomeViewController *homeVC;
@property (nonatomic, retain) RootViewController *rootVC;
@property (nonatomic, retain) AuthorizedConnector *web;
@property (nonatomic, retain) DataAccess *da;

@property (nonatomic, retain) UIViewController *currentVC;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

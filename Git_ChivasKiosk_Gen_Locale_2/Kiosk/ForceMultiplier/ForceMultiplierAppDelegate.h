//
//  ForceMultiplierAppDelegate.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/3/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AuthorizedConnector.h"
#import "DataAccess.h"

// shahab open
@class KioskSettingsViewController;
// shahab close

@class RootViewController; 
@class HomeViewController;
@class BlankViewController;


@interface ForceMultiplierAppDelegate : NSObject <UIApplicationDelegate> {
    BlankViewController *blankVC;
    RootViewController *rootVC;
    HomeViewController *homeVC;
    AuthorizedConnector *web;
    DataAccess *da;
    BOOL optIn;
    // shahab open
    BOOL userIsLoggedIn;
    KioskSettingsViewController *settingsVw;
    // shahab close
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) BlankViewController *blankVC;
@property (nonatomic, retain) HomeViewController *homeVC;
@property (nonatomic, retain) RootViewController *rootVC;
@property (nonatomic, retain) AuthorizedConnector *web;
@property (nonatomic, retain) DataAccess *da;

// shahab open
@property (nonatomic, assign) BOOL userIsLoggedIn;
@property (nonatomic, retain) KioskSettingsViewController *settingsVw;
// shahab close

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic) BOOL optIn;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

// shahab open

-(BOOL) autoLogin;
- (void) showTakePhotoViewController;
// shahab close


@end

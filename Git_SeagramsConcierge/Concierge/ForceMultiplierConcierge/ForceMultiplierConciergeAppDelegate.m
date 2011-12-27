//
//  ForceMultiplierConciergeAppDelegate.m
//  ForceMultiplierConcierge
//
//  Created by Garrett Shearer on 6/17/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import "ForceMultiplierConciergeAppDelegate.h"
#import "RootViewController.h"
#import "HomeViewController.h"
#import "BlankViewController.h"

@implementation ForceMultiplierConciergeAppDelegate


@synthesize window=_window;

@synthesize managedObjectContext=__managedObjectContext;

@synthesize managedObjectModel=__managedObjectModel;

@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

@synthesize rootVC, currentVC, blankVC, homeVC;

@synthesize web, da;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    //Force Orientation change with StatusBar (Hacky but actually works)
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice beginGeneratingDeviceOrientationNotifications];

    web = [[AuthorizedConnector alloc] init];
    da = [[DataAccess alloc] init];
    web.dataAccess = da;
    da.web = web;
    
       
    //CHECK DEFAULTS AND CREATE IF NEEDED
    [da getDefaults];
    /*
    NSLog(@"Build RootViewController");
    // Override point for customization after application launch.
    rootVC = [[RootViewController alloc] initWithNibName:@"RootViewController_Landscape" bundle:nil];
    
    /*
    NSLog(@"Animate in RootViewController");
    /* ANIMATE IN ROOTVIEWCONTROLLER */ 
    /*

    // Create animation
    CATransition *applicationLoadViewIn =[CATransition animation];
    // Set animation properties
    [applicationLoadViewIn setDuration:1.0];
    [applicationLoadViewIn setType:kCATransitionPush];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    // Add animation to view
    [[rootVC.view layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    
    // Add view to screen and make visible
    [self.window addSubview:rootVC.view];
    [self.window makeKeyAndVisible];
    
    NSLog(@"Made Window Visible");
    
    [self.rootVC.view setNeedsDisplay];
    [self.rootVC.view setNeedsLayout];
    
    NSLog(@"Forced RootView ReLayout");
    */
    
    // Override point for customization after application launch.
    blankVC = [[BlankViewController alloc] initWithNibName:@"BlankViewController" bundle:nil];
    
    
    // Add view to screen and make visible
    [self.window addSubview:blankVC.view];
    [self.window makeKeyAndVisible];
    
    [self.window setNeedsDisplay];
    [self.window setNeedsLayout];
    
    //[self buildRootView];
    [self buildHomeView];
    
    NSLog(@"System fonts: \n %@",[UIFont familyNames]);
    NSLog(@"Gotham fonts: \n %@",[UIFont fontNamesForFamilyName:@"Gotham-Medium"]);
    return YES;    
}

-(void)buildHomeView
{
    if(homeVC==nil){
        // Override point for customization after application launch.
        homeVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        
        // Add view to screen and make visible
        [blankVC.view addSubview:homeVC.view];
    }else{
        [blankVC.view bringSubviewToFront:homeVC.view];
    }
    
    [homeVC startTicks];
    
    NSLog(@"move from buildHomeView");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentVersion = CURRENTVERSION;
    
    if([defaults objectForKey:@"concierge_version"] != nil){
        if(![[defaults objectForKey:@"concierge_version"] isEqualToString:@""]){
            if(![[defaults objectForKey:@"concierge_version"] isEqualToString:currentVersion]){
                //[homeVC lock];
                //[da performSelectorInBackground:@selector(moveAndQueueAllData) withObject:nil];
                [defaults setValue:currentVersion forKey:@"concierge_version"];
            }
        }else{
            //[homeVC lock];
            //[da performSelectorInBackground:@selector(moveAndQueueAllData) withObject:nil];
            [defaults setValue:currentVersion forKey:@"concierge_version"];
        }
    }else{
        //[homeVC lock];
        //[da performSelectorInBackground:@selector(moveAndQueueAllData) withObject:nil];
        [defaults setValue:currentVersion forKey:@"concierge_version"]; 
    }

    [homeVC.view setHidden:NO];
    
    
    [self.window setNeedsDisplay];
    [self.window setNeedsLayout];
    [self.blankVC.view setNeedsDisplay];
    [self.blankVC.view setNeedsLayout];
    [self.homeVC.view setNeedsDisplay];
    [self.homeVC.view setNeedsLayout]; 
}

-(void)buildRootView
{
    if(rootVC==nil){
        // Override point for customization after application launch.
        rootVC = [[RootViewController alloc] initWithNibName:@"RootViewController_Landscape" bundle:nil];
        
        
        /* ANIMATE IN ROOTVIEWCONTROLLER */ 
        // Create animation
        CATransition *applicationLoadViewIn =[CATransition animation];
        // Set animation properties
        [applicationLoadViewIn setDuration:1.0];
        [applicationLoadViewIn setType:kCATransitionFade];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        // Add animation to view
        [[rootVC.view layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
        
        // Add view to screen and make visible
        //[self.homeVC.view addSubview:rootVC.view];
        [self.blankVC.view addSubview:rootVC.view];
        //[self.homeVC.view makeKeyAndVisible];
        
        [self.blankVC.view setNeedsDisplay];
        [self.blankVC.view setNeedsLayout];
        
        //CGRect frame = self.window.frame;
        
        /*8
         if([myDevice orientation] == UIDeviceOrientationLandscapeLeft || [myDevice orientation] == UIDeviceOrientationLandscapeRight)
         {
         frame.origin.y = 20.0f;
         frame.origin.x = 0.0f;
         }
         else
         {
         if([myDevice orientation] == UIDeviceOrientationPortrait || [myDevice orientation] == 0)
         {
         frame.origin.y = 20.0f;
         frame.size.height = frame.size.height - 20.0f;
         frame.origin.x = 0.0f;
         }
         else
         {
         frame.origin.y = 20.0f;
         frame.origin.x = 0.0f;
         }
         }
         
         self.rootVC.view.frame = frame;
         */
        //self.rootVC.view.frame = frame;
        [self.rootVC.view setNeedsDisplay];
        [self.rootVC.view setNeedsLayout]; 
        
        
    }else{
        /*
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if([defaults objectForKey:@"kiosk_currentSession"] != nil){
            if(![[defaults objectForKey:@"kiosk_currentSession"] isEqualToString:@""]){
                [rootVC.navController popToRootViewControllerAnimated:YES];
            }
        }
        */
        [blankVC.view bringSubviewToFront:rootVC.view];
        [rootVC.navController popToRootViewControllerAnimated:YES];    
        [[rootVC.navController.viewControllers objectAtIndex:0]clearFields];
    }
    
    [homeVC stopTimer];
    [homeVC.view setHidden:YES];
    
    
    
    [self.window setNeedsDisplay];
    [self.window setNeedsLayout];
    
    [self.blankVC.view setNeedsDisplay];
    [self.blankVC.view setNeedsLayout];
    
    [self.rootVC.view setNeedsDisplay];
    [self.rootVC.view setNeedsLayout]; 
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [self buildHomeView];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [self buildHomeView];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)dealloc
{
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [super dealloc];
}

- (void)awakeFromNib
{
    /*
     Typically you should set up the Core Data stack here, usually by passing the managed object context to the first view controller.
     self.<#View controller#>.managedObjectContext = self.managedObjectContext;
    */
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ForceMultiplierConcierge" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
/*
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ForceMultiplierConcierge.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
     /*   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}
*/

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    
    NSString *storePath = [[[self applicationDocumentsDirectory]absoluteString] stringByAppendingPathComponent: @"ForceMultiplierConcierge.sqlite"];
    
    NSLog(@"storePath: %@",storePath);
    
    /*
     Set up the store.
     For the sake of illustration, provide a pre-populated default store.
     */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:storePath]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"ForceMultiplierConcierge"      ofType:@"sqlite"];
        if (defaultStorePath) {
            [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
        }
    }
    
    NSURL *storeUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent: @"ForceMultiplierConcierge.sqlite"];
    
    NSLog(@"storeURL: %@", [storeUrl absoluteString]);
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES], 
                                                                        NSMigratePersistentStoresAutomaticallyOption, 
                                                                        [NSNumber numberWithBool:YES], 
                                                                        NSInferMappingModelAutomaticallyOption,
                                                                        [NSNumber numberWithBool:YES],
                                                                        NSInferMappingModelAutomaticallyOption, nil]; 
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    NSError *error;
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }    
    
    return __persistentStoreCoordinator;
}
#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

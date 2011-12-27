//
//  ForceMultiplierAppDelegate.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/3/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//


#import "ForceMultiplierAppDelegate.h"
#import "RootViewController.h"
#import "HomeViewController.h"
#import "BlankViewController.h"
//#import "AuthorizedConnector.h"
#import "TakePhotoViewController.h"

@implementation ForceMultiplierAppDelegate


@synthesize window=_window;

@synthesize managedObjectContext=__managedObjectContext;

@synthesize managedObjectModel=__managedObjectModel;

@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

@synthesize rootVC, homeVC, blankVC;

@synthesize web, da, optIn;

// shahab open
@synthesize userIsLoggedIn;
@synthesize settingsVw;
// shahab close


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice beginGeneratingDeviceOrientationNotifications];
    
    web = [[AuthorizedConnector alloc] init];
    da = [[DataAccess alloc] init];
    
    // shahab open
    self.userIsLoggedIn = NO;
    // shahab close
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentVersion = CURRENTVERSION;
    
    if([defaults objectForKey:@"kiosk_version"] != nil){
        if(![[defaults objectForKey:@"kiosk_version"] isEqualToString:@""]){
            if(![[defaults objectForKey:@"kiosk_version"] isEqualToString:currentVersion]){
                //[da moveAndQueueAllData];
                [defaults setValue:currentVersion forKey:@"kiosk_version"];
            }
        }else{
            //[da moveAndQueueAllData];
            [defaults setValue:currentVersion forKey:@"kiosk_version"];
        }
    }else{
        //[da moveAndQueueAllData];
        [defaults setValue:currentVersion forKey:@"kiosk_version"]; 
    }
    
    //CHECK DEFAULTS AND CREATE IF NEEDED
    //[da getDefaults];
    //[da setPeopleDefaults];
    
    optIn = YES;
    
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
    NSLog(@"TradeGothic LT CondEighteen fonts: \n %@",[UIFont fontNamesForFamilyName:@"TradeGothic LT CondEighteen"]);
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
        CGRect frame = self.window.frame;
        
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
        //[rootVC hideSettings];
        [self.rootVC.view setNeedsDisplay];
        [self.rootVC.view setNeedsLayout]; 
    
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if([defaults objectForKey:@"kiosk_currentSession"] != nil){
            if(![[defaults objectForKey:@"kiosk_currentSession"] isEqualToString:@""]){
                [rootVC.navController popToRootViewControllerAnimated:YES];
            }
        }
        
        [blankVC.view bringSubviewToFront:rootVC.view];
        [rootVC showSettings];
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
    if(da.currentSession != nil)
    {
        if(![da.currentSession isEqualToString:@""]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:da.currentSession forKey:@"kiosk_currentSession"];
        }
    }
    
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
    //[homeVC stopTimer];
    /*if(da.currentSession != nil){
        if([da.currentSession isEqualToString:@""]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if([defaults objectForKey:@"kiosk_currentSession"]!=nil){
                if(![[defaults objectForKey:@"kiosk_currentSession"]isEqualToString:@""]){
                    da.currentSession = [defaults objectForKey:@"kiosk_currentSession"];
                    NSLog(@"current session for NSUserDefaults: %@"
                }
            }
        }
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        da.currentSession = [defaults objectForKey:@"kiosk_currentSession"]; 
    }*/
    NSLocale *locale = [NSLocale currentLocale];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(language);
    
    
    if([language isEqualToString:@"en"]){
        //DEV
        if(RELEASE == 0) da.brandID = STUDYID_DEV_ENG;
        //STAGING
        if(RELEASE == 1) da.brandID = STUDYID_STG_ENG;
        //PRODUCTION
        if(RELEASE == 2) da.brandID = STUDYID_PROD_ENG;
    }else{
        //DEV
        if(RELEASE == 0) da.brandID = STUDYID_DEV_ES;
        //STAGING
        if(RELEASE == 1) da.brandID = STUDYID_STG_ES;
        //PRODUCTION
        if(RELEASE == 2) da.brandID = STUDYID_PROD_ES;
    }
    
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
    /*rootVC = [[RootViewController alloc] initWithNibName:"RootViewController.xib" bundle:nil];*/
}

-(void)saveContext
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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ForceMultiplier" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ForceMultiplier.sqlite"];
        
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
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
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
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

// shahab open

-(BOOL) autoLogin
{
    NSError *errorLoggingIn = nil;
    NSArray *logins = nil;
    NSError *errorSavingLogin = nil;
    ///*
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[self managedObjectContext]];
    
    //[sessionEntity setValue:[session valueForKey:@"TimeID"] forKey:@"TimeID"];
    
    NSFetchRequest *allLoginRequest = [[NSFetchRequest alloc] init];
    [allLoginRequest setEntity:userEntity];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:
//                              @"(Username = %@) AND (Password = %@)", user,pass];
//    [allLoginRequest setPredicate:predicate];
    
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    logins = [[self managedObjectContext] executeFetchRequest:allLoginRequest error:&errorLoggingIn];
    
    NSEnumerator *loginEnumerator = [logins objectEnumerator];
    NSManagedObject *tmp;
    
    
    //check if we got back a user, if so trigger login method
    if([logins count]>0){
        if(tmp = [loginEnumerator nextObject] != nil)
        {
            NSDictionary *dict = [logins objectAtIndex:0];
            NSString *username = [dict valueForKey:@"Username"];
            NSString *password = [dict valueForKey:@"Password"];
            //NSLog(str);
            return YES;
        }

    }else{
        //Login failed from local db, check on server
        return NO;
    }
    
}

- (void) showTakePhotoViewController {
    TakePhotoViewController *takePhoto = [[TakePhotoViewController alloc] initWithNibName:@"TakePhotoViewController" bundle:nil];
    //takePhoto.view.frame = CGRectMake(0, 0,1024, 1024);
    [self.window addSubview:takePhoto.view];
    //[takePhoto release];
}

// shahab close

@end

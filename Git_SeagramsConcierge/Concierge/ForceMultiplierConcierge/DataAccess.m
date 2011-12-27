
//
//  DataAccess.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/13/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "DataAccess.h"
#import "GSOrderedDictionary.h"
#import "LoginViewController.h"

@implementation DataAccess

@synthesize currentAuthorID,currentTimeID,brandID,web;

-(id)init
{
    [super init];

    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    coordinator = [appDelegate persistentStoreCoordinator];
    web = [appDelegate web];
    
    //Production
    //DEV
    if(RELEASE == 0) self.brandID = STUDYID_DEV_ENG;
    //STAGING
    if(RELEASE == 1) self.brandID = STUDYID_STG_ENG;
    //PRODUCTION
    if(RELEASE == 2) self.brandID = STUDYID_PROD_ENG;
    
    self.currentTimeID = @""; // @"0a31eadc-46ac-440b-952f-8e1121a5bf4d";
    self.currentAuthorID = @"";
    
    //Dev
    //self.brandID = @"103";
    self.currentTimeID = @"";
    
    return self;
}

#pragma mark - Settings/Methods Methods

-(BOOL)loginWithUser:(NSString*)user Password:(NSString*)pass forVC:(LoginViewController*)vc
{
    NSError *errorLoggingIn = nil;
    NSArray *logins = nil;
    NSError *errorSavingLogin = nil;
    ///*
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    
    //[sessionEntity setValue:[session valueForKey:@"TimeID"] forKey:@"TimeID"];
    
    NSFetchRequest *allLoginRequest = [[NSFetchRequest alloc] init];
    [allLoginRequest setEntity:userEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(Username = %@) AND (Password = %@)", user,pass];
    [allLoginRequest setPredicate:predicate];
    
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    logins = [context executeFetchRequest:allLoginRequest error:&errorLoggingIn];
    
    NSEnumerator *loginEnumerator = [logins objectEnumerator];
    NSManagedObject *tmp;
    //NSLog(@"logins: %@",logins);
    
    //check if we got back a user, if so trigger login method
    if([logins count]>0){
        if(tmp = [loginEnumerator nextObject] != nil)
        {
            //NSLog(@"existing user creds: %@", tmp);
            [vc loginSuccessful];
        }
    }else{
        //Login failed from local db, check on server
        [web loginAndGetStudiesWithUser:user Password:pass withVC:vc];
    }
    
}

-(BOOL)saveUser:(NSString*)user Password:(NSString*)pass
{
    NSError *errorLoggingIn = nil;
    NSArray *logins = nil;
    NSError *errorSavingLogin = nil;
    ///*
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    
    //[sessionEntity setValue:[session valueForKey:@"TimeID"] forKey:@"TimeID"];
    
    NSFetchRequest *allLoginRequest = [[NSFetchRequest alloc] init];
    [allLoginRequest setEntity:userEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(Username = %@) AND (Password = %@)", user,pass];
    [allLoginRequest setPredicate:predicate];
    
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    logins = [context executeFetchRequest:allLoginRequest error:&errorLoggingIn];
    
    NSEnumerator *loginEnumerator = [logins objectEnumerator];
    NSManagedObject *tmp;
    
    
    //check if we got back a user, if so trigger login method
    if([logins count]>0){
        if(tmp = [loginEnumerator nextObject] != nil)
        {
            //NSLog(@"existing user creds: %@", tmp);
            //[vc loginSuccessful];
        }
    }else{
        //Add Entry to DB
        NSManagedObject *login = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        [login setValue:user forKey:@"Username"];
        [login setValue:pass forKey:@"Password"];
        [login setValue:@"first" forKey:@"FirstName"];
        [login setValue:@"last" forKey:@"LastName"];
        
        //NSLog(@"new user creds: %@", login);
        
        if (login!=nil && [context save:&errorSavingLogin] == NO) {
            
        }
    }
    
}


-(void)getDefaults
{
    NSLog(@"setDefaults");
    
    NSError *errorGettingSettings = nil;
    NSArray *settings = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *settingEntity = [NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    
    NSFetchRequest *settingRequest = [[NSFetchRequest alloc] init];
    [settingRequest setEntity:settingEntity];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    settings = [context executeFetchRequest:settingRequest error:errorGettingSettings];
    
    NSEnumerator *settingEnumerator = [settings objectEnumerator];
    //NSManagedObject *tmp;
    
    if(!([[settingEnumerator allObjects] count] > 0)){
        NSManagedObject *setting = nil;
        
        setting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:context];
        
        [setting setValue:[NSNumber numberWithInt:2] forKey:@"Mode"];
        [setting setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"LastSyncTS"];
        
        //NSError *errorSavingPerson = nil;
        if (setting!=nil && [context save:errorGettingSettings] == NO) {
           // [context deleteObject:setting];
            
            setting = nil;
        }
    }
        
    // Clean up and return.
    
    [settingRequest release];
    
    //*/
   // NSLog(@"peopleData: %@",peopleData);
}


-(NSNumber*)getMode
{
    NSLog(@"setDefaults");
    
    NSError *errorGettingSettings = nil;
    NSArray *settings = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *settingEntity = [NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    
    NSFetchRequest *settingRequest = [[NSFetchRequest alloc] init];
    [settingRequest setEntity:settingEntity];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    settings = [context executeFetchRequest:settingRequest error:errorGettingSettings];
    
    NSEnumerator *settingEnumerator = [settings objectEnumerator];
    NSManagedObject *tmp;
    
    int mode = 2;
    
    while ((tmp = [settingEnumerator nextObject]) != nil) {
        mode = [[tmp valueForKey:@"Mode"]integerValue];
    }

    
    // Clean up and return.
    
    [settingRequest release];
    
    return [NSNumber numberWithInt:mode];
}

-(void)changeMode:(NSNumber*)value
{
    NSError *errorGettingSettings = nil;
    NSArray *settings = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *settingEntity = [NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    
    NSFetchRequest *settingRequest = [[NSFetchRequest alloc] init];
    [settingRequest setEntity:settingEntity];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    settings = [context executeFetchRequest:settingRequest error:errorGettingSettings];
    [context obtainPermanentIDsForObjects:settings error:errorGettingSettings];
    
    NSEnumerator *settingEnumerator = [settings objectEnumerator];
    NSManagedObject *tmp;
    
    while ((tmp = [settingEnumerator nextObject]) != nil) {
        NSString *tempID = [self uniqueObjectURIString:tmp];
        NSManagedObject *setting = nil;
        
        setting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:context];
        
        [setting setValue:value forKey:@"Mode"];
        [setting setValue:[tmp valueForKey:@"LastSyncTS"] forKey:@"LastSyncTS"];
        
        NSError *errorSavingPerson = nil;
        if (setting!=nil && [context save:errorGettingSettings] == NO) {
            //[context deleteObject:setting];
            
            setting = nil;
        }
        
        [self deleteObjectForURIString:tempID];
    }
        
        
    NSError *errorSavingSetting = nil;
    if (tmp!=nil && [context save:errorSavingSetting] == NO) {
       // [context deleteObject:tmp];
        tmp = nil;
    }
    
    
    // Clean up and return.
    
    [settingRequest release];
}

-(void)setWebAddress:(NSString*)address
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:address forKey:@"ws_url"];
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[appDelegate web] setWS_URL:address];
}

-(NSInteger*)changeCount
{
    NSLog(@"eventTimeIDsForPush");
    
    NSError *errorFetchingPeople = nil;
    NSArray *queue_people = nil;
    NSArray *sent_people = nil;
    
    // Create a request to fetch all Authors present in the 'Queue' Table
    NSEntityDescription *sentPersonEntity = [NSEntityDescription entityForName:@"Trans_Sent_Author" inManagedObjectContext:context];
    
    NSFetchRequest *sentPeopleRequest = [[NSFetchRequest alloc] init];
    [sentPeopleRequest setEntity:sentPersonEntity];
    [sentPeopleRequest setReturnsObjectsAsFaults:NO];    
    sent_people = [context executeFetchRequest:sentPeopleRequest error:&errorFetchingPeople];
    
    
    
    // Create a request to fetch all Queued Authors NOT present in the 'Sent' Table
    NSEntityDescription *queuePersonEntity = [NSEntityDescription entityForName:@"Trans_Queue_Author" inManagedObjectContext:context];
    
    NSFetchRequest *queuePeopleRequest = [[NSFetchRequest alloc] init];
    [queuePeopleRequest setEntity:queuePersonEntity];
    [queuePeopleRequest setReturnsObjectsAsFaults:NO];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(NOT (self IN %@))",sent_people];
    [queuePeopleRequest setPredicate:pred];
    [queuePeopleRequest setPropertiesToFetch:[NSArray arrayWithObject:@"TimeID"]];
    [queuePeopleRequest setReturnsDistinctResults:YES];
    
    
    queue_people = [context executeFetchRequest:queuePeopleRequest error:&errorFetchingPeople];
    
    // Clean up and return.
    [queuePeopleRequest release];
    [sentPeopleRequest release];
    
    
    return [queue_people count];//[NSMutableArray arrayWithCapacity:0];//peopleData;
}

#pragma mark - 

-(BOOL)loginWithUser:(NSString*)user Password:(NSString*)pass{
    NSError *errorLoggingIn = nil;
    NSArray *logins = nil;
    NSError *errorSavingLogin = nil;
    ///*
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    
    //[sessionEntity setValue:[session valueForKey:@"TimeID"] forKey:@"TimeID"];
    
    NSFetchRequest *allLoginRequest = [[NSFetchRequest alloc] init];
    [allLoginRequest setEntity:userEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(Username == '%@') AND (Password == '%@')", user,pass];
    [allLoginRequest setPredicate:predicate];
    
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    logins = [context executeFetchRequest:allLoginRequest error:errorLoggingIn];
    
    NSEnumerator *loginEnumerator = [logins objectEnumerator];
    NSManagedObject *tmp;
    
    [allLoginRequest release];
    
    if([logins count]>0){
        if(tmp = [loginEnumerator nextObject] != nil)
        {
            return YES;
        }
    }else{
        
        NSLog(@"login failed");
        [web loginAndGetStudiesWithUser:user Password:pass];
        return NO;
    }

}



-(void)addAuthors:(NSArray*)authors
{
    NSLog(@"addAuthors");
    for(NSMutableDictionary *author in [authors objectForKey:@"EventTimeAuthors"])
    {
        NSLog(@"addAuthor");
        [self addAuthor:author];
    }
}

-(void)addAuthorDetails:(NSArray*)authorDetails
{
    NSLog(@"addAuthorDetails");
    for(NSMutableDictionary *authorDetail in authorDetails)
    {
        NSLog(@"addAuthoDetail");
        [self addAuthorDetail:authorDetail];
    }
}

-(void)addAuthor:(NSMutableDictionary*)author
{
    NSLog(@"addAuthor: %@", author);
    //CHECK FOR QUEUED EVENTTIMEAUTHOR, ADD TO SENT
    
    NSError *errorFetchingPeople = nil;
    NSArray *people = nil;
    /*
     // Create a request to fetch all Chefs.
     
     NSEntityDescription *personEntity = [NSEntityDescription entityForName:@"Trans_Queue_Author" inManagedObjectContext:context];
     
     NSFetchRequest *allPeopleRequest = [[NSFetchRequest alloc] init];
     [allPeopleRequest setEntity:personEntity];
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID = %@)", [author valueForKey:@"AuthorID"]];
     [allPeopleRequest setPredicate:predicate];
     
     // Ask the context for everything matching the request.
     // If an error occurs, the context will return nil and an error in *error.
     
     people = [context executeFetchRequest:allPeopleRequest error:&errorFetchingPeople];
     
     NSEnumerator *peopleEnumerator = [people objectEnumerator];
     NSManagedObject *tmp;
     
     
     NSMutableArray *peopleData = [[NSMutableArray alloc] initWithCapacity:0];
     //*
     while ((tmp = [peopleEnumerator nextObject]) != nil) {
     //ADD ENTRY TO THE 'SENT' TABLE SO AUTHOR DOESN'T GET PUSHED AGAIN
     NSEntityDescription *authorDetail_sent = [NSEntityDescription insertNewObjectForEntityForName:@"Trans_Sent_Author" inManagedObjectContext:context];
     NSError *errorSavingPerson = nil;
     
     [authorDetail_sent setValue:[author valueForKey:@"AuthorID"] forKey:@"AuthorID"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorStudyID"] forKey:@"AuthorStudyID"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorName"] forKey:@"AuthorName"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorFirstName"] forKey:@"AuthorFirstName"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorLastName"] forKey:@"AuthorLastName"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorAge"] forKey:@"AuthorAge"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorGender"] forKey:@"AuthorGender"];
     [authorDetail_sent setValue:[author valueForKey:@"LanguageID"] forKey:@"LanguageID"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorLocation"] forKey:@"AuthorLocation"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorCity"] forKey:@"AuthorCity"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorState"] forKey:@"AuthorState"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorZip"] forKey:@"AuthorZip"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorZip4"] forKey:@"AuthorZip4"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorDateCreated"] forKey:@"AuthorDateCreated"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorDateUpdated"] forKey:@"AuthorDateUpdated"];
     [authorDetail_sent setValue:[author valueForKey:@"CountryID"] forKey:@"CountryID"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorCredabilityScore"] forKey:@"AuthorCredabilityScore"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorCompanyName"] forKey:@"AuthorCompanyName"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorTitle"] forKey:@"AuthorTitle"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorEmail"] forKey:@"AuthorEmail"];
     [authorDetail_sent setValue:[author valueForKey:@"UserManaged"] forKey:@"UserManaged"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorDOB"] forKey:@"AuthorDOB"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorStreet1"] forKey:@"AuthorStreet1"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorStreet2"] forKey:@"AuthorStreet2"];
     [authorDetail_sent setValue:[author valueForKey:@"AuthorCountry"] forKey:@"AuthorCountry"];
     [authorDetail_sent setValue:[author valueForKey:@"RemoteSystemID"] forKey:@"RemoteSystemID"];
     [authorDetail_sent setValue:[author valueForKey:@"MetaData1"] forKey:@"MetaData1"];
     [authorDetail_sent setValue:[author valueForKey:@"MetaData2"] forKey:@"MetaData2"];
     [authorDetail_sent setValue:[author valueForKey:@"ProvinceID"] forKey:@"ProvinceID"];
     
     
     if (authorDetail_sent!=nil && [context save:&errorSavingPerson] == NO) {
     authorDetail_sent = nil;
     }
     
     break;
     }*/
    
    //ADD TO MAIN TABLE
    NSError *errorFetchingAuthors = nil;
    NSArray *authors = nil;
    NSManagedObject *tmp;
    
    //[web RegistrationCountForAuthorID:[author valueForKey:@"AuthorID"]];
    
    
    // Create a request to fetch all Authors.
    
    NSEntityDescription *authorEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
    
    NSFetchRequest *allAuthorsRequest = [[NSFetchRequest alloc] init];
    [allAuthorsRequest setEntity:authorEntity];
    
    //Set a predicate to search for the primary key
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID == %@) AND (TimeID == %@)",[author valueForKey:@"AuthorID"],[author valueForKey:@"TimeID"]];
    [allAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    authors = [context executeFetchRequest:allAuthorsRequest error:errorFetchingAuthors];
    
    [allAuthorsRequest release];
    
    NSEnumerator *authorsEnumerator = [authors objectEnumerator];
    //NSManagedObject *tmp;
    
    NSError *errorAddingAuthor;
    //NSMutableArray *authorsData = [[NSMutableArray alloc] initWithCapacity:0];
    NSNumber *flag = [NSNumber numberWithInt:0];
    
    while ((tmp = [authorsEnumerator nextObject]) != nil) {
        
        [tmp setValue:[author valueForKey:@"AuthorID"] forKey:@"AuthorID"];
        [tmp setValue:[author valueForKey:@"TimeID"] forKey:@"TimeID"];
        [tmp setValue:[NSNumber numberWithInteger:[self.brandID integerValue]] forKey:@"AuthorStudyID"];
        if([author valueForKey:@"AuthorName"] != [NSNull null])[tmp setValue:[author valueForKey:@"AuthorName"] forKey:@"AuthorName"];
        if([author valueForKey:@"AuthorFirstName"] != [NSNull null])[tmp setValue:[author valueForKey:@"AuthorFirstName"] forKey:@"AuthorFirstName"];
        if([author valueForKey:@"AuthorLastName"] != [NSNull null])[tmp setValue:[author valueForKey:@"AuthorLastName"] forKey:@"AuthorLastName"];
        if([author valueForKey:@"RegistrationCount"] != [NSNull null])[tmp setValue:[author valueForKey:@"RegistrationCount"] forKey:@"RegistrationCount"];
        if([author valueForKey:@"City"] != [NSNull null])[tmp setValue:[author valueForKey:@"City"] forKey:@"AuthorCity"];
        if([author valueForKey:@"Street1"] != [NSNull null])[tmp setValue:[author valueForKey:@"Street1"] forKey:@"AuthorStreet1"];
        if([author valueForKey:@"Street2"] != [NSNull null])[tmp setValue:[author valueForKey:@"Street2"] forKey:@"AuthorStreet2"];
        if([author valueForKey:@"StateProvince"] != [NSNull null])[tmp setValue:[author valueForKey:@"StateProvince"] forKey:@"AuthorState"];
        if([author valueForKey:@"PostalCode"] != [NSNull null])[tmp setValue:[author valueForKey:@"PostalCode"] forKey:@"AuthorZip"];
        if([author valueForKey:@"AuthorEmail"] != [NSNull null])[tmp setValue:[author valueForKey:@"AuthorEmail"] forKey:@"AuthorEmail"];
        if([author valueForKey:@"DOB"] != [NSNull null])[tmp setValue:[self parseDateString:[author valueForKey:@"DOB"]] forKey:@"AuthorDOB"];
        
    
        if([author valueForKey:@"ParentTimeAuthorID"] != [NSNull null]) [tmp setValue:[author valueForKey:@"ParentTimeAuthorID"] forKey:@"ParentTimeAuthorID"];
        if([author valueForKey:@"TimeAuthorID"] != [NSNull null]) [tmp setValue:[author valueForKey:@"TimeAuthorID"] forKey:@"TimeAuthorID"];
        
        
        if([author valueForKey:@"isAttending"] != [NSNull null]){
            if([[author valueForKey:@"isAttending"] isEqualToNumber:[NSNumber numberWithBool:YES]] ){
                flag = [NSNumber numberWithInt:1];
            }else{
                flag = [NSNumber numberWithInt:0];
            }
        }else{
            flag = [NSNumber numberWithInt:0];
        }
        [tmp setValue:flag forKey:@"isAttending"];
        
        if([author valueForKey:@"Invited"] != [NSNull null]){
            if([[author valueForKey:@"Invited"] isEqualToNumber:[NSNumber numberWithBool:YES]]){
                flag = [NSNumber numberWithInt:1];
            }else{
                flag = [NSNumber numberWithInt:0];
            }
        }else{
            flag = [NSNumber numberWithInt:0];
        }
        [tmp setValue:flag forKey:@"Invited"];
        
        if([author valueForKey:@"Cancelled"] != [NSNull null]){
            if([[author valueForKey:@"Cancelled"] isEqualToNumber:[NSNumber numberWithBool:YES]]){
                flag = [NSNumber numberWithInt:1];
            }else{
                flag = [NSNumber numberWithInt:0];
            }
        }else{
            flag = [NSNumber numberWithInt:0];
        }
        [tmp setValue:flag forKey:@"Cancelled"];
        
        if([author valueForKey:@"Attended"] != [NSNull null]){
            if([[author valueForKey:@"Attended"] isEqualToNumber:[NSNumber numberWithBool:YES]]){
                flag = [NSNumber numberWithInt:1];
            }else{
                flag = [NSNumber numberWithInt:0];
            }
        }else{
            flag = [NSNumber numberWithInt:0];
        }
        [tmp setValue:flag forKey:@"Attended"];
        
        if([author valueForKey:@"OptIn"] != [NSNull null]){
            if([[author valueForKey:@"OptIn"] isEqualToNumber:[NSNumber numberWithBool:YES]]){
                flag = [NSNumber numberWithInt:1];
            }else{
                flag = [NSNumber numberWithInt:0];
            }
        }else{
            flag = [NSNumber numberWithInt:0];
        }
        [tmp setValue:flag forKey:@"IsOptedOut"];
        
        NSLog(@"tmp author: %@",tmp);
        
        if (tmp != nil && [context save:errorAddingAuthor] == NO) 
        {
            NSLog(@"boosh");
        }
        
        [web RegistrationCountForAuthorID:[author valueForKey:@"AuthorID"]];
        return;
        
    }
    
    
    
    NSManagedObject *newAuthor = [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:context];
    
    [newAuthor setValue:[author valueForKey:@"AuthorID"] forKey:@"AuthorID"];
    [newAuthor setValue:[author valueForKey:@"TimeID"] forKey:@"TimeID"];
    [newAuthor setValue:[NSNumber numberWithInteger:[self.brandID integerValue]] forKey:@"AuthorStudyID"];
    if([author valueForKey:@"AuthorName"] != [NSNull null])[newAuthor setValue:[author valueForKey:@"AuthorName"] forKey:@"AuthorName"];
    if([author valueForKey:@"AuthorFirstName"] != [NSNull null])[newAuthor setValue:[author valueForKey:@"AuthorFirstName"] forKey:@"AuthorFirstName"];
    if([author valueForKey:@"AuthorLastName"] != [NSNull null])[newAuthor setValue:[author valueForKey:@"AuthorLastName"] forKey:@"AuthorLastName"];
    //if([author valueForKey:@"RegistrationsCount"] != [NSNull null])[newAuthor setValue:[author valueForKey:@"RegistrationsCount"] forKey:@"RegistrationsCount"];
    
    if([author valueForKey:@"City"] != [NSNull null])[newAuthor setValue:[author valueForKey:@"City"] forKey:@"AuthorCity"];
    if([author valueForKey:@"Street1"] != [NSNull null])[newAuthor setValue:[author valueForKey:@"Street1"] forKey:@"AuthorStreet1"];
    if([author valueForKey:@"Street2"] != [NSNull null])[newAuthor setValue:[author valueForKey:@"Street2"] forKey:@"AuthorStreet2"];
    if([author valueForKey:@"StateProvince"] != [NSNull null])[newAuthor setValue:[author valueForKey:@"StateProvince"] forKey:@"AuthorState"];
    if([author valueForKey:@"PostalCode"] != [NSNull null])[newAuthor setValue:[author valueForKey:@"PostalCode"] forKey:@"AuthorZip"];
    if([author valueForKey:@"AuthorEmail"] != [NSNull null])[newAuthor setValue:[author valueForKey:@"AuthorEmail"] forKey:@"AuthorEmail"];
    if([author valueForKey:@"DOB"] != [NSNull null])[newAuthor setValue:[self parseDateString:[author valueForKey:@"DOB"]] forKey:@"AuthorDOB"];
    
    if([author valueForKey:@"ParentTimeAuthorID"] != [NSNull null]) [newAuthor setValue:[author valueForKey:@"ParentTimeAuthorID"] forKey:@"ParentTimeAuthorID"];
    if([author valueForKey:@"TimeAuthorID"] != [NSNull null]) [newAuthor setValue:[author valueForKey:@"TimeAuthorID"] forKey:@"TimeAuthorID"];
    
    if([author valueForKey:@"isAttending"] != [NSNull null]){
        if([[author valueForKey:@"isAttending"] isEqualToNumber:[NSNumber numberWithBool:YES]] ){
            flag = [NSNumber numberWithInt:1];
        }else{
            flag = [NSNumber numberWithInt:0];
        }
    }else{
        flag = [NSNumber numberWithInt:0];
    }
    [newAuthor setValue:flag forKey:@"isAttending"];
    
    if([author valueForKey:@"Invited"] != [NSNull null]){
        if([[author valueForKey:@"Invited"] isEqualToNumber:[NSNumber numberWithBool:YES]]){
            flag = [NSNumber numberWithInt:1];
        }else{
            flag = [NSNumber numberWithInt:0];
        }
    }else{
        flag = [NSNumber numberWithInt:0];
    }
    [newAuthor setValue:flag forKey:@"Invited"];
    
    if([author valueForKey:@"Cancelled"] != [NSNull null]){
        if([[author valueForKey:@"Cancelled"] isEqualToNumber:[NSNumber numberWithBool:YES]]){
            flag = [NSNumber numberWithInt:1];
        }else{
            flag = [NSNumber numberWithInt:0];
        }
    }else{
        flag = [NSNumber numberWithInt:0];
    }
    [newAuthor setValue:flag forKey:@"Cancelled"];
    
    if([author valueForKey:@"Attended"] != [NSNull null]){
        if([[author valueForKey:@"Attended"] isEqualToNumber:[NSNumber numberWithBool:YES]]){
            flag = [NSNumber numberWithInt:1];
        }else{
            flag = [NSNumber numberWithInt:0];
        }
    }else{
        flag = [NSNumber numberWithInt:0];
    }
    [newAuthor setValue:flag forKey:@"Attended"];
    
    if([author valueForKey:@"OptIn"] != [NSNull null]){
        if([[author valueForKey:@"OptIn"] isEqualToNumber:[NSNumber numberWithBool:YES]]){
            flag = [NSNumber numberWithInt:1];
        }else{
            flag = [NSNumber numberWithInt:0];
        }
    }else{
        flag = [NSNumber numberWithInt:0];
    }
    [newAuthor setValue:flag forKey:@"IsOptedOut"];
    
    NSLog(@"new author: %@",newAuthor);
    
    NSError *errorSavingAuthor = nil;
    if (newAuthor!=nil && [context save:errorSavingAuthor] == NO) {
        //[context deleteObject:author];
        //author = nil;
    }else{
        NSLog(@"There was an error: %@", [errorSavingAuthor description]);
    }
    [web RegistrationCountForAuthorID:[author valueForKey:@"AuthorID"]];
}

-(void)updateDOBForCurrentAuthor:(NSDate*)dob
{
    //NSLog(@"addAuthor: %@", author);
    //CHECK FOR QUEUED EVENTTIMEAUTHOR, ADD TO SENT
    NSLog(@"Date: %@  AuthorID: %@",dob,currentAuthorID);
    
    NSError *errorFetchingPeople = nil;
    NSArray *people = nil;
    
    
    //ADD TO MAIN TABLE
    NSError *errorFetchingAuthors = nil;
    NSArray *authors = nil;
    NSManagedObject *tmp,*tmp2;
    
    //[web RegistrationCountForAuthorID:[author valueForKey:@"AuthorID"]];
    
    
    // Create a request to fetch all Authors.
    
    NSEntityDescription *authorEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
    
    NSFetchRequest *allAuthorsRequest = [[NSFetchRequest alloc] init];
    [allAuthorsRequest setEntity:authorEntity];
    
    //Set a predicate to search for the primary key
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID = %@)",currentAuthorID];
    [allAuthorsRequest setPredicate:predicate];
    
    NSLog(@"predString: (AuthorID = '%@')",currentAuthorID);
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    authors = [context executeFetchRequest:allAuthorsRequest error:errorFetchingAuthors];
    NSLog(@"DOB Authors: %@",authors);
    
    
    [allAuthorsRequest release];
    
    NSEnumerator *authorsEnumerator = [authors objectEnumerator];
    //NSManagedObject *tmp;
    
    NSError *errorAddingAuthor;
    //NSMutableArray *authorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    while ((tmp = [authorsEnumerator nextObject]) != nil) {
        [tmp setValue:dob forKey:@"AuthorDOB"];
        [tmp setValue:[NSDate date] forKey:@"modified"];
        NSLog(@"tmp author: %@",tmp);
        
        /*
        NSEntityDescription *authorQueueEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
        
        NSFetchRequest *allAuthorsQueueRequest = [[NSFetchRequest alloc] init];
        [allAuthorsQueueRequest setEntity:authorQueueEntity];
        
        //Set a predicate to search for the primary key
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID = %@) AND (TimeID = %@)",currentAuthorID,currentTimeID];
        [allAuthorsQueueRequest setPredicate:predicate];
        
        // Ask the context for everything matching the request.
        // If an error occurs, the context will return nil and an error in *error.
        
        NSArray *queue_authors = [context executeFetchRequest:allAuthorsQueueRequest error:&errorFetchingAuthors];
        NSLog(@"DOB Authors: %@",authors);
        
        
        [allAuthorsQueueRequest release];
        
        NSEnumerator *authorsQueueEnumerator = [queue_authors objectEnumerator];
        
        if([queue_authors count]>0){
            while ((tmp2 = [authorsQueueEnumerator nextObject]) != nil) 
            {
                [tmp2 setValue:dob forKey:authorsQueueEnumerator];
            }
        }else{*/
            NSEntityDescription *eventTimeAuthor_queue = [NSEntityDescription insertNewObjectForEntityForName:@"Trans_Queue_Author" inManagedObjectContext:context];
            
            for(NSString *key in [[authorEntity propertiesByName]allKeys])
            {
                [eventTimeAuthor_queue setValue:[tmp valueForKey:key] forKey:key];
            }
       // }
        
        
        
        if (tmp != nil && [context save:&errorAddingAuthor] == NO) 
        {
            NSLog(@"boosh");
        }
        
        
        return;
        
    }
    
}

-(void)addAuthorDetail:(NSMutableDictionary*)authorDetail
{
    NSLog(@"addAuthor");
    
    NSError *errorFetchingAuthorDetails = nil;
    NSArray *authorDetails = nil;
    
    // Create a request to fetch all Authors.
    
    NSEntityDescription *authorDetailEntity = [NSEntityDescription entityForName:@"AuthorDetail" inManagedObjectContext:context];
    
    NSFetchRequest *allAuthorDetailsRequest = [[NSFetchRequest alloc] init];
    [allAuthorDetailsRequest setEntity:authorDetailEntity];
    
    //Set a predicate to search for the primary key
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID == '%@')",[authorDetail valueForKey:@"AuthorID"]];
    [allAuthorDetailsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    authorDetails = [context executeFetchRequest:allAuthorDetailsRequest error:errorFetchingAuthorDetails];
    
    [allAuthorDetailsRequest release];
    
    NSEnumerator *authorDetailsEnumerator = [authorDetails objectEnumerator];
    NSManagedObject *tmp;
    
    NSError *errorAddingAuthoDetail;
   // NSMutableArray *authorDetailsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    while ((tmp = [authorDetailsEnumerator nextObject]) != nil) {
        
        
        [tmp setValue:[authorDetail valueForKey:@"AuthorID"] forKey:@"AuthorID"];
        [tmp setValue:[authorDetail valueForKey:@"HomePhone"] forKey:@"HomePhone"];
        [tmp setValue:[authorDetail valueForKey:@"MobilePhone"] forKey:@"MobilePhone"];
        [tmp setValue:[authorDetail valueForKey:@"Occupation"] forKey:@"Occupation"];
        [tmp setValue:[authorDetail valueForKey:@"Education"] forKey:@"Education"];
        [tmp setValue:[authorDetail valueForKey:@"Adult"] forKey:@"Adult"];
        [tmp setValue:[authorDetail valueForKey:@"HasChildren"] forKey:@"HasChildren"];
        [tmp setValue:[authorDetail valueForKey:@"IncomeCode"] forKey:@"IncomeCode"];
        [tmp setValue:[authorDetail valueForKey:@"MaritalStatus"] forKey:@"MaritalStatus"];
        [tmp setValue:[authorDetail valueForKey:@"BusinessOwner"] forKey:@"BusinessOwner"];
        [tmp setValue:[authorDetail valueForKey:@"WorkingWomen"] forKey:@"WorkingWomen"];
        [tmp setValue:[authorDetail valueForKey:@"DMASuppression"] forKey:@"DMASuppression"];
        [tmp setValue:[authorDetail valueForKey:@"IsHomeowner"] forKey:@"IsHomeowner"];
        [tmp setValue:[authorDetail valueForKey:@"IsRenter"] forKey:@"IsRenter"];
        [tmp setValue:[authorDetail valueForKey:@"LengthOfResidence"] forKey:@"LengthOfResidence"];
        [tmp setValue:[authorDetail valueForKey:@"MailOrderBuyer"] forKey:@"MailOrderBuyer"];
        [tmp setValue:[authorDetail valueForKey:@"MailOrderResponder"] forKey:@"MailOrderResponder"];
        [tmp setValue:[authorDetail valueForKey:@"EntertainsAtHome"] forKey:@"EntertainsAtHome"];
        [tmp setValue:[authorDetail valueForKey:@"Music"] forKey:@"Music"];
        [tmp setValue:[authorDetail valueForKey:@"InternetUse"] forKey:@"InternetUse"];
        [tmp setValue:[authorDetail valueForKey:@"LanguagePreference"] forKey:@"LanguagePreference"];
        [tmp setValue:[authorDetail valueForKey:@"SexualOrientation"] forKey:@"SexualOrientation"];
        [tmp setValue:[authorDetail valueForKey:@"Travel"] forKey:@"Travel"];
        [tmp setValue:[authorDetail valueForKey:@"Gamers"] forKey:@"Gamers"];
        [tmp setValue:[authorDetail valueForKey:@"DrinkingPreference"] forKey:@"DrinkingPreference"];
        [tmp setValue:[authorDetail valueForKey:@"DrinkingIdeas"] forKey:@"DrinkingIdeas"];
        [tmp setValue:[authorDetail valueForKey:@"IsOptedOut"] forKey:@"IsOptedOut"];
        [tmp setValue:[authorDetail valueForKey:@"IsInvalidEmail"] forKey:@"IsInvalidEmail"];
        [tmp setValue:[authorDetail valueForKey:@"DateCreated"] forKey:@"DateCreated"];
        [tmp setValue:[authorDetail valueForKey:@"DateUpdated"] forKey:@"DateUpdated"];
        [tmp setValue:[authorDetail valueForKey:@"ProfileImageURL"] forKey:@"ProfileImageURL"];
        
        if (tmp != nil && [context save:errorAddingAuthoDetail] == NO) 
        {
            NSLog(@"boosh");
        }
        return;
        
    }
    
    
    
    NSManagedObject *newAuthorDetail = [NSEntityDescription insertNewObjectForEntityForName:@"AuthorDetail" inManagedObjectContext:context];
    
    [newAuthorDetail setValue :[authorDetail valueForKey:@"AuthorID"] forKey:@"AuthorID"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"HomePhone"] forKey:@"HomePhone"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"MobilePhone"] forKey:@"MobilePhone"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"Occupation"] forKey:@"Occupation"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"Education"] forKey:@"Education"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"Adult"] forKey:@"Adult"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"HasChildren"] forKey:@"HasChildren"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"IncomeCode"] forKey:@"IncomeCode"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"MaritalStatus"] forKey:@"MaritalStatus"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"BusinessOwner"] forKey:@"BusinessOwner"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"WorkingWomen"] forKey:@"WorkingWomen"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"DMASuppression"] forKey:@"DMASuppression"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"IsHomeowner"] forKey:@"IsHomeowner"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"IsRenter"] forKey:@"IsRenter"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"LengthOfResidence"] forKey:@"LengthOfResidence"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"MailOrderBuyer"] forKey:@"MailOrderBuyer"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"MailOrderResponder"] forKey:@"MailOrderResponder"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"EntertainsAtHome"] forKey:@"EntertainsAtHome"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"Music"] forKey:@"Music"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"InternetUse"] forKey:@"InternetUse"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"LanguagePreference"] forKey:@"LanguagePreference"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"SexualOrientation"] forKey:@"SexualOrientation"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"Travel"] forKey:@"Travel"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"Gamers"] forKey:@"Gamers"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"DrinkingPreference"] forKey:@"DrinkingPreference"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"DrinkingIdeas"] forKey:@"DrinkingIdeas"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"IsOptedOut"] forKey:@"IsOptedOut"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"IsInvalidEmail"] forKey:@"IsInvalidEmail"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"DateCreated"] forKey:@"DateCreated"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"DateUpdated"] forKey:@"DateUpdated"];
    [newAuthorDetail setValue :[authorDetail valueForKey:@"ProfileImageURL"] forKey:@"ProfileImageURL"];
    
    
    NSError *errorSavingAuthorDetail = nil;
    if (newAuthorDetail!=nil && [context save:errorSavingAuthorDetail] == NO) {
       // [context deleteObject:newAuthorDetail];
        newAuthorDetail = nil;
    }
    
}

-(void)checkAuthorForAuthorID:(NSString*)authorID
{
    NSLog(@"checkAuthor");
    
    NSError *errorFetchingAuthors = nil;
    NSArray *authors = nil;
    
    // Create a request to fetch all Authors.
    
    NSEntityDescription *authorEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
    
    NSFetchRequest *allAuthorsRequest = [[NSFetchRequest alloc] init];
    [allAuthorsRequest setEntity:authorEntity];
    
    //Set a predicate to search for the primary key
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID = '%@')",authorID];
    [allAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    authors = [context executeFetchRequest:allAuthorsRequest error:errorFetchingAuthors];
    
    [allAuthorsRequest release];
    
    NSEnumerator *authorsEnumerator = [authors objectEnumerator];
    NSManagedObject *tmp;
    
    NSError *errorAddingAuthor;
    //NSMutableArray *authorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    while ((tmp = [authorsEnumerator nextObject]) != nil) {
        [web RegistrationCountForAuthorID:authorID];
    }
    
    [web AuthorForAuthorID:authorID];
    
    
}

-(void)saveRegistrationCount:(NSUInteger)regCount forAuthorID:(NSString*)authorID
{
    NSLog(@"checkAuthor");
    
    NSError *errorFetchingAuthors = nil;
    NSArray *authors = nil;
    
    // Create a request to fetch all Authors.
    
    NSLog(@"regCount: %d for AuthorID: %@", regCount, authorID);
    
    NSEntityDescription *authorEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
    
    NSFetchRequest *allAuthorsRequest = [[NSFetchRequest alloc] init];
    [allAuthorsRequest setEntity:authorEntity];
    
    //Set a predicate to search for the primary key
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID == %@)",authorID];
    [allAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    authors = [context executeFetchRequest:allAuthorsRequest error:errorFetchingAuthors];
    
    [allAuthorsRequest release];
    
    NSEnumerator *authorsEnumerator = [authors objectEnumerator];
    NSManagedObject *tmp;
    
    NSError *errorAddingAuthor;
    //NSMutableArray *authorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    while ((tmp = [authorsEnumerator nextObject]) != nil) {
        [tmp setValue:[NSNumber numberWithInt:regCount] forKey:@"RegistrationCount"];
        
        if (tmp != nil && [context save:errorAddingAuthor] == NO) 
        {
            NSLog(@"boosh");
        }
        return;
    }
    
    
    
}

-(void)checkAuthorDetailsForAuthorID:(NSString*)authorID
{
    NSLog(@"checkAuthorDetails");
    
    NSError *errorFetchingAuthors = nil;
    NSArray *authors = nil;
    
    // Create a request to fetch all Authors.
    
    NSEntityDescription *authorEntity = [NSEntityDescription entityForName:@"AuthorDetail" inManagedObjectContext:context];
    
    NSFetchRequest *allAuthorsRequest = [[NSFetchRequest alloc] init];
    [allAuthorsRequest setEntity:authorEntity];
    
    //Set a predicate to search for the primary key
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID == %@)",authorID];
    [allAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    authors = [context executeFetchRequest:allAuthorsRequest error:errorFetchingAuthors];
    
    [allAuthorsRequest release];
    
    NSEnumerator *authorsEnumerator = [authors objectEnumerator];
    NSManagedObject *tmp;
    
    NSError *errorAddingAuthor;
    //NSMutableArray *authorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    while ((tmp = [authorsEnumerator nextObject]) != nil) {
        
        return;
    }
    
    [web AuthorDetailsForAuthorID:authorID]; 
    
}

-(void)updateOptInForAuthorID:(NSString*)authorID withValue:(BOOL)val
{
    NSError *errorFetchingEventTimeAuthors = nil;
    NSArray *eventTimeAuthors = nil;
    
    
    //[self checkAuthorForAuthorID:[eventTimeAuthor valueForKey:@"AuthorID"]];
    
    // Create a request to fetch all EventTimeAuthors.
    
    NSEntityDescription *eventTimeAuthorEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
    
    NSFetchRequest *allEventTimeAuthorsRequest = [[NSFetchRequest alloc] init];
    [allEventTimeAuthorsRequest setEntity:eventTimeAuthorEntity];
    
    //Set a predicate to search for the primary key
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID == %@) AND (TimeID == %@)",authorID,self.currentTimeID];
    [allEventTimeAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    eventTimeAuthors = [context executeFetchRequest:allEventTimeAuthorsRequest error:errorFetchingEventTimeAuthors];
    
    [allEventTimeAuthorsRequest release];
    
    NSEnumerator *eventTimeAuthorsEnumerator = [eventTimeAuthors objectEnumerator];
    NSManagedObject *tmp;
    
    NSError *errorAddingEventTimeAuthor;
    //NSMutableArray *eventTimeAuthorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    while ((tmp = [eventTimeAuthorsEnumerator nextObject]) != nil) {
        [tmp setValue:[NSNumber numberWithBool:val] forKey:@"IsOptedOut"];
        [tmp setValue:[NSNumber numberWithInt:1] forKey:@"changed"];
        [tmp setValue:[NSDate date] forKey:@"modified"];
        
        NSLog(@"tmp AuthorDetail: %@",tmp);
        
        NSEntityDescription *authorDetail_queue = [NSEntityDescription insertNewObjectForEntityForName:@"Trans_Queue_Author" inManagedObjectContext:context];
        
        for(NSString *key in [[eventTimeAuthorEntity propertiesByName]allKeys])
        {
            [authorDetail_queue setValue:[tmp valueForKey:key] forKey:key];
        }
        
        if (tmp != nil && [context save:errorAddingEventTimeAuthor] == NO) 
        {
            
        }
        return;
        
    }
}

-(void)updateAttendedForAuthorID:(NSString*)authorID withValue:(BOOL)val
{
    NSError *errorFetchingEventTimeAuthors = nil;
    NSArray *eventTimeAuthors = nil;
    
    // Create a request to fetch all EventTimeAuthors.
    
    NSEntityDescription *eventTimeAuthorEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
    
    NSFetchRequest *allEventTimeAuthorsRequest = [[NSFetchRequest alloc] init];
    [allEventTimeAuthorsRequest setEntity:eventTimeAuthorEntity];
    
    //Set a predicate to search for the primary key
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID == %@) AND (TimeID == %@)",authorID,self.currentTimeID];
    [allEventTimeAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    eventTimeAuthors = [context executeFetchRequest:allEventTimeAuthorsRequest error:errorFetchingEventTimeAuthors];
    
    [allEventTimeAuthorsRequest release];
    
    NSEnumerator *eventTimeAuthorsEnumerator = [eventTimeAuthors objectEnumerator];
    NSManagedObject *tmp;
    
    NSError *errorAddingEventTimeAuthor;
   // NSMutableArray *eventTimeAuthorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    while ((tmp = [eventTimeAuthorsEnumerator nextObject]) != nil) {
        NSLog(@"EventTimeAuthor Attended: %d",val);
        [tmp setValue:[NSNumber numberWithBool:val] forKey:@"Attended"];
        [tmp setValue:[NSNumber numberWithInt:1] forKey:@"changed"];
        [tmp setValue:[NSDate date] forKey:@"modified"];
        
        NSEntityDescription *eventTimeAuthor_queue = [NSEntityDescription insertNewObjectForEntityForName:@"Trans_Queue_Author" inManagedObjectContext:context];
        
        for(NSString *key in [[eventTimeAuthorEntity propertiesByName]allKeys])
        {
            [eventTimeAuthor_queue setValue:[tmp valueForKey:key] forKey:key];
        }

        
        if (tmp != nil && [context save:errorAddingEventTimeAuthor] == NO) 
        {
            NSLog(@"boosh");
        }
        return;
        
    }
}

-(void)toggleTestAttendees
{
    NSError *errorFetchingEventTimeAuthors = nil;
    NSArray *eventTimeAuthors = nil;
    
    // Create a request to fetch all EventTimeAuthors.
    
    NSEntityDescription *eventTimeAuthorEntity = [NSEntityDescription entityForName:@"EventTimeAuthor" inManagedObjectContext:context];
    
    NSFetchRequest *allEventTimeAuthorsRequest = [[NSFetchRequest alloc] init];
    [allEventTimeAuthorsRequest setEntity:eventTimeAuthorEntity];
    
    //Set a predicate to search for the primary key
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(TimeID == %@)",@"b53f602b-82f6-41a1-84df-c43ac605c520"];
    [allEventTimeAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    eventTimeAuthors = [context executeFetchRequest:allEventTimeAuthorsRequest error:errorFetchingEventTimeAuthors];
    
    [allEventTimeAuthorsRequest release];
    
    NSEnumerator *eventTimeAuthorsEnumerator = [eventTimeAuthors objectEnumerator];
    NSManagedObject *tmp;
    
    NSError *errorAddingEventTimeAuthor;
    // NSMutableArray *eventTimeAuthorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    while ((tmp = [eventTimeAuthorsEnumerator nextObject]) != nil) {
       
        if([[tmp valueForKey:@"Attended"]isEqualToNumber:[NSNumber numberWithInt:1]]){
            [tmp setValue:[NSNumber numberWithInt:0] forKey:@"Attended"];
        }else{
            [tmp setValue:[NSNumber numberWithInt:1] forKey:@"Attended"];
        }
        [tmp setValue:[NSNumber numberWithInt:1] forKey:@"changed"];
        
        NSEntityDescription *eventTimeAuthor_queue = [NSEntityDescription insertNewObjectForEntityForName:@"Trans_Queue_EventTimeAuthor" inManagedObjectContext:context];
        
        for(NSString *key in [[eventTimeAuthorEntity propertiesByName]allKeys])
        {
            [eventTimeAuthor_queue setValue:[tmp valueForKey:key] forKey:key];
        }
        
        
        if (tmp != nil && [context save:errorAddingEventTimeAuthor] == NO) 
        {
            NSLog(@"boosh");
        }
        
        
    }
    return;
}

-(void)updateSurveyForAuthorID:(NSString*)authorID
{
    NSError *errorFetchingEventTimeAuthors = nil;
    NSArray *eventTimeAuthors = nil;
    
    // Create a request to fetch all EventTimeAuthors.
    
    NSEntityDescription *eventTimeAuthorEntity = [NSEntityDescription entityForName:@"EventTimeAuthor" inManagedObjectContext:context];
    
    NSFetchRequest *allEventTimeAuthorsRequest = [[NSFetchRequest alloc] init];
    [allEventTimeAuthorsRequest setEntity:eventTimeAuthorEntity];
    
    //Set a predicate to search for the primary key
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID == %@)",authorID];
    [allEventTimeAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    eventTimeAuthors = [context executeFetchRequest:allEventTimeAuthorsRequest error:errorFetchingEventTimeAuthors];
    
    [allEventTimeAuthorsRequest release];
    
    NSEnumerator *eventTimeAuthorsEnumerator = [eventTimeAuthors objectEnumerator];
    NSManagedObject *tmp;
    
    NSError *errorAddingEventTimeAuthor;
    //NSMutableArray *eventTimeAuthorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    while ((tmp = [eventTimeAuthorsEnumerator nextObject]) != nil) {
        [tmp setValue:[NSNumber numberWithInt:1] forKey:@"changed"];
        [tmp setValue:[NSDate date] forKey:@"modified"];
        
        if (tmp != nil && [context save:errorAddingEventTimeAuthor] == NO) 
        {
            NSLog(@"boosh");
        }
        return;
        
    }
}

-(NSMutableArray*)eventTimeIDsForPush
{
    NSLog(@"eventTimeIDsForPush");
    
    NSError *errorFetchingPeople = nil;
    NSArray *queue_people = nil;
    NSArray *sent_people = nil;
    
    // Create a request to fetch all Authors present in the 'Queue' Table
    NSEntityDescription *sentPersonEntity = [NSEntityDescription entityForName:@"Trans_Sent_Author" inManagedObjectContext:context];
    
    NSFetchRequest *sentPeopleRequest = [[NSFetchRequest alloc] init];
    [sentPeopleRequest setEntity:sentPersonEntity];
    [sentPeopleRequest setReturnsObjectsAsFaults:NO];    
    sent_people = [context executeFetchRequest:sentPeopleRequest error:&errorFetchingPeople];
    
    
    
    // Create a request to fetch all Queued Authors NOT present in the 'Sent' Table
    NSEntityDescription *queuePersonEntity = [NSEntityDescription entityForName:@"Trans_Queue_Author" inManagedObjectContext:context];
    
    NSFetchRequest *queuePeopleRequest = [[NSFetchRequest alloc] init];
    [queuePeopleRequest setEntity:queuePersonEntity];
    [queuePeopleRequest setReturnsObjectsAsFaults:NO];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(NOT (self IN %@))",sent_people];
    [queuePeopleRequest setPredicate:pred];
    [queuePeopleRequest setPropertiesToFetch:[NSArray arrayWithObject:@"TimeID"]];
    [queuePeopleRequest setReturnsDistinctResults:YES];
    
    
    queue_people = [context executeFetchRequest:queuePeopleRequest error:&errorFetchingPeople];
    
    [context obtainPermanentIDsForObjects:queue_people error:&errorFetchingPeople];
    
    NSEnumerator *peopleEnumerator = [queue_people objectEnumerator];
    NSManagedObject *tmp;
    
    
    NSMutableArray *peopleData = [[NSMutableArray alloc] initWithCapacity:0];
    peopleData = [queue_people valueForKeyPath:@"@distinctUnionOfObjects.TimeID"];
    //*
    /*while ((tmp = [peopleEnumerator nextObject]) != nil) {
     
     //[person setValue:@"USA" forKey:@"Country"];
     
     
     [peopleData addObject:[tmp valueForKey:@"TimeID"]];
     }
     */
    // Clean up and return.
    [queuePeopleRequest release];
    [sentPeopleRequest release];
    
    //*/
    NSLog(@"eventTimeIDsForPush: %@",peopleData);
    return peopleData;//[NSMutableArray arrayWithCapacity:0];//peopleData;
}


-(NSMutableArray*)allAuthorsForPush:(NSString*)timeID
{
    /* OLD IMPLEMENTATION
    NSError *errorFetchingEventTimeAuthors = nil;
    NSArray *eventTimeAuthors = nil;
    
    //[self checkAuthorForAuthorID:[eventTimeAuthor valueForKey:@"AuthorID"]];
    
    // Create a request to fetch all EventTimeAuthors.
    
    NSEntityDescription *eventTimeAuthorEntity = [NSEntityDescription entityForName:@"EventTimeAuthor" inManagedObjectContext:context];
    
    NSFetchRequest *allEventTimeAuthorsRequest = [[NSFetchRequest alloc] init];
    [allEventTimeAuthorsRequest setEntity:eventTimeAuthorEntity];
    
    //Set a predicate to search for the primary key
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Changed == 1)"];
    [allEventTimeAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    eventTimeAuthors = [context executeFetchRequest:allEventTimeAuthorsRequest error:errorFetchingEventTimeAuthors];
    
    [allEventTimeAuthorsRequest release];
    
    NSEnumerator *eventTimeAuthorsEnumerator = [eventTimeAuthors objectEnumerator];
    NSManagedObject *tmp;
    
    NSError *errorAddingEventTimeAuthor;
    //NSMutableArray *eventTimeAuthorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    while ((tmp = [eventTimeAuthorsEnumerator nextObject]) != nil) {
        NSMutableDictionary *eventTimeAuthor = [NSMutableDictionary dictionaryWithCapacity:0];
       // NSLog(@"temp eventTimeAuthor: %@",tmp);
        
        [eventTimeAuthor setValue:[tmp valueForKey:@"TimeAuthorID"] forKey:@"TimeAuthorID"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"ParentTimeAuthorID"] forKey:@"ParentTimeAuthorID"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"TimeID"] forKey:@"TimeID"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"AuthorID"] forKey:@"AuthorID"];
        
        //* CONVERT OBJ-C BOOLS TO .NET COMPATIBLE BOOLS i.e. YES -> 'true' 
        if([[tmp valueForKey:@"Attended"]boolValue] == NO){
            [eventTimeAuthor setValue:@"false" forKey:@"Attended"];
        }else{
            [eventTimeAuthor setValue:@"true" forKey:@"Attended"];
        }
        if([[tmp valueForKey:@"isAttending"]boolValue] == NO){
            [eventTimeAuthor setValue:@"false" forKey:@"isAttending"];
        }else{
            [eventTimeAuthor setValue:@"true" forKey:@"isAttending"];
        }
        if([[tmp valueForKey:@"Cancelled"]boolValue] == NO){
            [eventTimeAuthor setValue:@"false" forKey:@"Cancelled"];
        }else{
            [eventTimeAuthor setValue:@"true" forKey:@"Cancelled"];
        }
        if([[tmp valueForKey:@"Invited"]boolValue] == NO){
            [eventTimeAuthor setValue:@"false" forKey:@"Invited"];
        }else{
            [eventTimeAuthor setValue:@"true" forKey:@"Invited"];
        }
        
        
        [eventTimeAuthor setValue:[tmp valueForKey:@"CreatedDate"] forKey:@"CreatedDate"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"ModifiedDate"] forKey:@"ModifiedDate"];
        
        [web updateEventTimeAuthor:eventTimeAuthor];
        
        [tmp setValue:[NSNumber numberWithInt:0] forKey:@"changed"];
        
        if (tmp != nil && [context save:errorAddingEventTimeAuthor] == NO) 
        {
            NSLog(@"boosh");
        }
        //return;
    }
     */
    NSLog(@"updatedEventTimeAuthors");
    
    NSError *errorFetchingPeople = nil;
    NSArray *queue_people = nil;
    NSArray *sent_people = nil;
    
    // Create a request to fetch all Authors present in the 'Queue' Table
    NSEntityDescription *sentPersonEntity = [NSEntityDescription entityForName:@"Trans_Sent_Author" inManagedObjectContext:context];
    
    NSFetchRequest *sentPeopleRequest = [[NSFetchRequest alloc] init];
    [sentPeopleRequest setEntity:sentPersonEntity];
    [sentPeopleRequest setReturnsObjectsAsFaults:NO];   
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(TimeID == %@)",timeID];
    [sentPeopleRequest setPredicate:pred];
    sent_people = [context executeFetchRequest:sentPeopleRequest error:&errorFetchingPeople];
    NSLog(@"number of sent_EventTimeAuthors: %d", [sent_people count]);
    
    
    // Create a request to fetch all Queued Authors NOT present in the 'Sent' Table
    NSEntityDescription *queuePersonEntity = [NSEntityDescription entityForName:@"Trans_Queue_Author" inManagedObjectContext:context];
    
    NSFetchRequest *queuePeopleRequest = [[NSFetchRequest alloc] init];
    [queuePeopleRequest setEntity:queuePersonEntity];
    [queuePeopleRequest setReturnsObjectsAsFaults:NO];
    pred = [NSPredicate predicateWithFormat:@"(NOT (self IN %@)) AND (TimeID == %@)",sent_people,timeID];
    [queuePeopleRequest setPredicate:pred];
    
    queue_people = [context executeFetchRequest:queuePeopleRequest error:&errorFetchingPeople];
    [context obtainPermanentIDsForObjects:queue_people error:&errorFetchingPeople];
    
    NSEnumerator *peopleEnumerator = [queue_people objectEnumerator];
    NSManagedObject *tmp;
    
    
    NSMutableArray *peopleData = [[NSMutableArray alloc] initWithCapacity:0];
    //*
    
   

    
    while ((tmp = [peopleEnumerator nextObject]) != nil) {
        NSLog(@"found queue eventtimeauthor: %@",tmp);
        
        NSMutableDictionary *eventTimeAuthor = [NSMutableDictionary dictionaryWithCapacity:0];
        // NSLog(@"temp eventTimeAuthor: %@",tmp);
        
        [eventTimeAuthor setValue:[tmp valueForKey:@"ParentTimeAuthorID"] forKey:@"ParentTimeAuthorID"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"TimeID"] forKey:@"TimeID"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"AuthorID"] forKey:@"AuthorID"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"TimeAuthorID"] forKey:@"TimeAuthorID"];
        [eventTimeAuthor setValue:[self parseDateSlashes:[tmp valueForKey:@"AuthorDOB"]] forKey:@"DOB"];
        [eventTimeAuthor setValue:[self parseDateTime:[tmp valueForKey:@"modified"]] forKey:@"DateTimeTransaction"];
        
        //* CONVERT OBJ-C BOOLS TO .NET COMPATIBLE BOOLS i.e. YES -> 'true' 
        if([[tmp valueForKey:@"Attended"]boolValue] == NO){
            [eventTimeAuthor setValue:@"false" forKey:@"Attended"];
        }else{
            [eventTimeAuthor setValue:@"true" forKey:@"Attended"];
        }
        if([[tmp valueForKey:@"isAttending"]boolValue] == NO){
            [eventTimeAuthor setValue:@"false" forKey:@"isAttending"];
        }else{
            [eventTimeAuthor setValue:@"true" forKey:@"isAttending"];
        }
        if([[tmp valueForKey:@"Cancelled"]boolValue] == NO){
            [eventTimeAuthor setValue:@"false" forKey:@"Cancelled"];
        }else{
            [eventTimeAuthor setValue:@"true" forKey:@"Cancelled"];
        }
        if([[tmp valueForKey:@"Invited"]boolValue] == NO){
            [eventTimeAuthor setValue:@"false" forKey:@"Invited"];
        }else{
            [eventTimeAuthor setValue:@"true" forKey:@"Invited"];
        }
        
        if([[tmp valueForKey:@"IsOptedOut"]boolValue] == NO){
            [eventTimeAuthor setValue:@"false" forKey:@"OptIn"];
        }else{
            [eventTimeAuthor setValue:@"true" forKey:@"OptIn"];
        }
        
        
        [tmp setValue:[NSNumber numberWithInt:0] forKey:@"Changed"];
        
        NSError *errorAddingEventTimeAuthor;
        if (tmp != nil && [context save:errorAddingEventTimeAuthor] == NO) 
        {
            NSLog(@"boosh");
        }
        //return;
        
        [peopleData addObject:eventTimeAuthor];
    }
    
    // Clean up and return.
    [queuePeopleRequest release];
    [sentPeopleRequest release];
    
    return peopleData;
    //*/
    //NSLog(@"peopleData: %@",peopleData);
    //return peopleData;//[NSMutableArray arrayWithCapacity:0];//peopleData;
}

-(void)updatedAuthorDetails
{
    /*OLD IMPLEMENTATION
    NSError *errorFetchingEventTimeAuthors = nil;
    NSArray *eventTimeAuthors = nil;
    
    
    //[self checkAuthorForAuthorID:[eventTimeAuthor valueForKey:@"AuthorID"]];
    
    // Create a request to fetch all EventTimeAuthors.
    
    NSEntityDescription *eventTimeAuthorEntity = [NSEntityDescription entityForName:@"AuthorDetail" inManagedObjectContext:context];
    
    NSFetchRequest *allEventTimeAuthorsRequest = [[NSFetchRequest alloc] init];
    [allEventTimeAuthorsRequest setEntity:eventTimeAuthorEntity];
    
    //Set a predicate to search for the primary key
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Changed == 1)"];
    [allEventTimeAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    eventTimeAuthors = [context executeFetchRequest:allEventTimeAuthorsRequest error:errorFetchingEventTimeAuthors];
    
    [allEventTimeAuthorsRequest release];
    
    NSEnumerator *eventTimeAuthorsEnumerator = [eventTimeAuthors objectEnumerator];
    NSManagedObject *tmp;
    
    NSError *errorAddingEventTimeAuthor;
    //NSMutableArray *eventTimeAuthorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    while ((tmp = [eventTimeAuthorsEnumerator nextObject]) != nil) {
        NSMutableDictionary *eventTimeAuthor = [NSMutableDictionary dictionaryWithCapacity:0];
       // NSLog(@"temp eventTimeAuthor: %@",tmp);
        
        [eventTimeAuthor setValue:[tmp valueForKey:@"AuthorID"] forKey:@"AuthorID"];
        if([[tmp valueForKey:@"IsOptedOut"]boolValue] == NO){
            [eventTimeAuthor setValue:@"true" forKey:@"optIn"];
        }else{
            [eventTimeAuthor setValue:@"false" forKey:@"optIn"];
        }
        
        [web updateAuthorDetail:eventTimeAuthor];
        
        [tmp setValue:[NSNumber numberWithInt:0] forKey:@"changed"];
        
        if (tmp != nil && [context save:errorAddingEventTimeAuthor] == NO) 
        {
            NSLog(@"boosh");
        }
        //return;
    }
     */
    
    NSError *errorFetchingPeople = nil;
    NSArray *queue_people = nil;
    NSArray *sent_people = nil;
    
    // Create a request to fetch all Authors present in the 'Queue' Table
    NSEntityDescription *sentPersonEntity = [NSEntityDescription entityForName:@"Trans_Sent_AuthorDetail" inManagedObjectContext:context];
    
    NSFetchRequest *sentPeopleRequest = [[NSFetchRequest alloc] init];
    [sentPeopleRequest setEntity:sentPersonEntity];
    [sentPeopleRequest setReturnsObjectsAsFaults:NO];    
    sent_people = [context executeFetchRequest:sentPeopleRequest error:&errorFetchingPeople];
    
    
    
    // Create a request to fetch all Queued Authors NOT present in the 'Sent' Table
    NSEntityDescription *queuePersonEntity = [NSEntityDescription entityForName:@"Trans_Queue_AuthorDetail" inManagedObjectContext:context];
    
    NSFetchRequest *queuePeopleRequest = [[NSFetchRequest alloc] init];
    [queuePeopleRequest setEntity:queuePersonEntity];
    [queuePeopleRequest setReturnsObjectsAsFaults:NO];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"NOT (self IN %@)",sent_people];
    [queuePeopleRequest setPredicate:pred];
    
    queue_people = [context executeFetchRequest:queuePeopleRequest error:&errorFetchingPeople];
    [context obtainPermanentIDsForObjects:queue_people error:&errorFetchingPeople];
    
    NSEnumerator *peopleEnumerator = [queue_people objectEnumerator];
    NSManagedObject *tmp;
    
    
    NSMutableArray *peopleData = [[NSMutableArray alloc] initWithCapacity:0];
    //*
    while ((tmp = [peopleEnumerator nextObject]) != nil) {
        NSMutableDictionary *eventTimeAuthor = [NSMutableDictionary dictionaryWithCapacity:0];
        // NSLog(@"temp eventTimeAuthor: %@",tmp);
        
        [eventTimeAuthor setValue:[tmp valueForKey:@"AuthorID"] forKey:@"AuthorID"];
        if([[tmp valueForKey:@"IsOptedOut"]boolValue] == NO){
            [eventTimeAuthor setValue:@"true" forKey:@"optIn"];
        }else{
            [eventTimeAuthor setValue:@"false" forKey:@"optIn"];
        }
        
        [web updateAuthorDetail:eventTimeAuthor];
        
        [tmp setValue:[NSNumber numberWithInt:0] forKey:@"changed"];
        
        NSError *errorAddingEventTimeAuthor;
        if (tmp != nil && [context save:errorAddingEventTimeAuthor] == NO) 
        {
            NSLog(@"boosh");
        }
        //return;
    }
    
    // Clean up and return.
    [queuePeopleRequest release];
    [sentPeopleRequest release];

    
}

-(void)addEventTimeAuthors:(NSArray*)eventTimeAuthors
{
    NSLog(@"addEventTimeAuthor");
    for(NSMutableDictionary *eventTimeAuthor in eventTimeAuthors)
    {
        NSLog(@"eventTimeAuthor");
        [self addEventTimeAuthor:eventTimeAuthor];
    }
}

-(void)addEventTimeAuthor:(NSMutableDictionary*)eventTimeAuthor
{
 NSLog(@"addEventTimeAuthor");
   //CHECK FOR QUEUED EVENTTIMEAUTHOR, ADD TO SENT
   
    NSError *errorFetchingPeople = nil;
    NSArray *people = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *personEntity = [NSEntityDescription entityForName:@"Trans_Queue_EventTimeAuthor" inManagedObjectContext:context];
    
    NSFetchRequest *allPeopleRequest = [[NSFetchRequest alloc] init];
    [allPeopleRequest setEntity:personEntity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID = %@) AND (TimeID = %@)", [eventTimeAuthor valueForKey:@"AuthorID"],[eventTimeAuthor valueForKey:@"TimeID"]];
    [allPeopleRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    people = [context executeFetchRequest:allPeopleRequest error:&errorFetchingPeople];
    
    NSEnumerator *peopleEnumerator = [people objectEnumerator];
    NSManagedObject *tmp;
    
    
    NSMutableArray *peopleData = [[NSMutableArray alloc] initWithCapacity:0];
    //*
    while ((tmp = [peopleEnumerator nextObject]) != nil) {
        //ADD ENTRY TO THE 'SENT' TABLE SO AUTHOR DOESN'T GET PUSHED AGAIN
        NSEntityDescription *eventTimeAuthor_sent = [NSEntityDescription insertNewObjectForEntityForName:@"Trans_Sent_EventTimeAuthor" inManagedObjectContext:context];
        NSError *errorSavingPerson = nil;
        
        [eventTimeAuthor_sent setValue:[tmp valueForKey:@"TimeAuthorID"] forKey:@"TimeAuthorID"];
        [eventTimeAuthor_sent setValue:[tmp valueForKey:@"AuthorID"] forKey:@"AuthorID"];
        [eventTimeAuthor_sent setValue:[tmp valueForKey:@"TimeID"] forKey:@"TimeID"];
        //[eventTimeAuthor_sent setValue:[tmp valueForKey:@"RemoteSystemID"] forKey:@"RemoteSystemID"];
        [eventTimeAuthor_sent setValue:[tmp valueForKey:@"ParentTimeAuthorID"] forKey:@"ParentTimeAuthorID"];
        [eventTimeAuthor_sent setValue:[tmp valueForKey:@"ModifiedDate"] forKey:@"ModifiedDate"];
        [eventTimeAuthor_sent setValue:[tmp valueForKey:@"isAttending"] forKey:@"isAttending"];
        [eventTimeAuthor_sent setValue:[tmp valueForKey:@"Invited"] forKey:@"Invited"];
        [eventTimeAuthor_sent setValue:[tmp valueForKey:@"CreatedDate"] forKey:@"CreatedDate"];
        [eventTimeAuthor_sent setValue:[tmp valueForKey:@"Cancelled"] forKey:@"Cancelled"];
        [eventTimeAuthor_sent setValue:[tmp valueForKey:@"Attended"] forKey:@"Attended"];
        
        
        if (eventTimeAuthor_sent!=nil && [context save:&errorSavingPerson] == NO) {
            eventTimeAuthor_sent = nil;
        }
        
        break;
    }

    //ADD TO MAIN TABLE
    NSError *errorFetchingEventTimeAuthors = nil;
    NSArray *eventTimeAuthors = nil;
    
    
    [self checkAuthorForAuthorID:[eventTimeAuthor valueForKey:@"AuthorID"]];
    [self checkAuthorDetailsForAuthorID:[eventTimeAuthor valueForKey:@"AuthorID"]];
    
    
    // Create a request to fetch all EventTimeAuthors.
    
    NSEntityDescription *eventTimeAuthorEntity = [NSEntityDescription entityForName:@"EventTimeAuthor" inManagedObjectContext:context];
    
    NSFetchRequest *allEventTimeAuthorsRequest = [[NSFetchRequest alloc] init];
    [allEventTimeAuthorsRequest setEntity:eventTimeAuthorEntity];
    
    //Set a predicate to search for the primary key
    predicate = [NSPredicate predicateWithFormat:@"(TimeAuthorID == %@)",[eventTimeAuthor valueForKey:@"TimeAuthorID"]];
    [allEventTimeAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    eventTimeAuthors = [context executeFetchRequest:allEventTimeAuthorsRequest error:errorFetchingEventTimeAuthors];
    
    [allEventTimeAuthorsRequest release];
    
    NSEnumerator *eventTimeAuthorsEnumerator = [eventTimeAuthors objectEnumerator];
    //NSManagedObject *tmp;
    
    NSError *errorAddingEventTimeAuthor;
    //NSMutableArray *eventTimeAuthorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    while ((tmp = [eventTimeAuthorsEnumerator nextObject]) != nil) {
        
        [tmp setValue:[eventTimeAuthor valueForKey:@"TimeAuthorID"] forKey:@"TimeAuthorID"];
        [tmp setValue:[eventTimeAuthor valueForKey:@"ParentTimeAuthorID"] forKey:@"ParentTimeAuthorID"];
        [tmp setValue:[eventTimeAuthor valueForKey:@"TimeID"] forKey:@"TimeID"];
        [tmp setValue:[eventTimeAuthor valueForKey:@"AuthorID"] forKey:@"AuthorID"];
        [tmp setValue:[eventTimeAuthor valueForKey:@"Attended"] forKey:@"Attended"];
        [tmp setValue:[eventTimeAuthor valueForKey:@"isAttending"] forKey:@"isAttending"];
        [tmp setValue:[eventTimeAuthor valueForKey:@"Cancelled"] forKey:@"Cancelled"];
        [tmp setValue:[eventTimeAuthor valueForKey:@"Invited"] forKey:@"Invited"];
        [tmp setValue:[eventTimeAuthor valueForKey:@"CreatedDate"] forKey:@"CreatedDate"];
        [tmp setValue:[eventTimeAuthor valueForKey:@"ModifiedDate"] forKey:@"ModifiedDate"];
        
        if (tmp != nil && [context save:errorAddingEventTimeAuthor] == NO) 
        {
            NSLog(@"boosh");
        }
        return;
        
    }
    
    
    
    NSManagedObject *newEventTimeAuthor = [NSEntityDescription insertNewObjectForEntityForName:@"EventTimeAuthor" inManagedObjectContext:context];
    
    [newEventTimeAuthor setValue:[eventTimeAuthor valueForKey:@"TimeAuthorID"] forKey:@"TimeAuthorID"];
    [newEventTimeAuthor setValue:[eventTimeAuthor valueForKey:@"ParentTimeAuthorID"] forKey:@"ParentTimeAuthorID"];
    [newEventTimeAuthor setValue:[eventTimeAuthor valueForKey:@"TimeID"] forKey:@"TimeID"];
    [newEventTimeAuthor setValue:[eventTimeAuthor valueForKey:@"AuthorID"] forKey:@"AuthorID"];
    [newEventTimeAuthor setValue:[eventTimeAuthor valueForKey:@"Attended"] forKey:@"Attended"];
    [newEventTimeAuthor setValue:[eventTimeAuthor valueForKey:@"isAttending"] forKey:@"isAttending"];
    [newEventTimeAuthor setValue:[eventTimeAuthor valueForKey:@"Cancelled"] forKey:@"Cancelled"];
    [newEventTimeAuthor setValue:[eventTimeAuthor valueForKey:@"Invited"] forKey:@"Invited"];
    [newEventTimeAuthor setValue:[eventTimeAuthor valueForKey:@"CreatedDate"] forKey:@"CreatedDate"];
    [newEventTimeAuthor setValue:[eventTimeAuthor valueForKey:@"ModifiedDate"] forKey:@"ModifiedDate"];
    
    NSError *errorSavingEventTimeAuthor = nil;
    if (newEventTimeAuthor!=nil && [context save:errorSavingEventTimeAuthor] == NO) {
       // [context deleteObject:eventTimeAuthor];
        eventTimeAuthor = nil;
    }
}

-(NSMutableDictionary*)allAuthorsForTimeAuthorID:(NSString*)parentTimeAuthorID EventTimeAuthorOptions:(NSMutableArray*)eventTimeAuthorOptions AuthorOptions:(NSMutableArray*)authorOptions
{
    NSEnumerator *authorsEnumerator;
    NSMutableArray *authors = nil;
    
    NSEntityDescription *authorEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
    
    NSFetchRequest *allAuthorsRequest = [[NSFetchRequest alloc] init];
    
    if(![currentTimeID isEqualToString:@""]){
        //NSArray *unorderedDict = [self allAuthorsForTimeID:currentTimeID withEventTimeAuthorOptions:eventTimeAuthorOptions andAuthorOptions:authorOptions];
        
        [allAuthorsRequest setEntity:authorEntity];
        
        //Predicate for Primary Key
        NSMutableString *predString = [[NSMutableString alloc] initWithFormat:@"(TimeID = '%@') AND (ParentTimeAuthorID = '%@')",currentTimeID,parentTimeAuthorID];
        
        NSLog(@"predString: %@",predString);
        
        for(NSString *option in authorOptions)
        {
            [predString appendFormat:@" AND %@",option];
        }
        
        for(NSString *option in eventTimeAuthorOptions)
        {
            [predString appendFormat:@" AND %@",option];
        }
        
        //NSLog(@"predicate string: %@", predString);
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
        
        [predString release];
        [allAuthorsRequest setPredicate:predicate];
        
        [allAuthorsRequest setResultType:NSDictionaryResultType];
        
        // NSArray *propertiesArr = [[NSArray alloc] initWithObjects:@"AuthorID",@"AuthorFirstName",@"AuthorLastName",@"AuthorEmail",@"AuthorDOB",@"RegistrationCount", nil];
        
        //[allAuthorsRequest setPropertiesToFetch:propertiesArr];
        //[propertiesArr release];
        
        // Ask the context for everything matching the request.
        // If an error occurs, the context will return nil and an error in *error.
        NSError *errorFetchingAuthors = nil;
        authors = [context executeFetchRequest:allAuthorsRequest error:errorFetchingAuthors];
        authors = [NSMutableArray arrayWithArray:authors];
        
        NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"AuthorLastName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"AuthorFirstName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        NSSortDescriptor *emailDescriptor = [[NSSortDescriptor alloc] initWithKey:@"AuthorEmail" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        
        NSArray *sortDescriptorArr = [[NSArray alloc] initWithObjects:lastNameDescriptor,firstNameDescriptor,emailDescriptor,nil];
        
        [authors sortUsingDescriptors:sortDescriptorArr];
        
        [sortDescriptorArr release];
        [lastNameDescriptor release];
        [firstNameDescriptor release];
        [emailDescriptor release];
        //[context obtainPermanentIDsForObjects:authors error:errorFetchingAuthors];
        
        NSLog(@"Authors: %@", authors);
        
        authorsEnumerator = [authors objectEnumerator];
        
    }else{
        authorsEnumerator = [[NSArray array] objectEnumerator];
    }
    
    
    //NSLog(@"unordered: %@",unorderedDict);
    
    NSMutableArray *authorID = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *timeAuthorID = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *fname = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *lname = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *email = [[NSMutableArray alloc] initWithCapacity:0];
    //NSMutableArray *guests = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *attended = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *isAttending = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *cancelled = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *invited = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *optIn = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *dob = [[NSMutableArray alloc] initWithCapacity:0];
    NSManagedObject *tmp;
    
    
    while ((tmp = [authorsEnumerator nextObject]) != nil) 
    {
        NSLog(@"a dict");
        [authorID addObject:[tmp valueForKey:@"AuthorID"]];
        [timeAuthorID addObject:[tmp valueForKey:@"TimeAuthorID"]];
        [fname addObject:[tmp valueForKey:@"AuthorFirstName"]];
        [lname addObject:[tmp valueForKey:@"AuthorLastName"]];
        [email addObject:[tmp valueForKey:@"AuthorEmail"]];
        [dob addObject:[self parseDateSlashes:[tmp valueForKey:@"AuthorDOB"]]];
        //[guests addObject:[tmp valueForKey:@"Guests"]];
        [attended addObject:[tmp valueForKey:@"Attended"]];
        [isAttending addObject:[tmp valueForKey:@"isAttending"]];
        [cancelled addObject:[tmp valueForKey:@"Cancelled"]];
        [invited addObject:[tmp valueForKey:@"Invited"]];
        if([tmp valueForKey:@"IsOptedOut"]!=nil)
        {
            [optIn addObject:[tmp valueForKey:@"IsOptedOut"]];
        }else{
            [optIn addObject:[NSNumber numberWithInt:0]];
        }
    }
    //NSLog(@"authorIDs: %@",authorID);
    
    NSMutableDictionary *dataCollection = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dataCollection setObject:authorID forKey:@"AuthorID"];
    [dataCollection setObject:timeAuthorID forKey:@"TimeAuthorID"];
    [dataCollection setObject:fname forKey:@"AuthorFirstName"];
    [dataCollection setObject:lname forKey:@"AuthorLastName"];
    [dataCollection setObject:email forKey:@"AuthorEmail"];
    [dataCollection setObject:dob forKey:@"AuthorDOB"];
    //[dataCollection setObject:guests forKey:@"Guests"];
    [dataCollection setObject:attended forKey:@"Attended"];
    [dataCollection setObject:isAttending forKey:@"isAttending"];
    [dataCollection setObject:cancelled forKey:@"Cancelled"];
    [dataCollection setObject:invited forKey:@"Invited"];
    [dataCollection setObject:optIn forKey:@"optIn"];
    
    [authorID release];
    [timeAuthorID release];
    [fname release];
    [lname release];
    [email release];
    //[guests release];
    [attended release];
    [isAttending release];
    [cancelled release];
    [invited release];
    [optIn release];
    [dob release];
    
    NSLog(@"dataCollection: %@",dataCollection);
    
    return [dataCollection autorelease];
}
/*
-(NSMutableDictionary*)allGuestsForTimeAuthorID:(NSString*)timeAuthorID 
                withEventTimeAuthorOptions:(NSMutableArray*)eventTimeAuthorOptions 
                          andAuthorOptions:(NSMutableArray*)authorOptions
{
    NSLog(@"allAuthors");
    
    NSError *errorFetchingAuthors = nil;
    NSArray *authors = nil;
    
    NSArray *eventTimeAuthors = [self guestsForEventTimeAuthor:timeAuthorID EventTimeAuthorOptions:eventTimeAuthorOptions];
    
    NSMutableArray *authorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    for(NSMutableDictionary *eventTimeAuthor in eventTimeAuthors){
        NSLog(@"an EventtimeAuthor");
        
        NSEntityDescription *authorEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
        
        NSFetchRequest *allAuthorsRequest = [[NSFetchRequest alloc] init];
        [allAuthorsRequest setEntity:authorEntity];
        
        //Predicate for Primary Key
        NSMutableString *predString = [[NSMutableString alloc] initWithFormat:@"(AuthorID = '%@')",[eventTimeAuthor objectForKey:@"AuthorID"]];
        
        NSLog(@"predString: %@",predString);
        
        for(NSString *option in authorOptions)
        {
            [predString appendFormat:@" AND %@",option];
        }
        
        //NSLog(@"predicate string: %@", predString);
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
        
        [predString release];
        
        [allAuthorsRequest setPredicate:predicate];
        
        [allAuthorsRequest setResultType:NSDictionaryResultType];
        
        NSArray *propertiesArr = [[NSArray alloc] initWithObjects:@"AuthorID",@"AuthorFirstName",@"AuthorLastName",@"AuthorEmail",@"AuthorDOB", nil];
        
        [allAuthorsRequest setPropertiesToFetch:propertiesArr];
        
        [propertiesArr release];
        // Ask the context for everything matching the request.
        // If an error occurs, the context will return nil and an error in *error.
        
        authors = [context executeFetchRequest:allAuthorsRequest error:errorFetchingAuthors];
        //[context obtainPermanentIDsForObjects:authors error:errorFetchingAuthors];
        
        [allAuthorsRequest release];
        
        NSLog(@"Authors: %@", authors);
        
        NSEnumerator *authorsEnumerator = [authors objectEnumerator];
        NSManagedObject *tmp;
        
        
        while ((tmp = [authorsEnumerator nextObject]) != nil) {
            NSMutableDictionary *author = [[NSMutableDictionary alloc ]initWithDictionary:tmp];
            NSLog(@"temp author: %@",tmp);
            
            [author setValue:[eventTimeAuthor valueForKey:@"TimeAuthorID"] forKey:@"TimeAuthorID"];
            [author setValue:[eventTimeAuthor valueForKey:@"Attended"] forKey:@"Attended"];
            [author setValue:[eventTimeAuthor valueForKey:@"isAttending"] forKey:@"isAttending"];
            [author setValue:[eventTimeAuthor valueForKey:@"Cancelled"] forKey:@"Cancelled"];
            [author setValue:[eventTimeAuthor valueForKey:@"Invited"] forKey:@"Invited"];
            NSString *guestStr = [[NSString alloc] initWithFormat:@"%d",[self numGuestsForEventTimeAuthor:[eventTimeAuthor valueForKey:@"TimeAuthorID"]]];
            [author setValue:guestStr forKey:@"Guests"];
            [guestStr release];
            
            [author setValue:[self parseDateSlashes:[tmp valueForKey:@"AuthorDOB"]] forKey:@"AuthorDOB"];
            
            /* GRAB AUTHOR DETAILS */
/*            
            NSError *errorFetchingAuthorDetails = nil;
            NSArray *authorDetails = nil;
            
            // Create a request to fetch all Authors.
            
            NSEntityDescription *authorDetailEntity = [NSEntityDescription entityForName:@"AuthorDetail" inManagedObjectContext:context];
            
            NSFetchRequest *allAuthorDetailsRequest = [[NSFetchRequest alloc] init];
            [allAuthorDetailsRequest setEntity:authorDetailEntity];
            
            //Set a predicate to search for the primary key
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID == %@)",[author valueForKey:@"AuthorID"]];
            [allAuthorDetailsRequest setPredicate:predicate];
            
            // Ask the context for everything matching the request.
            // If an error occurs, the context will return nil and an error in *error.
            
            authorDetails = [context executeFetchRequest:allAuthorDetailsRequest error:errorFetchingAuthorDetails];
            
            [allAuthorDetailsRequest release];
            
            NSEnumerator *authorDetailsEnumerator = [authorDetails objectEnumerator];
            NSManagedObject *tmp2;
            
            NSError *errorAddingAuthoDetail;
            //NSMutableArray *authorDetailsData = [[NSMutableArray alloc] initWithCapacity:0];
            
            while ((tmp2 = [authorDetailsEnumerator nextObject]) != nil) {
                //   NSLog(@"lists -> tmp AuthorDetail: %@",tmp2);
                //   NSLog(@"lists -> tmp AuthorDetail IsOptedOut: %@",[tmp2 valueForKey:@"IsOptedOut"]);
                
                NSNumber *flag;
                
                if([[tmp2 valueForKey:@"IsOptedOut"]boolValue] == NO){
                    //     NSLog(@"was zero");
                    flag = [NSNumber numberWithInt:1];
                }else{
                    //     NSLog(@"was one");
                    flag = [NSNumber numberWithInt:0];
                }
                
                [author setValue:flag forKey:@"optIn"];
                //  NSLog(@"author: %@",author);
            }
            
            [authorsData addObject:author];
            [author release];
        }

    }
    // Clean up and return.
    
    
    //*/
/*    NSLog(@"authorsData: %@",authorsData);
    return [authorsData autorelease];
}

*/
-(NSMutableDictionary*)allAuthorsForCurrentTime:(NSMutableArray*)eventTimeAuthorOptions AuthorOptions:(NSMutableArray*)authorOptions
{
    NSEnumerator *authorsEnumerator;
    NSMutableArray *authors = nil;
    
    NSEntityDescription *authorEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
    
    NSFetchRequest *allAuthorsRequest = [[NSFetchRequest alloc] init];
    
    if(![currentTimeID isEqualToString:@""]){
        //NSArray *unorderedDict = [self allAuthorsForTimeID:currentTimeID withEventTimeAuthorOptions:eventTimeAuthorOptions andAuthorOptions:authorOptions];
        
        [allAuthorsRequest setEntity:authorEntity];
        
        //Predicate for Primary Key
        NSMutableString *predString = [[NSMutableString alloc] initWithFormat:@"(TimeID = '%@')",currentTimeID];
        
        NSLog(@"predString: %@",predString);
        
        for(NSString *option in authorOptions)
        {
            [predString appendFormat:@" AND %@",option];
        }
        
        for(NSString *option in eventTimeAuthorOptions)
        {
            [predString appendFormat:@" AND %@",option];
        }
        
        //NSLog(@"predicate string: %@", predString);
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
        
        [predString release];
        [allAuthorsRequest setPredicate:predicate];
        
        [allAuthorsRequest setResultType:NSDictionaryResultType];
        
        // NSArray *propertiesArr = [[NSArray alloc] initWithObjects:@"AuthorID",@"AuthorFirstName",@"AuthorLastName",@"AuthorEmail",@"AuthorDOB",@"RegistrationCount", nil];
        
        //[allAuthorsRequest setPropertiesToFetch:propertiesArr];
        //[propertiesArr release];
        
        // Ask the context for everything matching the request.
        // If an error occurs, the context will return nil and an error in *error.
        NSError *errorFetchingAuthors = nil;
        authors = [context executeFetchRequest:allAuthorsRequest error:errorFetchingAuthors];
        authors = [NSMutableArray arrayWithArray:authors];
        
        NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"AuthorLastName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"AuthorFirstName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        NSSortDescriptor *emailDescriptor = [[NSSortDescriptor alloc] initWithKey:@"AuthorEmail" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        
        NSArray *sortDescriptorArr = [[NSArray alloc] initWithObjects:lastNameDescriptor,firstNameDescriptor,emailDescriptor,nil];
        
        [authors sortUsingDescriptors:sortDescriptorArr];
        
        [sortDescriptorArr release];
        [lastNameDescriptor release];
        [firstNameDescriptor release];
        [emailDescriptor release];
        //[context obtainPermanentIDsForObjects:authors error:errorFetchingAuthors];
        
        NSLog(@"Authors: %@", authors);
        
        authorsEnumerator = [authors objectEnumerator];
    
    }else{
        authorsEnumerator = [[NSArray array] objectEnumerator];
    }
    
    NSManagedObject *tmp;
    
    NSMutableArray *authorID = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *timeAuthorID = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *fname = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *lname = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *dob = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *email = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *guests = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *attended = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *isAttending = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *cancelled = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *invited = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *optIn = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *regCount = [[NSMutableArray alloc] initWithCapacity:0];
    
    while ((tmp = [authorsEnumerator nextObject]) != nil) {
        /*
        NSMutableDictionary *author = [[NSMutableDictionary alloc] initWithDictionary:tmp];
        NSLog(@"temp author: %@",tmp);
        
        [author setValue:[tmp valueForKey:@"TimeAuthorID"] forKey:@"TimeAuthorID"];
        [author setValue:[tmp valueForKey:@"Attended"] forKey:@"Attended"];
        [author setValue:[tmp valueForKey:@"isAttending"] forKey:@"isAttending"];
        [author setValue:[tmp valueForKey:@"Cancelled"] forKey:@"Cancelled"];
        [author setValue:[tmp valueForKey:@"Invited"] forKey:@"Invited"];
        //NSString *guestStr = [[NSString alloc] initWithFormat:@"%d",[self numGuestsForEventTimeAuthor:[eventTimeAuthor valueForKey:@"TimeAuthorID"]]];
        //[author setValue:guestStr forKey:@"Guests"];
        //[guestStr release];
        //NSLog(@"Author Reg Count: %d",[[tmp valueForKey:@"RegistrationCount"]integerValue]);
        //NSString *regStr = [[NSString alloc] initWithFormat:@"%d",[[tmp valueForKey:@"RegistrationCount"]integerValue]];
        //[author setValue:regStr forKey:@"RegistrationCount"];
        //[regStr release];
        [author setValue:[self parseDateSlashes:[tmp valueForKey:@"AuthorDOB"]] forKey:@"AuthorDOB"];
        NSNumber *flag;
        if([[tmp valueForKey:@"IsOptedOut"]boolValue] == NO){
            //     NSLog(@"was zero");
            flag = [NSNumber numberWithInt:1];
        }else{
            //     NSLog(@"was one");
            flag = [NSNumber numberWithInt:0];
        }
        
        [author setValue:flag forKey:@"optIn"];
        
        /* GRAB AUTHOR DETAILS */
        /* 
         NSError *errorFetchingAuthorDetails = nil;
         NSArray *authorDetails = nil;
         
         // Create a request to fetch all Authors.
         
         NSEntityDescription *authorDetailEntity = [NSEntityDescription entityForName:@"AuthorDetail" inManagedObjectContext:context];
         
         NSFetchRequest *allAuthorDetailsRequest = [[NSFetchRequest alloc] init];
         [allAuthorDetailsRequest setEntity:authorDetailEntity];
         
         //Set a predicate to search for the primary key
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID == %@)",[author valueForKey:@"AuthorID"]];
         [allAuthorDetailsRequest setPredicate:predicate];
         
         // Ask the context for everything matching the request.
         // If an error occurs, the context will return nil and an error in *error.
         
         authorDetails = [context executeFetchRequest:allAuthorDetailsRequest error:errorFetchingAuthorDetails];
         
         [allAuthorDetailsRequest release];
         
         NSEnumerator *authorDetailsEnumerator = [authorDetails objectEnumerator];
         NSManagedObject *tmp2;
         
         NSError *errorAddingAuthoDetail;
         //NSMutableArray *authorDetailsData = [[NSMutableArray alloc] initWithCapacity:0];
         
         while ((tmp2 = [authorDetailsEnumerator nextObject]) != nil) {
         //   NSLog(@"lists -> tmp AuthorDetail: %@",tmp2);
         //   NSLog(@"lists -> tmp AuthorDetail IsOptedOut: %@",[tmp2 valueForKey:@"IsOptedOut"]);
         
         NSNumber *flag;
         
         if([[tmp2 valueForKey:@"IsOptedOut"]boolValue] == NO){
         //     NSLog(@"was zero");
         flag = [NSNumber numberWithInt:1];
         }else{
         //     NSLog(@"was one");
         flag = [NSNumber numberWithInt:0];
         }
         
         [author setValue:flag forKey:@"optIn"];
         //  NSLog(@"author: %@",author);
         }
         */
        //[authorsData addObject:author];
        //[author release];
        [authorID addObject:[tmp valueForKey:@"AuthorID"]];
        [timeAuthorID addObject:[tmp valueForKey:@"TimeAuthorID"]];
        [fname addObject:[tmp valueForKey:@"AuthorFirstName"]];
        [lname addObject:[tmp valueForKey:@"AuthorLastName"]];
        [email addObject:[tmp valueForKey:@"AuthorEmail"]];
        [dob addObject:[self parseDateSlashes:[tmp valueForKey:@"AuthorDOB"]]];
        NSString *guestStr = [[NSString alloc] initWithFormat:@"%d",[self numGuestsForEventTimeAuthor:[tmp valueForKey:@"TimeAuthorID"]]];
        [guests addObject:guestStr];
        [guestStr release];
        [attended addObject:[tmp valueForKey:@"Attended"]];
        [isAttending addObject:[tmp valueForKey:@"isAttending"]];
        [cancelled addObject:[tmp valueForKey:@"Cancelled"]];
        [invited addObject:[tmp valueForKey:@"Invited"]];
        if([tmp valueForKey:@"IsOptedOut"]!=nil)
        {
            NSLog(@"IsOptedOut exists");
            if([[tmp valueForKey:@"IsOptedOut"] isEqual:[NSNumber numberWithBool:YES]])
            {
                [optIn addObject:[NSNumber numberWithBool:YES]];
            }else{
                [optIn addObject:[NSNumber numberWithBool:NO]];
            }
        }else{
            [optIn addObject:[NSNumber numberWithInt:0]];
        }
        [regCount addObject:[tmp valueForKey:@"RegistrationCount"]];
    }
    
    [allAuthorsRequest release];
    
   
    /*
    //NSLog(@"unordered: %@",unorderedDict);
    
    NSMutableArray *authorID = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *timeAuthorID = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *fname = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *lname = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *dob = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *email = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *guests = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *attended = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *isAttending = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *cancelled = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *invited = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *optIn = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *regCount = [[NSMutableArray alloc] initWithCapacity:0];
    
    for(NSDictionary *dict in unorderedDict)
    {
        NSLog(@"a dict: %@",dict);
        [authorID addObject:[dict valueForKey:@"AuthorID"]];
        //[timeAuthorID addObject:[dict valueForKey:@"TimeAuthorID"]];
        [fname addObject:[dict valueForKey:@"AuthorFirstName"]];
        [lname addObject:[dict valueForKey:@"AuthorLastName"]];
        [email addObject:[dict valueForKey:@"AuthorEmail"]];
        [dob addObject:[dict valueForKey:@"AuthorDOB"]];
      //  [guests addObject:[dict valueForKey:@"Guests"]];
        [attended addObject:[dict valueForKey:@"Attended"]];
        [isAttending addObject:[dict valueForKey:@"isAttending"]];
        [cancelled addObject:[dict valueForKey:@"Cancelled"]];
        [invited addObject:[dict valueForKey:@"Invited"]];
        if([dict valueForKey:@"optIn"]!=nil)
        {
            [optIn addObject:[dict valueForKey:@"optIn"]];
        }else{
            [optIn addObject:[NSNumber numberWithInt:0]];
        }
        //[regCount addObject:[dict valueForKey:@"RegistrationCount"]];
    }
    NSLog(@"regCounts: %@",regCount);
    */
    NSMutableDictionary *dataCollection = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dataCollection setObject:authorID forKey:@"AuthorID"];
    [dataCollection setObject:timeAuthorID forKey:@"TimeAuthorID"];
    [dataCollection setObject:fname forKey:@"AuthorFirstName"];
    [dataCollection setObject:lname forKey:@"AuthorLastName"];
    [dataCollection setObject:email forKey:@"AuthorEmail"];
    [dataCollection setObject:dob forKey:@"AuthorDOB"];
    [dataCollection setObject:guests forKey:@"Guests"];
    [dataCollection setObject:attended forKey:@"Attended"];
    [dataCollection setObject:isAttending forKey:@"isAttending"];
    [dataCollection setObject:cancelled forKey:@"Cancelled"];
    [dataCollection setObject:invited forKey:@"Invited"];
    [dataCollection setObject:optIn forKey:@"optIn"];
    [dataCollection setObject:regCount forKey:@"RegistrationCount"];
    
   NSLog(@"dataCollection: %@",dataCollection);
    
    [authorID release];
    [timeAuthorID release];
    [fname release];
    [lname release];
    [email release];
    [guests release];
    [attended release];
    [isAttending release];
    [cancelled release];
    [invited release];
    [optIn release];
    [dob release];
    [regCount release];
    
    return [dataCollection autorelease];
}
 
/*
-(NSMutableDictionary*)allAuthorsForTimeID:(NSString*)timeID 
                withEventTimeAuthorOptions:(NSMutableArray*)eventTimeAuthorOptions 
                          andAuthorOptions:(NSMutableArray*)authorOptions
{
    NSLog(@"allAuthors");
    
    NSError *errorFetchingAuthors = nil;
    NSArray *authors = nil;
    
    NSArray *eventTimeAuthors = [self eventTimeAuthorsForTimeID:timeID withOptions:eventTimeAuthorOptions];
    
    NSMutableArray *authorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    for(NSMutableDictionary *eventTimeAuthor in eventTimeAuthors){
        NSLog(@"an EventtimeAuthor");
        
        NSEntityDescription *authorEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
        
        NSFetchRequest *allAuthorsRequest = [[NSFetchRequest alloc] init];
        [allAuthorsRequest setEntity:authorEntity];
        
        //Predicate for Primary Key
        NSMutableString *predString = [[NSMutableString alloc] initWithFormat:@"(AuthorID == \"%@\")",[eventTimeAuthor objectForKey:@"AuthorID"]];
        
        NSLog(@"predString: %@",predString);
       
        for(NSString *option in authorOptions)
        {
            [predString appendFormat:@" AND %@",option];
        }
        
        //NSLog(@"predicate string: %@", predString);
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
        
        [predString release];
        [allAuthorsRequest setPredicate:predicate];
        
        [allAuthorsRequest setResultType:NSDictionaryResultType];
        
        NSArray *propertiesArr = [[NSArray alloc] initWithObjects:@"AuthorID",@"AuthorFirstName",@"AuthorLastName",@"AuthorEmail",@"AuthorDOB",@"RegistrationCount", nil];
        
        [allAuthorsRequest setPropertiesToFetch:propertiesArr];
        [propertiesArr release];
        
        // Ask the context for everything matching the request.
        // If an error occurs, the context will return nil and an error in *error.
        
        authors = [context executeFetchRequest:allAuthorsRequest error:errorFetchingAuthors];
        //[context obtainPermanentIDsForObjects:authors error:errorFetchingAuthors];
        
        NSLog(@"Authors: %@", authors);
        
        NSEnumerator *authorsEnumerator = [authors objectEnumerator];
        NSManagedObject *tmp;
        
       
        while ((tmp = [authorsEnumerator nextObject]) != nil) {
            NSMutableDictionary *author = [[NSMutableDictionary alloc] initWithDictionary:tmp];
            NSLog(@"temp author: %@",tmp);
        
            [author setValue:[eventTimeAuthor valueForKey:@"TimeAuthorID"] forKey:@"TimeAuthorID"];
            [author setValue:[eventTimeAuthor valueForKey:@"Attended"] forKey:@"Attended"];
            [author setValue:[eventTimeAuthor valueForKey:@"isAttending"] forKey:@"isAttending"];
            [author setValue:[eventTimeAuthor valueForKey:@"Cancelled"] forKey:@"Cancelled"];
            [author setValue:[eventTimeAuthor valueForKey:@"Invited"] forKey:@"Invited"];
            NSString *guestStr = [[NSString alloc] initWithFormat:@"%d",[self numGuestsForEventTimeAuthor:[eventTimeAuthor valueForKey:@"TimeAuthorID"]]];
            [author setValue:guestStr forKey:@"Guests"];
            [guestStr release];
            NSLog(@"Author Reg Count: %d",[[tmp valueForKey:@"RegistrationCount"]integerValue]);
            NSString *regStr = [[NSString alloc] initWithFormat:@"%d",[[tmp valueForKey:@"RegistrationCount"]integerValue]];
            [author setValue:regStr forKey:@"RegistrationCount"];
            [regStr release];
            [author setValue:[self parseDateSlashes:[tmp valueForKey:@"AuthorDOB"]] forKey:@"AuthorDOB"];
            
            
            /* GRAB AUTHOR DETAILS */
    /*        
            NSError *errorFetchingAuthorDetails = nil;
            NSArray *authorDetails = nil;
            
            // Create a request to fetch all Authors.
            
            NSEntityDescription *authorDetailEntity = [NSEntityDescription entityForName:@"AuthorDetail" inManagedObjectContext:context];
            
            NSFetchRequest *allAuthorDetailsRequest = [[NSFetchRequest alloc] init];
            [allAuthorDetailsRequest setEntity:authorDetailEntity];
            
            //Set a predicate to search for the primary key
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID == %@)",[author valueForKey:@"AuthorID"]];
            [allAuthorDetailsRequest setPredicate:predicate];
            
            // Ask the context for everything matching the request.
            // If an error occurs, the context will return nil and an error in *error.
            
            authorDetails = [context executeFetchRequest:allAuthorDetailsRequest error:errorFetchingAuthorDetails];
            
            [allAuthorDetailsRequest release];
            
            NSEnumerator *authorDetailsEnumerator = [authorDetails objectEnumerator];
            NSManagedObject *tmp2;
            
            NSError *errorAddingAuthoDetail;
            //NSMutableArray *authorDetailsData = [[NSMutableArray alloc] initWithCapacity:0];
            
            while ((tmp2 = [authorDetailsEnumerator nextObject]) != nil) {
             //   NSLog(@"lists -> tmp AuthorDetail: %@",tmp2);
             //   NSLog(@"lists -> tmp AuthorDetail IsOptedOut: %@",[tmp2 valueForKey:@"IsOptedOut"]);
                
                NSNumber *flag;
                
                if([[tmp2 valueForKey:@"IsOptedOut"]boolValue] == NO){
               //     NSLog(@"was zero");
                    flag = [NSNumber numberWithInt:1];
                }else{
               //     NSLog(@"was one");
                    flag = [NSNumber numberWithInt:0];
                }
                    
                [author setValue:flag forKey:@"optIn"];
              //  NSLog(@"author: %@",author);
            }
            
            [authorsData addObject:author];
            [author release];
        }
        
        [allAuthorsRequest release];
    }
    // Clean up and return.
    
     
    
    NSLog(@"authorsData: %@",authorsData);
    return [authorsData autorelease];
}
*/

-(NSMutableDictionary*)allAuthorsForTimeID:(NSString*)timeID 
                withEventTimeAuthorOptions:(NSMutableArray*)eventTimeAuthorOptions 
                          andAuthorOptions:(NSMutableArray*)authorOptions
{
    NSLog(@"allAuthors");
    
    NSError *errorFetchingAuthors = nil;
    NSArray *authors = nil;
    
    //NSArray *eventTimeAuthors = [self eventTimeAuthorsForTimeID:timeID withOptions:eventTimeAuthorOptions];
    
    NSMutableArray *authorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    
        NSEntityDescription *authorEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
        
        NSFetchRequest *allAuthorsRequest = [[NSFetchRequest alloc] init];
        [allAuthorsRequest setEntity:authorEntity];
        
        //Predicate for Primary Key
        NSMutableString *predString = [[NSMutableString alloc] initWithFormat:@"(TimeID = %@)",timeID];
        
        NSLog(@"predString: %@",predString);
        
        for(NSString *option in authorOptions)
        {
            [predString appendFormat:@" AND %@",option];
        }
    
        for(NSString *option in eventTimeAuthorOptions)
        {
            [predString appendFormat:@" AND %@",option];
        }
        
        //NSLog(@"predicate string: %@", predString);
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
        
        [predString release];
        [allAuthorsRequest setPredicate:predicate];
        
        [allAuthorsRequest setResultType:NSDictionaryResultType];
        
       // NSArray *propertiesArr = [[NSArray alloc] initWithObjects:@"AuthorID",@"AuthorFirstName",@"AuthorLastName",@"AuthorEmail",@"AuthorDOB",@"RegistrationCount", nil];
        
        //[allAuthorsRequest setPropertiesToFetch:propertiesArr];
        //[propertiesArr release];
        
        // Ask the context for everything matching the request.
        // If an error occurs, the context will return nil and an error in *error.
        
        authors = [context executeFetchRequest:allAuthorsRequest error:errorFetchingAuthors];
        //[context obtainPermanentIDsForObjects:authors error:errorFetchingAuthors];
        
        NSLog(@"Authors: %@", authors);
        
        NSEnumerator *authorsEnumerator = [authors objectEnumerator];
        NSManagedObject *tmp;
        
        
        while ((tmp = [authorsEnumerator nextObject]) != nil) {
            NSMutableDictionary *author = [[NSMutableDictionary alloc] initWithDictionary:tmp];
            NSLog(@"temp author: %@",tmp);
            
            [author setValue:[tmp valueForKey:@"TimeAuthorID"] forKey:@"TimeAuthorID"];
            [author setValue:[tmp valueForKey:@"Attended"] forKey:@"Attended"];
            [author setValue:[tmp valueForKey:@"isAttending"] forKey:@"isAttending"];
            [author setValue:[tmp valueForKey:@"Cancelled"] forKey:@"Cancelled"];
            [author setValue:[tmp valueForKey:@"Invited"] forKey:@"Invited"];
            NSString *guestStr = [[NSString alloc] initWithFormat:@"%d",
                                  [self numGuestsForEventTimeAuthor:[tmp valueForKey:@"TimeAuthorID"]]];
            [author setValue:guestStr forKey:@"Guests"];
            [guestStr release];
            //NSLog(@"Author Reg Count: %d",[[tmp valueForKey:@"RegistrationCount"]integerValue]);
            NSString *regStr = [[NSString alloc] initWithFormat:@"%d",[[tmp valueForKey:@"RegistrationCount"]integerValue]];
            [author setValue:regStr forKey:@"RegistrationCount"];
            [regStr release];
            [author setValue:[self parseDateSlashes:[tmp valueForKey:@"AuthorDOB"]] forKey:@"AuthorDOB"];
            NSNumber *flag;
            if([[tmp valueForKey:@"IsOptedOut"]boolValue] == NO){
                //     NSLog(@"was zero");
                flag = [NSNumber numberWithInt:0];
            }else{
                //     NSLog(@"was one");
                flag = [NSNumber numberWithInt:1];
            }
            
            [author setValue:flag forKey:@"optIn"];
           
            /* GRAB AUTHOR DETAILS */
           /* 
            NSError *errorFetchingAuthorDetails = nil;
            NSArray *authorDetails = nil;
            
            // Create a request to fetch all Authors.
            
            NSEntityDescription *authorDetailEntity = [NSEntityDescription entityForName:@"AuthorDetail" inManagedObjectContext:context];
            
            NSFetchRequest *allAuthorDetailsRequest = [[NSFetchRequest alloc] init];
            [allAuthorDetailsRequest setEntity:authorDetailEntity];
            
            //Set a predicate to search for the primary key
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID == %@)",[author valueForKey:@"AuthorID"]];
            [allAuthorDetailsRequest setPredicate:predicate];
            
            // Ask the context for everything matching the request.
            // If an error occurs, the context will return nil and an error in *error.
            
            authorDetails = [context executeFetchRequest:allAuthorDetailsRequest error:errorFetchingAuthorDetails];
            
            [allAuthorDetailsRequest release];
            
            NSEnumerator *authorDetailsEnumerator = [authorDetails objectEnumerator];
            NSManagedObject *tmp2;
            
            NSError *errorAddingAuthoDetail;
            //NSMutableArray *authorDetailsData = [[NSMutableArray alloc] initWithCapacity:0];
            
            while ((tmp2 = [authorDetailsEnumerator nextObject]) != nil) {
                //   NSLog(@"lists -> tmp AuthorDetail: %@",tmp2);
                //   NSLog(@"lists -> tmp AuthorDetail IsOptedOut: %@",[tmp2 valueForKey:@"IsOptedOut"]);
                
                NSNumber *flag;
                
                if([[tmp2 valueForKey:@"IsOptedOut"]boolValue] == NO){
                    //     NSLog(@"was zero");
                    flag = [NSNumber numberWithInt:1];
                }else{
                    //     NSLog(@"was one");
                    flag = [NSNumber numberWithInt:0];
                }
                
                [author setValue:flag forKey:@"optIn"];
                //  NSLog(@"author: %@",author);
            }
            */
            [authorsData addObject:author];
            [author release];
        }
        
        [allAuthorsRequest release];
    //}
    // Clean up and return.
    
    
    //*/
    NSLog(@"authorsData: %@",authorsData);
    return [authorsData autorelease];
}


-(NSMutableArray*)eventTimeAuthorsForTimeID:(NSString*)timeID withOptions:(NSMutableArray*)eventTimeAuthorOptions 
{
    NSLog(@"allEventTimeAuthors");
    
    NSError *errorFetchingEventTimeAuthors = nil;
    NSArray *eventTimeAuthors = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *eventTimeAuthorEntity = [NSEntityDescription entityForName:@"EventTimeAuthor" inManagedObjectContext:context];
    
    NSFetchRequest *allEventTimeAuthorsRequest = [[NSFetchRequest alloc] init];
    [allEventTimeAuthorsRequest setEntity:eventTimeAuthorEntity];
    
    //Predicate for Primary Key
    NSMutableString *predString = [[NSMutableString alloc] initWithFormat:@"(TimeID = %@)",timeID];
    
    for(NSString *option in eventTimeAuthorOptions)
    {
        [predString appendFormat:@" AND %@",option];
    }
    
    //NSLog(@"predicate string: %@",predString);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
    [predString release];
    [allEventTimeAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    eventTimeAuthors = [context executeFetchRequest:allEventTimeAuthorsRequest error:errorFetchingEventTimeAuthors];
    [context obtainPermanentIDsForObjects:eventTimeAuthors error:errorFetchingEventTimeAuthors];
    
    NSEnumerator *eventTimeAuthorsEnumerator = [eventTimeAuthors objectEnumerator];
    NSManagedObject *tmp;
    
    
    NSMutableArray *eventTimeAuthorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    while ((tmp = [eventTimeAuthorsEnumerator nextObject]) != nil) {
        NSMutableDictionary *eventTimeAuthor = [NSMutableDictionary dictionaryWithCapacity:0];
    //    NSLog(@"temp eventTimeAuthor: %@",tmp);
        
        [eventTimeAuthor setValue:[tmp valueForKey:@"TimeAuthorID"] forKey:@"TimeAuthorID"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"ParentTimeAuthorID"] forKey:@"ParentTimeAuthorID"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"TimeID"] forKey:@"TimeID"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"AuthorID"] forKey:@"AuthorID"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"Attended"] forKey:@"Attended"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"isAttending"] forKey:@"isAttending"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"Cancelled"] forKey:@"Cancelled"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"Invited"] forKey:@"Invited"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"CreatedDate"] forKey:@"CreatedDate"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"ModifiedDate"] forKey:@"ModifiedDate"];
        
        [eventTimeAuthorsData addObject:eventTimeAuthor];
    }
    
    
    // Clean up and return.
    [allEventTimeAuthorsRequest release];
    
   
    return [eventTimeAuthorsData autorelease];
}

-(NSUInteger)numGuestsForEventTimeAuthor:(NSString*)eventTimeAuthorID 
{
    NSLog(@"numGuestsForEventTimeAuthor");
    
    NSError *errorFetchingEventTimeAuthors = nil;
    NSArray *eventTimeAuthors = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *eventTimeAuthorEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
    
    NSFetchRequest *allEventTimeAuthorsRequest = [[NSFetchRequest alloc] init];
    [allEventTimeAuthorsRequest setEntity:eventTimeAuthorEntity];
    
    //Predicate for Primary Key
    NSMutableString *predString = [[NSMutableString alloc] initWithFormat:@"(ParentTimeAuthorID = '%@')",eventTimeAuthorID];

    
    NSLog(@"predicate string: %@",predString);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
    [predString release];
    
    [allEventTimeAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    eventTimeAuthors = [context executeFetchRequest:allEventTimeAuthorsRequest error:errorFetchingEventTimeAuthors];
    [context obtainPermanentIDsForObjects:eventTimeAuthors error:errorFetchingEventTimeAuthors];
    
    
    
    // Clean up and return.
    [allEventTimeAuthorsRequest release];
    
    NSLog(@"numGuestsForEventTimeAuthor: %d", [eventTimeAuthors count]);
    
    return [eventTimeAuthors count];
}

-(NSMutableArray*)guestsForEventTimeAuthor:(NSString*)eventTimeAuthorID EventTimeAuthorOptions:(NSString*)eventTimeAuthorOptions
{
    NSLog(@"numGuestsForEventTimeAuthor");
    
    NSError *errorFetchingEventTimeAuthors = nil;
    NSArray *eventTimeAuthors = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *eventTimeAuthorEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
    
    NSFetchRequest *allEventTimeAuthorsRequest = [[NSFetchRequest alloc] init];
    [allEventTimeAuthorsRequest setEntity:eventTimeAuthorEntity];
    
    //Predicate for Primary Key
    NSMutableString *predString = [[NSMutableString alloc] initWithFormat:@"(ParentTimeAuthorID = '%@')",eventTimeAuthorID];
    
    for(NSString *option in eventTimeAuthorOptions)
    {
        [predString appendFormat:@" AND %@",option];
    }
    
    //NSLog(@"predicate string: %@",predString);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predString];
    
    [predString release];
    
    [allEventTimeAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    eventTimeAuthors = [context executeFetchRequest:allEventTimeAuthorsRequest error:errorFetchingEventTimeAuthors];
    [context obtainPermanentIDsForObjects:eventTimeAuthors error:errorFetchingEventTimeAuthors];
    
    NSEnumerator *eventTimeAuthorsEnumerator = [eventTimeAuthors objectEnumerator];
    NSManagedObject *tmp;
    
    
    NSMutableArray *eventTimeAuthorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    while ((tmp = [eventTimeAuthorsEnumerator nextObject]) != nil) {
        NSMutableDictionary *eventTimeAuthor = [NSMutableDictionary dictionaryWithCapacity:0];
        //    NSLog(@"temp eventTimeAuthor: %@",tmp);
        
        [eventTimeAuthor setValue:[tmp valueForKey:@"TimeAuthorID"] forKey:@"TimeAuthorID"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"ParentTimeAuthorID"] forKey:@"ParentTimeAuthorID"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"TimeID"] forKey:@"TimeID"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"AuthorID"] forKey:@"AuthorID"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"Attended"] forKey:@"Attended"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"isAttending"] forKey:@"isAttending"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"Cancelled"] forKey:@"Cancelled"];
        [eventTimeAuthor setValue:[tmp valueForKey:@"Invited"] forKey:@"Invited"];
        //[eventTimeAuthor setValue:[tmp valueForKey:@"CreatedDate"] forKey:@"CreatedDate"];
        //[eventTimeAuthor setValue:[tmp valueForKey:@"ModifiedDate"] forKey:@"ModifiedDate"];
        
        [eventTimeAuthorsData addObject:eventTimeAuthor];
    }
    
    // Clean up and return.
    [allEventTimeAuthorsRequest release];
    
    NSLog(@"numGuestsForEventTimeAuthor: %d", [eventTimeAuthors count]);
    
    return [eventTimeAuthorsData autorelease];
}

-(NSMutableArray*)allStudiesWithStats
{
    NSLog(@"allStudiesWithStats");
    
    NSError *errorFetchingStudiesWithStats = nil;
    NSArray *studiesWithStats = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *studiesWithStatEntity = [NSEntityDescription entityForName:@"StudiesWithStat" inManagedObjectContext:context];
    
    NSFetchRequest *allStudiesWithStatsRequest = [[NSFetchRequest alloc] init];
    [allStudiesWithStatsRequest setEntity:studiesWithStatEntity];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    studiesWithStats = [context executeFetchRequest:allStudiesWithStatsRequest error:errorFetchingStudiesWithStats];
    [context obtainPermanentIDsForObjects:studiesWithStats error:errorFetchingStudiesWithStats];
    
    NSEnumerator *studiesWithStatsEnumerator = [studiesWithStats objectEnumerator];
    NSManagedObject *tmp;
    
    
    NSMutableArray *studiesWithStatsData = [[NSMutableArray alloc] initWithCapacity:0];
    //*
    while ((tmp = [studiesWithStatsEnumerator nextObject]) != nil) {
        NSMutableDictionary *studiesWithStat = [NSMutableDictionary dictionaryWithCapacity:0];
        NSLog(@"temp studiesWithStat: %@",tmp);
       
        [studiesWithStat setValue:[tmp valueForKey:@"StudyID"] forKey:@"StudyID"];
        [studiesWithStat setValue:[tmp valueForKey:@"StudyName"] forKey:@"StudyName"];
        [studiesWithStat setValue:[tmp valueForKey:@"StudyDateCreated"] forKey:@"StudyDateCreated"];
        [studiesWithStat setValue:[tmp valueForKey:@"NumberOfAuthors"] forKey:@"NumberOfAuthors"];
        [studiesWithStat setValue:[tmp valueForKey:@"NumberOfDocs"] forKey:@"NumberOfDocs"];
        [studiesWithStat setValue:[tmp valueForKey:@"NumberOfURLs"] forKey:@"NumberOfURLs"];
        [studiesWithStat setValue:[tmp valueForKey:@"UserName"] forKey:@"UserName"];
        
        [studiesWithStatsData addObject:studiesWithStat];
    }
    
    
    // Clean up and return.
    
    [allStudiesWithStatsRequest release];
     
     //*/
    NSLog(@"studiesWithStatsData: %@",studiesWithStatsData);
    return [studiesWithStatsData autorelease];
}




-(void)setSentForPerson:(NSDictionary*)aPerson
{
   
    NSError *errorFetchingPeople = nil;
    NSArray *people = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *personEntity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    
    NSFetchRequest *allPeopleRequest = [[NSFetchRequest alloc] init];
    [allPeopleRequest setEntity:personEntity];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    people = [context executeFetchRequest:allPeopleRequest error:errorFetchingPeople];
    
    [allPeopleRequest release];
    
    NSEnumerator *peopleEnumerator = [people objectEnumerator];
    NSManagedObject *tmp;
    
    
    //NSMutableArray *peopleData = [[NSMutableArray alloc] initWithCapacity:0];
    //*
    while ((tmp = [peopleEnumerator nextObject]) != nil) {
        //NSLog(@"a person: \nPersistentRemoteID:%@\nInTheSkyRemoteID:%@",
          //    [tmp valueForKey:@"RemoteSystemID"],
            //  trimmed);
        if([[tmp valueForKey:@"RemoteSystemID"] isEqualToString:[aPerson valueForKey:@"RemoteSystemID"]])
        {
            [tmp setValue:@"true" forKey:@"Sent"];
            
            NSError *errorAddingPerson;
            if (tmp != nil && [context save:errorAddingPerson] == NO) 
            {
                NSLog(@"boosh");
            }
            
            break;
        }
    }
    
}

-(NSDictionary*)personForURI:(NSString*)objURI
{
    NSArray *people = [self allPeople];
    
    NSString *trimmed = [objURI stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //trimmed = [trimmed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int idx = 0;
    int len = [people count];
    NSLog(@"ids count: %d",len);
    BOOL gotIt=NO;
    
    for(int i=0;i<len;i++){//NSString *aTimeID in ids){
        NSLog(@"ping a person");
        NSLog(@"newID: (%@) /noldID: (%@)",
              [trimmed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
              [[[people objectAtIndex:i]objectForKey:@"RemoteSystemID"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
        if([[[[people objectAtIndex:i]objectForKey:@"RemoteSystemID"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:[trimmed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
            return [people objectAtIndex:i];
        }
        idx++;
    }
    
    return nil;
   
}

- (NSManagedObject *)objectWithURI:(NSURL *)uri
{
    //NSString *trimmed = [uri stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];   
   //trimmed = [trimmed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSManagedObjectID *objectID =
    [coordinator managedObjectIDForURIRepresentation:uri];
    
    if (!objectID)
    {
        return nil;
    }
    
    NSManagedObject *objectForID = [context objectWithID:objectID];
    if (![objectForID isFault])
    {
        return objectForID;
    }
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[objectID entity]];
    
    // Equivalent to
    // predicate = [NSPredicate predicateWithFormat:@"SELF = %@", objectForID];
    NSPredicate *predicate =
    [NSComparisonPredicate
     predicateWithLeftExpression:
     [NSExpression expressionForEvaluatedObject]
     rightExpression:
     [NSExpression expressionForConstantValue:objectForID]
     modifier:NSDirectPredicateModifier
     type:NSEqualToPredicateOperatorType
     options:0];
    [request setPredicate:predicate];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    if ([results count] > 0 )
    {
        return [results objectAtIndex:0];
    }
    
    return nil;
}

-(void)addSessions:(NSDictionary*)sessions 
{
    NSLog(@"Sessions: %@",(NSDictionary*)sessions);
    
    NSMutableArray *activeSessions = [[NSMutableArray alloc] initWithCapacity:0];
    for(NSMutableDictionary *session in [sessions objectForKey:@"EventTimes"])
    {
        NSLog(@"addSession");
        [self addSession:session];
        [activeSessions addObject:[session valueForKey:@"TimeID"]];
    }
    [self setInactiveSessions:activeSessions];
}

-(void)addSession:(NSMutableDictionary*)session
{
    NSLog(@"addSessions: %@",session);
    /*
    
    NSDictionary *sessions = [self allSessions];
    
    NSLog(@"addSession sessions:%@",sessions);
    
    NSArray *ids = [sessions objectForKey:@"eventIDs"];
    
    NSLog(@"timeID's: %@",ids);
    
    int idx = 0;
    int len = [ids count];
    NSLog(@"ids count: %d",len);
    BOOL gotIt=NO;
    
    for(int i=0;i<len;i++){
        NSLog(@"ping a session");
        NSLog(@"newID: (%@) /noldID: (%@)",
              [[session valueForKey:@"TimeID"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
              [[ids objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
        if([[[ids objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:[[session valueForKey:@"TimeID"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
            gotIt = YES;
            break;
        }
        idx++;
    }*/
    
    NSError *errorFetchingSessions = nil;
    NSMutableArray *sessions = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *sessionEntity = [NSEntityDescription entityForName:@"Session" inManagedObjectContext:context];
    
    NSFetchRequest *allSessionRequest = [[NSFetchRequest alloc] init];
    [allSessionRequest setEntity:sessionEntity];
    
    //NSDate *today = [NSDate date];
    
    /*NSPredicate *predicate = [NSPredicate predicateWithFormat:
     @"(DateTime < %@) "/*AND (EndDateTime > %@)"*///,today,today];
    // [allSessionRequest setPredicate:predicate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(TimeID = %@)",[session valueForKey:@"TimeID"]]; /*AND (EndDateTime > %@)"*///,today,today];
    [allSessionRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    sessions = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:allSessionRequest error:errorFetchingSessions]];
    
    [allSessionRequest release];
    
    NSEnumerator *sessionEnumerator = [sessions objectEnumerator];
    NSManagedObject *tmp;
    
    
    
    NSLog(@"DataAccess - allSessions - numSessions: %d",[sessions count]);
    
    while ((tmp = [sessionEnumerator nextObject]) != nil) {
        if([session valueForKey:@"StartDate"] != [NSNull null])[tmp setValue:[self parseDateString:[session valueForKey:@"StartDate"]] forKey:@"StartDateT"];
        if([session valueForKey:@"EndDate"] != [NSNull null])[tmp setValue:[self parseDateString:[session valueForKey:@"EndDate"]] forKey:@"EndDateT"];
        if([session valueForKey:@"EventID"] != [NSNull null])[tmp setValue:[session valueForKey:@"EventID"] forKey:@"EventID"];
        if([session valueForKey:@"EventName"] != [NSNull null])[tmp setValue:[session valueForKey:@"EventName"] forKey:@"Name"];
        if([session valueForKey:@"VenueName"] != nil){
            [tmp setValue:[session valueForKey:@"VenueName"] forKey:@"venueName"];
        }else{
            [tmp setValue:@"" forKey:@"venueName"];
        }
        
        
        if([session valueForKey:@"SessionName"] != [NSNull null])[tmp setValue:[session valueForKey:@"SessionName"] forKey:@"SessionName"];
        if([session valueForKey:@"RegistrationsCount"] != [NSNull null])[tmp setValue:[session valueForKey:@"RegistrationsCount"] forKey:@"RegistrationsCount"];
        if([session valueForKey:@"StudyID"] != [NSNull null])[tmp setValue:[session valueForKey:@"StudyID"] forKey:@"StudyID"]; 
        if([session valueForKey:@"City"] != [NSNull null])[tmp setValue:[session valueForKey:@"City"] forKey:@"Location"];
        [tmp setValue:[NSNumber numberWithBool:YES] forKey:@"active"];
        
        
        NSError *errorSavingSessions = nil;
        if (tmp!=nil && [context save:errorSavingSessions] == NO) {
           // [context deleteObject:session];
            session = nil;
        }
        
        [sessions release];
        return;
    }
    
        errorFetchingSessions = nil;
        [sessions release];
        NSError *errorSavingSession = nil;
        ///*
        // Create a request to fetch all Chefs.
        
        NSManagedObject *newSession = [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:context];
        
        [newSession setValue:[session valueForKey:@"TimeID"] forKey:@"TimeID"];
        [newSession setValue:[self parseDateString:[session valueForKey:@"StartDate"]] forKey:@"StartDateT"];
        [newSession setValue:[self parseDateString:[session valueForKey:@"EndDate"]] forKey:@"EndDateT"];
        [newSession setValue:[session valueForKey:@"EventID"] forKey:@"EventID"];
        [newSession setValue:[session valueForKey:@"EventName"] forKey:@"Name"];
        if([session valueForKey:@"VenueName"] != nil){
            [newSession setValue:[session valueForKey:@"VenueName"] forKey:@"venueName"];
        }else{
            [newSession setValue:@"" forKey:@"venueName"];
        }
        [newSession setValue:[session valueForKey:@"SessionName"] forKey:@"SessionName"];
        [newSession setValue:[session valueForKey:@"RegistrationsCount"] forKey:@"RegistrationsCount"];
        [newSession setValue:[session valueForKey:@"StudyID"] forKey:@"StudyID"]; 
        [newSession setValue:[session valueForKey:@"City"] forKey:@"Location"]; 
        [newSession setValue:[NSNumber numberWithBool:YES] forKey:@"active"];
       
        NSError *errorSavingSessions = nil;
        if (newSession!=nil && [context save:errorSavingSessions] == NO) {
         //   [context deleteObject:session];
            session = nil;
        }
    
    
}

-(void)setInactiveSessions:(NSMutableArray*)activeSessions
{
    NSLog(@"setInactiveSessions: %@",activeSessions);
    
        NSError *errorFetchingSessions = nil;
        NSMutableArray *sessions = nil;
        
        // Create a request to fetch all Chefs.
        
        NSEntityDescription *sessionEntity = [NSEntityDescription entityForName:@"Session" inManagedObjectContext:context];
        
        NSFetchRequest *allSessionRequest = [[NSFetchRequest alloc] init];
        [allSessionRequest setEntity:sessionEntity];
        
        //NSDate *today = [NSDate date];
        
        /*NSPredicate *predicate = [NSPredicate predicateWithFormat:
         @"(DateTime < %@) "/*AND (EndDateTime > %@)"*///,today,today];
        // [allSessionRequest setPredicate:predicate];
        int idx = 0;
        NSMutableString *predString = [NSMutableString stringWithCapacity:0];
        
    if([activeSessions count]>0)
    {
        for(NSString *active in activeSessions)
        {
            if(idx == 0)
            {
                [predString appendFormat:@"(TimeID != \"%@\")",active];
            }else{
                [predString appendFormat:@" AND (TimeID != \"%@\")",active];
            }
            idx++;
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predString]; /*AND (EndDateTime > %@)"*///,today,today];
        [allSessionRequest setPredicate:predicate];
    }     
        // Ask the context for everything matching the request.
        // If an error occurs, the context will return nil and an error in *error.
        
        sessions = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:allSessionRequest error:errorFetchingSessions]];
        
        [allSessionRequest release];
        
        NSEnumerator *sessionEnumerator = [sessions objectEnumerator];
        NSManagedObject *tmp;
        
        
        
        NSLog(@"DataAccess - allSessions - numSessions: %d",[sessions count]);
        
        while ((tmp = [sessionEnumerator nextObject]) != nil) {
            [tmp setValue:[NSNumber numberWithBool:NO] forKey:@"active"];
            
            NSError *errorSavingSessions = nil;
            if (tmp!=nil && [context save:errorSavingSessions] == NO) 
            {
                
            }
            
            
        }
    [sessions release];
}

-(NSDictionary*)allSessions
{
    NSLog(@"allSessions");
    
    NSError *errorFetchingSessions = nil;
    NSMutableArray *sessions = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *sessionEntity = [NSEntityDescription entityForName:@"Session" inManagedObjectContext:context];

    NSFetchRequest *allSessionRequest = [[NSFetchRequest alloc] init];
    [allSessionRequest setEntity:sessionEntity];
    
    //NSDate *today = [NSDate date];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(active != %@)",[NSNumber numberWithBool:NO]];/*AND (EndDateTime > %@)"*///,today,today];
    [allSessionRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    sessions = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:allSessionRequest error:errorFetchingSessions]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"StartDateT" ascending:TRUE];
    NSArray *sortDescriptorArr = [[NSArray alloc] initWithObject:sortDescriptor];
    [sessions sortUsingDescriptors:sortDescriptorArr];
    
    [sortDescriptorArr release];
    [sortDescriptor release];
    
    NSEnumerator *sessionEnumerator = [sessions objectEnumerator];
    NSManagedObject *tmp;
    
    NSMutableArray *eventNames = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *venueNames = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *sessionNames = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *eventMarkets = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *eventDates = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *eventTimes = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *eventIDs = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *eventCounts = [[NSMutableArray alloc] initWithCapacity:0];
    
    
   
    NSLog(@"DataAccess - allSessions - numSessions: %d",[sessions count]);
    
    while ((tmp = [sessionEnumerator nextObject]) != nil) {
        
        NSLog(@"temp Sessions: %@",tmp);
        
        if([tmp valueForKey:@"Name"]!=nil){
            [eventNames addObject:[tmp valueForKey:@"Name"]];
            [sessionNames addObject:[tmp valueForKey:@"SessionName"]];
            [venueNames addObject:[tmp valueForKey:@"venueName"]];
            if([tmp valueForKey:@"Location"]){
                [eventMarkets addObject:[tmp valueForKey:@"Location"]];
            }else{
                NSString *tmpString = [[NSString alloc] initWithString:@""];
                [eventMarkets addObject:tmpString];
                [tmpString release];
            }
            
            NSDictionary *dateTime = [self parseDate:[tmp valueForKey:@"StartDateT"]];
            
            [eventDates addObject:[dateTime objectForKey:@"date"]];
            [eventTimes addObject:[dateTime objectForKey:@"time"]];
            [eventIDs addObject:[tmp valueForKey:@"TimeID"]];
            NSLog(@"timeID: %@",[tmp valueForKey:@"TimeID"]);
            [eventCounts addObject:[tmp valueForKey:@"RegistrationsCount"]];
        }
        
    }
    NSArray *arrs = [[NSArray alloc] initWithObjects:eventNames,venueNames,sessionNames,eventMarkets,eventDates,eventTimes,eventIDs,eventCounts, nil];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"names",@"venueNames",@"sessionNames",@"markets",@"dates",@"times",@"eventIDs",@"eventCounts",nil];
    NSDictionary *sessionData = [[NSDictionary alloc] initWithObjects:arrs forKeys:keys];
    // Clean up and return.
    [arrs release];
    [keys release];
    [eventNames release];
    [sessionNames release];
    [eventMarkets release];
    [venueNames release];
    [eventDates release];
    [eventTimes release];
    [eventIDs release];
    [eventCounts release];
    [allSessionRequest release];
    [sessions release];
    
    //*/
    NSLog(@"sessionData: %@",sessionData);
    return [sessionData autorelease];//[NSMutableArray arrayWithCapacity:0];//peopleData;
}

-(NSString*)sessionNameForID:(NSString*)timeID
{
    NSLog(@"allSessions");
    
    NSDictionary *sessions = [self allSessions];

    NSArray *ids = [sessions objectForKey:@"eventIDs"];
    
    NSLog(@"timeID's: %@",ids);
    
    int idx = 0;
    
    for(NSString *aTimeID in ids){
        if([aTimeID isEqualToString:[timeID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
            break;
        }
        idx++;
    }
    
    NSString *eventName = [[sessions objectForKey:@"names"] objectAtIndex:idx];
    
    NSLog(@"THE EVENT NAME!!!: %@",eventName);
    
    return eventName;
}

#pragma -

#pragma helper methods

-(NSString*)uniqueObjectURIString:(NSManagedObject*)obj
{
    
    NSManagedObjectID *moID = [obj objectID];
    NSURL *uri = [moID URIRepresentation];
    NSString *string = [uri absoluteString];
    return string;
}

-(void)deleteObjectForURIString:(NSString*)objURI
{
    NSLog(@"URI: %@",objURI);
    /*
    NSManagedObjectID *moID = [NSManagedObjectID managedObjectIDForURIRepresentation:[NSURL URLWithString:objURI]];
    NSManagedObject *obj = [context objectWithID:moID];
    [context deleteObject:obj];
    NSError *errorSavingPerson = nil;
    if (obj!=nil && [context save:errorSavingPerson] == NO) 
    {
        NSLog(@"boosh");
    }
    //*/
    
    objURI = [objURI stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSError *errorDeletingPerson = nil;
    NSManagedObjectID *objectID =
    [coordinator managedObjectIDForURIRepresentation:[NSURL URLWithString:objURI]];
    
    if (!objectID)
    {
        return;
    }
    
    NSManagedObject *objectForID = [context objectWithID:objectID];
    if (![objectForID isFault])
    {
        [context deleteObject:objectForID];
        if (objectForID!=nil && [context save:errorDeletingPerson] == NO) 
        {
            NSLog(@"boosh");
        }
        return;
    }
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[objectID entity]];
    
    // Equivalent to
    // predicate = [NSPredicate predicateWithFormat:@"SELF = %@", objectForID];
    NSPredicate *predicate =
    [NSComparisonPredicate
     predicateWithLeftExpression:
     [NSExpression expressionForEvaluatedObject]
     rightExpression:
     [NSExpression expressionForConstantValue:objectForID]
     modifier:NSDirectPredicateModifier
     type:NSEqualToPredicateOperatorType
     options:0];
    [request setPredicate:predicate];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    if ([results count] > 0 )
    {
        [context deleteObject:[results objectAtIndex:0]];
        if ([results objectAtIndex:0]!=nil && [context save:errorDeletingPerson] == NO) 
        {
            NSLog(@"boosh");
        }
    }
    
    return;
}

#pragma -

-(void)saveAnswerID:(NSString*)answerID Value:(NSString*)value
{
    NSError *errorFetchingPeople = nil;
    NSArray *people = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *personEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
    
    NSFetchRequest *allPeopleRequest = [[NSFetchRequest alloc] init];
    [allPeopleRequest setEntity:personEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID = %@) ",self.currentAuthorID];
    [allPeopleRequest setPredicate:predicate];
    
    people = [context executeFetchRequest:allPeopleRequest error:errorFetchingPeople];
    [context obtainPermanentIDsForObjects:people error:errorFetchingPeople];
    
    [allPeopleRequest release];
    
    NSEnumerator *peopleEnumerator = [people objectEnumerator];
    NSManagedObject *tmp;
    
    while ((tmp = [peopleEnumerator nextObject]) != nil) {
        NSLog(@"a person for answers: %@",tmp);
        NSManagedObject *newAnswer = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyResponse" inManagedObjectContext:context];
       // NSString *tempID = [self uniqueObjectURIString:tmp];
        [newAnswer setValue:self.currentTimeID forKey:@"TimeID"];
        [newAnswer setValue:currentAuthorID forKey:@"AuthorID"];
        [newAnswer setValue:answerID forKey:@"AnswerID"];
        [newAnswer setValue:value forKey:@"Value"];
        
        NSArray *queuepeople = nil;
        NSEntityDescription *queuepersonEntity = [NSEntityDescription entityForName:@"Trans_Queue_Author" inManagedObjectContext:context];
        
        NSFetchRequest *queuePeopleRequest = [[NSFetchRequest alloc] init];
        [queuePeopleRequest setEntity:queuepersonEntity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID = %@) ",self.currentAuthorID];
        [queuePeopleRequest setPredicate:predicate];
        
        queuepeople = [context executeFetchRequest:queuePeopleRequest error:errorFetchingPeople];
        
        if([queuepeople count] == 0){
            NSManagedObject *queueAuthor = [NSEntityDescription insertNewObjectForEntityForName:@"Trans_Queue_Author" inManagedObjectContext:context];
            for(NSString *key in [[personEntity propertiesByName]allKeys])
            {
                [queueAuthor setValue:[tmp valueForKey:key] forKey:key];
            } 
        }
        
        NSError *errorSavingSessions = nil;
        if (newAnswer!=nil && [context save:errorSavingSessions] == NO) {
            
        }
    }
}



-(NSMutableArray*)answersForAuthorID:(NSString*)authorID
{
    NSString *trimmed = [authorID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    trimmed = [trimmed stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"'"]];
    
    NSError *errorFetchingPeople = nil;
    NSArray *people = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *responseEntity = [NSEntityDescription entityForName:@"SurveyResponse" inManagedObjectContext:context];
    
    NSFetchRequest *allResponseRequest = [[NSFetchRequest alloc] init];
    [allResponseRequest setEntity:responseEntity];
    [allResponseRequest setReturnsObjectsAsFaults:NO];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    people = [context executeFetchRequest:allResponseRequest error:errorFetchingPeople];
    
    [allResponseRequest release];
    
    NSEnumerator *peopleEnumerator = [people objectEnumerator];
    NSManagedObject *tmp;
    
    NSLog(@"answersForRemoteID: %@",authorID);
    
    
    NSMutableArray *answerData = [[NSMutableArray alloc] initWithCapacity:0];
    //*
    while ((tmp = [peopleEnumerator nextObject]) != nil) {
        NSLog(@"an Answer: %@",tmp);
        NSLog(
@"\nan AnswerAuthorID: %@ \n       a AuthorID: %@",[tmp valueForKey:@"AuthorID"],trimmed);
        
        if([[tmp valueForKey:@"AuthorID"] isEqualToString:trimmed])
        {
            NSLog(@"match");
            NSMutableDictionary *response = [[NSMutableDictionary alloc] initWithCapacity:0];
            [response setValue:[tmp valueForKey:@"AnswerID"] forKey:@"AnswerID"];
            [response setValue:[tmp valueForKey:@"Value"] forKey:@"Value"];
            [answerData addObject:response];
            [response release];
        }
    }
    
    return [answerData autorelease];
}

-(void)moveAndQueueAllData{
    NSLog(@"moveAndQueueAllData");
    NSError *errorFetchingEventTimeAuthors = nil;
    NSArray *eventTimeAuthors = nil;
    
    // Create a request to fetch all EventTimeAuthors.
    
    NSEntityDescription *eventTimeAuthorEntity = [NSEntityDescription entityForName:@"EventTimeAuthor" inManagedObjectContext:context];
    
    NSFetchRequest *allEventTimeAuthorsRequest = [[NSFetchRequest alloc] init];
    [allEventTimeAuthorsRequest setEntity:eventTimeAuthorEntity];
    
    //Set a predicate to search for the primary key
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(TimeID == %@)",@"b53f602b-82f6-41a1-84df-c43ac605c520"];
    //[allEventTimeAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    [allEventTimeAuthorsRequest setReturnsObjectsAsFaults:NO];   
    eventTimeAuthors = [context executeFetchRequest:allEventTimeAuthorsRequest error:errorFetchingEventTimeAuthors];
    
    [allEventTimeAuthorsRequest release];
    
    NSEnumerator *eventTimeAuthorsEnumerator = [eventTimeAuthors objectEnumerator];
    NSManagedObject *tmp;
    
    NSError *errorAddingEventTimeAuthor;
    // NSMutableArray *eventTimeAuthorsData = [[NSMutableArray alloc] initWithCapacity:0];
    //[eventTimeAuthors release];
    
    while ((tmp = [eventTimeAuthorsEnumerator nextObject]) != nil) {
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
       
        NSLog(@"old eventTimeAuthor: %@", tmp);
        NSError *errorFetchingAuthors = nil;
        NSArray *authors = nil;
         
       NSManagedObject *author_queue = [NSEntityDescription insertNewObjectForEntityForName:@"Trans_Queue_Author" inManagedObjectContext:context];
        
        
        // Create a request to fetch all EventTimeAuthors.
        NSEntityDescription *authorEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:context];
        
        NSFetchRequest *authorsRequest = [[NSFetchRequest alloc] init];
        [authorsRequest setEntity:authorEntity];
        
        //Set a predicate to search for the primary key
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(AuthorID = %@) OR (AuthorID == %@) OR (AuthorID = '%@') OR (AuthorID == '%@')",[tmp valueForKey:@"AuthorID"],[tmp valueForKey:@"AuthorID"],[tmp valueForKey:@"AuthorID"],[tmp valueForKey:@"AuthorID"]];
        [authorsRequest setPredicate:predicate];
        
        //[predicate release];
        
        // Ask the context for everything matching the request.
        // If an error occurs, the context will return nil and an error in *error.
        [authorsRequest setReturnsObjectsAsFaults:NO];   
        authors = [context executeFetchRequest:authorsRequest error:errorFetchingAuthors];
        
        
        
        NSEnumerator *authorsEnumerator = [authors objectEnumerator];
        NSManagedObject *tmp2;
        
        NSError *errorAddingAuthor;
        
        while ((tmp2 = [authorsEnumerator nextObject]) != nil) {
            NSLog(@"old author: %@",tmp2);
            [author_queue setValue:[tmp valueForKey:@"ParentTimeAuthorID"] forKey:@"ParentTimeAuthorID"];
            [author_queue setValue:[tmp valueForKey:@"TimeID"] forKey:@"TimeID"];
            [author_queue setValue:[tmp valueForKey:@"AuthorID"] forKey:@"AuthorID"];
            //[author_queue setValue:[self parseDateSlashes:[tmp2 valueForKey:@"AuthorDOB"]] forKey:@"DOB"];
            
            //* CONVERT OBJ-C BOOLS TO .NET COMPATIBLE BOOLS i.e. YES -> 'true' 
            [author_queue setValue:[tmp valueForKey:@"Attended"] forKey:@"Attended"];
            [author_queue setValue:[tmp valueForKey:@"isAttending"] forKey:@"isAttending"];
            [author_queue setValue:[tmp valueForKey:@"Cancelled"] forKey:@"Cancelled"];
            [author_queue setValue:[tmp valueForKey:@"Invited"] forKey:@"Invited"];
            /*if([[tmp valueForKey:@"Attended"]boolValue] == NO){
                [author_queue setValue:[tmp valueForKey:@"Attended"]boolValue] forKey:@"Attended"];
            }else{
                [author_queue setValue:@"true" forKey:@"Attended"];
            }
            if([[tmp valueForKey:@"isAttending"]boolValue] == NO){
                [author_queue setValue:@"false" forKey:@"isAttending"];
            }else{
                [author_queue setValue:@"true" forKey:@"isAttending"];
            }
            if([[tmp valueForKey:@"Cancelled"]boolValue] == NO){
                [author_queue setValue:@"false" forKey:@"Cancelled"];
            }else{
                [author_queue setValue:@"true" forKey:@"Cancelled"];
            }
            if([[tmp valueForKey:@"Invited"]boolValue] == NO){
                [author_queue setValue:@"false" forKey:@"Invited"];
            }else{
                [author_queue setValue:@"true" forKey:@"Invited"];
            }
            
            if([[tmp valueForKey:@"IsOptedOut"]boolValue] == NO){
                [author_queue setValue:@"false" forKey:@"OptIn"];
            }else{
                [author_queue setValue:@"true" forKey:@"OptIn"];
            }
             */
        }
        
        NSArray *authorDetails = nil;
        // Create a request to fetch all EventTimeAuthors.
        NSEntityDescription *authorDetailEntity = [NSEntityDescription entityForName:@"AuthorDetail" inManagedObjectContext:context];
        
        NSFetchRequest *authorDetailsRequest = [[NSFetchRequest alloc] init];
        [authorDetailsRequest setEntity:authorDetailEntity];
        
        //Set a predicate to search for the primary key
        predicate = [NSPredicate predicateWithFormat:@"(AuthorID = %@) OR (AuthorID == %@) OR (AuthorID = '%@') OR (AuthorID == '%@')",[tmp valueForKey:@"AuthorID"],[tmp valueForKey:@"AuthorID"],[tmp valueForKey:@"AuthorID"],[tmp valueForKey:@"AuthorID"]];
        [authorDetailsRequest setPredicate:predicate];
        //[predicate release];
        
        // Ask the context for everything matching the request.
        // If an error occurs, the context will return nil and an error in *error.
        [authorDetailsRequest setReturnsObjectsAsFaults:NO]; 
        authorDetails = [context executeFetchRequest:authorDetailsRequest error:errorFetchingAuthors];
        //NSLog(@"authorDetails array: %@",authorDetails);
        
        
        NSEnumerator *authorDetailsEnumerator = [authorDetails objectEnumerator];
        NSManagedObject *tmp3;
        
        NSError *errorAddingAuthor2;
        
        while ((tmp3 = [authorDetailsEnumerator nextObject]) != nil) {
            NSLog(@"old AuthorDetails: %@",tmp3);
            if([[tmp3 valueForKey:@"IsOptedOut"]boolValue] == NO){
                [author_queue setValue:[NSNumber numberWithBool:YES] forKey:@"IsOptedOut"];
            }
            if([[tmp3 valueForKey:@"IsOptedOut"]boolValue] == YES){
                [author_queue setValue:[NSNumber numberWithBool:NO] forKey:@"IsOptedOut"];
            }

        }
        /*
        if([author_queue valueForKey:@"IsOptedOut"] == nil){
            [author_queue setValue:[NSNumber numberWithInt:0] forKey:@"IsOptedOut"];
        }*/
        
        NSLog(@"New Author Queue: %@",author_queue);
        
        if (author_queue != nil && [context save:errorAddingEventTimeAuthor] == NO) 
        {
            NSLog(@"boosh");
        }
        
        [authorDetailsRequest release];
        //[authorDetailEntity release];
        [authorsRequest release];
        //[authorEntity release];
        //[authorDetails release];
        //[authors release];
        [pool release];
        
    }
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.homeVC unlockScreen];
    return;
}

-(void)clearQueues
{
    NSLog(@"clearQueues");
    //EVENT TIME AUTHORS
    NSError *errorFetchingPeople = nil;
    NSArray *queue_people = nil;
    NSArray *sent_people = nil;
    NSArray *queue_people2 = nil;
    NSArray *sent_people2 = nil;
    
    // Create a request to fetch all Authors present in the 'Queue' Table
    NSEntityDescription *sentPersonEntity = [NSEntityDescription entityForName:@"Trans_Sent_EventTimeAuthor" inManagedObjectContext:context];
    
    NSFetchRequest *sentPeopleRequest = [[NSFetchRequest alloc] init];
    [sentPeopleRequest setEntity:sentPersonEntity];
    [sentPeopleRequest setReturnsObjectsAsFaults:NO];    
    sent_people = [context executeFetchRequest:sentPeopleRequest error:&errorFetchingPeople];
    
    
    
    // Create a request to fetch all Queued Authors NOT present in the 'Sent' Table
    NSEntityDescription *queuePersonEntity = [NSEntityDescription entityForName:@"Trans_Queue_Author" inManagedObjectContext:context];
    
    NSFetchRequest *queuePeopleRequest = [[NSFetchRequest alloc] init];
    [queuePeopleRequest setEntity:queuePersonEntity];
    [queuePeopleRequest setReturnsObjectsAsFaults:NO];
    //NSPredicate *pred = [NSPredicate predicateWithFormat:@"(self IN %@)",sent_people];
    //[queuePeopleRequest setPredicate:pred];
    
    queue_people = [context executeFetchRequest:queuePeopleRequest error:&errorFetchingPeople];
    [context obtainPermanentIDsForObjects:queue_people error:&errorFetchingPeople];
    
    NSEnumerator *peopleEnumerator = [queue_people objectEnumerator];
    NSManagedObject *tmp;
    
    
    
    // Create a request to fetch all Authors present in the 'Queue' Table
    NSEntityDescription *sentPersonEntity2 = [NSEntityDescription entityForName:@"Trans_Queue_EventTimeAuthor" inManagedObjectContext:context];
    
    NSFetchRequest *sentPeopleRequest2 = [[NSFetchRequest alloc] init];
    [sentPeopleRequest2 setEntity:sentPersonEntity2];
    [sentPeopleRequest2 setReturnsObjectsAsFaults:NO];    
    sent_people2 = [context executeFetchRequest:sentPeopleRequest2 error:&errorFetchingPeople];
    
    // Create a request to fetch all Queued Authors NOT present in the 'Sent' Table
    NSEntityDescription *queuePersonEntity2 = [NSEntityDescription entityForName:@"Trans_Queue_SurveyResponse" inManagedObjectContext:context];
    
    NSFetchRequest *queuePeopleRequest2 = [[NSFetchRequest alloc] init];
    [queuePeopleRequest2 setEntity:queuePersonEntity2];
    [queuePeopleRequest2 setReturnsObjectsAsFaults:NO];
    //pred = [NSPredicate predicateWithFormat:@"(self IN %@)",sent_people2];
    //[queuePeopleRequest2 setPredicate:pred];
    
    queue_people2 = [context executeFetchRequest:queuePeopleRequest2 error:&errorFetchingPeople];
    [context obtainPermanentIDsForObjects:queue_people2 error:&errorFetchingPeople];
    
    NSEnumerator *peopleEnumerator2 = [queue_people2 objectEnumerator];
    NSManagedObject *tmp2;
    
    NSLog(@"Sent_in_Queue: %d  Queue_in_Sent: %d  Total_Sent: %d  Total_Queue: %d",[queue_people count], [queue_people2 count], [sent_people count], [queue_people count]);
    
    while ((tmp = [peopleEnumerator nextObject]) != nil) {
        [context deleteObject:tmp];
    }
    
    
    /*
    
    //AUTHOR DETAILS
    NSError *errorFetchingAuthorDetails = nil;
    queue_people = nil;
    sent_people = nil;
    queue_people2 = nil;
    sent_people2 = nil;
    
    // Create a request to fetch all Authors present in the 'Queue' Table
    sentPersonEntity = [NSEntityDescription entityForName:@"Trans_Sent_AuthorDetail" inManagedObjectContext:context];
    
    sentPeopleRequest = [[NSFetchRequest alloc] init];
    [sentPeopleRequest setEntity:sentPersonEntity];
    [sentPeopleRequest setReturnsObjectsAsFaults:NO];    
    sent_people = [context executeFetchRequest:sentPeopleRequest error:&errorFetchingAuthorDetails];
    
    
    
    // Create a request to fetch all Queued Authors NOT present in the 'Sent' Table
    queuePersonEntity = [NSEntityDescription entityForName:@"Trans_Queue_AuthorDetail" inManagedObjectContext:context];
    
    queuePeopleRequest = [[NSFetchRequest alloc] init];
    [queuePeopleRequest setEntity:queuePersonEntity];
    [queuePeopleRequest setReturnsObjectsAsFaults:NO];
    pred = [NSPredicate predicateWithFormat:@"(self IN %@)",sent_people];
    [queuePeopleRequest setPredicate:pred];
    
    queue_people = [context executeFetchRequest:queuePeopleRequest error:&errorFetchingAuthorDetails];
    [context obtainPermanentIDsForObjects:queue_people error:&errorFetchingAuthorDetails];
    
    peopleEnumerator = [queue_people objectEnumerator];
        
        
    NSLog(@"Sent_in_Queue: %d  Queue_in_Sent: %d  Total_Sent: %d  Total_Queue: %d",[queue_people count], [queue_people2 count], [sent_people count], [queue_people count]);
    
    while ((tmp = [peopleEnumerator nextObject]) != nil) {
        [context deleteObject:tmp];
    }
    
    while ((tmp2 = [peopleEnumerator2 nextObject]) != nil) {
        [context deleteObject:tmp2];
    }
    */
    NSError *errorSavingPerson = nil;
    if ([context save:errorSavingPerson] == NO) {
        
    }
}

-(void)saveNewSyncTS
{
    NSError *errorGettingSettings = nil;
    NSArray *settings = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *settingEntity = [NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    
    NSFetchRequest *settingRequest = [[NSFetchRequest alloc] init];
    [settingRequest setEntity:settingEntity];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    settings = [context executeFetchRequest:settingRequest error:errorGettingSettings];
    [context obtainPermanentIDsForObjects:settings error:errorGettingSettings];
    
    NSEnumerator *settingEnumerator = [settings objectEnumerator];
    NSManagedObject *tmp;
    
    while ((tmp = [settingEnumerator nextObject]) != nil) {
       // NSString *tempID = [self uniqueObjectURIString:tmp];
        NSManagedObject *setting = nil;
        
        //setting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:context];
        
        //[setting setValue:[tmp valueForKey:@"Mode"] forKey:@"Mode"];
        [tmp setValue:[NSDate date] forKey:@"LastSyncTS"];
        
        NSError *errorSavingPerson = nil;
        if (setting!=nil && [context save:errorGettingSettings] == NO) {
            //[context deleteObject:setting];
            
            setting = nil;
        }
        
        //[self deleteObjectForURIString:tempID];
    }
    
    
    NSError *errorSavingSetting = nil;
    if (tmp!=nil && [context save:errorSavingSetting] == NO) {
       // [context deleteObject:tmp];
        tmp = nil;
    }
    
    
    // Clean up and return.
    
    [settingRequest release];
}

-(NSDate*)getNewSyncTS
{
    NSError *errorGettingSettings = nil;
    NSArray *settings = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *settingEntity = [NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    
    NSFetchRequest *settingRequest = [[NSFetchRequest alloc] init];
    [settingRequest setEntity:settingEntity];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    settings = [context executeFetchRequest:settingRequest error:errorGettingSettings];
    
    [settingRequest release];
    
    NSEnumerator *settingEnumerator = [settings objectEnumerator];
    NSManagedObject *tmp;
    
    while ((tmp = [settingEnumerator nextObject]) != nil) {
        return [tmp valueForKey:@"LastSyncTS"];
    }
    return nil;
}

-(NSDictionary*) parseDate:(NSDate*)aDate{
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *newDateString = [outputFormatter stringFromDate:aDate];
    
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *newTimeString = [outputFormatter stringFromDate:aDate];
    
    NSArray *objs = [[NSArray alloc] initWithObjects:newDateString,newTimeString, nil];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"date",@"time", nil];
    
    NSDictionary *dateTime = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    
    [objs release];
    [keys release];
    
    NSLog(@"dateTime: %@",dateTime);
    
	[outputFormatter release];
	
    return [dateTime autorelease];
    // For US English, the output is:
    // newDateString 10:30 on Sunday July 11
}

-(NSString*) parseDateSlashes:(NSDate*)aDate{
    NSString *newDateString;
    
    if(aDate){
        
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        
        [outputFormatter setDateFormat:@"MM/dd/yyyy"];
        newDateString = [outputFormatter stringFromDate:aDate];
        [outputFormatter release];
        
        return newDateString;
    }else{
        newDateString = [[NSString alloc] initWithString:@""]; 
        return [newDateString autorelease];
    }
	
    // For US English, the output is:
    // newDateString 10:30 on Sunday July 11
}

-(NSDate*) parseDateString:(NSString*)aDateString{
    if([aDateString length] > 19) aDateString = [aDateString substringToIndex:19];
   
    NSLog(@"newDate: %@", aDateString);
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate *newDate = [outputFormatter dateFromString:aDateString];
    [outputFormatter release];
    
    NSLog(@"newDate: %@", newDate);
    
    return newDate;
    // For US English, the output is:
    // newDateString 10:30 on Sunday July 11
}

-(NSString*) parseDateTime:(NSDate*)aDate{
    NSString *newDateString;
    
    if(aDate){
        
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        
        [outputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        newDateString = [outputFormatter stringFromDate:aDate];
        [outputFormatter release];
        
        return newDateString;
    }else{
        newDateString = [[NSString alloc] initWithString:@""]; 
        return [newDateString autorelease];
    }
}

@end

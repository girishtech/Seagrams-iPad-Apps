//
//  DataAccess.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/13/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "DataAccess.h"
#import "LoginViewController.h"

@implementation DataAccess

@synthesize currentSession;
@synthesize context = _context;
@synthesize coordinator = _coordinator;
@synthesize web;
@synthesize mode;
@synthesize brandID;

-(id)init
{
    self = [super init];
    if (self) {
        
        
        self.mode = 1;
        
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
        self.context = [appDelegate managedObjectContext];
        self.coordinator = [appDelegate persistentStoreCoordinator];
        self.web = [appDelegate web];
        
        
        //NSLocale *locale = [NSLocale currentLocale];
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSLog(@"%@", language);
        
        
        if([language isEqualToString:@"en"]){
            //DEV
            if(RELEASE == 0) self.brandID = STUDYID_DEV_ENG;
            //STAGING
            if(RELEASE == 1) self.brandID = STUDYID_STG_ENG;
            //PRODUCTION
            if(RELEASE == 2) self.brandID = STUDYID_PROD_ENG;
        }else{
            //DEV
            if(RELEASE == 0) self.brandID = STUDYID_DEV_ES;
            //STAGING
            if(RELEASE == 1) self.brandID = STUDYID_STG_ES;
            //PRODUCTION
            if(RELEASE == 2) self.brandID = STUDYID_PROD_ES;
        }
    }

    //*/ 
    return self;
}

#pragma mark - Settings/Methods Methods

-(void)getDefaults
{
    NSLog(@"setDefaults");
    
    NSError *errorGettingSettings = nil;
    NSArray *settings = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *settingEntity = [NSEntityDescription entityForName:@"Setting" inManagedObjectContext:self.context];
    
    NSFetchRequest *settingRequest = [[NSFetchRequest alloc] init];
    [settingRequest setEntity:settingEntity];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    settings = [self.context executeFetchRequest:settingRequest error:&errorGettingSettings];
    
    NSEnumerator *settingEnumerator = [settings objectEnumerator];
   // NSManagedObject *tmp;
    
    if(!([[settingEnumerator allObjects] count] > 0)){
        NSManagedObject *setting = nil;
        
        setting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:self.context];
        
        [setting setValue:[NSNumber numberWithInt:2] forKey:@"Mode"];
        [setting setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"LastSyncTS"];
        
        NSError *errorSavingPerson = nil;
        if (setting!=nil && [self.context save:errorGettingSettings] == NO) {
            [self.context deleteObject:setting];
            
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
    return [NSNumber numberWithInt:mode];
    
    NSLog(@"setDefaults");
    
    NSError *errorGettingSettings = nil;
    NSArray *settings = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *settingEntity = [NSEntityDescription entityForName:@"Setting" inManagedObjectContext:self.context];
    
    NSFetchRequest *settingRequest = [[NSFetchRequest alloc] init];
    [settingRequest setEntity:settingEntity];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    settings = [self.context executeFetchRequest:settingRequest error:&errorGettingSettings];
    
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
    mode = [value intValue];
    return;
    NSError *errorGettingSettings = nil;
    NSArray *settings = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *settingEntity = [NSEntityDescription entityForName:@"Setting" inManagedObjectContext:self.context];
    
    NSFetchRequest *settingRequest = [[NSFetchRequest alloc] init];
    [settingRequest setEntity:settingEntity];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    settings = [self.context executeFetchRequest:settingRequest error:&errorGettingSettings];
    [self.context obtainPermanentIDsForObjects:settings error:&errorGettingSettings];
    
    NSEnumerator *settingEnumerator = [settings objectEnumerator];
    NSManagedObject *tmp;
    
    while ((tmp = [settingEnumerator nextObject]) != nil) {
        NSString *tempID = [self uniqueObjectURIString:tmp];
        NSManagedObject *setting = nil;
        
        setting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:self.context];
        
        [setting setValue:value forKey:@"Mode"];
        [setting setValue:[tmp valueForKey:@"LastSyncTS"] forKey:@"LastSyncTS"];
        
        NSError *errorSavingPerson = nil;
        if (setting!=nil && [self.context save:&errorGettingSettings] == NO) {
            [self.context deleteObject:setting];
            
            setting = nil;
        }
        
        [self deleteObjectForURIString:tempID];
    }
        
        
    NSError *errorSavingSetting = nil;
    if (tmp!=nil && [self.context save:&errorSavingSetting] == NO) {
        [self.context deleteObject:tmp];
        tmp = nil;
    }
    
    
    // Clean up and return.
    
    [settingRequest release];
}

-(void)setWebAddress:(NSString*)address
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:address forKey:@"ws_url"];
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[appDelegate web] setWS_URL:address];
}

#pragma mark - 

-(BOOL)loginWithUser:(NSString*)user Password:(NSString*)pass forVC:(LoginViewController*)vc
{
    NSError *errorLoggingIn = nil;
    NSArray *logins = nil;
    NSError *errorSavingLogin = nil;
    ///*
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context];
    
    //[sessionEntity setValue:[session valueForKey:@"TimeID"] forKey:@"TimeID"];
    
    NSFetchRequest *allLoginRequest = [[NSFetchRequest alloc] init];
    [allLoginRequest setEntity:userEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(Username = %@) AND (Password = %@)", user,pass];
    [allLoginRequest setPredicate:predicate];
    
   
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    logins = [self.context executeFetchRequest:allLoginRequest error:&errorLoggingIn];
    
    NSEnumerator *loginEnumerator = [logins objectEnumerator];
    NSManagedObject *tmp;
    
    
    //check if we got back a user, if so trigger login method
    if([logins count]>0){
        if(tmp = [loginEnumerator nextObject] != nil)
        {
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
    
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context];
    
    //[sessionEntity setValue:[session valueForKey:@"TimeID"] forKey:@"TimeID"];
    
    NSFetchRequest *allLoginRequest = [[NSFetchRequest alloc] init];
    [allLoginRequest setEntity:userEntity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(Username = %@) AND (Password = %@)", user,pass];
    [allLoginRequest setPredicate:predicate];
    
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    logins = [self.context executeFetchRequest:allLoginRequest error:&errorLoggingIn];
    
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
        NSManagedObject *login = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.context];
        [login setValue:user forKey:@"Username"];
        [login setValue:pass forKey:@"Password"];
        [login setValue:@"first" forKey:@"FirstName"];
        [login setValue:@"last" forKey:@"LastName"];
        
        //NSLog(@"new user creds: %@", login);
        
        if (login!=nil && [self.context save:&errorSavingLogin] == NO) {
            
        }
    }
    
}

-(NSString*)logoImage
{
    return @"logo.gif";
}

-(void)saveAnswerID:(NSString*)answerID Value:(NSString*)value
{
    NSError *errorFetchingPeople = nil;
    NSArray *people = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *personEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:self.context];
    
    NSFetchRequest *allPeopleRequest = [[NSFetchRequest alloc] init];
    [allPeopleRequest setEntity:personEntity];
    
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"Modified" ascending:NO];
    [allPeopleRequest setSortDescriptors:[NSArray arrayWithObject:dateSort]];
    [allPeopleRequest setFetchLimit:1];
    [allPeopleRequest setReturnsObjectsAsFaults:NO];
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    people = [self.context executeFetchRequest:allPeopleRequest error:&errorFetchingPeople];
    [self.context obtainPermanentIDsForObjects:people error:&errorFetchingPeople];
    
    NSEnumerator *peopleEnumerator = [people objectEnumerator];
    NSManagedObject *tmp;
    
    while ((tmp = [peopleEnumerator nextObject]) != nil) {
        NSLog(@"a person for answers: %@",tmp);
        NSManagedObject *newAnswer = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyResponse" inManagedObjectContext:self.context];
        //NSString *tempID = [self uniqueObjectURIString:tmp];
        [newAnswer setValue:self.currentSession forKey:@"TimeID"];
        [newAnswer setValue:[tmp valueForKey:@"RemoteSystemID"] forKey:@"RemoteID"];
        [newAnswer setValue:answerID forKey:@"AnswerID"];
        [newAnswer setValue:value forKey:@"Value"];
        
        NSManagedObject *newAnswer_queue = [NSEntityDescription insertNewObjectForEntityForName:@"Trans_Queue_SurveyResponse" inManagedObjectContext:self.context];
        [newAnswer_queue setValue:self.currentSession forKey:@"TimeID"];
        [newAnswer_queue setValue:[tmp valueForKey:@"RemoteSystemID"] forKey:@"RemoteID"];
        [newAnswer_queue setValue:answerID forKey:@"AnswerID"];
        [newAnswer_queue setValue:value forKey:@"Value"];
        
        NSManagedObject *newAnswer_archive = [NSEntityDescription insertNewObjectForEntityForName:@"Trans_Archive_SurveyResponse" inManagedObjectContext:self.context];
        [newAnswer_archive setValue:self.currentSession forKey:@"TimeID"];
        [newAnswer_archive setValue:[tmp valueForKey:@"RemoteSystemID"] forKey:@"RemoteID"];
        [newAnswer_archive setValue:answerID forKey:@"AnswerID"];
        [newAnswer_archive setValue:value forKey:@"Value"];
        
        NSError *errorSavingSessions = nil;
        if (newAnswer!=nil && [self.context save:&errorSavingSessions] == NO) {
            
        }
    }
}



-(NSMutableArray*)answersForRemoteID:(NSString*)remoteID
{
    NSString *trimmed = [remoteID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSError *errorFetchingPeople = nil;
    NSArray *queue_people = nil;
    NSArray *sent_people = nil;
    
    // Create a request to fetch all Chefs.
    // Create a request to fetch all Authors present in the 'Queue' Table
    NSEntityDescription *sentPersonEntity = [NSEntityDescription entityForName:@"Trans_Sent_SurveyResponse" inManagedObjectContext:self.context];
    
    NSFetchRequest *sentPeopleRequest = [[NSFetchRequest alloc] init];
    [sentPeopleRequest setEntity:sentPersonEntity];
    [sentPeopleRequest setReturnsObjectsAsFaults:NO];    
    sent_people = [self.context executeFetchRequest:sentPeopleRequest error:&errorFetchingPeople];
    
    
    
    // Create a request to fetch all Queued Authors NOT present in the 'Sent' Table
    NSEntityDescription *queuePersonEntity = [NSEntityDescription entityForName:@"Trans_Queue_SurveyResponse" inManagedObjectContext:self.context];
    
    NSFetchRequest *queuePeopleRequest = [[NSFetchRequest alloc] init];
    [queuePeopleRequest setEntity:queuePersonEntity];
    [queuePeopleRequest setReturnsObjectsAsFaults:NO];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(NOT (self IN %@)) AND (RemoteID = %@)",sent_people,trimmed];
    [queuePeopleRequest setPredicate:pred];
    
    queue_people = [self.context executeFetchRequest:queuePeopleRequest error:&errorFetchingPeople];
    [self.context obtainPermanentIDsForObjects:queue_people error:&errorFetchingPeople];
    
    NSEnumerator *peopleEnumerator = [queue_people objectEnumerator];
    NSManagedObject *tmp;
    
    
    
    NSLog(@"answersForRemoteID: %@",remoteID);
    
    
    NSMutableArray *answerData = [[NSMutableArray alloc] initWithCapacity:0];
    //*
    while ((tmp = [peopleEnumerator nextObject]) != nil) {
        NSLog(@"an Answer: %@",tmp);
        NSLog(@"an AnswerRemoteID: %@",[tmp valueForKey:@"RemoteID"]);
        
        if([[tmp valueForKey:@"RemoteID"] isEqualToString:trimmed])
        {
            NSMutableDictionary *response = [[NSMutableDictionary alloc] initWithCapacity:0];
            [response setValue:[tmp valueForKey:@"AnswerID"] forKey:@"AnswerID"];
            [response setValue:[tmp valueForKey:@"Value"] forKey:@"Value"];
            [answerData addObject:response];
        }
    }
    
    return answerData;
}


-(NSMutableArray*)allAuthorsForPush:(NSString*)timeID
{
    NSLog(@"allPeopleForPush");
    
    NSError *errorFetchingPeople = nil;
    NSArray *queue_people = nil;
    NSArray *sent_people = nil;
    
    // Create a request to fetch all Authors present in the 'Queue' Table
    NSEntityDescription *sentPersonEntity = [NSEntityDescription entityForName:@"Trans_Sent_Author" inManagedObjectContext:self.context];
    
    NSFetchRequest *sentPeopleRequest = [[NSFetchRequest alloc] init];
    [sentPeopleRequest setEntity:sentPersonEntity];
    [sentPeopleRequest setReturnsObjectsAsFaults:NO];    
    sent_people = [self.context executeFetchRequest:sentPeopleRequest error:&errorFetchingPeople];
    
    
    
    // Create a request to fetch all Queued Authors NOT present in the 'Sent' Table
    NSEntityDescription *queuePersonEntity = [NSEntityDescription entityForName:@"Trans_Queue_Author" inManagedObjectContext:self.context];
    
    NSFetchRequest *queuePeopleRequest = [[NSFetchRequest alloc] init];
    [queuePeopleRequest setEntity:queuePersonEntity];
    [queuePeopleRequest setReturnsObjectsAsFaults:NO];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(NOT (self IN %@)) AND (TimeID = %@)",sent_people, timeID];
    [queuePeopleRequest setPredicate:pred];
    
    queue_people = [self.context executeFetchRequest:queuePeopleRequest error:&errorFetchingPeople];
    [self.context obtainPermanentIDsForObjects:queue_people error:&errorFetchingPeople];
    
    NSEnumerator *peopleEnumerator = [queue_people objectEnumerator];
    NSManagedObject *tmp;
    
    
    NSMutableArray *peopleData = [[NSMutableArray alloc] initWithCapacity:0];
    //*
    while ((tmp = [peopleEnumerator nextObject]) != nil) {
        NSMutableDictionary *person = [NSMutableDictionary dictionaryWithCapacity:0];
        NSLog(@"temp person: %@",tmp);
        // NSLog(@"fname: %@",[tmp valueForKey:@"FirstName"]);
        [person setValue:[tmp valueForKey:@"FirstName"] forKey:@"AuthorFirstName"];
        [person setValue:[tmp valueForKey:@"LastName"] forKey:@"AuthorLastName"];
        [person setValue:[tmp valueForKey:@"Email"] forKey:@"AuthorEmail"];
        [person setValue:[tmp valueForKey:@"City"] forKey:@"City"];
        [person setValue:[tmp valueForKey:@"StateProvince"] forKey:@"StateProvince"];
        [person setValue:[tmp valueForKey:@"Phone"] forKey:@"Phone"];
        [person setValue:[tmp valueForKey:@"PostalCode"] forKey:@"PostalCode"];
        [person setValue:[tmp valueForKey:@"Address1"] forKey:@"Street1"];
        [person setValue:[tmp valueForKey:@"Address2"] forKey:@"Street2"];
        [person setValue:[tmp valueForKey:@"DOB"] forKey:@"DOB"];
        [person setValue:[tmp valueForKey:@"Opt_In"] forKey:@"Opt_In"];
        [person setValue:[tmp valueForKey:@"AccountName"] forKey:@"AccountName"];
        //[person setValue:[tmp valueForKey:@"Ordered"] forKey:@"Ordered"];
        [person setValue:@"true" forKey:@"Attended"];
        if([tmp valueForKey:@"AuthorID"])[person setValue:[tmp valueForKey:@"AuthorID"] forKey:@"AuthorID"];
        if([tmp valueForKey:@"Sent"]==nil)[tmp setValue:@"false" forKey:@"Sent"];
        [person setValue:[tmp valueForKey:@"Sent"] forKey:@"Sent"];
        [person setValue:[tmp valueForKey:@"Gender"] forKey:@"Gender"];
        [person setValue:[tmp valueForKey:@"DrinkingPreferences"] forKey:@"DrinkingPreferences"];
        [person setValue:[tmp valueForKey:@"DrinkingIdeas"] forKey:@"DrinkingIdeas"];
        [person setValue:[tmp valueForKey:@"LanguagePreferences"] forKey:@"LanguagePreferences"];
        
        [person setValue:[NSString stringWithFormat:@"%d", (long)[[NSDate date] timeIntervalSince1970]] forKey:@"DateTimeTransaction"];
        
        [person setValue:[tmp valueForKey:@"RemoteSystemID"] forKey:@"RemoteSystemID"];
        
        
        
        
        //[person setValue:@"USA" forKey:@"Country"];
        
        
        [peopleData addObject:person];
    }
    
    // Clean up and return.
    [queuePeopleRequest release];
    [sentPeopleRequest release];
    
    //*/
    //NSLog(@"peopleData: %@",peopleData);
    return peopleData;//[NSMutableArray arrayWithCapacity:0];//peopleData;
}

-(NSMutableArray*)eventTimeIDsForPush
{
    NSLog(@"eventTimeIDsForPush");
    
    NSError *errorFetchingPeople = nil;
    NSArray *queue_people = nil;
    NSArray *sent_people = nil;
    
    // Create a request to fetch all Authors present in the 'Queue' Table
    NSEntityDescription *sentPersonEntity = [NSEntityDescription entityForName:@"Trans_Sent_Author" inManagedObjectContext:self.context];
    
    NSFetchRequest *sentPeopleRequest = [[NSFetchRequest alloc] init];
    [sentPeopleRequest setEntity:sentPersonEntity];
    [sentPeopleRequest setReturnsObjectsAsFaults:NO];    
    sent_people = [self.context executeFetchRequest:sentPeopleRequest error:&errorFetchingPeople];
    
    
    
    // Create a request to fetch all Queued Authors NOT present in the 'Sent' Table
    NSEntityDescription *queuePersonEntity = [NSEntityDescription entityForName:@"Trans_Queue_Author" inManagedObjectContext:self.context];
    
    NSFetchRequest *queuePeopleRequest = [[NSFetchRequest alloc] init];
    [queuePeopleRequest setEntity:queuePersonEntity];
    [queuePeopleRequest setReturnsObjectsAsFaults:NO];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(NOT (self IN %@))",sent_people];
    [queuePeopleRequest setPredicate:pred];
    [queuePeopleRequest setPropertiesToFetch:[NSArray arrayWithObject:@"TimeID"]];
    [queuePeopleRequest setReturnsDistinctResults:YES];
    
    
    queue_people = [self.context executeFetchRequest:queuePeopleRequest error:&errorFetchingPeople];
    
    [self.context obtainPermanentIDsForObjects:queue_people error:&errorFetchingPeople];
    
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


-(NSMutableArray*)setPeopleDefaults
{
    NSLog(@"allPeople");
    
    NSError *errorFetchingPeople = nil;
    NSArray *people = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *personEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:self.context];
    
    NSFetchRequest *allPeopleRequest = [[NSFetchRequest alloc] init];
    [allPeopleRequest setEntity:personEntity];
    [allPeopleRequest setReturnsObjectsAsFaults:NO];
    //[allPeopleRequest setPredicate:pred];
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    people = [self.context executeFetchRequest:allPeopleRequest error:&errorFetchingPeople];
    [self.context obtainPermanentIDsForObjects:people error:&errorFetchingPeople];
    
    NSEnumerator *peopleEnumerator = [people objectEnumerator];
    NSManagedObject *tmp;
    
    
    NSMutableArray *peopleData = [[NSMutableArray alloc] initWithCapacity:0];
    //*
    while ((tmp = [peopleEnumerator nextObject]) != nil) {
        if([tmp valueForKey:@"Sent"]==nil)[tmp setValue:@"false" forKey:@"Sent"];
        
        if([tmp valueForKey:@"BrandID"]==nil) [tmp setValue:self.brandID forKey:@"BrandID"];
        
        
        if (tmp != nil && [self.context save:&errorFetchingPeople] == NO) 
        {
            NSLog(@"boosh");
        }
    }
    
    
    // Clean up and return.
    
    [allPeopleRequest release];
    
    //*/
    //NSLog(@"peopleData: %@",peopleData);
    return peopleData;//[NSMutableArray arrayWithCapacity:0];//peopleData;
}


-(void)createTestAuthors
{
    NSLog(@"createTestAuthors");
    web.creatingTestAuthors = YES;
    NSEntityDescription *person = nil;
    NSEntityDescription *person_update = nil;
    NSError *csvError = nil;
    //NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *cleanPath = [documentsPath substringToIndex:[documentsPath length]-1];
    /*
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *err = nil;
    NSArray *fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:&err];
    
    NSLog(@"filelist: %@",fileList);
    /*
    NSArray *paths = 
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSString *fullPath = [NSString stringWithFormat:@"%@%@",basePath,@"/TestDataTemplate_kiosk.csv"];
    */
    NSString *csvString = @"FIRSTNAME,LastName,Email,ZipCode,Date of Birth,Invited,RSVP,Cancelled,Attended,GuestOfEmail,Opt-In\n"
    "j,mcguigan+B401.78,jmcguigan+B401.78@emergepartners.com,25485,5/5/1986,1,1,1,0,,0\n"
    "j,mcguigan+B401.09,jmcguigan+B401.09@emergepartners.com,89349,5/1/1976,1,0,1,1,,0\n"
    "j,mcguigan+B401.64,jmcguigan+B401.64@emergepartners.com,23451,1/30/1978,1,0,1,1,,0\n"
    "j,mcguigan+B401.14,jmcguigan+B401.14@emergepartners.com,93471,9/2/1982,1,0,0,1,,0\n"
    "j,mcguigan+B401.83,jmcguigan+B401.83@emergepartners.com,81366,4/10/1970,1,0,0,1,,0\n"
    "j,mcguigan+B401.98,jmcguigan+B401.98@emergepartners.com,33308,5/3/1982,0,0,1,0,,0\n"
    "j,mcguigan+B401.38,jmcguigan+B401.38@emergepartners.com,77040,12/20/1980,1,0,0,1,,0\n"
    "j,mcguigan+B401.61,jmcguigan+B401.61@emergepartners.com,51144,6/16/1979,1,0,1,1,,0\n"
    "j,mcguigan+B401.91,jmcguigan+B401.91@emergepartners.com,51230,1/6/1987,0,1,1,1,,0\n"
    "j,mcguigan+B401.15,jmcguigan+B401.15@emergepartners.com,67624,7/19/1977,0,0,1,0,,0\n"
    "j,mcguigan+B401.23,jmcguigan+B401.23@emergepartners.com,18121,10/7/1972,1,0,0,1,,0\n"
    "j,mcguigan+B401.19,jmcguigan+B401.19@emergepartners.com,69098,2/12/1984,0,0,1,0,,0\n"
    "j,mcguigan+B401.18,jmcguigan+B40.18@emergepartners.com,37780,7/11/1971,0,0,0,1,,0\n"
    "j,mcguigan+B40.97,jmcguigan+B40.97@emergepartners.com,84094,7/25/1970,0,1,1,0,,0\n"
    "j,mcguigan+B40.94,jmcguigan+B40.94@emergepartners.com,72107,10/24/1980,0,0,0,0,,0\n"
///*    "j,mcguigan+B40.49,jmcguigan+B40.49@emergepartners.com,33001,12/25/1979,1,0,0,1,,0\n"
    "j,mcguigan+B40.77,jmcguigan+B40.77@emergepartners.com,54377,6/21/1976,1,0,0,1,,0\n"
    "j,mcguigan+B40.08,jmcguigan+B40.08@emergepartners.com,37911,3/30/1983,1,0,1,0,,0\n"
    "j,mcguigan+B40.76,jmcguigan+B40.76@emergepartners.com,46266,2/18/1973,0,0,0,1,,0\n"
    "j,mcguigan+B40.02,jmcguigan+B40.02@emergepartners.com,60037,11/5/1977,0,1,1,0,,0\n"
    "j,mcguigan+B40.66,jmcguigan+B40.66@emergepartners.com,29853,3/24/1979,0,1,1,0,,0\n"
    "j,mcguigan+B40.85,jmcguigan+B40.85@emergepartners.com,60729,10/16/1975,0,0,1,0,,0\n"
    "j,mcguigan+B40.25,jmcguigan+B40.25@emergepartners.com,47361,9/15/1976,1,1,1,1,,0\n"
    "j,mcguigan+B40.8,jmcguigan+B40.8@emergepartners.com,18776,10/18/1988,1,1,0,1,,0\n"
    "j,mcguigan+B40.26,jmcguigan+B40.26@emergepartners.com,14839,3/11/1982,0,0,0,1,,0\n"
    "j,mcguigan+B40.77,jmcguigan+B40.77@emergepartners.com,74980,1/11/1986,0,1,1,0,,0\n"
    "j,mcguigan+B40.09,jmcguigan+B40.09@emergepartners.com,85441,9/14/1980,1,0,0,1,,0\n"
    "j,mcguigan+B40.21,jmcguigan+B40.21@emergepartners.com,36230,1/12/1984,1,1,1,0,,0\n"
    "j,mcguigan+B40.87,jmcguigan+B40.87@emergepartners.com,37867,12/9/1983,1,0,1,1,,0\n"
    "j,mcguigan+B40.47,jmcguigan+B40.47@emergepartners.com,18756,12/5/1985,1,0,1,1,,0\n"
    "j,mcguigan+B40.98,jmcguigan+B40.98@emergepartners.com,33593,1/23/1979,0,1,1,0,,0\n"
    "j,mcguigan+B40.51,jmcguigan+B40.51@emergepartners.com,88557,8/19/1983,0,1,0,1,,0\n"
    "j,mcguigan+B40.92,jmcguigan+B40.92@emergepartners.com,31510,7/28/1988,1,1,1,0,,0\n"
    "j,mcguigan+B40.45,jmcguigan+B40.45@emergepartners.com,98139,10/26/1981,1,0,1,1,,0\n"
    "j,mcguigan+B40.06,jmcguigan+B40.06@emergepartners.com,66849,6/3/1972,1,1,1,0,,0\n"
    "j,mcguigan+B40.9,jmcguigan+B40.9@emergepartners.com,44039,3/11/1986,1,1,0,0,,0\n"
    "j,mcguigan+B40.74,jmcguigan+B40.74@emergepartners.com,68591,9/9/1971,0,0,1,0,,0\n"
    "j,mcguigan+B40.67,jmcguigan+B40.67@emergepartners.com,67709,4/7/1972,1,1,1,1,,0\n"
    "j,mcguigan+B40.33,jmcguigan+B40.33@emergepartners.com,88107,9/10/1981,0,0,0,0,,0\n"
    "j,mcguigan+B40.38,jmcguigan+B40.38@emergepartners.com,26327,1/21/1977,1,1,1,0,,0\n"
    "j,mcguigan+B40.6,jmcguigan+B40.6@emergepartners.com,23246,7/25/1986,1,0,1,0,,0\n"
    "j,mcguigan+B40.93,jmcguigan+B40.93@emergepartners.com,79054,8/29/1980,0,1,0,0,,0\n"
    "j,mcguigan+B40.39,jmcguigan+B40.39@emergepartners.com,57854,3/24/1988,0,1,1,1,,0\n"
    "j,mcguigan+B40.21,jmcguigan+B40.21@emergepartners.com,60397,4/27/1985,1,0,1,1,,0\n"
    "j,mcguigan+B40.95,jmcguigan+B40.95@emergepartners.com,47481,10/2/1971,1,1,1,0,,0\n"
    "j,mcguigan+B40.77,jmcguigan+B40.77@emergepartners.com,44934,4/3/1985,1,1,1,0,,0\n"
    "j,mcguigan+B40.26,jmcguigan+B40.26@emergepartners.com,77264,4/11/1984,0,0,0,0,,0\n"
    "j,mcguigan+B40.86,jmcguigan+B40.86@emergepartners.com,31815,9/16/1986,1,1,0,0,,0\n"
    "j,mcguigan+B40.3,jmcguigan+B40.3@emergepartners.com,92640,4/25/1983,1,1,1,0,,0\n"
    "j,mcguigan+B40.72,jmcguigan+B40.72@emergepartners.com,67135,11/7/1987,1,1,0,1,,0\n"
    "j,mcguigan+B40.35,jmcguigan+B40.35@emergepartners.com,83924,10/23/1982,0,1,1,0,,0\n"
    "j,mcguigan+B40.53,jmcguigan+B40.53@emergepartners.com,98717,11/12/1977,1,0,1,0,,0\n"
    "j,mcguigan+B40.6,jmcguigan+B40.6@emergepartners.com,47005,5/19/1970,0,1,1,0,,0\n"
    "j,mcguigan+B40.74,jmcguigan+B40.74@emergepartners.com,58119,7/24/1975,1,0,0,1,,0\n"
    "j,mcguigan+B40.89,jmcguigan+B40.89@emergepartners.com,22340,5/14/1984,1,0,1,0,,0\n"
    "j,mcguigan+B40.57,jmcguigan+B40.57@emergepartners.com,55344,3/24/1977,0,1,1,1,,0\n"
    "j,mcguigan+B40.77,jmcguigan+B40.77@emergepartners.com,79721,2/1/1984,1,1,0,0,,0\n"
    "j,mcguigan+B40.55,jmcguigan+B40.55@emergepartners.com,25652,11/1/1988,0,0,1,0,,0\n"
    "j,mcguigan+B40.66,jmcguigan+B40.66@emergepartners.com,13127,12/5/1980,0,0,0,0,,0\n"
    "j,mcguigan+B40.06,jmcguigan+B40.06@emergepartners.com,21678,10/24/1971,1,0,1,0,,0\n"
    "j,mcguigan+B40.9,jmcguigan+B40.9@emergepartners.com,84250,11/26/1987,1,1,0,0,,0\n"
    "j,mcguigan+B40.04,jmcguigan+B40.04@emergepartners.com,94954,12/1/1987,1,1,0,0,,0\n"
    "j,mcguigan+B40.37,jmcguigan+B40.37@emergepartners.com,72797,2/7/1986,0,1,0,1,,0\n"
    "j,mcguigan+B40.39,jmcguigan+B40.39@emergepartners.com,22230,7/28/1987,0,1,0,1,,0\n"
    "j,mcguigan+B40.67,jmcguigan+B40.67@emergepartners.com,92466,7/28/1972,0,1,0,0,,0\n"
    "j,mcguigan+B40.43,jmcguigan+B40.43@emergepartners.com,23562,6/16/1973,0,1,1,0,,0\n"
    "j,mcguigan+B40.02,jmcguigan+B40.02@emergepartners.com,71497,2/15/1973,0,1,1,1,,0\n"
    "j,mcguigan+B40.21,jmcguigan+B40.21@emergepartners.com,34176,5/24/1974,0,1,0,0,,0\n"
    "j,mcguigan+B40.56,jmcguigan+B40.56@emergepartners.com,81789,12/29/1977,0,1,1,1,,0\n"
    "j,mcguigan+B40.08,jmcguigan+B40.08@emergepartners.com,31668,2/6/1972,0,1,1,0,,0\n"
    "j,mcguigan+B40.57,jmcguigan+B40.57@emergepartners.com,53331,5/6/1978,1,1,0,0,,0\n"
    "j,mcguigan+B40.79,jmcguigan+B40.79@emergepartners.com,98076,3/9/1976,1,0,1,0,,0\n"
    "j,mcguigan+B40.13,jmcguigan+B40.13@emergepartners.com,85983,1/31/1975,1,0,1,1,,0\n"
    "j,mcguigan+B40.08,jmcguigan+B40.08@emergepartners.com,52656,10/5/1976,1,0,1,1,,0\n"
    "j,mcguigan+B40.26,jmcguigan+B40.26@emergepartners.com,90710,10/29/1971,0,1,1,1,,0\n"
    "j,mcguigan+B40.8,jmcguigan+B40.8@emergepartners.com,33077,9/6/1978,1,1,1,0,,0\n"
    "j,mcguigan+B40.85,jmcguigan+B40.85@emergepartners.com,70557,12/4/1979,1,1,0,0,,0\n"
    "j,mcguigan+B40.73,jmcguigan+B40.73@emergepartners.com,71691,9/22/1974,1,0,0,0,,0\n"
    "j,mcguigan+B40.76,jmcguigan+B40.76@emergepartners.com,63287,12/11/1973,0,0,1,1,,0\n"
    "j,mcguigan+B40.73,jmcguigan+B40.73@emergepartners.com,20178,4/15/1986,0,1,1,1,,0\n"
    "j,mcguigan+B40.73,jmcguigan+B40.73@emergepartners.com,73426,5/21/1976,1,0,0,1,,0\n"
    "j,mcguigan+B40.12,jmcguigan+B40.12@emergepartners.com,55332,1/19/1980,1,0,0,0,,0\n"
    "j,mcguigan+B40.35,jmcguigan+B40.35@emergepartners.com,61166,12/28/1971,0,1,1,0,,0\n"
    "j,mcguigan+B40.09,jmcguigan+B40.09@emergepartners.com,20652,1/31/1981,1,0,0,0,,0\n"
    "j,mcguigan+B40.58,jmcguigan+B40.58@emergepartners.com,28547,8/13/1974,1,1,1,0,,0\n"
    "j,mcguigan+B40,jmcguigan+B40@emergepartners.com,73244,4/13/1984,1,0,0,0,,0\n"
    "j,mcguigan+B40.59,jmcguigan+B40.59@emergepartners.com,64110,5/8/1978,0,0,0,1,,0\n"
    "j,mcguigan+B40.92,jmcguigan+B40.92@emergepartners.com,78207,3/1/1981,1,0,1,1,,0\n"
    "j,mcguigan+B40.84,jmcguigan+B40.84@emergepartners.com,40413,4/19/1982,1,0,0,1,,0\n"
    "j,mcguigan+B40.95,jmcguigan+B40.95@emergepartners.com,67574,6/9/1980,1,1,1,1,,0\n"
    "j,mcguigan+B40.87,jmcguigan+B40.87@emergepartners.com,75857,1/8/1986,1,1,0,1,,0\n"
    "j,mcguigan+B40.44,jmcguigan+B40.44@emergepartners.com,55445,9/9/1974,1,1,0,0,,0\n"
    "j,mcguigan+B40.55,jmcguigan+B40.55@emergepartners.com,69956,8/11/1988,1,0,0,0,,0\n"
    "j,mcguigan+B40.45,jmcguigan+B40.45@emergepartners.com,55622,1/30/1976,1,1,0,1,,0\n"
    "j,mcguigan+B40.64,jmcguigan+B40.64@emergepartners.com,82648,11/30/1978,0,0,0,1,,0\n"
    "j,mcguigan+B40.63,jmcguigan+B40.63@emergepartners.com,76878,11/11/1976,1,0,1,0,,0\n"
    "j,mcguigan+B40.89,jmcguigan+B40.89@emergepartners.com,31116,12/1/1981,0,1,1,0,,0\n"
    "j,mcguigan+B40.83,jmcguigan+B40.83@emergepartners.com,38874,7/28/1971,0,1,0,0,,0\n"
    "j,mcguigan+B40.8,jmcguigan+B40.8@emergepartners.com,29397,5/25/1980,1,1,1,0,,0\n"
    "j,mcguigan+B40.15,jmcguigan+B40.15@emergepartners.com,49595,3/28/1979,0,1,1,1,,0\n"
    "j,mcguigan+B40.09,jmcguigan+B40.09@emergepartners.com,31816,12/22/1979,1,0,0,0,,0\n"
    "j,mcguigan+B40.98,jmcguigan+B40.98@emergepartners.com,24843,10/30/1974,0,0,1,1,,0\n"
    "j,mcguigan+B40.96,jmcguigan+B40.96@emergepartners.com,97210,5/29/1972,0,0,0,1,,0\n"
    "j,mcguigan+B40.99,jmcguigan+B40.99@emergepartners.com,11111,8/18/1979,1,1,1,1,,0\n"
    "j,mcguigan+B40.4,jmcguigan+B40.4@emergepartners.com,59968,10/5/1978,1,1,1,0,,0\n"
    "j,mcguigan+B40.97,jmcguigan+B40.97@emergepartners.com,37002,11/26/1988,1,0,1,1,,0\n"
    "j,mcguigan+B41,jmcguigan+B41@emergepartners.com,60952,1/19/1983,1,0,1,1,,0\n"
    "j,mcguigan+B40.1,jmcguigan+B40.1@emergepartners.com,16975,6/8/1981,1,1,0,1,,0\n"
    "j,mcguigan+B40.17,jmcguigan+B40.17@emergepartners.com,70968,4/1/1972,0,1,1,0,,0\n"
    "j,mcguigan+B40.33,jmcguigan+B40.33@emergepartners.com,60039,1/10/1971,1,0,1,0,,0\n"
    "j,mcguigan+B40.35,jmcguigan+B40.35@emergepartners.com,60704,1/19/1970,0,0,1,0,,0\n"
    "j,mcguigan+B40.51,jmcguigan+B40.51@emergepartners.com,80851,2/11/1987,0,0,0,0,,0\n"
    "j,mcguigan+B40.59,jmcguigan+B40.59@emergepartners.com,25537,7/14/1988,1,0,0,1,,0\n"
    "j,mcguigan+B40.49,jmcguigan+B40.49@emergepartners.com,56318,11/20/1987,0,0,0,0,,0\n"
    "j,mcguigan+B40.46,jmcguigan+B40.46@emergepartners.com,75340,11/16/1983,0,1,0,0,,0\n"
    "j,mcguigan+B40.39,jmcguigan+B40.39@emergepartners.com,92387,3/9/1976,0,0,1,1,,0\n"
    "j,mcguigan+B40.79,jmcguigan+B40.79@emergepartners.com,41084,10/26/1977,1,1,0,1,,0\n"
    "j,mcguigan+B40.58,jmcguigan+B40.58@emergepartners.com,89846,6/16/1973,0,0,0,0,,0\n"
    "j,mcguigan+B40.58,jmcguigan+B40.58@emergepartners.com,83162,9/29/1986,1,1,1,1,,0\n"
    "j,mcguigan+B40.7,jmcguigan+B40.7@emergepartners.com,74030,11/15/1982,1,0,0,1,,0\n"
    "j,mcguigan+B40.93,jmcguigan+B40.93@emergepartners.com,34267,2/5/1986,1,1,0,1,,0\n"
    "j,mcguigan+B40.66,jmcguigan+B40.66@emergepartners.com,81149,6/19/1984,1,0,1,0,,0\n"
    "j,mcguigan+B40.63,jmcguigan+B40.63@emergepartners.com,72118,7/6/1976,1,0,1,1,,0\n"
    "j,mcguigan+B40.18,jmcguigan+B40.18@emergepartners.com,28288,7/22/1971,0,0,0,0,,0\n"
    "j,mcguigan+B40.89,jmcguigan+B40.89@emergepartners.com,27803,6/29/1982,0,0,1,0,,0\n"
    "j,mcguigan+B40.1,jmcguigan+B40.1@emergepartners.com,74528,2/16/1972,1,0,1,0,,0\n"
    "j,mcguigan+B40.41,jmcguigan+B40.41@emergepartners.com,39060,3/4/1980,0,0,1,1,,0\n"
    "j,mcguigan+B40.48,jmcguigan+B40.48@emergepartners.com,83266,11/12/1979,1,1,0,0,,0\n"
    "j,mcguigan+B40.04,jmcguigan+B40.04@emergepartners.com,18095,3/14/1985,0,1,0,1,,0\n"
    "j,mcguigan+B40.06,jmcguigan+B40.06@emergepartners.com,82412,9/24/1986,1,0,1,0,,0\n"
    "j,mcguigan+B40.09,jmcguigan+B40.09@emergepartners.com,65384,6/25/1979,1,1,0,0,,0\n"
    "j,mcguigan+B40.3,jmcguigan+B40.3@emergepartners.com,75277,12/1/1981,1,1,1,0,,0\n"
    "j,mcguigan+B40.73,jmcguigan+B40.73@emergepartners.com,20772,6/26/1973,1,0,1,0,,0\n"
    "j,mcguigan+B40.61,jmcguigan+B40.61@emergepartners.com,77320,11/26/1983,1,1,1,0,,0\n"
    "j,mcguigan+B40.22,jmcguigan+B40.22@emergepartners.com,71208,3/10/1982,1,0,1,1,,0\n"
    "j,mcguigan+B40.59,jmcguigan+B40.59@emergepartners.com,40751,10/18/1970,1,0,1,0,,0\n"
    "j,mcguigan+B40.33,jmcguigan+B40.33@emergepartners.com,74586,9/22/1980,0,0,1,1,,0\n"
    "j,mcguigan+B40.46,jmcguigan+B40.46@emergepartners.com,31512,6/21/1977,0,1,0,0,,0\n"
    "j,mcguigan+B40.96,jmcguigan+B40.96@emergepartners.com,34665,12/28/1978,0,0,0,0,,0\n"
    "j,mcguigan+B40.12,jmcguigan+B40.12@emergepartners.com,17352,8/1/1985,1,1,0,0,,0\n"
    "j,mcguigan+B40.68,jmcguigan+B40.68@emergepartners.com,96709,5/16/1971,1,1,1,1,,0\n"
    "j,mcguigan+B40.99,jmcguigan+B40.99@emergepartners.com,54791,11/20/1970,0,1,0,0,,0\n"
    "j,mcguigan+B40.62,jmcguigan+B40.62@emergepartners.com,63085,1/27/1976,1,0,0,1,,0\n"
    "j,mcguigan+B40.01,jmcguigan+B40.01@emergepartners.com,48961,3/14/1981,1,0,1,1,,0\n"
    "j,mcguigan+B40.58,jmcguigan+B40.58@emergepartners.com,80882,8/21/1985,1,0,0,0,,0\n"
    "j,mcguigan+B40.01,jmcguigan+B40.01@emergepartners.com,85122,10/21/1982,1,1,0,1,,0\n"
    "j,mcguigan+B40.26,jmcguigan+B40.26@emergepartners.com,74019,5/12/1978,1,1,0,0,,0\n"
    "j,mcguigan+B40.61,jmcguigan+B40.61@emergepartners.com,27711,1/14/1987,1,1,1,1,,0\n"
    "j,mcguigan+B40.35,jmcguigan+B40.35@emergepartners.com,53308,3/12/1972,0,1,1,1,,0\n"//*/
    "j,mcguigan+B40.55,jmcguigan+B40.55@emergepartners.com,63837,7/24/1979,1,1,1,1,,0";
    
   // NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TestDataTemplate_kiosk" ofType:@"csv"]; 
   // NSLog(@"csv path: %@",filePath);
    
    NSArray *testAuthors = [NSArray arrayWithContentsOfCSVString:csvString encoding:NSUTF8StringEncoding error:&csvError];
    NSLog(@"csvError: %@", [csvError userInfo]);
    NSLog(@"testAuthors: %@",testAuthors);
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int idx = 0;
   // for(int i=1;i<15;i++){
        for(NSArray *row in testAuthors){
            if(idx != 0)
            {
                NSLog(@"test author row: %@",row);
                person = [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:self.context];
                
                NSString *GUID = [self generateUuidString];
                
                [person setValue:[row objectAtIndex:0] forKey:@"FirstName"];
                [person setValue:[row objectAtIndex:1] forKey:@"LastName"];
                [person setValue:[row objectAtIndex:4] forKey:@"DOB"];
                int x = arc4random() % 90000;
                NSString *email = [NSString stringWithFormat:@"aTestEmail%d@emergepartners.com",x,[row objectAtIndex:2]];
                NSLog(@"generated email:%@",email);
                [person setValue:email forKey:@"Email"];
                [person setValue:@"5555555555" forKey:@"Phone"];
                [person setValue:@"false" forKey:@"Sent"];
                [person setValue:currentSession forKey:@"TimeID"];
                [person setValue:@"10" forKey:@"BrandID"];
                [person setValue:@"Test Account" forKey:@"AccountName"];
              
                [person setValue:[[NSString alloc] initWithString:@"true"] forKey:@"Opt_In"];
                [person setValue:GUID forKey:@"RemoteSystemID"];
                
                
                 [person setValue:[NSDate date] forKey:@"Modified"];
                 NSError *errorSavingPerson = nil;
                 if (person!=nil && [self.context save:&errorSavingPerson] == NO) {
                     person = nil;
                 }
                
                //CREATE QUEUE AUTHOR
                person_update = [NSEntityDescription insertNewObjectForEntityForName:@"Trans_Queue_Author" inManagedObjectContext:self.context];
                
                [person_update setValue:[row objectAtIndex:0] forKey:@"FirstName"];
                [person_update setValue:[row objectAtIndex:1] forKey:@"LastName"];
                [person_update setValue:[row objectAtIndex:4] forKey:@"DOB"];
                [person_update setValue:email forKey:@"Email"];
                [person_update setValue:@"5555555555" forKey:@"Phone"];
                [person_update setValue:@"false" forKey:@"Sent"];
                [person_update setValue:currentSession forKey:@"TimeID"];
                [person_update setValue:@"10" forKey:@"BrandID"];
                [person_update setValue:@"Test Account" forKey:@"AccountName"];
                
                [person_update setValue:[[NSString alloc] initWithString:@"true"] forKey:@"Opt_In"];
                [person_update setValue:GUID forKey:@"RemoteSystemID"];
               
                
                [person_update setValue:[NSDate date] forKey:@"Modified"];
                if (person_update!=nil && [self.context save:&errorSavingPerson] == NO) {
                    person_update = nil;
                }

            }
            idx++;
        }
    //}
    [pool drain];
    web.creatingTestAuthors = NO;
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];

    
    AuthorizedConnector *auth = [appDelegate web];
    [auth dumpRegistrationsToServer];
    //[auth performSelectorInBackground:@selector(dumpRegistrationsToServer) withObject:nil];
    //[auth performSelectorInBackground:@selector(getEventTimes) withObject:nil];


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
    
    NSManagedObject *objectForID = [self.context objectWithID:objectID];
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
    
    NSArray *results = [self.context executeFetchRequest:request error:nil];
    if ([results count] > 0 )
    {
        return [results objectAtIndex:0];
    }
    
    return nil;
}

#pragma mark - 


////////////////////////////////////////////////////////////////////////////////


#pragma mark - Session Methods

-(void)addSessions:(NSMutableArray*)sessions 
{
    NSLog(@"Sessions: %@",(NSMutableArray*)sessions);
    
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
    NSLog(@"addSessions");
    
    NSManagedObjectContext *moc = [[[NSManagedObjectContext alloc] init] autorelease];
    [moc setPersistentStoreCoordinator:[self.context persistentStoreCoordinator]];
    NSError *errorFetchingSessions = nil;
    NSMutableArray *sessions = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *sessionEntity = [NSEntityDescription entityForName:@"Session" inManagedObjectContext:moc];
    
    NSFetchRequest *allSessionRequest = [[NSFetchRequest alloc] init];
    [allSessionRequest setEntity:sessionEntity];
    
    NSDate *today = [NSDate date];
    
    /*NSPredicate *predicate = [NSPredicate predicateWithFormat:
     @"(DateTime < %@) "/*AND (EndDateTime > %@)"*///,today,today];
    // [allSessionRequest setPredicate:predicate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(TimeID = %@)",[session valueForKey:@"TimeID"]]; /*AND (EndDateTime > %@)"*///,today,today];
    [allSessionRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    sessions = [NSMutableArray arrayWithArray:[moc executeFetchRequest:allSessionRequest error:&errorFetchingSessions]];
    
    NSEnumerator *sessionEnumerator = [sessions objectEnumerator];
    NSManagedObject *tmp;
    
    
    
    NSLog(@"DataAccess - allSessions - numSessions: %d",[sessions count]);
    
    while ((tmp = [sessionEnumerator nextObject]) != nil) {
        [tmp setValue:[self parseDateString:[session valueForKey:@"StartDate"]] forKey:@"StartDateT"];
        [tmp setValue:[self parseDateString:[session valueForKey:@"EndDate"]] forKey:@"EndDateT"];
        [tmp setValue:[session valueForKey:@"EventID"] forKey:@"EventID"];
        [tmp setValue:[session valueForKey:@"EventName"] forKey:@"Name"];
        
        
        [tmp setValue:[session valueForKey:@"SessionName"] forKey:@"SessionName"];
        [tmp setValue:[session valueForKey:@"RegistrationsCount"] forKey:@"RegistrationsCount"];
        [tmp setValue:self.brandID  forKey:@"StudyID"]; 
        [tmp setValue:[session valueForKey:@"City"] forKey:@"Location"];
        [tmp setValue:[NSNumber numberWithBool:YES] forKey:@"active"];
        
        NSError *errorSavingSessions = nil;
        if (tmp!=nil && [moc save:&errorSavingSessions] == NO) {
            //[moc deleteObject:session];
            session = nil;
        }
        
        return;
    }
    
    errorFetchingSessions = nil;
    sessions = nil;
    NSError *errorSavingSession = nil;
    ///*
    // Create a request to fetch all Chefs.
    
    NSManagedObject *newSession = [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:moc];
    
    [newSession setValue:[session valueForKey:@"TimeID"] forKey:@"TimeID"];
    [newSession setValue:[self parseDateString:[session valueForKey:@"StartDate"]] forKey:@"StartDateT"];
    [newSession setValue:[self parseDateString:[session valueForKey:@"EndDate"]] forKey:@"EndDateT"];
    [newSession setValue:[session valueForKey:@"EventID"] forKey:@"EventID"];
    [newSession setValue:[session valueForKey:@"EventName"] forKey:@"Name"];
    [newSession setValue:[session valueForKey:@"SessionName"] forKey:@"SessionName"];
    [newSession setValue:[session valueForKey:@"RegistrationsCount"] forKey:@"RegistrationsCount"];
    [newSession setValue:self.brandID forKey:@"StudyID"]; 
    [newSession setValue:[session valueForKey:@"City"] forKey:@"Location"]; 
    [newSession setValue:[NSNumber numberWithBool:YES] forKey:@"active"];
    
    NSError *errorSavingSessions = nil;
    if (newSession!=nil && [moc save:&errorSavingSessions] == NO) {
        //[moc deleteObject:session];
        session = nil;
    }
    
}

-(void)setInactiveSessions:(NSMutableArray*)activeSessions
{
    NSLog(@"setInactiveSessions: %@",activeSessions);
    
    NSError *errorFetchingSessions = nil;
    NSMutableArray *sessions = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *sessionEntity = [NSEntityDescription entityForName:@"Session" inManagedObjectContext:self.context];
    
    NSFetchRequest *allSessionRequest = [[NSFetchRequest alloc] init];
    [allSessionRequest setEntity:sessionEntity];
    
    //NSDate *today = [NSDate date];
    
    /*NSPredicate *predicate = [NSPredicate predicateWithFormat:
     @"(DateTime < %@) "/*AND (EndDateTime > %@)"*///,today,today];
    // [allSessionRequest setPredicate:predicate];
    int idx = 0;
    NSMutableString *predString = [NSMutableString stringWithCapacity:0];
    
    if([activeSessions count]>0){
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
    
    sessions = [[NSMutableArray alloc] initWithArray:[self.context executeFetchRequest:allSessionRequest error:&errorFetchingSessions]];
    
    [allSessionRequest release];
    
    NSEnumerator *sessionEnumerator = [sessions objectEnumerator];
    NSManagedObject *tmp;
    
    
    
    NSLog(@"DataAccess - allSessions - numSessions: %d",[sessions count]);
    
    while ((tmp = [sessionEnumerator nextObject]) != nil) {
        [tmp setValue:[NSNumber numberWithBool:NO] forKey:@"active"];
        
        NSError *errorSavingSessions = nil;
        if (tmp!=nil && [self.context save:&errorSavingSessions] == NO) 
        {
            
        }
    }
    
    [sessions release];
}

-(NSDictionary*)allSessions
{
    NSLog(@"allSessions");
    
    NSError *errorFetchingSessions = nil;
    NSMutableArray *faultSessions = nil;
    NSMutableArray *sessions = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *sessionEntity = [NSEntityDescription entityForName:@"Session" inManagedObjectContext:self.context];
    
    NSFetchRequest *allSessionRequest = [[NSFetchRequest alloc] init];
    [allSessionRequest setEntity:sessionEntity];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    faultSessions = [NSMutableArray arrayWithArray:[self.context executeFetchRequest:allSessionRequest error:&errorFetchingSessions]];
    
    [allSessionRequest release];
    
    
    
    allSessionRequest = [[NSFetchRequest alloc] init];
    [allSessionRequest setEntity:sessionEntity];
    [allSessionRequest setReturnsObjectsAsFaults:NO];
    //NSArray *array = [NSArray arrayWithObjects:fault1, fault2, ..., nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(StudyID == %@) AND (active != %@)",  self.brandID, [NSNumber numberWithBool:NO]];
    
    [allSessionRequest setPredicate:predicate];
    
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    sessions = [NSMutableArray arrayWithArray:[self.context executeFetchRequest:allSessionRequest error:&errorFetchingSessions]];
    
    NSLog(@"allSessions: %@",sessions);
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"StartDateT" ascending:TRUE];
    [sessions sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSEnumerator *sessionEnumerator = [sessions objectEnumerator];
    NSManagedObject *tmp;
    
    NSMutableArray *eventNames = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *sessionNames = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *eventMarkets = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *eventDates = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *eventTimes = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *eventIDs = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *eventCounts = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    //NSMutableArray *sessionData = [[NSMutableArray alloc] initWithCapacity:0];
    //*
    NSLog(@"DataAccess - allSessions - numSessions: %d",[sessions count]);
    
    while ((tmp = [sessionEnumerator nextObject]) != nil) {
        //NSMutableDictionary *session = [NSMutableDictionary dictionaryWithCapacity:0];
        NSLog(@"temp Sessions: %@",tmp);
        //NSLog(@"fname: %@",[tmp valueForKey:@"FirstName"]);
        if([tmp valueForKey:@"Name"]!=nil){
            [eventNames addObject:[tmp valueForKey:@"Name"]];
            [sessionNames addObject:[tmp valueForKey:@"SessionName"]];
            if([tmp valueForKey:@"Location"]){
                [eventMarkets addObject:[tmp valueForKey:@"Location"]];
            }else{
                [eventMarkets addObject:[[NSString alloc] initWithString:@""]];
            }
            
            
            
            NSDictionary *dateTime = [self parseDate:[[tmp valueForKey:@"StartDateT"]retain]];
            
            [eventDates addObject:[dateTime objectForKey:@"date"]];
            [eventTimes addObject:[dateTime objectForKey:@"time"]];
            [eventIDs addObject:[tmp valueForKey:@"TimeID"]];
            NSLog(@"timeID: %@",[tmp valueForKey:@"TimeID"]);
            [eventCounts addObject:[tmp valueForKey:@"RegistrationsCount"]];
        }
        
    }
    
    NSDictionary *sessionData = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:eventNames,sessionNames,eventMarkets,eventDates,eventTimes,eventIDs,eventCounts, nil] forKeys:[NSArray arrayWithObjects:@"names",@"sessionNames",@"markets",@"dates",@"times",@"eventIDs",@"eventCounts",nil]];
    // Clean up and return.
    
    [allSessionRequest release];
    
    //*/
    NSLog(@"sessionData: %@",sessionData);
    return sessionData;//[NSMutableArray arrayWithCapacity:0];//peopleData;
}



-(void)clearQueues
{
    NSLog(@"clearQueues");
    
    NSError *errorFetchingPeople;// = nil;
    NSArray *queue_people; //= nil;
    NSArray *sent_people;// = nil;
    
    // Create a request to fetch all Authors present in the 'Queue' Table
    NSEntityDescription *sentPersonEntity = [NSEntityDescription entityForName:@"Trans_Sent_Author" inManagedObjectContext:self.context];
    NSLog(@"q1");
    ///// HHmmmm
    NSFetchRequest *sentPeopleRequest = [[NSFetchRequest alloc] init];
    NSLog(@"q1.1");
    [sentPeopleRequest setEntity:sentPersonEntity];
    NSLog(@"q1.2");
    [sentPeopleRequest setReturnsObjectsAsFaults:NO];    
    NSLog(@"q1.3");
    sent_people = [self.context executeFetchRequest:sentPeopleRequest error:&errorFetchingPeople];
    /////////
    NSLog(@"q2"); 
    
    
    // Create a request to fetch all Queued Authors NOT present in the 'Sent' Table
    NSEntityDescription *queuePersonEntity = [NSEntityDescription entityForName:@"Trans_Queue_Author" inManagedObjectContext:self.context];
    NSLog(@"q3");
    NSFetchRequest *queuePeopleRequest = [[NSFetchRequest alloc] init];
    [queuePeopleRequest setEntity:queuePersonEntity];
    [queuePeopleRequest setReturnsObjectsAsFaults:NO];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(NOT (self IN %@))",sent_people];
    [queuePeopleRequest setPredicate:pred];
    NSLog(@"q4");
    queue_people = [self.context executeFetchRequest:queuePeopleRequest error:&errorFetchingPeople];
    [self.context obtainPermanentIDsForObjects:queue_people error:&errorFetchingPeople];
    NSLog(@"q5");
    NSEnumerator *peopleEnumerator = [queue_people objectEnumerator];
    NSManagedObject *tmp;
    
    
  //  NSMutableArray *peopleData = [[NSMutableArray alloc] initWithCapacity:0];
    //*
    NSLog(@"About to do a while loop");
    while ((tmp = [peopleEnumerator nextObject]) != nil) {
        [self.context deleteObject:tmp];
    }
    NSLog(@"out of while loop");
    NSError *errorSavingSessions = nil;
    if ([self.context save:&errorSavingSessions] == NO) {
       
    }

    NSLog(@"near bottom... doing cleanup...");
    // Clean up and return.
    [queuePeopleRequest release];
    [sentPeopleRequest release];
    
    //*/
    //NSLog(@"peopleData: %@",peopleData);
    //return peopleData;//[NSMutableArray arrayWithCapacity:0];//peopleData;
    NSLog(@"Exiting clear queueueueueueus");
}

-(NSString*)sessionNameForID:(NSString*)timeID
{
    NSLog(@"allSessions");
    NSString *eventName;
    if([timeID isEqualToString:@"d3da2294-5321-478a-8d45-0138eb53dc71"]){
        eventName = @"Kiosk Test Session";
    }else{
        NSDictionary *sessions = [self allSessionsForPush];

        NSArray *ids = [sessions objectForKey:@"eventIDs"];
        
        NSLog(@"timeID's: %@",ids);
        
        int idx = 0;
        
        for(NSString *aTimeID in ids){
            if([aTimeID isEqualToString:[timeID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
                break;
            }
            idx++;
        }
        
        eventName = [[sessions objectForKey:@"names"] objectAtIndex:idx];
        
        NSLog(@"THE EVENT NAME!!!: %@",eventName);
    }
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
    
    NSManagedObject *objectForID = [self.context objectWithID:objectID];
    if (![objectForID isFault])
    {
        [self.context deleteObject:objectForID];
        if (objectForID!=nil && [self.context save:&errorDeletingPerson] == NO) 
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
    
    NSArray *results = [self.context executeFetchRequest:request error:nil];
    if ([results count] > 0 )
    {
        [self.context deleteObject:[results objectAtIndex:0]];
        if ([results objectAtIndex:0]!=nil && [self.context save:errorDeletingPerson] == NO) 
        {
            NSLog(@"boosh");
        }
    }
    
    return;
}

#pragma -

-(void)saveNewSyncTS
{
    NSError *errorGettingSettings = nil;
    NSArray *settings = nil;
    
    // Create a request to fetch all Chefs.
    
    NSEntityDescription *settingEntity = [NSEntityDescription entityForName:@"Setting" inManagedObjectContext:self.context];
    
    NSFetchRequest *settingRequest = [[NSFetchRequest alloc] init];
    [settingRequest setEntity:settingEntity];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    settings = [self.context executeFetchRequest:settingRequest error:&errorGettingSettings];
    [self.context obtainPermanentIDsForObjects:settings error:&errorGettingSettings];
    
    NSEnumerator *settingEnumerator = [settings objectEnumerator];
    NSManagedObject *tmp;
    
    while ((tmp = [settingEnumerator nextObject]) != nil) {
        NSString *tempID = [self uniqueObjectURIString:tmp];
        NSManagedObject *setting = nil;
        
        //setting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:context];
        
        //[setting setValue:[tmp valueForKey:@"Mode"] forKey:@"Mode"];
        [tmp setValue:[NSDate date] forKey:@"LastSyncTS"];
        
        NSError *errorSavingPerson = nil;
        if (setting!=nil && [self.context save:&errorGettingSettings] == NO) {
            [self.context deleteObject:setting];
            
            setting = nil;
        }
        
        //[self deleteObjectForURIString:tempID];
    }
    
    
    NSError *errorSavingSetting = nil;
    if (tmp!=nil && [self.context save:&errorSavingSetting] == NO) {
        [self.context deleteObject:tmp];
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
    
    NSEntityDescription *settingEntity = [NSEntityDescription entityForName:@"Setting" inManagedObjectContext:self.context];
    
    NSFetchRequest *settingRequest = [[NSFetchRequest alloc] init];
    [settingRequest setEntity:settingEntity];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    
    settings = [self.context executeFetchRequest:settingRequest error:&errorGettingSettings];
    
    NSEnumerator *settingEnumerator = [settings objectEnumerator];
    NSManagedObject *tmp;
    
    while ((tmp = [settingEnumerator nextObject]) != nil) {
        //NSString *tempID = [self uniqueObjectURIString:tmp];
        //NSManagedObject *setting = nil;
        /*
        setting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:context];
        
        [setting setValue:[tmp valueForKey:@"Mode"] forKey:@"Mode"];
        [setting setValue:[NSDate date] forKey:@"LastSyncTS"];
        
        NSError *errorSavingPerson = nil;
        if (setting!=nil && [context save:errorGettingSettings] == NO) {
            [context deleteObject:setting];
            
            setting = nil;
        }
        
        [self deleteObjectForURIString:tempID];
         */
        return [tmp valueForKey:@"LastSyncTS"];
    }
    return nil;
}

-(NSDictionary*) parseDate:(NSDate*)aDate{
    NSLog(@"aDate: %@",aDate);
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *newDateString = [outputFormatter stringFromDate:aDate];
    
    [outputFormatter setDateFormat:@"HH:mm"];
    NSString *newTimeString = [outputFormatter stringFromDate:aDate];
    
    NSDictionary *dateTime = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:newDateString,newTimeString, nil] forKeys:[NSArray arrayWithObjects:@"date",@"time", nil]];
    
    NSLog(@"dateTime: %@",dateTime);
    
	[outputFormatter release];
	
    return dateTime;
    // For US English, the output is:
    // newDateString 10:30 on Sunday July 11
}

// return a new autoreleased UUID string
- (NSString *)generateUuidString
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    
    // transfer ownership of the string
    // to the autorelease pool
    [uuidString autorelease];
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}

-(void)moveAndQueueAllData{
    NSLog(@"moveAndQueueAllData");
    NSError *errorFetchingEventTimeAuthors = nil;
    NSArray *eventTimeAuthors = nil;
    
    // Create a request to fetch all EventTimeAuthors.
    
    NSEntityDescription *eventTimeAuthorEntity = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:self.context];
    
    NSFetchRequest *allEventTimeAuthorsRequest = [[NSFetchRequest alloc] init];
    [allEventTimeAuthorsRequest setEntity:eventTimeAuthorEntity];
    
    //Set a predicate to search for the primary key
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(TimeID == %@)",@"b53f602b-82f6-41a1-84df-c43ac605c520"];
    //[allEventTimeAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    [allEventTimeAuthorsRequest setReturnsObjectsAsFaults:NO];   
    eventTimeAuthors = [self.context executeFetchRequest:allEventTimeAuthorsRequest error:errorFetchingEventTimeAuthors];
    
    [allEventTimeAuthorsRequest release];
    
    NSEnumerator *eventTimeAuthorsEnumerator = [eventTimeAuthors objectEnumerator];
    NSManagedObject *tmp;
    
    NSError *errorAddingEventTimeAuthor;
    // NSMutableArray *eventTimeAuthorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    while ((tmp = [eventTimeAuthorsEnumerator nextObject]) != nil) {
        NSLog(@"old eventTimeAuthor: %@", tmp);
        if([[tmp valueForKey:@"Opt_In"] isEqualToString:@"true"]){
            [tmp setValue:@"false" forKey:@"Opt_In"];
        }else{
            [tmp setValue:@"true" forKey:@"Opt_In"];
        }
        
        
        if (tmp != nil && [self.context save:&errorAddingEventTimeAuthor] == NO) 
        {
            NSLog(@"boosh");
        }
    }
    
    eventTimeAuthorEntity = [NSEntityDescription entityForName:@"Trans_Queue_Author" inManagedObjectContext:self.context];
    
    allEventTimeAuthorsRequest = [[NSFetchRequest alloc] init];
    [allEventTimeAuthorsRequest setEntity:eventTimeAuthorEntity];
    
    //Set a predicate to search for the primary key
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(TimeID == %@)",@"b53f602b-82f6-41a1-84df-c43ac605c520"];
    //[allEventTimeAuthorsRequest setPredicate:predicate];
    
    // Ask the context for everything matching the request.
    // If an error occurs, the context will return nil and an error in *error.
    [allEventTimeAuthorsRequest setReturnsObjectsAsFaults:NO];   
    eventTimeAuthors = [self.context executeFetchRequest:allEventTimeAuthorsRequest error:&errorFetchingEventTimeAuthors];
    
    [allEventTimeAuthorsRequest release];
    
    eventTimeAuthorsEnumerator = [eventTimeAuthors objectEnumerator];
    
    
   
    // NSMutableArray *eventTimeAuthorsData = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    while ((tmp = [eventTimeAuthorsEnumerator nextObject]) != nil) {
        NSLog(@"old eventTimeAuthor: %@", tmp);
        if([[tmp valueForKey:@"Opt_In"] isEqualToString:@"true"]){
            [tmp setValue:@"false" forKey:@"Opt_In"];
        }else{
            [tmp setValue:@"true" forKey:@"Opt_In"];
        }
        
        if (tmp != nil && [self.context save:&errorAddingEventTimeAuthor] == NO) 
        {
            NSLog(@"boosh");
        }
    }
    
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

@end

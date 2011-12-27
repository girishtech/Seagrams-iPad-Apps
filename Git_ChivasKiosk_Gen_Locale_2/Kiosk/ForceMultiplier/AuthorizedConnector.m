//
//  AuthorizedConnector.m
//  EventCheckIn
//
//  Created by Garrett Shearer on 9/14/10.
//  Copyright 2010 Rochester Institute of Technology. All rights reserved.
//

#import "AuthorizedConnector.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ForceMultiplierAppDelegate.h"
#import "XMLManager.h"

#pragma mark -
#pragma mark properites
@implementation AuthorizedConnector
@synthesize responseString;
@synthesize token;
@synthesize username;
@synthesize password;
@synthesize keychainItemWrapper;
@synthesize currentScript;
@synthesize queue;
@synthesize loadInitCount;
@synthesize lastLoadPeopleUpdate;
@synthesize newLoadPeopleUpdate;
@synthesize lastLoadInitUpdate;
@synthesize busy,newLoadInitUpdate, isUpdatingCheckIn,isLoadingMarketOnline,isLoadingMarketEventOnline,isLoadingPeopleForDate, isAddingPeople, isUpdatingPeople,creatingTestAuthors;
@synthesize WS_URL;
@synthesize dataAccess = _dataAccess;
@synthesize requestQueue;
@synthesize xmlParser;
@synthesize loginVC;
@synthesize diagnosticMode;


#pragma mark -
#pragma mark init
-(id)init
{
	[super init];
    NSLog(@"init AuthorizedConnector");
	
	//Initialise Async Data Class
	[ASIFormDataRequest setDefaultTimeOutSeconds:300];
    busy = NO;
	
	//Root URL for Webservices
    //DEV
    if(RELEASE == 0) WS_URL = WS_DEV;
    //STAGING
    if(RELEASE == 1) WS_URL = WS_STG;
    //PRODUCTION
    if(RELEASE == 2) WS_URL = WS_PROD;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"ws_url"] != nil){
        if(![[defaults objectForKey:@"ws_url"] isEqualToString:@""]){
            WS_URL = [defaults valueForKey:@"ws_url"];
        }
    }
	
    self.dataAccess = [[DataAccess alloc] init];
    self.xmlParser = [[XMLManager alloc] init];
    self.requestQueue = [[NSMutableArray alloc] init];
    
    diagnosticMode = NO;
    
	return self;
} 

////////////////////////////////////////////////////////////////////////////////


#pragma mark - Request Methods

-(ASIFormDataRequest*)buildRequestToService:(NSString*)service withData:(NSDictionary*)theData
{
	[ASIFormDataRequest setDefaultTimeOutSeconds:300];
	
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WS_URL,service];
    NSLog(@"urlString: %@",urlString);
    
    NSString *fixedURL = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8);
    NSURL *url = [NSURL URLWithString:fixedURL];
    [fixedURL release];
    
	//NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	
    request.shouldStreamPostDataFromDisk = NO;
    //
    NSString *aKey;
    if(theData != nil){
        for(aKey in theData){
            [request setPostValue:[theData valueForKey:aKey] forKey:aKey];
        }
	}
    
    NSLog(@"AuthorizedConnector - makeRequestToService:%@ method - \n\n WS_URL: %@ \nFull_URL: %@ \npostData:\n %@",service,WS_URL,[url absoluteURL],[[request postData] description]);
     
    return request;
}

-(ASIFormDataRequest*)buildRequestToService:(NSString*)service withJSONData:(NSDictionary*)theData
{
	[ASIFormDataRequest setDefaultTimeOutSeconds:300];
	
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WS_URL,service];
    NSLog(@"urlString: %@",urlString);
    
    NSString *fixedURL = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8);
    NSURL *url = [NSURL URLWithString:fixedURL];
    [fixedURL release];
    
	//NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	request.shouldStreamPostDataFromDisk = NO;
    //
    NSString *jsonString = [theData JSONRepresentation];
    [request setPostBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"AuthorizedConnector - makeRequestToService:%@ method - \n\n WS_URL: %@ \nFull_URL: %@ \npostData:\n %@",service,WS_URL,[url absoluteURL],[[request postData] description]);
    
    return request;
}

#pragma mark - End Request Methods


////////////////////////////////////////////////////////////////////////////////


#pragma mark - Helper Methods

-(NSMutableDictionary*)wrapStringsInQuotesForKeys:(NSArray*)keys fromDictionary:(NSMutableDictionary*)dict
{
    for(NSString *key in keys)
    {
        NSString *str = [NSString stringWithFormat:@"'%@'",[dict valueForKey:key]];
        [dict setValue:str forKey:key];
    }
    
    return dict;
}

-(NSMutableString*)appendQueryVars:(NSDictionary*)dict  toString:(NSMutableString*)requestStr
{
    int idx=0;
    for(NSString *key in dict)
    {
        if(idx == 0)
        {
            [requestStr appendString:[NSString stringWithFormat:@"?%@=%@",key,[dict valueForKey:key]]];
            idx++;
        }
        else
        {
            [requestStr appendString:[NSString stringWithFormat:@"&%@=%@",key,[dict valueForKey:key]]]; 
        }
    }
    
    return requestStr;
}

-(NSMutableString*)appendCamelCaseQueryVars:(NSDictionary*)dict  toString:(NSMutableString*)requestStr
{
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    for(NSString *key in dict)
    {
        NSString *firstLetter = [[key substringToIndex:1]lowercaseString];
        NSString *theRest = [key substringFromIndex:1];
        NSString *newKey = [NSString stringWithFormat:@"%@%@",firstLetter,theRest];
        
        NSLog(@"Old Key: %@   New Key: %@",key, newKey);
        
        [newDict setValue:[dict valueForKey:key] forKey:newKey];
    }
    
    return [self appendQueryVars:newDict toString:requestStr];
}

-(void)addAuthParamsToRequest:(ASIFormDataRequest*)aRequest
{
	NSString *timestamp = [NSString stringWithFormat:@"%d", (long)[[NSDate date] timeIntervalSince1970]];
	NSString *UUID = [[UIDevice currentDevice] uniqueIdentifier];
	NSString *timeHash = [self md5:timestamp];
	NSString *tokenHash = [self md5:[self token]];
	NSString *timeTokenHash = [[NSString alloc] initWithFormat:@"%@%@",timeHash,tokenHash];
	NSString *auth = [self md5:timeTokenHash];
	
	[aRequest setPostValue:auth forKey:@"APIToken"];
	[aRequest setPostValue:UUID forKey:@"uuid"];
	[aRequest setPostValue:timestamp forKey:@"timestamp"];
	
}

-(NSString *) md5:(NSString *)str 
{
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3], 
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];	
}

#pragma mark - End Helper Methods


////////////////////////////////////////////////////////////////////////////////


#pragma mark - Login/Studies Methods

-(void)loginAndGetStudiesWithUser:(NSString*)user Password:(NSString*)password withVC:(LoginViewController*)vc
{
    NSLog(@"loginAndGetStudies");
    self.loginVC = vc;
    
    NSMutableString *requestString = [[NSMutableString alloc] initWithCapacity:0];
    NSDictionary *person;
    
    [requestString setString:@""];
    [requestString appendString:@"Events.svc/LoginAndGetStudies"];
    [requestString appendFormat:@"?username='%@'",user];
    [requestString appendFormat:@"&password='%@'",password];
    
    NSLog(@"request string: %@",requestString);
    
    ASIFormDataRequest *request = [self buildRequestToService:requestString withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(loginAndGetStudiesFinished:)];
    [request setDidFailSelector:@selector(loginAndGetStudiesFailed:)];
    [self addRequestToQueue:request];
    
    //if([requestQueue count]>0 && !busy)
    //{
    [self nextRequest];
    //}
}

-(void)loginAndGetStudiesFinished:(ASIFormDataRequest *)request
{
	NSLog(@"loginAndGetStudies finished");
	NSLog(@"loginAndGetStudies response: %@",[request responseString]);
	
    NSString *loginAndGetStudiesResponseXML = [request responseString];
    [xmlParser parseXMLString:loginAndGetStudiesResponseXML forService:@"LoginAndGetStudies"];
    
    NSString *time = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    if([self diagnosticMode])[self createLogEntry:request status:@"Y" timestamp:time];
    
    [self popRequest];
}

-(void)loginAndGetStudiesFailed:(ASIFormDataRequest *)request
{
    NSLog(@"loginAndGetStudiesFailed:");
	NSError *error = [request error];
	NSLog(@"loginAndGetStudies error: %@", [error userInfo]);
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self clearQueue];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    
    
    
    
    NSString *time = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    if([self diagnosticMode])[self createLogEntry:request status:@"N" timestamp:time];
}

#pragma mark - End Login/Studies Methods


////////////////////////////////////////////////////////////////////////////////


#pragma mark - Author Methods



-(void)dumpRegistrationsToServer
{
    
    NSLog(@"dumpRegistrationsToServer");
    NSArray *eventTimeIDs = [self.dataAccess eventTimeIDsForPush];
    
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    UIDevice *device = [UIDevice currentDevice];
    
    NSString *deviceName = [device name];
    NSString *deviceModel = [device model];
    NSString *deviceSystemName = [device systemName];
    NSString *deviceSystemVersion = [device systemVersion];
    NSString *deviceUUID = [device uniqueIdentifier];
    NSString *applicationName = [bundleInfo valueForKey:@"CFBundleName"];
    NSString *applicationVersion = CURRENTVERSION;
    NSLog(@"abut to do first POST change...");
    // for image POSTing
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *wsPhotoMethod = @"API/AddPhoto";
    NSString *urlString = [NSString stringWithFormat:@"%@%@",WS_URL,wsPhotoMethod];
    NSLog(@"urlString: %@",urlString);

    
    NSString *APIKEY;
    NSString *APPKEY;
    //DEV
	if(RELEASE == 0)
    {
        APIKEY = APIKEY_DEV_ENG;
        APPKEY = APPKEY_DEV_ENG;
    }
    //STAGING
    if(RELEASE == 1)
    {
        APIKEY = APIKEY_STG_ENG;
        APPKEY = APPKEY_STG_ENG;
    }
    //PRODUCTION
    if(RELEASE == 2)
    {
        APIKEY = APIKEY_PROD_ENG;
        APPKEY = APPKEY_PROD_ENG;
    }
    
    
    for(NSString *eventTimeID in eventTimeIDs)
    {
        NSLog(@"%@",eventTimeID);
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSMutableDictionary *requestJSONObj = [[NSMutableDictionary alloc] initWithCapacity:0];
        [requestJSONObj setValue:APIKEY forKey:@"AccountAPIKey"];
        [requestJSONObj setValue:APPKEY forKey:@"ApplicationKey"];
        [requestJSONObj setValue:[self parseDateTime:[NSDate date]] forKey:@"RequestTimestamp"];
        [requestJSONObj setValue:self.dataAccess.brandID forKey:@"StudyID"];
        
        [requestJSONObj setValue:deviceName forKey:@"ClientName"];
        [requestJSONObj setValue:deviceModel forKey:@"ClientModel"];
        [requestJSONObj setValue:deviceSystemName forKey:@"ClientSystemName"];
        [requestJSONObj setValue:deviceSystemVersion forKey:@"ClientSystemVersion"];
        [requestJSONObj setValue:deviceUUID forKey:@"ClientRemoteID"];
        [requestJSONObj setValue:applicationName forKey:@"ApplicationName"];
        [requestJSONObj setValue:applicationVersion forKey:@"ApplicationVersion"];
    
   
        NSMutableArray *eventTimes = [[NSMutableArray alloc] initWithCapacity:0];
    
        NSMutableDictionary *eventTime = [[NSMutableDictionary alloc] initWithCapacity:0];
        [eventTime setValue:eventTimeID forKey:@"TimeID"];
        
        NSArray *authorsForPush = [self.dataAccess allAuthorsForPush:eventTimeID];
        NSMutableArray *authors = [[NSMutableArray alloc] initWithCapacity:0];
        // each person...
        for(NSDictionary *authorForPush in authorsForPush){
            
            NSMutableDictionary *author = [[NSMutableDictionary alloc] initWithCapacity:0];
            [author addEntriesFromDictionary:authorForPush];
            
            ///////////////
            // IMAGE UPLOAD STUFF
          //*
            NSString *authorEmail = [author valueForKey:@"AuthorEmail"];
            NSLog(@"got email addy of %@", authorEmail);
            
            // see if we have an image
            NSString *imageFileName = [NSString stringWithFormat:@"%@_%@.png", eventTimeID, authorEmail];
            NSString *imagePath = [documentDirectory stringByAppendingPathComponent:imageFileName];
            BOOL imgExists = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
            NSLog(@"Checked for image %@; did I find one? %d", imagePath, imgExists);
      
             if (imgExists) {
                 NSLog(@"Found an image, so creating a new request to send it...");
                 
                  ASIFormDataRequest *theRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
                  [theRequest setPostValue:eventTimeID forKey:@"timeID"];
                  [theRequest setPostValue:authorEmail forKey:@"email"];
                  [theRequest setFile:imagePath withFileName:imageFileName andContentType:@"image/png" forKey:@"photo"];
                  
                  //synchronous request
                  [theRequest startSynchronous];
                  NSError *err = [theRequest error];
                  if (!err) {
                      NSLog(@"request returned with no error: %@ going to remove image", [theRequest responseString]);
                      // no error, so remove the image
                      [[NSFileManager defaultManager] removeItemAtPath:imagePath error:NULL];
                  } else {
                      NSLog(@"Request bombed: %@", err.description);
                  }
                  

               
             }
             else {
                NSLog(@"No image for author");
             }
            // END IMAGE UPLOAD STUFF
            ///////////////////////////////
            // */
            
            NSArray *responses = [self.dataAccess answersForRemoteID:[authorForPush valueForKey:@"RemoteSystemID"]];
            [author setObject:responses forKey:@"SurveyResponses"];
            [author setValue:[author valueForKey:@"Opt_In"] forKey:@"OptIn"];
            
            [author removeObjectForKey:@"RemoteSystemID"];
            [author removeObjectForKey:@"Opt_In"];
            
            [authors addObject:author];
        }
        [eventTime setObject:authors forKey:@"Authors"];
        [eventTimes addObject:eventTime];
    
    
        [requestJSONObj setObject:eventTimes forKey:@"EventTimes"];
    
        NSString *jsonString = [requestJSONObj JSONRepresentation];
        NSLog(@"SYNC JSON: \n %@",jsonString);
    
        //SEND QUESTIONS
        NSMutableString *requestString2 = [[NSMutableString alloc] initWithCapacity:0];
    
        [requestString2 setString:@""];
        [requestString2 appendString:@"API/BulkInsert"];
            
        //NSLog(@"personVars: %@",personVars);
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] initWithCapacity:0];
        [postData setObject:jsonString forKey:@"data"];
        
        ASIFormDataRequest *request2 = [self buildRequestToService:requestString2 withData:postData];
        [request2 setDelegate:self];
        [request2 setDidFinishSelector:@selector(dumpRegistrationsToServerRequestFinished:)];
        [request2 setDidFailSelector:@selector(dumpRegistrationsToServerRequestFailed:)];
        
        [self addRequestToQueue:request2];
        [pool drain];
    }
    
    [self nextRequest];

}
 //*/

-(void)dumpRegistrationsToServerRequestFinished:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
	NSLog(@"dumpRegistrationsToServerRequestFinished finished");
	NSLog(@"dumpRegistrationsToServerRequestFinished response: %@",responseString);
    
    if([responseString isEqualToString:@"\"Thank You\""] && ([requestQueue count]==1)){
        [self.dataAccess performSelectorOnMainThread:@selector(clearQueues) withObject:nil waitUntilDone:YES];
        //[self.dataAccess clearQueues];
    }
    NSLog(@"about to call popRequest....");
    [self popRequest];
}

-(void)dumpRegistrationsToServerRequestFailed:(ASIFormDataRequest *)request
{
    NSLog(@"dumpRegistrationsToServerRequestFailed:");
	NSError *error = [request error];
	NSLog(@"dumpRegistrationsToServerRequestFailed error: %@", [error userInfo]);
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    busy = NO;
    [self clearQueue];
   
}


#pragma mark - End EventTimeAuthor Methods


////////////////////////////////////////////////////////////////////////////////


#pragma mark - EventTime Methods

-(void)getEventTimes 
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"getEventTimes");
    
    NSString *service = [NSString stringWithFormat:@"%@%@", @"API/GetEventsForStudyID?studyID=", self.dataAccess.brandID];
    
    ASIFormDataRequest *request = [self buildRequestToService:service withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getEventTimesRequestFinished:)];
    [request setDidFailSelector:@selector(getEventTimesRequestFailed:)];
    [self addRequestToQueue:request];
    
    if([requestQueue count]==1)
    {
        [self nextRequest];
    }
    
    [pool release];
}

-(void)getEventTimesRequestFinished:(ASIFormDataRequest *)request
{
	NSLog(@"getEventTimesRequest finished");
    NSLog(@"getEventTimesRequest response: %@",[request responseString]);
    NSLog(@"getEventTimesRequest: %@",request);
    
    NSString *time = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    if([self diagnosticMode])[self createLogEntry:request status:@"Y" timestamp:time];
    
    NSString *eventTimes = [request responseString];
    //[xmlParser parseXMLString:eventTimesXML forService:@"GetStudyEventTimes"];
    [self.dataAccess addSessions:[eventTimes JSONValue]];
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate settingsVw] fetchRecordCount];
    [[appDelegate settingsVw] reloadGrid];
    
    [self popRequest];
}

-(void)getEventTimesRequestFailed:(ASIFormDataRequest *)request
{
    NSLog(@"getEventTimesRequestFailed:");
    
    NSString *time = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    if([self diagnosticMode])[self createLogEntry:request status:@"N" timestamp:time];
    
	NSError *error = [request error];
	NSLog(@"getEventTimes error: %@", [error userInfo]);
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    busy = NO;
    [self clearQueue];
}


#pragma mark - End EventTimeAuthor Methods

////////////////////////////////////////////////////////////////////////////////
 

#pragma mark - Queue Methods

-(void)addRequestToQueue:(ASIFormDataRequest*)request
{
    [requestQueue addObject:request];
}

-(void)nextRequest
{
    if([requestQueue count] > 0 && !busy)
    {
        NSLog(@"next request: %@",[requestQueue objectAtIndex:0]);
        busy = YES;
        [[requestQueue objectAtIndex:0]startAsynchronous];
    } else {
        NSLog(@"I'm not busy! Request count is %d", [requestQueue count]);
        if([requestQueue count] == 0) {
            if(isAddingPeople)
            {
                NSLog(@"use to add reg for people...");
                isAddingPeople = NO;
                //[self addRegistrationForPeople];
            }
            
            else if(creatingTestAuthors)
            {
                
            }
            else
            {
                NSLog(@"sync done");
                ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
                //[[appDelegate rootVC]syncSucceeded];
                //[[appDelegate rootVC]unlockScreen];
               // NSTimer *aTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkCount) userInfo:nil repeats:NO]; 
                [self.dataAccess saveNewSyncTS];
                [[appDelegate rootVC] performSelectorOnMainThread:@selector(unlockScreen) withObject:nil waitUntilDone:YES];
                [[appDelegate rootVC]syncSucceeded];
            }
            
            
        }
    }
}


-(void)clearQueue
{
    [requestQueue removeAllObjects];
}

-(void)popRequest
{
    NSLog(@"popRequest called");
    busy = NO;
    [requestQueue removeObjectAtIndex:0];
    [self nextRequest];
}

#pragma mark - End Queue Methods

#pragma mark - Logging Methods

-(void)createLogEntry:(ASIFormDataRequest*)request status:(NSString*)successStr timestamp:(NSString*)timestamp
{
    NSMutableDictionary *requestEntry = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSMutableDictionary *logData = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    
        if([[request requestMethod] isEqualToString:@"GET"])
        {
            [requestEntry setObject:@"GET" forKey:@"datatype"];
            [requestEntry setObject:@"IN URL" forKey:@"data"];
        }
        else if([[request requestMethod] isEqualToString:@"POST"])
        {
            [requestEntry setObject:@"POST/JSON" forKey:@"datatype"];
            NSLog(@"DATA: %@", [[NSString alloc] initWithData:[request postBody] encoding:NSUTF8StringEncoding]);
            [requestEntry setObject:[[NSString alloc] initWithData:[request postBody] encoding:NSUTF8StringEncoding] forKey:@"data"];
        }
    
    
    //Extract Services String
    NSString *serviceStr = [[[request url] absoluteString] substringFromIndex:[WS_URL length]];
    NSRange searchRange = NSMakeRange(0, [serviceStr length]);
    NSRange textRange = [serviceStr rangeOfString:@"?"
                                   options:NSCaseInsensitiveSearch 
                                     range:searchRange];
        
    if ( textRange.location == NSNotFound ) {
        // Not there
        NSLog(@"question mark not found");
    } else {
        NSLog(@"question mark found at index: %d",textRange.location);
        serviceStr = [serviceStr substringToIndex:textRange.location];
    }
    
    [requestEntry setObject:serviceStr forKey:@"service"];
    
    if([successStr isEqualToString:@"Y"])
    {
        [requestEntry setObject:[request responseString] forKey:@"response"];
    }else{
        [requestEntry setObject:[[request error] userInfo] forKey:@"response"];
    }
    
    [requestEntry setObject:successStr forKey:@"success"];
    [requestEntry setObject:timestamp forKey:@"timestamp"];
    [requestEntry setObject:[[request url] absoluteString] forKey:@"url"];
    
    
    //Add request to an array, web service can accept many requests in bulk sends
    NSArray *requestArr = [[NSArray alloc] initWithObjects:requestEntry, nil];
    
    NSString *requestJSON;
    NSString *requestJSONTmp = [requestArr JSONRepresentation];
    if(requestJSONTmp!=nil){
        requestJSON = [[NSString alloc] initWithString:requestJSONTmp];
    }else{
      requestJSON = [[NSString alloc] initWithString:@"NO POST DATA"]; 
    }
    
    
    //Add request data to the POST vars
    [logData setObject:requestJSON forKey:@"requests"];
    UIDevice *device = [UIDevice currentDevice]; 
    [logData setObject:[device uniqueIdentifier] forKey:@"uuid"];
    [logData setObject:@"Chivas 1801 Kiosk" forKey:@"application_name"];
    [logData setObject:@"1.0.0.25" forKey:@"application_version"];
    
    //NSLog(@"Log Data: %@",logData);
    
    //*
    [ASIFormDataRequest setDefaultTimeOutSeconds:300];
	
    NSString *urlString = @"http://ss-scripts.etghosting.net/logging/_api_logger.php";//[NSString stringWithFormat:@"%@%@",WS_URL,service];
    NSLog(@"urlString: %@",urlString);
    
    NSString *fixedURL = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8);
    NSURL *url = [NSURL URLWithString:fixedURL];
    [fixedURL release];
    
	//NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *logrequest = [ASIFormDataRequest requestWithURL:url];
	
    //
    NSString *aKey;
    if(logData != nil){
        for(aKey in logData){
            [logrequest setPostValue:[logData valueForKey:aKey] forKey:aKey];
        }
	}
    
    [logrequest setDelegate:self];
    [logrequest setDidFinishSelector:@selector(logEntryFinished:)];
    [logrequest setDidFailSelector:@selector(logEntryFailed:)];
    [self addRequestToQueue:logrequest];
    
    
    [self nextRequest];
    
    
    //NSLog(@"AuthorizedConnector - makeRequestToService:%@ method - \n\n WS_URL: %@ \nFull_URL: %@ \npostData:\n %@",service,WS_URL,[url absoluteURL],[[request postData] description]);
    //*/
}

-(void)logEntryFinished:(ASIFormDataRequest *)request
{
	NSLog(@"logEntryFinished finished");
	NSLog(@"logEntryFinished response: %@",[request responseString]);
    
	//NSString *eventXML = [request responseString];
    //[xmlParser parseXMLString:eventXML];
    
    [self popRequest];
}

-(void)logEntryFailed:(ASIFormDataRequest *)request
{
    NSLog(@"logEntryFinished:");
	NSError *error = [request error];
	NSLog(@"logEntryFinished error: %@", [error userInfo]);
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self clearQueue];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    busy = NO;
    
}

#pragma mark - End Logging Methods

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


////////////////////////////////////////////////////////////////////////////////




@end

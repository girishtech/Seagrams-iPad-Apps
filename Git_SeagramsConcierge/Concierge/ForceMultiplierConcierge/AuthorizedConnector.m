

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
#import "ForceMultiplierConciergeAppDelegate.h"
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
@synthesize busy,newLoadInitUpdate, isUpdatingCheckIn,isLoadingMarketOnline,isLoadingMarketEventOnline,isLoadingPeopleForDate, isAddingPeople, isUpdatingPeople;
@synthesize WS_URL;
@synthesize dataAccess;
@synthesize xmlParser;
@synthesize loginVC,loggingIn;



#pragma mark -
#pragma mark init
-(id)init{
	[super init];
    NSLog(@"init AuthorizedConnector");
	//NSString *keyChainIdentifier = [[NSMutableString alloc] initWithFormat:@"Macallan_Checkin_1_0_%@",@"garrett@garrettshearer.com"];//user];
	//self.keychainItemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:keyChainIdentifier accessGroup:nil];
	
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
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
   
    
    dataAccess = [appDelegate da];
    xmlParser = [[XMLManager alloc] init];
    requestQueue = [[NSMutableArray alloc] init];
    
    self.loggingIn = NO;
    
	return self;
} 

-(void)syncPush
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self updateEventTimeAuthors];
    [pool release];
}

-(void)syncPull
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self getEventTimes];
    NSString *timeID = [dataAccess currentTimeID];
    if(![timeID isEqualToString:@""]) [self EventTimeAuthorForTimeID:timeID];
    [pool release];
}

-(void)testSync
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self getEventTimes];
    [self EventTimeAuthorForTimeID:@"b53f602b-82f6-41a1-84df-c43ac605c520"];
    [dataAccess toggleTestAttendees];
    [dataAccess updatedEventTimeAuthors];
    [dataAccess updatedAuthorDetails];
    //[dataAccess clearQueues];
     
    [pool release];
}

#pragma mark services

-(ASIFormDataRequest*)buildRequestToService:(NSString*)service withData:(NSDictionary*)theData
{
	[ASIFormDataRequest setDefaultTimeOutSeconds:300];
	
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",WS_URL,service];
    NSLog(@"urlString: %@",urlString);
    
    NSString *fixedURL = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8);
    NSURL *url = [NSURL URLWithString:fixedURL];
    [fixedURL release];
    [urlString release];
    
	//NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	
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
	
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",WS_URL,service];
    NSLog(@"urlString: %@",urlString);
    
    NSString *fixedURL = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)urlString, NULL, NULL, kCFStringEncodingUTF8);
    NSURL *url = [NSURL URLWithString:fixedURL];
    [fixedURL release];
    [urlString release];
    
	//NSURL *url = [NSURL URLWithString:urlString];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	
    //
    NSString *jsonString = [theData JSONRepresentation];
    [request setPostBody:[jsonString  dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"AuthorizedConnector - makeRequestToService:%@ method - \n\n WS_URL: %@ \nFull_URL: %@ \npostData:\n %@",service,WS_URL,[url absoluteURL],theData);
    
    return request;
}

-(NSMutableDictionary*)wrapStringsInQuotesForKeys:(NSArray*)keys fromDictionary:(NSMutableDictionary*)dict
{
    for(NSString *key in keys)
    {
        NSString *str = [[NSString alloc] initWithFormat:@"'%@'",[dict valueForKey:key]];
        [dict setValue:str forKey:key];
        [str release];
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
             NSString *formatstr = [[NSString alloc] initWithFormat:@"?%@=%@",key,[dict valueForKey:key]];
             [requestStr appendString:formatstr];
             [formatstr release];
             idx++;
         }
         else
         {
             NSString *formatstr2 = [[NSString alloc] initWithFormat:@"&%@=%@",key,[dict valueForKey:key]];
             [requestStr appendString:formatstr2];
             [formatstr2 release];
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
        NSString *newKey = [[NSString alloc] initWithFormat:@"%@%@",firstLetter,theRest];
                                                     
        NSLog(@"Old Key: %@   New Key: %@",key, newKey);
        
        [newDict setValue:[dict valueForKey:key] forKey:newKey];
        [newKey release];
    }
    
    return [self appendQueryVars:newDict toString:requestStr];
}
/*
-(void)AuthorDetailForAuthorID:(NSString*)authorID 
{
    NSLog(@"addAuthorDetailForAuthorID");
        NSMutableString *requestString = [[NSMutableString alloc] initWithCapacity:0];
    NSDictionary *authorDetail;
    
    [requestString setString:@""];
    [requestString appendString:@"Events.svc/AuthorDetails"];
    [requestString appendFormat:@"(guid'%@')",authorID ];
        
       
        
    ASIFormDataRequest *request = [self buildRequestToService:[requestString autorelease] withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(AuthorDetailForAuthorIDFinished:)];
    [request setDidFailSelector:@selector(AuthorDetailForAuthorIDFailed:)];
    
    [self addRequestToQueue:request];
    [self nextRequest];
}

- (void)AuthorDetailForAuthorIDFinished:(ASIFormDataRequest *)request
{
	NSLog(@"AuthorDetailForAuthorID finished");
	NSLog(@"AuthorDetailForAuthorID response: %@",[request responseString]);
    
    NSString *AuthorDetailForAuthorIDResponseXML = [request responseString];
    [xmlParser parseXMLString:AuthorDetailForAuthorIDResponseXML forService:@"AuthorDetailForAuthorID"];
    [self popRequest];
}

- (void)AuthorDetailForAuthorIDFailed:(ASIFormDataRequest *)request
{
    NSLog(@"AuthorDetailForAuthorIDFailed:");
	NSError *error = [request error];
	NSLog(@"loginAndGetStudies error: %@", [error userInfo]);
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
}
*/

#pragma mark - Login/Studies Methods

-(void)loginAndGetStudiesWithUser:(NSString*)user Password:(NSString*)password withVC:(LoginViewController*)vc
{
    NSLog(@"loginAndGetStudies");
    self.loginVC = vc;
    self.loggingIn = YES;
    
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
   // if([self diagnosticMode])[self createLogEntry:request status:@"Y" timestamp:time];
    
    [self popRequest];
}

-(void)loginAndGetStudiesFailed:(ASIFormDataRequest *)request
{
    NSLog(@"loginAndGetStudiesFailed:");
	NSError *error = [request error];
	NSLog(@"loginAndGetStudies error: %@", [error userInfo]);
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Login Failed"];
    
    NSString *time = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    //if([self diagnosticMode])[self createLogEntry:request status:@"N" timestamp:time];
    busy = NO;
    [self popRequest];
}

#pragma mark - End Login/Studies Methods


-(void)AuthorInteractionForAuthorInteractionID:(NSString*)authorInteractionID 
{
    NSLog(@"addPeople");
        NSMutableString *requestString = [[NSMutableString alloc] initWithCapacity:0];
    NSDictionary *authorInteraction;
    
    [requestString setString:@""];
    [requestString appendString:@"Events.svc/AuthorInteractions"];
    [requestString appendFormat:@"(guid'%@')",authorInteractionID ];
        
       
        
    ASIFormDataRequest *request = [self buildRequestToService:[requestString autorelease] withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(AuthorInteractionForAuthorInteractionIDFinished:)];
    [request setDidFailSelector:@selector(AuthorInteractionForAuthorInteractionIDFailed:)];
    
    [self addRequestToQueue:request];
    [self nextRequest];
}

- (void)AuthorInteractionForAuthorInteractionIDFinished:(ASIFormDataRequest *)request
{
	NSLog(@"AuthorInteractionForAuthorInteractionID finished");
	NSLog(@"AuthorInteractionForAuthorInteractionID response: %@",[request responseString]);
    
    NSString *AuthorInteractionForAuthorInteractionIDResponseXML = [request responseString];
    [xmlParser parseXMLString:AuthorInteractionForAuthorInteractionIDResponseXML forService:@"AuthorInteractionForAuthorInteractionID"];
    [self popRequest];
}

- (void)AuthorInteractionForAuthorInteractionIDFailed:(ASIFormDataRequest *)request
{
    NSLog(@"AuthorInteractionForAuthorInteractionIDFailed:");
	NSError *error = [request error];
	NSLog(@"loginAndGetStudies error: %@", [error userInfo]);
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    [self popRequest];
}


-(void)AuthorForAuthorID:(NSString*)authorID 
{
    NSLog(@"addPeople");
    NSMutableString *requestString = [[NSMutableString alloc] initWithCapacity:0];
    NSDictionary *author;
    
    [requestString setString:@""];
    [requestString appendString:@"Events.svc/Authors"];
    [requestString appendFormat:@"(guid'%@')",authorID ];
    
    ASIFormDataRequest *request = [self buildRequestToService:[requestString autorelease] withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(AuthorForAuthorIDFinished:)];
    [request setDidFailSelector:@selector(AuthorForAuthorIDFailed:)];
    
    [self addRequestToQueue:request];
    [self nextRequest];
}

- (void)AuthorForAuthorIDFinished:(ASIFormDataRequest *)request
{
	NSLog(@"AuthorForAuthorID finished");
	NSLog(@"AuthorForAuthorID response: %@",[request responseString]);
    
    NSString *AuthorForAuthorIDResponseXML = [request responseString];
    [xmlParser parseXMLString:AuthorForAuthorIDResponseXML forService:@"AuthorForAuthorID"];
    [self popRequest];
}

- (void)AuthorForAuthorIDFailed:(ASIFormDataRequest *)request
{
    NSLog(@"AuthorForAuthorIDFailed:");
	NSError *error = [request error];
	NSLog(@"loginAndGetStudies error: %@", [error userInfo]);
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    [self popRequest];
}

-(void)AuthorDetailsForAuthorID:(NSString*)authorID 
{
    NSLog(@"addPeople");
    NSMutableString *requestString = [[NSMutableString alloc] initWithCapacity:0];
    NSDictionary *author;
    
    [requestString setString:@""];
    [requestString appendString:@"Events.svc/AuthorDetails"];
    [requestString appendFormat:@"(guid'%@')",authorID ];
    
    ASIFormDataRequest *request = [self buildRequestToService:[requestString autorelease] withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(AuthorDetailsForAuthorIDFinished:)];
    [request setDidFailSelector:@selector(AuthorDetailsForAuthorIDFailed:)];
    
    [self addRequestToQueue:request];
    [self nextRequest];
}

- (void)AuthorDetailsForAuthorIDFinished:(ASIFormDataRequest *)request
{
	NSLog(@"AuthorDetailsForAuthorID finished");
	NSLog(@"AuthorDetailsForAuthorID response: %@",[request responseString]);
    
    NSString *AuthorDetailsForAuthorIDResponseXML = [request responseString];
    [xmlParser parseXMLString:AuthorDetailsForAuthorIDResponseXML forService:@"AuthorDetailForAuthorID"];
    [self popRequest];
}

- (void)AuthorDetailsForAuthorIDFailed:(ASIFormDataRequest *)request
{
    NSLog(@"AuthorDetailsForAuthorIDFailed:");
	NSError *error = [request error];
	NSLog(@"loginAndGetStudies error: %@", [error userInfo]);
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    [self popRequest];
}
/*
-(void)updateEventTimeAuthor:(NSMutableDictionary*)eventTimeAuthor
{
    NSLog(@"addPeople");
    NSMutableString *requestString = [[NSMutableString alloc] initWithCapacity:0];
    
    
    [requestString setString:@""];
    [requestString appendString:@"Events.svc/EditEventTimeAuthor"];
    
    //Wrap string type vars in quotes
    NSArray *keys = [[NSArray alloc] initWithObjects:@"TimeID",@"AuthorID", nil];
    eventTimeAuthor = [self wrapStringsInQuotesForKeys:keys fromDictionary:eventTimeAuthor];
    
    //Strip out params we dont need
    //keys = [NSArray arrayWithObjects:@"TimeID",@"AuthorID", nil];
    
    requestString = [self appendCamelCaseQueryVars:eventTimeAuthor toString:requestString];
    
    NSLog(@"updateEventTimeAuthor: %@",requestString);
    
    ASIFormDataRequest *request = [self buildRequestToService:[requestString autorelease] withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(updateEventTimeAuthorFinished:)];
    [request setDidFailSelector:@selector(updateEventTimeAuthorFailed:)];
    
    [self addRequestToQueue:request];
    
    [self nextRequest];
    
    NSArray *responses = [dataAccess answersForAuthorID:[eventTimeAuthor valueForKey:@"AuthorID"]];
    NSLog(@"survey responses: %@", responses);
    for(NSDictionary *questionAnswer in responses)
    {
        NSMutableString *requestString2 = [[NSMutableString alloc] initWithCapacity:0];
        
        
        [requestString2 setString:@""];
        [requestString2 appendString:@"Events.svc/AddSurveyResponse?"];
        [requestString2 appendFormat:@"authorID='%@'",[[eventTimeAuthor valueForKey:@"AuthorID"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"'"]]];
        [requestString2 appendFormat:@"&timeID='%@'",[[eventTimeAuthor valueForKey:@"TimeID"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"'"]]];
        [requestString2 appendFormat:@"&answerID='%@'",[questionAnswer valueForKey:@"AnswerID"]];
        if([questionAnswer valueForKey:@"Value"] != nil){
            [requestString2 appendFormat:@"&value='%@'",[questionAnswer valueForKey:@"Value"]];
        }else{
            [requestString2 appendFormat:@"&value='%@'",@"True"];
        }
        
        //NSLog(@"personVars: %@",personVars);
        
        ASIFormDataRequest *request2 = [self buildRequestToService:[requestString2 autorelease] withData:nil];
        [request2 setDelegate:self];
        [request2 setDidFinishSelector:@selector(questionsRequestFinished:)];
        [request2 setDidFailSelector:@selector(questionsRequestFailed:)];
        
        [self addRequestToQueue:request2];
    }
    
    [keys release];
    
}
*/
-(void)updateEventTimeAuthors
{
    NSLog(@"BulkUpdate");
    NSMutableString *requestString = [[NSMutableString alloc] initWithCapacity:0];
    NSArray *eventTimeIDs = [dataAccess eventTimeIDsForPush];
    
    [requestString setString:@""];
    [requestString appendString:@"API/BulkUpdate"];
    
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    UIDevice *device = [UIDevice currentDevice];
    
    NSString *deviceName = [device name];
    NSString *deviceModel = [device model];
    NSString *deviceSystemName = [device systemName];
    NSString *deviceSystemVersion = [device systemVersion];
    NSString *deviceUUID = [device uniqueIdentifier];
    NSString *applicationName = [bundleInfo valueForKey:@"CFBundleName"];
    NSString *applicationVersion = CURRENTVERSION;
    
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
    
    /*
    //Wrap string type vars in quotes
    NSArray *keys = [[NSArray alloc] initWithObjects:@"TimeID",@"AuthorID", nil];
    eventTimeAuthor = [self wrapStringsInQuotesForKeys:keys fromDictionary:eventTimeAuthor];
    
    //Strip out params we dont need
    //keys = [NSArray arrayWithObjects:@"TimeID",@"AuthorID", nil];
    
    requestString = [self appendCamelCaseQueryVars:eventTimeAuthor toString:requestString];
    
    NSLog(@"updateEventTimeAuthor: %@",requestString);
    */
    for(NSString *eventTimeID in eventTimeIDs)
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
        NSMutableDictionary *requestJSONObj = [[NSMutableDictionary alloc] initWithCapacity:0];
        [requestJSONObj setValue:APIKEY forKey:@"AccountAPIKey"];
        [requestJSONObj setValue:APPKEY forKey:@"ApplicationKey"];
        [requestJSONObj setValue:[self parseDateTime:[NSDate date]] forKey:@"RequestTimestamp"];
        [requestJSONObj setValue:dataAccess.brandID forKey:@"StudyID"];
        
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
        
        NSArray *authorsForPush = [dataAccess allAuthorsForPush:eventTimeID];
        NSMutableArray *authors = [[NSMutableArray alloc] initWithCapacity:0];
        for(NSDictionary *authorForPush in authorsForPush){
            NSMutableDictionary *author = [[NSMutableDictionary alloc] initWithCapacity:0];
            [author addEntriesFromDictionary:authorForPush];
            
            NSArray *responses = [dataAccess answersForAuthorID:[author valueForKey:@"AuthorID"]];
            [author setObject:responses forKey:@"SurveyResponses"];
            
            //[author removeObjectForKey:@"RemoteSystemID"];
            
            [authors addObject:author];
        }
        [eventTime setObject:authors forKey:@"Authors"];
        [eventTimes addObject:eventTime];
        
        
        [requestJSONObj setObject:eventTimes forKey:@"EventTimes"];
        
        NSString *jsonString = [requestJSONObj JSONRepresentation];
        NSLog(@"jsonString =  %@",jsonString);
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] initWithCapacity:0];
        [postData setObject:jsonString forKey:@"data"];
        
        ASIFormDataRequest *request = [self buildRequestToService:requestString withData:postData];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(updateEventTimeAuthorFinished:)];
        [request setDidFailSelector:@selector(updateEventTimeAuthorFailed:)];
        
        [self addRequestToQueue:request];
    
        [pool drain];
    }
    
    [self nextRequest];
    /*
    NSArray *responses = [dataAccess answersForAuthorID:[eventTimeAuthor valueForKey:@"AuthorID"]];
    NSLog(@"survey responses: %@", responses);
    for(NSDictionary *questionAnswer in responses)
    {
        NSMutableString *requestString2 = [[NSMutableString alloc] initWithCapacity:0];
        
        
        [requestString2 setString:@""];
        [requestString2 appendString:@"Events.svc/AddSurveyResponse?"];
        [requestString2 appendFormat:@"authorID='%@'",[[eventTimeAuthor valueForKey:@"AuthorID"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"'"]]];
        [requestString2 appendFormat:@"&timeID='%@'",[[eventTimeAuthor valueForKey:@"TimeID"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"'"]]];
        [requestString2 appendFormat:@"&answerID='%@'",[questionAnswer valueForKey:@"AnswerID"]];
        if([questionAnswer valueForKey:@"Value"] != nil){
            [requestString2 appendFormat:@"&value='%@'",[questionAnswer valueForKey:@"Value"]];
        }else{
            [requestString2 appendFormat:@"&value='%@'",@"True"];
        }
        
        //NSLog(@"personVars: %@",personVars);
        
        ASIFormDataRequest *request2 = [self buildRequestToService:[requestString2 autorelease] withData:nil];
        [request2 setDelegate:self];
        [request2 setDidFinishSelector:@selector(questionsRequestFinished:)];
        [request2 setDidFailSelector:@selector(questionsRequestFailed:)];
        
        [self addRequestToQueue:request2];
    }
    
    [keys release];
     */
    
}

-(void)questionsRequestFinished:(ASIFormDataRequest *)request
{
	NSLog(@"questionsRequest finished");
	NSLog(@"questionsRequest response: %@",[request responseString]);
	
    //parse xml?
    
    [self popRequest];
}

-(void)questionsRequestFailed:(ASIFormDataRequest *)request
{
    NSLog(@"questionsRequestFailed:");
	NSError *error = [request error];
	NSLog(@"questionsRequest error: %@", [error userInfo]);
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
}


- (void)updateEventTimeAuthorFinished:(ASIFormDataRequest *)request
{
	NSLog(@"updateEventTimeAuthor finished");
	NSLog(@"updateEventTimeAuthor response: '%@'",[request responseString]);
    if(([[request responseString]isEqualToString:@"Thank you"] || [[request responseString]isEqualToString:@"\"Thank you\""] || [[request responseString]isEqualToString:@"Thank You"] || [[request responseString]isEqualToString:@"\"Thank You\""]) && ([requestQueue count]==1)){
        [dataAccess clearQueues];
    }
    NSString *updateEventTimeAuthorResponseXML = [request responseString];
    //[xmlParser parseXMLString:updateEventTimeAuthorResponseXML forService:@"updateEventTimeAuthor"];
    [self popRequest];
}

- (void)updateEventTimeAuthorFailed:(ASIFormDataRequest *)request
{
    NSLog(@"updateEventTimeAuthorFailed:");
	NSError *error = [request error];
	NSLog(@"updateEventTimeAuthor error: %@", [error userInfo]);
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    busy = NO;
    [self popRequest];
}

-(void)updateAuthorDetail:(NSMutableDictionary*)eventTimeAuthor
{
    NSLog(@"addPeople");
    NSMutableString *requestString = [[NSMutableString alloc] initWithCapacity:0];
    
    
    [requestString setString:@""];
    [requestString appendString:@"Events.svc/EditAuthor"];
    
    //Wrap string type vars in quotes
    NSArray *keys = [[NSArray alloc] initWithObjects:@"AuthorID", nil];
    eventTimeAuthor = [self wrapStringsInQuotesForKeys:keys fromDictionary:eventTimeAuthor];
    
    //Strip out params we dont need
    //keys = [NSArray arrayWithObjects:@"TimeID",@"AuthorID", nil];
    
    requestString = [self appendCamelCaseQueryVars:eventTimeAuthor toString:requestString];
    
    ASIFormDataRequest *request = [self buildRequestToService:[requestString autorelease] withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(updateAuthorDetailFinished:)];
    [request setDidFailSelector:@selector(updateAuthorDetailFailed:)];
    
    [self addRequestToQueue:request];
    
    [self nextRequest];
    
    [keys release];
    
}

- (void)updateAuthorDetailFinished:(ASIFormDataRequest *)request
{
	NSLog(@"updateEventTimeAuthor finished");
	NSLog(@"updateEventTimeAuthor response: %@",[request responseString]);
    
    NSString *updateAuthorDetailResponseXML = [request responseString];
    [xmlParser parseXMLString:updateAuthorDetailResponseXML forService:@"updateAuthorDetail"];
    [self popRequest];
}

- (void)updateAuthorDetailFailed:(ASIFormDataRequest *)request
{
    NSLog(@"updateAuthorDetailFailed:");
	NSError *error = [request error];
	NSLog(@"updateAuthorDetail error: %@", [error userInfo]);
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    busy = NO;
    [self popRequest];
}

-(void)RegistrationCountForAuthorID:(NSString*)authorID 
{
    NSLog(@"RegistrationCountForAuthorID");
    NSMutableString *requestString = [[NSMutableString alloc] initWithCapacity:0];
    NSDictionary *eventTimeAuthor;
    
    [requestString setString:@""];
    [requestString appendString:@"Events.svc/EventTimeAuthors"];
    [requestString appendFormat:@"/$count/?$filter=(AuthorID eq guid'%@') and (Attended eq true) and (TimeID ne guid'9c0ea06e-5ac4-4617-85ec-51a8710f72fa') and (TimeID ne guid'd00f9dc2-6618-49c6-80c2-1f515e60000a')&tmp_authorID=%@",authorID,authorID];
    
    
    ASIFormDataRequest *request = [self buildRequestToService:[requestString autorelease] withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(RegistrationCountForAuthorIDFinished:)];
    [request setDidFailSelector:@selector(RegistrationCountForAuthorIDFailed:)];
    
    [self addRequestToQueue:request];
    [self nextRequest];
    
    
}

- (void)RegistrationCountForAuthorIDFinished:(ASIFormDataRequest *)request
{
	NSLog(@"RegistrationCountForAuthorID finished");
	NSLog(@"RegistrationCountForAuthorID response: %@",[request responseString]);
    
    NSLog(@"RegistrationCountForAuthorID URL: %@",[[request url]absoluteString]);
    
    if(RELEASE == 0){
        NSLog(@"RegistrationCountForAuthorID AuthorID: %@",[[[request url]absoluteString]substringFromIndex:317]);
        [dataAccess saveRegistrationCount:[[request responseString]integerValue] forAuthorID:[[[request url]absoluteString]substringFromIndex:317]];
    }
    if(RELEASE == 1){
        NSLog(@"RegistrationCountForAuthorID AuthorID: %@",[[[request url]absoluteString]substringFromIndex:317]);
        [dataAccess saveRegistrationCount:[[request responseString]integerValue] forAuthorID:[[[request url]absoluteString]substringFromIndex:317]];
    }
    if(RELEASE == 2){
        NSLog(@"RegistrationCountForAuthorID AuthorID: %@",[[[request url]absoluteString]substringFromIndex:318]);
        [dataAccess saveRegistrationCount:[[request responseString]integerValue] forAuthorID:[[[request url]absoluteString]substringFromIndex:318]];
    }
    /*
    NSString *EventTimeAuthorForTimeIDResponseXML = [request responseString];
    [xmlParser parseXMLString:EventTimeAuthorForTimeIDResponseXML forService:@"EventTimeAuthorForTimeID"];*/
    [self popRequest];
}

- (void)RegistrationCountForAuthorIDFailed:(ASIFormDataRequest *)request
{
    NSLog(@"RegistrationCountForAuthorIDFailed:");
	NSError *error = [request error];
	NSLog(@"loginAndGetStudies error: %@", [error userInfo]);
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    [self popRequest];
}
/*
-(void)EventTimeAuthorForTimeID:(NSString*)timeID 
{
    NSLog(@"EventTimeAuthorForTimeID");
        NSMutableString *requestString = [[NSMutableString alloc] initWithCapacity:0];
    NSDictionary *eventTimeAuthor;
    
    [requestString setString:@""];
    [requestString appendString:@"Events.svc/EventTimeAuthors"];
        [requestString appendFormat:@"?$filter=TimeID eq guid'%@'",timeID ];
       
        
    ASIFormDataRequest *request = [self buildRequestToService:[requestString autorelease] withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(EventTimeAuthorForTimeIDFinished:)];
    [request setDidFailSelector:@selector(EventTimeAuthorForTimeIDFailed:)];
    
    [self addRequestToQueue:request];
    [self nextRequest];
    
    
}

- (void)EventTimeAuthorForTimeIDFinished:(ASIFormDataRequest *)request
{
	NSLog(@"EventTimeAuthorForTimeID finished");
	NSLog(@"EventTimeAuthorForTimeID response: %@",[request responseString]);
    
    NSString *EventTimeAuthorForTimeIDResponseXML = [request responseString];
    [xmlParser parseXMLString:EventTimeAuthorForTimeIDResponseXML forService:@"EventTimeAuthorForTimeID"];
    [self popRequest];
}

- (void)EventTimeAuthorForTimeIDFailed:(ASIFormDataRequest *)request
{
    NSLog(@"EventTimeAuthorForTimeIDFailed:");
	NSError *error = [request error];
	NSLog(@"loginAndGetStudies error: %@", [error userInfo]);
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
}
*/
-(void)EventTimeAuthorForTimeID:(NSString*)timeID 
{
    NSLog(@"EventTimeAuthorForTimeID");
    NSMutableString *requestString = [[NSMutableString alloc] initWithCapacity:0];
    NSDictionary *eventTimeAuthor;
    
    [requestString setString:@""];
    [requestString appendString:@"API/GetAuthorsForEventTime"];
    [requestString appendFormat:@"?studyID=%@",dataAccess.brandID ];
    [requestString appendFormat:@"&timeID=%@",timeID ];
    
    ASIFormDataRequest *request = [self buildRequestToService:[requestString autorelease] withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(EventTimeAuthorForTimeIDFinished:)];
    [request setDidFailSelector:@selector(EventTimeAuthorForTimeIDFailed:)];
    
    [self addRequestToQueue:request];
    [self nextRequest];
    
    
}

- (void)EventTimeAuthorForTimeIDFinished:(ASIFormDataRequest *)request
{
	NSLog(@"EventTimeAuthorForTimeID finished");
    NSString *EventTimeAuthorForTimeIDResponse = [request responseString];
	NSLog(@"EventTimeAuthorForTimeID response: %@",EventTimeAuthorForTimeIDResponse);
    
    [dataAccess addAuthors:[EventTimeAuthorForTimeIDResponse JSONValue]];
    //[xmlParser parseXMLString:EventTimeAuthorForTimeIDResponseXML forService:@"EventTimeAuthorForTimeID"];
    [self popRequest];
}

- (void)EventTimeAuthorForTimeIDFailed:(ASIFormDataRequest *)request
{
    NSLog(@"EventTimeAuthorForTimeIDFailed:");
	NSError *error = [request error];
	NSLog(@"loginAndGetStudies error: %@", [error userInfo]);
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    busy = NO;
    [self popRequest];
}

-(void)loginAndGetStudiesWithUser:(NSString*)user Password:(NSString*)password 
{
    NSLog(@"addPeople");
        NSMutableString *requestString = [[NSMutableString alloc] initWithCapacity:0];
    NSDictionary *person;
    
    [requestString setString:@""];
    [requestString appendString:@"Events.svc/LoginAndGetStudies"];
    [requestString appendFormat:@"?username='%@'",user];
    [requestString appendFormat:@"&password='%@'",password];
        
    ASIFormDataRequest *request = [self buildRequestToService:[requestString autorelease] withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(loginAndGetStudiesFinished:)];
    [request setDidFailSelector:@selector(loginAndGetStudiesFailed:)];
    [self addRequestToQueue:request];

    //if([requestQueue count]>0 && !busy)
    //{
    [self nextRequest];
    //}
}

-(void)addPeople 
{
    NSLog(@"addPeople");
    NSMutableArray *people = [dataAccess allPeople];
    
    NSLog(@"people in Auth: %@",people);
    
    //http://ssv2dev.etghosting.net/API/Events.svc/AddNewAuthor?authorStudyID=137&authorEmail=%27g%40g.com%27&authorFirstName=%27g%27&authorLastName=%27g%27&authorStreet1=%27123+somewhere%27&authorStreet2=&authorCity=%27Nowhere%27&authorState=%27NY%27&authorZip=%2714526%27&authorDOB=

    NSMutableString *requestString = [[NSMutableString alloc] initWithCapacity:0];
    NSDictionary *person;
    for(person in people)
    {
        [requestString setString:@""];
        [requestString appendString:@"Events.svc/AddNewAuthor"];//?authorStudyID=2"];
        if([person valueForKey:@"BrandID"]!=nil)[requestString appendFormat:@"?authorStudyID=%@",[person valueForKey:@"BrandID"]];
        if([person valueForKey:@"Email"]!=nil)[requestString appendFormat:@"&authorEmail='%@'",[person valueForKey:@"Email"]];
        if([person valueForKey:@"First"]!=nil)[requestString appendFormat:@"&authorFirstName='%@'",[person valueForKey:@"First"]];
        if([person valueForKey:@"Last"]!=nil)[requestString appendFormat:@"&authorLastName='%@'",[person valueForKey:@"Last"]];
        if([person valueForKey:@"Address1"]!=nil)[requestString appendFormat:@"&authorStreet1='%@'",[person valueForKey:@"Address1"]];
        if([person valueForKey:@"Address2"]!=nil)[requestString appendFormat:@"&authorStreet2='%@'",[person valueForKey:@"Address2"]];
        if([person valueForKey:@"City"]!=nil)[requestString appendFormat:@"&authorCity='%@'",[person valueForKey:@"City"]];
        if([person valueForKey:@"StateProvince"]!=nil)[requestString appendFormat:@"&authorState='%@'",[person valueForKey:@"StateProvince"]];
        if([person valueForKey:@"PostalCode"]!=nil)[requestString appendFormat:@"&authorZip='%@'",[person valueForKey:@"PostalCode"]];
        if([person valueForKey:@"DOB"]!=nil)[requestString appendFormat:@"&authorDOB='%@'",[person valueForKey:@"DOB"]];
        if([person valueForKey:@"Phone"]!=nil)[requestString appendFormat:@"&authorPhone='%@'",[person valueForKey:@"Phone"]];
        if([person valueForKey:@"RemoteSystemID"]!=nil)[requestString appendFormat:@"&remoteSystemID='%@'",[person valueForKey:@"RemoteSystemID"]];
        if([person valueForKey:@"Opt_In"]!=nil) [requestString appendFormat:@"&optIn=%@",[person valueForKey:@"Opt_In"]];
        if([person valueForKey:@"TimeID"]!=nil){
            NSString *eventName = [dataAccess sessionNameForID:[person valueForKey:@"TimeID"]];
            if(eventName != nil){
                [requestString appendFormat:@"&eventName='%@'",eventName];
            }
        }
        
        
        ASIFormDataRequest *request = [self buildRequestToService:[requestString autorelease] withData:nil];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(addPersonRequestFinished:)];
        [request setDidFailSelector:@selector(addPersonRequestFailed:)];
        [self addRequestToQueue:request];
    }
    //if([requestQueue count]>0 && !busy)
    //{
        [self nextRequest];
    //}
    [requestString release];
}

-(void)addRegistrationForPerson:(NSString*)objURI
{
    NSString *trimmed = [objURI stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDictionary *person = [dataAccess personForURI:trimmed];//[dataAccess objectWithURI:[NSURL URLWithString:objURI]];
    
    if(person != nil){
        NSLog(@"person in addRegistration: %@",person);
        NSMutableString *requestString = [[NSMutableString alloc] initWithCapacity:0];
        NSMutableDictionary *personVars = [[NSMutableDictionary alloc] initWithCapacity:0];
       
        if([person valueForKey:@"Ordered"]!=nil){
            if([[person valueForKey:@"Sent"] isEqualToString:@"false"]){
                if([[person valueForKey:@"Ordered"] isEqualToString:@"true"]){
                    [self authorPurchaseCompletedForAuthor:[person valueForKey:@"PersonUID"] withTime:[person valueForKey:@"TimeID"]];
                }else{
                    [self authorPurchaseCancelledForAuthor:[person valueForKey:@"PersonUID"] withTime:[person valueForKey:@"TimeID"]];
                }
                [dataAccess setSentForPerson:person];
            }else{
                //NSLog(@"already sent it");
            }
        }
        
        [requestString setString:@""];
        [requestString appendString:@"Events.svc/EventTimeAuthors"];
        if([person valueForKey:@"PersonUID"]!=nil)[personVars setValue:[person valueForKey:@"PersonUID"] forKey:@"AuthorID"];
        if([person valueForKey:@"TimeID"]!=nil)[personVars setValue:[person valueForKey:@"TimeID"] forKey:@"TimeID"];
        
        NSLog(@"personVars: %@",personVars);
    
        ASIFormDataRequest *request = [self buildRequestToService:[requestString autorelease] withJSONData:personVars];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(addRegistrationRequestFinished:)];
        [request setDidFailSelector:@selector(addRegistrationRequestFailed:)];
        [request addRequestHeader:@"Content-Type" value:@"application/json; charset=utf-8"];
        [self addRequestToQueue:request];
    
        [self nextRequest];
    }else{
        NSLog(@"person was nil");
    }
}

/*
-(void)getEventTimes 
{
    NSLog(@"addPeople");
    
    NSString *service = [NSString stringWithFormat:@"%@%@", @"GetEventTimes?studyID=", dataAccess.brandID];
    
    ASIFormDataRequest *request = [self buildRequestToService:service withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getEventTimesRequestFinished:)];
    [request setDidFailSelector:@selector(getEventTimesRequestFailed:)];
    [self addRequestToQueue:request];
    
    if([requestQueue count]==1)
    {
        [self nextRequest];
    }
    
}*/

-(void)getEventTimes 
{
    NSLog(@"getEventTimes");
    
    NSString *service = [NSString stringWithFormat:@"%@%@", @"API/GetEventsForStudyID?studyID=", dataAccess.brandID];
    
    ASIFormDataRequest *request = [self buildRequestToService:service withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getEventTimesRequestFinished:)];
    [request setDidFailSelector:@selector(getEventTimesRequestFailed:)];
    [self addRequestToQueue:request];
    
    /*if([requestQueue count]==1)
    {*/
        [self nextRequest];
    //}
    
}

-(void)getEvent:(NSString*)eventID 
{
    NSLog(@"addPeople");
    
    ASIFormDataRequest *request = [self buildRequestToService:[NSString stringWithFormat:@"Events?eventID=%@",eventID] withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getEventRequestFinished:)];
    [request setDidFailSelector:@selector(getEventRequestFailed:)];
    [self addRequestToQueue:request];
    
    if([requestQueue count]==1)
    {
        [self nextRequest];
    }
    
}

-(void)getTime:(NSString*)timeID 
{
    NSLog(@"addPeople");
    
    ASIFormDataRequest *request = [self buildRequestToService:[NSString stringWithFormat:@"EventTimes?timeID=%@",timeID] withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getTimeRequestFinished:)];
    [request setDidFailSelector:@selector(getTimeRequestFailed:)];
    [self addRequestToQueue:request];
    
    if([requestQueue count]==1)
    {
        [self nextRequest];
    }
    
}

-(void)authorPurchaseCompletedForAuthor:(NSString*)authorID withTime:(NSString*)timeID 
{
    NSLog(@"authorPurchaseCompleted");
    
    ASIFormDataRequest *request = [self buildRequestToService:[NSString stringWithFormat:@"AuthorPurchaseCompleted?authorID='%@'&timeID='%@'",authorID,timeID] withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(authorPurchaseCompletedRequestFinished:)];
    [request setDidFailSelector:@selector(authorPurchaseCompletedRequestFailed:)];
    [self addRequestToQueue:request];
    
    if([requestQueue count]==1)
    {
        [self nextRequest];
    }
    
}

-(void)authorPurchaseCancelledForAuthor:(NSString*)authorID withTime:(NSString*)timeID 
{
    NSLog(@"authorPurchaseCompleted");
    
    ASIFormDataRequest *request = [self buildRequestToService:[NSString stringWithFormat:@"AuthorPurchaseCancelled?authorID='%@'&timeID='%@'",authorID,timeID] withData:nil];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(authorPurchaseCancelledRequestFinished:)];
    [request setDidFailSelector:@selector(authorPurchaseCancelledRequestFailed:)];
    [self addRequestToQueue:request];
    
    if([requestQueue count]==1)
    {
        [self nextRequest];
    }
    
}


#pragma mark -
#pragma request handlers

- (void)addPersonRequestFinished:(ASIFormDataRequest *)request
{
	NSLog(@"addPersonRequest finished");
	//EventCheckInAppDelegate *appDelegate = (EventCheckInAppDelegate*)[[UIApplication sharedApplication] delegate];
	//NSDictionary *addPersonJSON = [[request responseString] JSONValue];
	NSLog(@"addPersonRequest response: %@",[request responseString]);
	//NSLog(@"addPersonRequest responseJSON: %@",addPersonJSON);
    NSString *addPersonResponseXML = [request responseString];
    [xmlParser parseXMLString:addPersonResponseXML];
    
    //[dataAccess deleteObjectForURIString:[addPersonJSON valueForKey:@"RemoteSystemID"]];
    //[dataAccess saveNewSyncTS];
    
    [self popRequest];
}

- (void)addPersonRequestFailed:(ASIFormDataRequest *)request
{
    NSLog(@"addPersonRequestFailed:");
	NSError *error = [request error];
	NSLog(@"addPersonRequest error: %@", [error userInfo]);
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    [self popRequest];
}

- (void)addRegistrationRequestFinished:(ASIFormDataRequest *)request
{
	NSLog(@"addRegistrationRequest finished");
	//EventCheckInAppDelegate *appDelegate = (EventCheckInAppDelegate*)[[UIApplication sharedApplication] delegate];
	//NSDictionary *addPersonJSON = [[request responseString] JSONValue];
	NSLog(@"addRegistrationRequest response: %@",[request responseString]);
	//NSLog(@"addPersonRequest responseJSON: %@",addPersonJSON);
    NSString *addRegistrationResponseXML = [request responseString];
    [xmlParser parseXMLString:addRegistrationResponseXML];
    
    //[dataAccess deleteObjectForURIString:[addPersonJSON valueForKey:@"RemoteSystemID"]];
    //[dataAccess saveNewSyncTS];
    
    [self popRequest];
}

- (void)addRegistrationRequestFailed:(ASIFormDataRequest *)request
{
    NSLog(@"addRegistrationRequestFailed:");
	NSError *error = [request error];
	NSLog(@"addRegistrationRequest error: %@", [error userInfo]);
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    busy = NO;
    [self popRequest];
}

- (void)getEventTimesRequestFinished:(ASIFormDataRequest *)request
{
	NSLog(@"getEventTimesRequest finished");
	//EventCheckInAppDelegate *appDelegate = (EventCheckInAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *eventTimes = [request responseString];
	NSLog(@"getEventTimesRequest response: %@",eventTimes);
    
    [dataAccess addSessions:[eventTimes JSONValue]];
    /*
    [xmlParser parseXMLString:eventTimesXML forService:@"GetStudyEventTimes"];
    */
    //[dataAccess deleteObjectForURIString:[addPersonJSON valueForKey:@"RemoteSystemID"]];
    //[dataAccess saveNewSyncTS];
    
    [self popRequest];
}

- (void)getEventTimesRequestFailed:(ASIFormDataRequest *)request
{
    NSLog(@"getEventTimesRequestFailed:");
	NSError *error = [request error];
	NSLog(@"getEventTimes error: %@", [error userInfo]);
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    busy = NO;
    [self popRequest];
}

- (void)getEventRequestFinished:(ASIFormDataRequest *)request
{
	NSLog(@"getEventRequest finished");
	//EventCheckInAppDelegate *appDelegate = (EventCheckInAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *eventXML = [request responseString];
	NSLog(@"getEventRequest response: %@",[request responseString]);
    
    [xmlParser parseXMLString:eventXML];
    
    //[dataAccess deleteObjectForURIString:[addPersonJSON valueForKey:@"RemoteSystemID"]];
    //[dataAccess saveNewSyncTS];
    
    [self popRequest];
}

- (void)getEventRequestFailed:(ASIFormDataRequest *)request
{
     NSLog(@"getEventRequestFailed:");
	NSError *error = [request error];
	NSLog(@"getEvent error: %@", [error userInfo]);
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    busy = NO;
    [self popRequest];
}

- (void)getTimeRequestFinished:(ASIFormDataRequest *)request
{
	NSLog(@"getTimeRequest finished");
	//EventCheckInAppDelegate *appDelegate = (EventCheckInAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *timeXML = [request responseString];
	NSLog(@"getTimeRequest response: %@",[request responseString]);
    
    [xmlParser parseXMLString:timeXML];
    
    //[dataAccess deleteObjectForURIString:[addPersonJSON valueForKey:@"RemoteSystemID"]];
    //[dataAccess saveNewSyncTS];
    
    [self popRequest];
}

- (void)getTimeRequestFailed:(ASIFormDataRequest *)request
{
    NSLog(@"getTimeRequestFailed:");
	NSError *error = [request error];
	NSLog(@"getTime error: %@", [error userInfo]);
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    [self popRequest];
    busy = NO;
}

- (void)authorPurchaseCompletedRequestFinished:(ASIFormDataRequest*)request
{
    
	NSLog(@"authorPurchaseCompletedRequest finished");
	//EventCheckInAppDelegate *appDelegate = (EventCheckInAppDelegate*)[[UIApplication sharedApplication] delegate];
	//NSString *timeXML = [request responseString];
	NSLog(@"authorPurchaseCompletedRequest response: %@",[request responseString]);
    
    //[xmlParser parseXMLString:timeXML];
    
    //[dataAccess deleteObjectForURIString:[addPersonJSON valueForKey:@"RemoteSystemID"]];
    //[dataAccess saveNewSyncTS];
    
    [self popRequest];
}

- (void)authorPurchaseCompletedRequestFailed:(ASIFormDataRequest*)request
{
	NSLog(@"authorPurchaseCompletedRequestFailed:");
	NSError *error = [request error];
	NSLog(@"authorPurchaseCompletedRequest error: %@", [error userInfo]);
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    [self popRequest];
}

- (void)authorPurchaseCancelledRequestFinished:(ASIFormDataRequest*)request
{
    
	NSLog(@"authorPurchaseCancelledRequest finished");
	//EventCheckInAppDelegate *appDelegate = (EventCheckInAppDelegate*)[[UIApplication sharedApplication] delegate];
	//NSString *timeXML = [request responseString];
	NSLog(@"authorPurchaseCancelledRequest response: %@",[request responseString]);
    
    //[xmlParser parseXMLString:timeXML];
    
    //[dataAccess deleteObjectForURIString:[addPersonJSON valueForKey:@"RemoteSystemID"]];
    //[dataAccess saveNewSyncTS];
    
    [self popRequest];
}

- (void)authorPurchaseCancelledRequestFailed:(ASIFormDataRequest*)request
{
	NSLog(@"authorPurchaseCancelledRequestFailed:");
	NSError *error = [request error];
	NSLog(@"authorPurchaseCancelled error: %@", [error userInfo]);
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    [[appDelegate rootVC]unlockScreen];
    [[appDelegate rootVC]showErrorMessage:@"Sync Failed"];
    [self popRequest];
}

#pragma mark - 

#pragma mark queue methods

-(void)addRequestToQueue:(ASIFormDataRequest*)request
{
    [requestQueue addObject:request];
}

-(void)nextRequest
{
    if([requestQueue count]>0 && !busy)
    {
        NSLog(@"next request: %@",[requestQueue objectAtIndex:0]);
        busy = YES;
        [[requestQueue objectAtIndex:0]startAsynchronous];
    }else{
        if([requestQueue count]==0){
            NSLog(@"sync done");
            busy = NO;
            //[[appDelegate rootVC]unlockScreen];
            //NSTimer *aTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkQueue) userInfo:nil repeats:NO];
            if(!loggingIn){
                ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
                [[appDelegate rootVC] performSelectorOnMainThread:@selector(syncSucceeded) withObject:nil waitUntilDone:YES];
            }else{
                loggingIn = NO;
            }
        }
    }
}

-(void)checkQueue
{
    if([requestQueue count]>0)
    {
        [self nextRequest];
    }
    else
    {
        NSLog(@"sync done");
        if(!loggingIn){
            ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
            [[appDelegate rootVC]syncSucceeded];
        }else{
            loggingIn = NO;
        }
        //[[appDelegate rootVC]unlockScreen];
        
    }
    
}

-(void)popRequest
{
    busy = NO;
    [requestQueue removeObjectAtIndex:0];
    [self nextRequest];
}

#pragma -

#pragma mark others

-(NSString *) md5:(NSString *)str {
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

#pragma -

@end


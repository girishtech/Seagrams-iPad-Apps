//
//  XMLManager.m
//  FM-WebServiceTester
//
//  Created by Garrett Shearer on 7/9/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import "XMLManager.h"

//Table Parsers
#import "AuthorInteractionParse.h"
#import "AuthorParse.h"
#import "AuthorDetailParse.h"
#import "EventTimeAuthorParse.h"
//View Parsers
#import "vwEventAttendeeParse.h"
#import "vwEventTimeAddressParse.h"
#import "vwEventTimeOverviewParse.h"
//#import "vwStudiesWithStatParse.h"
#import "vwStudyEventTimeParse.h"
#import "StudyEventTimeParse.h"
#import "LoginViewController.h"
#import "StudyParse.h"

#import "ForceMultiplierConciergeAppDelegate.h"

@implementation XMLManager

@synthesize busy,requestQueue,parserDelegate,xml,delegate;

-(id)init{
    // Init our superclass (NSObject)
    [super init];
	
    // Set our job queue to not busy, 
    //  and instantiate a collection to hold the queue
    busy = NO;
    requestQueue = [[NSMutableArray alloc] initWithCapacity:0];
    parserDelegate = nil;
    xml = nil;

    return self;
}

-(void)dealloc
{
    /*if(xml){
        [xml release];
    }*/
    if(parserDelegate) [parserDelegate release];
    [requestQueue release];
    [super dealloc];
}

#pragma mark - Parsing Methods

- (void)parseXMLString:(NSString*)xmlString forService:(NSString*)service{
    //NSLog(@"\n- XMLManager - \n-(void)parseXMLString:forService");
    
    // Add the request to the job queue
    [self addRequestToQueue:xmlString forService:service];
    
    // If there is only one job queued, start the next request
    if([requestQueue count]==1)
    {
        //NSLog(@"\n- XMLParser - \n-(void)parseXMLString: \ncall to - nextRequest");
        [self nextRequest];
    }
}

- (void)beginParse:(NSDictionary*)xmlJob {
    NSLog(@"XMLManager - beginParse:");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
    da = [appDelegate da];
    
    // Get the service string and xml as NSData
    NSString *service = [xmlJob objectForKey:@"service"];
    NSData *xmlData = [[xmlJob objectForKey:@"xml"] dataUsingEncoding:NSUTF8StringEncoding];
    
    // Instantiate parser
    //if(xml) [xml release];
    xml = [[NSXMLParser alloc] initWithData:xmlData];
    
    // If a parse already occured, 
    //  release the old delegate
    if(parserDelegate){
        [parserDelegate release];
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////
    // #CODEGENERATE#
    
    //Parser Choices
    //Table Parsers
    //AuthorInteractionParse
    //AuthorParse
    //EventTimeAuthorParse
    //View Parsers
    //vwEventAttendeeParse
    //vwEventTimeAddressParse
    //vwEventTimeOverviewParse
    //vwStudiesWithStatParse
    //vwStudyEventTimeParse
    
    //Determine which service we are parsing
    if([service isEqualToString:@"AddNewAuthor"])
    {
        parserDelegate = [[AuthorParse alloc] initWithDelegate:self];
    }
    else if([service isEqualToString:@"Authors"])
    {
        parserDelegate = [[AuthorParse alloc] initWithDelegate:self];
    }
    else if([service isEqualToString:@"GetStudyEventTimes"])
    {
        //Custom Implementation
        parserDelegate = [[StudyEventTimeParse alloc] initWithDelegate:self forService:@"GetStudyEventTimes"];
    }
    else if([service isEqualToString:@"AuthorForAuthorID"])
    {
        parserDelegate = [[AuthorParse alloc] initWithDelegate:self forService:@"AuthorForAuthorID"];
    }
    else if([service isEqualToString:@"updateAuthorDetail"])
    {
        parserDelegate = [[AuthorParse alloc] initWithDelegate:self forService:@"updateAuthorDetail"];
    }
    else if([service isEqualToString:@"AuthorDetailForAuthorID"])
    {
        parserDelegate = [[AuthorDetailParse alloc] initWithDelegate:self forService:@"AuthorDetailForAuthorID"];
    }
    else if([service isEqualToString:@"EventTimeAuthorForTimeID"])
    {
        parserDelegate = [[EventTimeAuthorParse alloc] initWithDelegate:self forService:@"EventTimeAuthorForTimeID"];
    }
    else if([service isEqualToString:@"updateEventTimeAuthor"])
    {
        parserDelegate = [[EventTimeAuthorParse alloc] initWithDelegate:self forService:@"updateEventTimeAuthor"];
    }
    else if([service isEqualToString:@"LoginAndGetStudies"])
    {
        parserDelegate = [[StudyParse alloc] initWithDelegate:self forService:@"LoginAndGetStudies"];
    }
    /*else if([service isEqualToString:@"GetStudyEventTimes"])
    {
        parserDelegate = [[StudyEventTimesParse alloc] initWithDelegate:self];
    }*/
    else
    {
        NSLog(@"\n\nFAILED TO FIND DEFINITION FOR XML SERVICE: %@\n\n",service); 
    }
	
    
    // #CODEGENERATE#
    ////////////////////////////////////////////////////////////////////////////////
    
    
	[xml setDelegate:parserDelegate];
	[xml setShouldResolveExternalEntities:NO];
	[xml setShouldProcessNamespaces:NO];
	[xml setShouldReportNamespacePrefixes:NO];
	if (![xml parse]){
        NSLog(@"Parse Failed");
		//NSLog(@"errorr in parse, error=%@",[xml parseError] );
		if(xml) [xml release];
	}
    [pool release];
}

#pragma mark - End Parsing Methods

#pragma mark - RequestParserDelegate Methods

-(void)parseDidFail
{
    //[xml abortParsing];
    [self popRequest];
}

-(void)parseDidReturnResults:(NSMutableArray*)collection forService:(NSString*)service
{
    NSLog(@"-(void)parseDidReturnResults:(NSMutableArray*)collection forService:(NSString*)service");
    NSLog(@"collection: %@",collection);
    
    NSMutableArray *tmpCollection = collection;//[collection retain];
    ////////////////////////////////////////////////////////////////////////////////
    // #CODEGENERATE#
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if(collection != nil)
    {
        //Determine which service we are parsing
        if([service isEqualToString:@"AddNewAuthor"])
        {
            //Custom Implementation
            NSLog(@"%@ Results: \n%@",service, tmpCollection);
        }
        else if([service isEqualToString:@"GetStudyEventTimes"])
        {
            //Custom Implementation
            NSLog(@"%@ Results: \n%@",service, tmpCollection);
            [da addSessions:tmpCollection];
        }
        else if([service isEqualToString:@"Authors"])
        {
            //Custom Implementation
            NSLog(@"%@ Results: \n%@",service, tmpCollection);
                    
        }
        else if([service isEqualToString:@"AuthorForAuthorID"])
        {
            //Custom Implementation
            //NSLog(@"%@ Results: \n%@",service, tmpCollection);
            NSLog(@"%@ Results",service);
            [da addAuthors:tmpCollection];    
        }
        else if([service isEqualToString:@"AuthorDetailForAuthorID"])
        {
            //Custom Implementation
            //NSLog(@"%@ Results: \n%@",service, tmpCollection);
            //NSLog(@"%@ Results",service);
            [da addAuthorDetails:tmpCollection];    
        }
        else if([service isEqualToString:@"EventTimeAuthorForTimeID"])
        {
            //Custom Implementation
            //NSLog(@"%@ Results: \n%@",service, tmpCollection);
            NSLog(@"%@ Results",service);
            [da addEventTimeAuthors:tmpCollection];
        }
        else if([service isEqualToString:@"updateEventTimeAuthor"])
        {
            //Custom Implementation
            //NSLog(@"%@ Results: \n%@",service, tmpCollection);
            NSLog(@"%@ Results",service);
            [da addEventTimeAuthors:tmpCollection];
        }
        else if([service isEqualToString:@"updateAuthorDetail"])
        {
            //Custom Implementation
            //NSLog(@"%@ Results: \n%@",service, tmpCollection);
            NSLog(@"%@ Results",service);
            [da addAuthors:tmpCollection];
        }
        else if([service isEqualToString:@"LoginAndGetStudies"])
        {
            //Custom Implementation
            NSLog(@"%@ Results: \n%@",service, tmpCollection);
            //NSLog(@"%@ Results",service);
            //[da addEventTimeAuthors:[tmpCollection retain]];
            
            ForceMultiplierConciergeAppDelegate *appDelegate = (ForceMultiplierConciergeAppDelegate*)[[UIApplication sharedApplication] delegate];
            LoginViewController *loginVC = [[appDelegate rootVC] loginVC];
            
            
            if([tmpCollection count]>0)
            {
                [loginVC loginSuccessful];  
            }else{
                //[loginVC loginSuccessful]; 
                [loginVC loginUnsuccessful];
            }
        }
        else
        {
            NSLog(@"\n\nFAILED TO FIND DEFINITION FOR XML SERVICE: %@\n\n",service); 
        }
        
        // #CODEGENERATE#
        ////////////////////////////////////////////////////////////////////////////////
        
        [self popRequest];
    }
    [pool release];
    
}

#pragma mark - END RequestParserDelegate Methods

#pragma mark - Job Queue methods

-(void)addRequestToQueue:(NSString*)xmlString forService:(NSString*)service
{
    // Build a data structure (dictionary) for the xml and request
    NSArray *objs = [[NSArray alloc] initWithObjects:xmlString,service, nil];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"xml",@"service", nil];
    NSDictionary *job = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    
    // Add the job to the queue
    [requestQueue addObject:job];
    
    [objs release];
    [keys release];
    [job release];
}

-(void)nextRequest
{
    //NSLog(@"\n- XMLManager - \n-(void)nextRequest");
    
    if([requestQueue count]>0 && !busy)
    {
        //NSLog(@"\n- XMLParser - \n-(void)parseXMLString: \ncall to - beginParse");
        
        busy = YES;
        [self beginParse:[requestQueue objectAtIndex:0]];
    }
    else
    {
        if([requestQueue count]==0)
        {
            NSLog(@"completed queue");
        }
    }
}

-(void)popRequest
{
    busy = NO;
    if([requestQueue count]>0)[requestQueue removeObjectAtIndex:0];
    [self nextRequest];
}

#pragma - End Job Queue Methods

@end

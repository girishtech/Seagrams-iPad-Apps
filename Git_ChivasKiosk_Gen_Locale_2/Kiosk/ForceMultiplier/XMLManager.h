//
//  XMLManager.h
//  FM-WebServiceTester
//
//  Created by Garrett Shearer on 7/9/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestParserDelegate.h"
#import "DataAccess.h"

//Table Parsers
@class AuthorInteractionParse;
@class AuthorParse;
@class AuthorDetailParse;
@class EventTimeAuthorParse;
@class StudyParse;
//View Parsers
@class vwEventAttendeeParse;
@class vwEventTimeAddressParse;
@class vwEventTimeOverviewParse;
@class vwStudiesWithStatParse;
@class vwStudyEventTimeParse;

@interface XMLManager : NSObject <RequestParserDelegate>{
	// The XML Parser
	NSXMLParser *xml;
    
    // Job Queuing Vars
    NSMutableArray *requestQueue;
    BOOL busy;
    
    // The XMLManager's Delegate
    id delegate; 
    
    // Reference to the current delegate class 
    //  of the NSXMLParser
    id parserDelegate;
    
    DataAccess *da;
}


//Synthesize Accessors/Mutators
@property (nonatomic,retain) NSXMLParser *xml;
@property (nonatomic,retain) NSMutableArray *requestQueue;
@property (nonatomic) BOOL busy;
@property (nonatomic,retain) id delegate; 
@property (nonatomic,retain) id parserDelegate;
@property (nonatomic,retain) DataAccess *da;

//Parsing Methods
-(id)init;
-(void)parseXMLString:(NSString*)xmlString forService:(NSString*)service;
-(void)beginParse:(NSDictionary*)xmlJob;

//Job Queue Methods
-(void)addRequestToQueue:(NSString*)xmlString forService:(NSString*)service;
-(void)nextRequest;
-(void)popRequest;

@end
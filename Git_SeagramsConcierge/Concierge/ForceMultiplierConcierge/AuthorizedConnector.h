
//
//  AuthorizedConnector.h
//  EventCheckIn
//
//  Created by Garrett Shearer on 9/14/10.
//  Copyright 2010 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import <CommonCrypto/CommonDigest.h>
#import "KeychainItemWrapper.h"
#import "ASIFormDataRequest.h"
#import "DataAccess.h"
@class XMLManager;
@class ForceMultiplierConciergeAppDelegate;
@class LoginViewController;

@interface AuthorizedConnector : NSObject {
	NSString *responseString;
	NSString *token;
	KeychainItemWrapper *keychainItemWrapper;
	
	NSString *username;
	NSString *password;
	NSString *currentScript;
	//NSMutableDictionary *loadInitJSON_Data;
	
	NSString *lastLoadPeopleUpdate;
	NSString *newLoadPeopleUpdate;

	NSInteger *loadInitCount;
	NSString *lastLoadInitUpdate;
	NSString *newLoadInitUpdate;
	
	NSString *WS_URL;
	
	NSOperationQueue *queue;
	BOOL isLookingUpAttendee;
	BOOL isAddingPeople;
	BOOL isUpdatingPeople;
	BOOL isLoadingInit;
	BOOL isLoadingPeople;
	BOOL isGettingPeople;
	BOOL isAddingGuest;
	BOOL isUpdatingCheckIn;
	BOOL isLoadingMarketOnline;
	BOOL isLoadingMarketEventOnline;
	BOOL isLoadingPeopleForDate;
    
    BOOL busy;
    BOOL loggingIn;
    DataAccess *dataAccess;
    XMLManager *xmlParser;
    NSMutableArray *requestQueue;
    
    LoginViewController *loginVC;
}

@property (nonatomic, retain) NSString *responseString;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *currentScript;
@property (nonatomic, retain) KeychainItemWrapper *keychainItemWrapper;
@property (nonatomic, retain) NSOperationQueue *queue;

@property (nonatomic) NSInteger *loadInitCount;
@property (nonatomic) BOOL loggingIn;
//@property (nonatomic, retain) NSMutableDictionary *loadInitJSON_Data;
@property (nonatomic, retain) NSString *lastLoadPeopleUpdate;
@property (nonatomic, retain) NSString *newLoadPeopleUpdate;
@property (nonatomic, retain) NSString *lastLoadInitUpdate;
@property (nonatomic, retain) NSString *newLoadInitUpdate;
@property (nonatomic, retain) NSString *WS_URL;
@property (nonatomic, retain) DataAccess *dataAccess;
@property (nonatomic, retain) XMLManager *xmlParser;
@property (nonatomic, retain) NSMutableArray *requestQueue;
@property (nonatomic, retain) LoginViewController *loginVC;

@property (nonatomic, assign) BOOL busy,isUpdatingCheckIn,isLoadingMarketOnline,isLoadingMarketEventOnline,isLoadingPeopleForDate, isAddingPeople, isUpdatingPeople; 
-(void)AuthorDetailForAuthorID:(NSString*)authorID;
-(void)AuthorDetailForAuthorIDFinished:(ASIFormDataRequest *)request;
-(void)AuthorDetailForAuthorIDFailed:(ASIFormDataRequest *)request;
    
-(void)AuthorInteractionForAuthorInteractionID:(NSString*)authorInteractionID;
-(void)AuthorInteractionForAuthorInteractionIDFinished:(ASIFormDataRequest *)request;
-(void)AuthorInteractionForAuthorInteractionIDFailed:(ASIFormDataRequest *)request;
    
-(void)AuthorForAuthorID:(NSString*)authorID;
-(void)AuthorForAuthorIDFinished:(ASIFormDataRequest *)request;
-(void)AuthorForAuthorIDFailed:(ASIFormDataRequest *)request;
    
-(void)EventTimeAuthorForTimeID:(NSString*)timeID;
-(void)EventTimeAuthorForTimeIDFinished:(ASIFormDataRequest *)request;
-(void)EventTimeAuthorForTimeIDFailed:(ASIFormDataRequest *)request;
  
-(void)addPeople;
-(void)getEventTimes;

/*
-(id)initWithUser:(NSString*)user withPassword:(NSString*)pass;
-(void)AuthorizeUser:(NSString*)user withPassword:(NSString*)pass;
-(void)loadInitFrom:(NSInteger)startIndex withRange:(NSInteger)aRange;
-(void)getAllPeople;
-(void)loadPeopleFrom:(NSInteger)start withRange:(NSInteger)range;
-(void)lookupAttendeesForDateTime:(NSString*)date_time_id;
-(void)updatePeople;*/
-(void)addPeople;
/*-(void)addNewGuest;
-(void)updateCheckIn;
-(void)addAuthParamsToRequest:(ASIFormDataRequest*)aRequest;
-(NSString *) md5:(NSString *)str;
- (void)loginRequestFinished:(ASIFormDataRequest *)request;
- (void)loginRequestFailed:(ASIFormDataRequest *)request;
- (void)loadInitRequestFinished:(ASIFormDataRequest *)request;
- (void)loadInitRequestFailed:(ASIFormDataRequest *)request;
- (void)getPeopleRequestFinished:(ASIFormDataRequest *)request;
- (void)getPeopleRequestFailed:(ASIFormDataRequest *)request;
- (void)lookupAttendeesRequestFinished:(ASIFormDataRequest *)request;
- (void)lookupAttendeesRequestFailed:(ASIFormDataRequest *)request;
- (void)updatePersonRequestFinished:(ASIFormDataRequest *)request;
- (void)updatePersonRequestFailed:(ASIFormDataRequest *)request;
- (void)addPersonRequestFinished:(ASIFormDataRequest *)request;
- (void)addPersonRequestFailed:(ASIFormDataRequest *)request;
- (void)addNewGuestRequestFinished:(ASIFormDataRequest *)request;
- (void)addNewGuestRequestFailed:(ASIFormDataRequest *)request;
- (void)updateCheckInRequestFinished:(ASIFormDataRequest *)request;
- (void)updateCheckInRequestFailed:(ASIFormDataRequest *)request;
- (void)loadMarketifonline;
- (void)loadMarketionlineRequestFinished:(ASIFormDataRequest *)request;
- (void)loadMarketionlineRequestFailed:(ASIFormDataRequest *)request;
- (void)loadEventForMarketOnline:(NSString*)city;
- (void)loadEventForMarketOnlineRequestFinished:(ASIFormDataRequest *)request;
- (void)loadEventForMarketOnlineRequestFailed:(ASIFormDataRequest *)request;
- (void)loadPeopleForDateOnline:(NSString*)date_time_id;
- (void)loadPeopleForDateOnlineRequestFinished:(ASIFormDataRequest *)request;
- (void)loadPeopleForDateOnlineRequestFailed:(ASIFormDataRequest *)request;
- (void)loadPeopleForDateOnline:(NSString*)date_time_id  since:(NSString*)since;
- (void)log_dump;
- (void)log_dumpRequestFinished:(ASIFormDataRequest *)request;
- (void)log_dumpRequestFailed:(ASIFormDataRequest *)request;*/

-(void)addRequestToQueue:(ASIFormDataRequest*)request;
-(void)nextRequest;
-(void)checkQueue;
-(void)popRequest;

@end

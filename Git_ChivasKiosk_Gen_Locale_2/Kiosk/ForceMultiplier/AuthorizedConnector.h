//
//  AuthorizedConnector.h
//  EventCheckIn
//
//  Created by Garrett Shearer on 9/14/10.
//  Copyright 2010 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "NSString+Parsing.h"
#import <CommonCrypto/CommonDigest.h>
#import "KeychainItemWrapper.h"
#import "ASIFormDataRequest.h"
//#import "LoginViewController.h"
#import "DataAccess.h"
@class XMLManager;
@class LoginViewController;

//@class ForceMultiplierAppDelegate;

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
	BOOL creatingTestAuthors;
	BOOL isLoadingInit;
	BOOL isLoadingPeople;
	BOOL isGettingPeople;
	BOOL isAddingGuest;
	BOOL isUpdatingCheckIn;
	BOOL isLoadingMarketOnline;
	BOOL isLoadingMarketEventOnline;
	BOOL isLoadingPeopleForDate;
    
    BOOL diagnosticMode;
    
    BOOL busy;
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


@property (nonatomic, assign) BOOL busy,isUpdatingCheckIn,isLoadingMarketOnline,isLoadingMarketEventOnline,isLoadingPeopleForDate, isAddingPeople, isUpdatingPeople, diagnosticMode,creatingTestAuthors; 

-(void)addPeople;
- (void)nextRequest;
-(void)addRequestToQueue:(ASIFormDataRequest*)request;
-(void)checkCount;
-(void)clearQueue;
-(void)popRequest;

@end


//
//  DataAccess.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/13/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ForceMultiplierAppDelegate.h"
@class ForceMultiplierAppDelegate;
@class AuthorizedConnector;
@class GSOrderedDictionary;

@interface DataAccess : NSObject {
    //CoreData
    NSManagedObjectContext *context;
    NSPersistentStoreCoordinator *coordinator;
    
   // NSString *currentTimeID;
    
    AuthorizedConnector *web;
    
    NSString *brandID;
    NSString *currentTimeID;
    NSString *currentAuthorID;
}

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSPersistentStoreCoordinator *coordinator;
//@property (nonatomic) NSString *currentTimeID;
@property (nonatomic, retain) AuthorizedConnector *web;
@property (nonatomic, retain) NSString *brandID;
@property (nonatomic, retain) NSString *currentTimeID;
@property (nonatomic, retain) NSString *currentAuthorID;


-(void)getDefaults;
-(NSNumber*)getMode;


-(NSMutableArray*)allAuthorInteractions;
-(NSMutableArray*)allAuthors;
-(NSMutableDictionary*)allAuthorsForTimeID:(NSString*)timeID;
-(GSOrderedDictionary*)allAuthorsForCurrentTime;
-(NSMutableArray*)allEventTimeAuthors;

-(NSMutableArray*)allEventAttendees;
-(NSMutableArray*)allEventTimeAddresses;
-(NSMutableArray*)allEventTimeOverviews;
-(NSMutableArray*)allStudiesWithStats;
-(NSMutableArray*)allStudyEventTimes;

-(void)updatedEventTimeAuthors;
-(void)updatedAuthorDetails;

-(void)addAuthors:(NSArray*)authors;
-(void)addAuthor:(NSMutableDictionary*)author;
-(void)addEventTimeAuthors:(NSArray*)eventTimeAuthors;
-(void)addEventTimeAuthor:(NSMutableDictionary*)eventTimeAuthor;

-(void)addvwEventAttendee:(NSMutableDictionary*)vwEventAttendee;
-(void)addvwEventTimeAddress:(NSMutableDictionary*)vwEventTimeAddress;
-(void)addvwEventTimeOverview:(NSMutableDictionary*)vwEventTimeOverview;
-(void)addvwStudiesWithStat:(NSMutableDictionary*)vwStudiesWithStat;
-(void)addvwStudyEventTime:(NSMutableDictionary*)vwStudyEventTime;

-(void)addSession:(NSMutableDictionary*)session;
-(NSString*)uniqueObjectURIString:(NSManagedObject*)obj;
-(NSDate*)getNewSyncTS;


@end
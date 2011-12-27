//
//  GSXMLParse.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/25/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForceMultiplierAppDelegate.h"

@interface GSXMLParse : NSObject {
    //server communication ivars
	NSMutableData *responseData;
	NSMutableArray *array;
	NSMutableArray *parsedArray;
	NSString *urlString;
	
	//xml parser ivars
	NSXMLParser *xml;
    NSMutableString *currentRequest;
	NSString *currentParent;
    NSMutableString *currentProperty;
    //NSManagedObject *currentEntity;
	NSMutableDictionary *currentEntity;
    
    NSString *authorID;
    
    NSManagedObjectContext *context;
    NSPersistentStoreCoordinator *coordinator;
    NSMutableArray *requestQueue;
    BOOL busy;
    DataAccess *da;
}

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSPersistentStoreCoordinator *coordinator;

@property (nonatomic, retain) NSMutableString *currentRequest;
@property (nonatomic, retain) NSString *currentParent;
@property (nonatomic, retain) NSMutableString *currentProperty;
@property (nonatomic, retain) NSMutableDictionary *currentEntity;//NSManagedObject *currentEntity;

@property (nonatomic, retain) NSString *authorID;

@property (nonatomic, retain) DataAccess *da;
/*
@property (nonatomic, retain) Instrument *currentInstrument;
@property (nonatomic, retain) Tuning *currentTuning;
@property (nonatomic, retain) InstrumentString *currentInstrumentString;
*/
 @property (nonatomic, readonly) NSMutableArray *instruments;
@property (nonatomic, retain) NSMutableArray *requestQueue;
@property (nonatomic, assign) BOOL busy;

 - (BOOL) initializeDb;
-(void)loadData;
-(void)parseData;

@end

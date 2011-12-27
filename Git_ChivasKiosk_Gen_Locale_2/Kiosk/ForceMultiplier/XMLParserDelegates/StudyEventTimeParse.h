//
//  StudyEventTimeParse.h
//  ForceMultiplierConcierge
//
//  Created by Garrett Shearer on 7/22/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestParserDelegate.h"

@interface StudyEventTimeParse : NSObject {
    NSString *service;
    NSString *currentParent;
    NSMutableString *currentProperty;
	NSMutableDictionary *currentEntity;
    NSMutableArray *collection;
    id <RequestParserDelegate> delegate;
}

@property (nonatomic,retain) NSString *currentParent;
@property (nonatomic,retain) NSMutableString *currentProperty;
@property (nonatomic,retain) NSMutableDictionary *currentEntity;
@property (nonatomic,retain) NSArray *collection;
@property (nonatomic,retain) NSString *service;
@property (nonatomic,retain) id delegate;

-(id)initWithDelegate:(id)aDelegate forService:(NSString*)aService;
-(NSDate*) parseDateString:(NSString*)aDateString;

@end
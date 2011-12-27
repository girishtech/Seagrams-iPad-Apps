//
//  Session.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 6/22/11.
//  Copyright (c) 2011 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Person;

@interface Session : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * DateTime;
@property (nonatomic, retain) NSString * Location;
@property (nonatomic, retain) NSString * Time;
@property (nonatomic, retain) NSNumber * TimeID;
@property (nonatomic, retain) NSNumber * RegistrationCount;
@property (nonatomic, retain) NSString * AddressID;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSString * StudyID;
@property (nonatomic, retain) Event * Session_Event;
@property (nonatomic, retain) NSSet* Session_Person;

@end

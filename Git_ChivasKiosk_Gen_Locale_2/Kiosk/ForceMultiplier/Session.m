//
//  Session.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 6/22/11.
//  Copyright (c) 2011 Rochester Institute of Technology. All rights reserved.
//

#import "Session.h"
/*
#import "Event.h"
#import "Person.h"
*/

@implementation Session
@dynamic DateTime;
@dynamic Location;
@dynamic Time;
@dynamic TimeID;
@dynamic RegistrationCount;
@dynamic AddressID;
@dynamic Name;
@dynamic StudyID;
@dynamic Session_Event;
@dynamic Session_Person;


- (void)addSession_PersonObject:(Person *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Session_Person" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Session_Person"] addObject:value];
    [self didChangeValueForKey:@"Session_Person" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeSession_PersonObject:(Person *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Session_Person" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Session_Person"] removeObject:value];
    [self didChangeValueForKey:@"Session_Person" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addSession_Person:(NSSet *)value {    
    [self willChangeValueForKey:@"Session_Person" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Session_Person"] unionSet:value];
    [self didChangeValueForKey:@"Session_Person" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeSession_Person:(NSSet *)value {
    [self willChangeValueForKey:@"Session_Person" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Session_Person"] minusSet:value];
    [self didChangeValueForKey:@"Session_Person" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end

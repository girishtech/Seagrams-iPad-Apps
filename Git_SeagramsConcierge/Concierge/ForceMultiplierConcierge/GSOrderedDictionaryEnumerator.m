//
//  GSOrderedDictionaryEnumerator.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/31/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "GSOrderedDictionaryEnumerator.h"


@implementation GSOrderedDictionaryEnumerator

@synthesize arr;

int idx = 0;

- initWithArray:(NSArray *)e
{ 
    [super init];
    arr = [[NSArray alloc]initWithArray:e];
    idx = 0;
    return self;
}

- (id)nextObject
{
    if(idx<([arr count]-1)){
        return [arr objectAtIndex:idx++];
    }else{
        return nil;
    }
}

- (NSArray*)allObjects
{
    int len = [arr count];
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:0];
    for(idx;idx<len;idx++){
        [tmp addObject:[arr objectAtIndex:idx]];
    }
    return [(NSArray *)tmp autorelease];
}

- (void)dealloc
{ 
    [arr release];
    [super dealloc];
}
@end

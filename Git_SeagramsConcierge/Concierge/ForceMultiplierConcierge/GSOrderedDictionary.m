//
//  GSOrderedDictionary.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/31/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "GSOrderedDictionary.h"


@implementation GSOrderedDictionary

@synthesize orderingArr, dict;

- (id)init{
    [super init];
    
    orderingArr = [[NSMutableArray alloc] initWithCapacity:0];
    dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    return self;
}

- (id)initWithDictionary:(GSOrderedDictionary*)otherDictionary{
    [super init];
    
    orderingArr = [otherDictionary.orderingArr retain];
    dict = [otherDictionary.dict retain];
    
    return self;
}

- (void)setObject:(id)anObject forKey:(NSString *)key
{
    if([dict objectForKey:key]==nil){
        [orderingArr addObject:key];
    }
    
    [dict setObject:anObject forKey:key];
}

- (void)removeObjectForKey:(NSString *)key
{
    if([dict objectForKey:key]!=nil)
    {
        int index = 0;
        for(id storedKey in orderingArr)
        {
            if([storedKey isEqualToString:key])
            {
                [orderingArr removeObjectAtIndex:index];
            }
            index++;
        }
    }
    
    [dict removeObjectForKey:key];
}

- (NSEnumerator*)keyEnumerator
{
    GSOrderedDictionaryEnumerator *e = [[GSOrderedDictionaryEnumerator alloc] initWithArray:orderingArr];
    return [e autorelease];
}

- (id)objectForKey:(NSString*)key{
    if([dict objectForKey:key]!=nil){
        return [dict objectForKey:key];
    }else{
        return nil;
    }
}

- (id)keyForIndex:(NSUInteger)index{
    if(index >= [orderingArr count]){
        //throw(NSRangeException);
        [NSException raise:@"NSRangeException" format:@"index of %d is invalid", index];
        return nil;
    }else{
        return [orderingArr objectAtIndex:index];
    }
}

- (id)objectAtIndex:(NSUInteger)index{
    if(index >= [orderingArr count]){
        //throw(NSRangeException);
        [NSException raise:@"NSRangeException" format:@"index of %d is invalid", index];
        return nil;
    }else{
        return [dict objectForKey:[orderingArr objectAtIndex:index]];
    }
}

- (NSUInteger)count
{
    return (NSUInteger)[orderingArr count];
}
@end

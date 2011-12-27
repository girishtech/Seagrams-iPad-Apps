//
//  GSOrderedDictionary.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/31/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSOrderedDictionaryEnumerator.h"

@interface GSOrderedDictionary : NSMutableDictionary {
    NSMutableArray *orderingArr;
    NSMutableDictionary *dict;
}

@property (nonatomic, retain) NSMutableArray *orderingArr;
@property (nonatomic, retain) NSMutableDictionary *dict;

- (id)initWithDictionary:(GSOrderedDictionary*)otherDictionary;
- (void)setObject:(id)anObject forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;
- (NSEnumerator*)keyEnumerator;
- (id)objectForKey:(NSString*)key;
- (id)keyForIndex:(NSUInteger)index;
- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)count;


@end

//
//  GSOrderedDictionaryEnumerator.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/31/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GSOrderedDictionaryEnumerator : NSEnumerator {
    NSArray *arr;
}

@property (nonatomic, retain) NSArray *arr;

@end

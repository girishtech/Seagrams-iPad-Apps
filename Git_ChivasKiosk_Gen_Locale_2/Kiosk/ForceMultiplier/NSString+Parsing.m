//
//  NSString+Parsing.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 10/13/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "NSString+Parsing.h"


@implementation NSString (NSString_Parsing)
-(id) return_between:(NSString*)start end:(NSString *)end{
    int firstEndIndex;
    NSLog(@"return_between \n self: '%@' \n start: '%@' \n end: '%@",self,start,end); 
    //Find occurence of start
    NSRange firstRange = [self rangeOfString:start];
    
    if(firstRange.location != NSNotFound)
    {
        NSLog(@"return_between - firstRange: %d, %d", firstRange.location, firstRange.length);
        //slice off start
        firstEndIndex = firstRange.location + firstRange.length;
        NSString *sub = [self substringFromIndex:firstEndIndex];
        
        //Find occurence of end
        NSRange secondRange = [sub rangeOfString:end];
        
        if(secondRange.location != NSNotFound)
        {
            NSLog(@"return_between - secondRange: %d, %d", secondRange.location, secondRange.length);
            //return results
            NSString *newStr = [sub substringToIndex:secondRange.location];
            return newStr;
        }else{
            NSLog(@"return_between - end not found");
            return nil;
        }
    }else{
        NSLog(@"return_between - start not found");
        return nil;
    }
}
@end

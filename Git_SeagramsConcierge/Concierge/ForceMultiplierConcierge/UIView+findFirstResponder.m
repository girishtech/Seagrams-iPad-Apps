//
//  UIView+findFirstResponder.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 6/7/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "UIView+findFirstResponder.h"


@implementation UIView (FindFirstResponder)
- (UIView *)findFirstResonder
{
    if (self.isFirstResponder) {        
        return self;     
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResonder];
        
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}
@end

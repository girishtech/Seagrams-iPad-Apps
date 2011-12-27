//
//  LandscapeImagePicker.m
//  ForceMultiplier
//
//  Created by Dave Vedder on 12/21/11.
//  Copyright (c) 2011  All rights reserved.
//

#import "LandscapeImagePicker.h"

@implementation LandscapeImagePicker

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end

//
//  UIUnderlinedLabel.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/27/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "UIUnderlinedLabel.h"


@implementation UIUnderlinedLabel


- (void)dealloc
{
    [super dealloc];
}

#pragma mark - View lifecycle


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 207.0f/255.0f, 91.0f/255.0f, 44.0f/255.0f, 1.0f); // RGBA
    CGContextSetLineWidth(ctx, 1.0f);
    
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height - 1);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height - 1);
    
    CGContextStrokePath(ctx);
    
    [super drawRect:rect];  
}

@end

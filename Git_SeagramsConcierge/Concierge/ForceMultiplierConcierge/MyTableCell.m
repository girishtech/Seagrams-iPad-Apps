//
//  MyTableCell.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/27/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "MyTableCell.h"


@implementation MyTableCell

@synthesize columns;


- (void)dealloc
{
    [super dealloc];
}



-(void)addColumn:(double)position
{
    NSLog(@"UITableCell -(void)addColumn:(double)position");
    [columns addObject:[NSNumber numberWithDouble:position]];
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    for (int i = 0; i < [columns count]; i++) {
        NSLog(@"draw gridline");
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake([[columns objectAtIndex:i]doubleValue], 0.0, self.bounds.size.width,self.bounds.size.height)];
        [aView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
        [self addSubview:aView];
    }
    
    
    [self setBackgroundColor:[UIColor colorWithRed:1.0 green:0.5 blue:1.0 alpha:1.0]];
}

- (void)viewWillAppear{
    for (int i = 0; i < [columns count]; i++) {
        NSLog(@"draw gridline");
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake([[columns objectAtIndex:i]doubleValue], 0.0, self.bounds.size.width,self.bounds.size.height)];
        [aView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
        [self addSubview:aView];
    }
    
    //CGContextStrokePath(ctx);
    
    [self setBackgroundColor:[UIColor colorWithRed:1.0 green:0.5 blue:1.0 alpha:1.0]];
}


- (void)drawRect:(CGRect)rect {
    NSLog(@"UITableCell drawRect");
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // Use the same color and width as the default cell separator for now
    CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0.5, 1.0);
    CGContextSetLineWidth(ctx, 0.25);
    
    
    for (int i = 0; i < [columns count]; i++) {
        NSLog(@"Cell Column Line");
        CGFloat f = [((NSNumber*) [columns objectAtIndex:i]) floatValue];
        CGContextMoveToPoint(ctx, f, 0);
        CGContextAddLineToPoint(ctx, f, self.bounds.size.height);
    }
    
    CGContextStrokePath(ctx);
    
    [super drawRect:rect];
    
    for (int i = 0; i < [columns count]; i++) {
        NSLog(@"draw gridline");
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake([[columns objectAtIndex:i]doubleValue], 0.0, self.bounds.size.width,self.bounds.size.height)];
        [aView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
        [self addSubview:aView];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end

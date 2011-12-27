//
//  TableViewGridHeaderController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/27/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "TableViewGridHeaderController.h"


@implementation TableViewGridHeaderController

@synthesize view;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    //UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width,self.view.bounds.size.height)
    
    for (int i = 0; i < [columns count]; i++) {
        NSLog(@"draw gridline");
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake([[columns objectAtIndex:i]doubleValue], 0.0, self.view.bounds.size.width,self.view.bounds.size.height)];
        [aView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
        [self.view addSubview:aView];
    }
    
    //CGContextStrokePath(ctx);
    
    [self setBackgroundColor:[UIColor colorWithRed:1.0 green:0.5 blue:1.0 alpha:1.0]];
    [super viewDidLoad];
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
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)addColumn:(CGFloat)position {
    [columns addObject:[NSNumber numberWithFloat:position]];
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"Header drawRect");
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // Use the same color and width as the default cell separator for now
    CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0.5, 1.0);
    CGContextSetLineWidth(ctx, 0.1);
    
    for (int i = 0; i < [columns count]; i++) {
        NSLog(@"draw gridline");
        CGFloat f = [((NSNumber*) [columns objectAtIndex:i]) floatValue];
        CGContextMoveToPoint(ctx, f, 0);
        CGContextAddLineToPoint(ctx, f, self.view.bounds.size.height-5.0);
    }
    
    CGContextStrokePath(ctx);
    
    [self setBackgroundColor:[UIColor colorWithRed:1.0 green:0.5 blue:1.0 alpha:1.0]];
    
    //[[UIColor colorWithRed:1.0 green:0.5 blue:1.0 alpha:1.0] set];
	//CGRectFill(rect);
    
    UIGraphicsPushContext(ctx);
    
    [super drawRect:rect];
}

@end

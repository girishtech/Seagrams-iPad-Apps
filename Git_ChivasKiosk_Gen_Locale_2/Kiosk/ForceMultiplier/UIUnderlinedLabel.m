//
//  UIUnderlinedLabel.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/27/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "UIUnderlinedLabel.h"


@implementation UIUnderlinedLabel

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

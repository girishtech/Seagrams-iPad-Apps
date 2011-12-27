//
//  HomeViewController.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 7/6/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "HomeViewController.h"


@implementation HomeViewController

@synthesize backgroundImages, theTimer, currentImageIndex, currentImageView, image1, image2, animating, running, unlock, tapScreenLbl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.unlock = YES;
    return self;
}

- (void)dealloc
{
    [theTimer release];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - Custom Implementation

-(void)startTicks
{
    //if(theTimer == nil) {
    running = YES;
        [image1 setAlpha:1.0f];
        //[image2 setAlpha:0.0f];
        currentImageView = image1;
        [self tickNextBackground];
    //}
}

-(void)stopTimer
{
    NSLog(@"stopTimer");
    running = NO;
    /*if(theTimer != nil && [theTimer isKindOfClass:[NSTimer class]]) {
        if([theTimer isValid]){
            [theTimer invalidate];
        }
    }*/
}

- (void) tickNextBackground
{
    /*
    if(self.animating == NO){
        self.animating = YES;
        if(currentImageIndex == [backgroundImages count]) currentImageIndex = 0;
        
        UIImageView *otherImageView;
        if(currentImageView == image1){
            otherImageView = image2;
        }else{
            otherImageView = image1;
        }
        
        //[otherImageView setAlpha:0.0f];
        [otherImageView setImage:[UIImage imageNamed:[backgroundImages objectAtIndex:currentImageIndex]]];
        //[otherImageView setAlpha:0.0f];
        [UIView animateWithDuration:1.0
                         animations:^ {
                             currentImageView.alpha = 0.0f;
                             otherImageView.alpha = 1.0f;
                         }
                         completion:^(BOOL finished){ self.animating = NO; }
         ];
        currentImageIndex = currentImageIndex + 1;
        currentImageView = otherImageView;
        
        if(running)
        {
        theTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                    target:self
                                                  selector:@selector(tickNextBackground)
                                                  userInfo:nil
                                                   repeats:NO];
        }
    }/*else{
        [image1 setAlpha:0.0f];
        [image2 setAlpha:0.0f];
        [image1 setImage:[UIImage imageNamed:[backgroundImages objectAtIndex:0]]];
        [UIView animateWithDuration:1.0
                         animations:^ {
                             image1.alpha = 1.0f;
                         }
         ];
        currentImageIndex = currentImageIndex + 1;
        currentImageView = image1;
    }
    */
    
}

-(void)lock
{
    NSLog(@"lock");
    self.unlock = NO;
    self.tapScreenLbl.text = @"Migrating Old Data, Please Wait.";
}

-(void)unlockScreen
{
    NSLog(@"unlock");
    self.unlock = YES;
    self.tapScreenLbl.text = @"Tap Screen to Begin";
}

-(IBAction)clickedScreen
{
    if(self.unlock == YES){
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate buildRootView];
    }else{
        self.tapScreenLbl.text = @"Migrating Old Data, Please Wait.";
    }
}

@end

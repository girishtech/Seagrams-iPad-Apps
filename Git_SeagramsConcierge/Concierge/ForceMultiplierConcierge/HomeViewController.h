//
//  HomeViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 7/6/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ForceMultiplierAppDelegate;

@interface HomeViewController : UIViewController {
    NSArray *backgroundImages;
    NSTimer *theTimer;
    
    NSInteger currentImageIndex;
    UIImageView *currentImageView;
    IBOutlet UIImageView *image1;
    IBOutlet UIImageView *image2;
    
    IBOutlet UILabel *tapScreenLbl;
    
    BOOL animating;
    BOOL running;
    BOOL unlock;
}

@property (nonatomic, retain) NSArray *backgroundImages;
@property (nonatomic, retain) NSTimer *theTimer;

@property (nonatomic) NSInteger currentImageIndex;
@property (nonatomic, retain) UIImageView *currentImageView;
@property (nonatomic, retain) IBOutlet UIImageView *image1;
@property (nonatomic, retain) IBOutlet UIImageView *image2;
@property (nonatomic, retain) IBOutlet UILabel *tapScreenLbl;
@property (nonatomic) BOOL animating;
@property (nonatomic) BOOL running;
@property (nonatomic) BOOL unlock;

@end

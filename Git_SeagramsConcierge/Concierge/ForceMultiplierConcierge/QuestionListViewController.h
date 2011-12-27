//
//  QuestionListViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 8/11/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionViewController.h"
//#import "ThankYouPurchaseViewController.h"

@interface QuestionListViewController : UIViewController {
    UINavigationController *nav;
    NSArray *questions;
    NSInteger currentQuestion;
    NSMutableArray *flags;
    NSMutableString *answers;
}

@property (nonatomic,retain) UINavigationController *nav;
@property (nonatomic,retain) NSArray *questions;
@property (nonatomic) NSInteger currentQuestion;
@property (nonatomic,retain) NSMutableArray *flags;
@property (nonatomic,retain) NSMutableString *answers;

@end

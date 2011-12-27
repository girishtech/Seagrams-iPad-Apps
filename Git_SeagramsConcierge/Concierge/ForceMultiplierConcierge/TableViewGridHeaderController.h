//
//  TableViewGridHeaderController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/27/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableViewGridHeaderController : UIViewController {
    NSMutableArray *columns;
    UIView *view;
    id delegate;
}

@property (nonatomic,retain) UIView *view;
@property (nonatomic,retain) id delegate;

- (void)addColumn:(CGFloat)position;

@end

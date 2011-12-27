//
//  MyTableCell.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/27/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyTableCell : UITableViewCell {
    NSMutableArray *columns;
}

@property (nonatomic,retain) NSMutableArray *columns;

- (void)addColumn:(double)position;
@end

//
//  TableViewGridController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/27/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTableCell.h"
#import "TableViewGridHeaderController.h"
#import "GSOrderedDictionary.h"

@protocol TableViewGridDelegate <NSCoding>

-(void)didSelectRow:(NSNumber *)rowID;

@end

@interface TableViewGridController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{
    GSOrderedDictionary *dataCollection;
    IBOutlet UITableView *theTableView;
    IBOutlet UIView *view;
    id delegate;
    NSNumber *rowHeight;
    NSInteger *selectedRow;
}

@property (nonatomic, retain) GSOrderedDictionary *dataCollection;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) IBOutlet UIView *view;
@property (nonatomic, retain) NSNumber *rowHeight;
@property (nonatomic) NSInteger *selectedRow;


@property (nonatomic, assign) id<TableViewGridDelegate> delegate;

- (void)loadHeader;

@end

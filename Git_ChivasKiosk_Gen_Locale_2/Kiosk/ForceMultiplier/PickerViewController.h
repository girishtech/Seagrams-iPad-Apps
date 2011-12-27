//
//  PickerViewController.h
//  PopApp
//
//  Created by Matthew Casey on 13/05/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopoverPickerDelegate <NSCoding>

-(void)numberDidChangeTo:(NSString *)newNumber;
-(void)popoverShown;
- (void) doneClicked;

@end


@interface PickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	NSMutableDictionary *components;
	IBOutlet UIPickerView *thePickerView;
    IBOutlet UIDatePicker *theDatePickerView;
	id delegate;
}

@property (nonatomic, retain) UIPickerView *thePickerView;
@property (nonatomic, retain) UIDatePicker *theDatePickerView;
@property (nonatomic, assign) id<PopoverPickerDelegate> delegate;
@property (nonatomic, copy) NSMutableDictionary *components;

-(void)didChangeSelection:(NSMutableDictionary *)componentValues;
- (IBAction) selectDOB:(id)sender;

@end

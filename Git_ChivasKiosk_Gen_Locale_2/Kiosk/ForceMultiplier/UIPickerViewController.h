//
//  UIPickerViewController.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 7/1/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIPickerViewController : UIViewController {
    IBOutlet id delegate;
    IBOutlet UIPickerView *pickerView;
}

@property (nonatomic) IBOutlet id delegate;
@property (nonatomic) IBOutlet UIPickerView *pickerView;

@end

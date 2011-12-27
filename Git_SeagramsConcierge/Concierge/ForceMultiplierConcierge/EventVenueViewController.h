//
//  EventVenueViewController.h
//  ForceMultiplierConcierge
//
//  Created by Dustin Fineout on 6/22/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventVenueViewController : UIViewController {
    IBOutlet UILabel *venueName;
    IBOutlet UILabel *venueAddress;
    IBOutlet UILabel *venueCityStateZip;
    IBOutlet UITextView *venueDirections;
    IBOutlet UILabel *hostName;
    IBOutlet UILabel *hostAddress;
    IBOutlet UILabel *hostCityStateZip;
    IBOutlet UITextView *hostDescription;
    IBOutlet UIImageView *hostImage;
}

@property (nonatomic,retain) IBOutlet UILabel *venueName;
@property (nonatomic,retain) IBOutlet UILabel *venueAddress;
@property (nonatomic,retain) IBOutlet UILabel *venueCityStateZip;
@property (nonatomic,retain) IBOutlet UITextView *venueDirections;
@property (nonatomic,retain) IBOutlet UILabel *hostName;
@property (nonatomic,retain) IBOutlet UILabel *hostAddress;
@property (nonatomic,retain) IBOutlet UILabel *hostCityStateZip;
@property (nonatomic,retain) IBOutlet UITextView *hostDescription;
@property (nonatomic,retain) IBOutlet UIImageView *hostImage;

@end

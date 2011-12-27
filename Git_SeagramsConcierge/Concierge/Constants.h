//
//  Settings.h
//  ForceMultiplier
//
//  Created by Garrett Shearer on 10/25/11.
//  Copyright (c) 2011 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject
    extern NSString * const MySecondConstant;

    extern CGFloat const HEADER_HEIGHT;
    
    //APP-WIDE
    extern BOOL const USES_SURVEY;
    extern NSString * const CURRENTVERSION;
    extern int const RELEASE;

    extern NSString * const WS_DEV;
    extern NSString * const WS_STG;
    extern NSString * const WS_PROD;

    extern NSString * const APIKEY_DEV_ENG;
    extern NSString * const APIKEY_STG_ENG;
    extern NSString * const APIKEY_PROD_ENG;

    extern NSString * const APPKEY_DEV_ENG;
    extern NSString * const APPKEY_STG_ENG;
    extern NSString * const APPKEY_PROD_ENG;

    extern NSString * const STUDYID_DEV_ENG;
    extern NSString * const STUDYID_STG_ENG;
    extern NSString * const STUDYID_PROD_ENG;

    extern NSString * const STUDYID_DEV_ES;
    extern NSString * const STUDYID_STG_ES;
    extern NSString * const STUDYID_PROD_ES;

    //OPTIN CONFIRMATION CONTROLLER
    extern BOOL const HIDES_HEADER_ON_OPTIN_PAGE;

    //SURVEY CONTROLLER
    extern BOOL const HIDES_HEADER_ON_SURVEY_PAGE;
    

    //THANKYOU CONTROLLER
    extern BOOL const HIDES_HEADER_ON_THANKYOU_PAGE;
@end


//COLORS!!!!
@interface UIColor (Constants)
    +(UIColor *) foregroundColor;
    +(UIColor *) backgroundColor;
    +(UIColor *) highlightColor;

    +(UIColor *) eventsTableHeader_BackgroundColor;
    +(UIColor *) eventsTableHeader_LabelBackgroundColor;
    +(UIColor *) eventsTableHeader_FontColor;

    +(UIColor *) eventsTable_FontColor;
    +(UIColor *) eventsTable_OddFontColor;
    +(UIColor *) eventsTable_BackgroundColor;
    +(UIColor *) eventsTable_OddBackgroundColor;
    +(UIColor *) eventsTable_SelectedBackgroundColor;
@end
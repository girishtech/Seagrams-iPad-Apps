//
//  RequestParserDelegate.h
//  FM-WebServiceTester
//
//  Created by Garrett Shearer on 7/10/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol RequestParserDelegate <NSObject>
-(void)parseDidReturnResults:(NSArray *)results forService:(NSString*)service;
-(void)parseDidFail;
@end

//
//  RequestParserDelegate.h
//  ForceMultiplierConcierge
//
//  Created by Garrett Shearer on 7/15/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol RequestParserDelegate <NSObject>
-(void)parseDidFail;
-(void)parseDidReturnResults:(NSMutableArray*)collection forService:(NSString*)service;
@end

//
//  loginParse.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 7/7/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "loginParse.h"
#import "DataAccess.h"
#import "ForceMultiplierAppDelegate.h"

@implementation loginParse
/*
#pragma mark NSXMLParser delegate method
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.currentProperty) {
        [currentProperty appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	/*
     NSLog(@"didStartElement=%@",elementName);
     NSLog(@"Namespace=%@",namespaceURI);
     NSLog(@"Attributes=%@",attributeDict);
     *//*
	if (qualifiedName) {
        elementName = qualifiedName;
    }
    if ([elementName isEqualToString:@"feed"]) {
        NSLog(@"found feed");
        self.currentParent = @"feed";//[elementName retain];
        NSLog(@"feed - currentParent retainCount: %d",[self.currentParent retainCount]);
    } else if ([elementName isEqualToString:@"error"]) {
        NSLog(@"login failed");
        ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
        da = [appDelegate da];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName {
    if (qualifiedName) {
        elementName = qualifiedName;
    }
    
    self.currentProperty = [NSMutableString string];
}


- (void)parserDidStartDocument:(NSXMLParser *)parser{
	NSLog(@"parserDidStartDocument");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
	NSLog(@"parserDidEndDocument");
	NSLog(@"array=%@",array);
	//parser = nil;
	[parsedArray removeAllObjects];
    //self.currentRequest = [NSMutableString string];
    //self.currentParent = [NSString string];
    NSLog(@"didEndDoc - currentParent retainCount: %d",[self.currentParent retainCount]);
    //self.currentProperty = [NSMutableString string];
    //self.currentEntity = [NSMutableString string];
    [self popRequest];
}
#pragma mark -
*/
@end

//
//  vwEventAttendeeParse.m
//  FM-WebServiceTester
//
//  Created by Garrett Shearer on 7/9/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import "vwEventAttendeeParse.h"


@implementation vwEventAttendeeParse

@synthesize currentParent, currentProperty, currentEntity, collection, delegate, service;

#pragma mark -

-(id)initWithDelegate:(id)aDelegate forService:(NSString*)aService
{
    [super init];
    
    self.service = aService;
   
    self.delegate = aDelegate;
    
    self.currentParent = [[NSString alloc]initWithString:@""];
    self.currentProperty = [[NSMutableString alloc]initWithString:@""];
    self.currentEntity = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.collection = [[NSMutableArray alloc] initWithCapacity:0];
    
    return self;
}

-(void)dealloc{
    [service release];
    [currentParent release];
    [currentProperty release];
    [currentEntity release];
    //[collection release];
}

#pragma mark -

#pragma mark - NSXMLParser delegate method
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.currentProperty) {
        [currentProperty appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	
	if (qualifiedName) {
        elementName = qualifiedName;
    }
    
    NSString *namespace = @"";
    namespace = [elementName substringWithRange:NSMakeRange(0, 1)];
    if([namespace isEqualToString:@"d:"]){
        elementName = [elementName substringWithRange:NSMakeRange(2,[elementName length])];
    }
    
    if ([elementName isEqualToString:@"feed"]) {
        
        NSLog(@"found feed");
        self.currentParent = @"feed";
        
    } else if ([elementName isEqualToString:@"entry"]) {
        
        NSLog(@"found entry");
        self.currentParent = @"entry";
        //if(currentEntity) [currentEntity release];
        self.currentEntity = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
{
    if (qualifiedName) {
        elementName = qualifiedName;
    }
    
    
    // Check if the "d:" namespace is present in the elementname,
    //  and strip it out if necessary
    NSString *namespace = @"";
    namespace = [elementName substringWithRange:NSMakeRange(0, 1)];
    if([namespace isEqualToString:@"d:"]){
        elementName = [elementName substringWithRange:NSMakeRange(2,[elementName length])];
    }

                           
    NSString *trimmed = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([currentParent isEqualToString:@"entry"])
    {
    
        if([elementName isEqualToString:@"AuthorID"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        else if([elementName isEqualToString:@"AuthorStudyID"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        else if([elementName isEqualToString:@"AuthorFirstName"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        else if([elementName isEqualToString:@"AuthorLastName"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        else if([elementName isEqualToString:@"AuthorEmail"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        else if([elementName isEqualToString:@"TimeAuthorID"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        else if([elementName isEqualToString:@"TimeID"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        else if([elementName isEqualToString:@"ParentTimeAuthorID"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        else if([elementName isEqualToString:@"Attended"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        else if([elementName isEqualToString:@"Cancelled"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        else if([elementName isEqualToString:@"isAttending"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        else if([elementName isEqualToString:@"Invited"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        else if([elementName isEqualToString:@"StartDateT"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        else if([elementName isEqualToString:@"EndDateT"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        else if([elementName isEqualToString:@"MaxRegistrants"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        else if([elementName isEqualToString:@"EventID"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        else if([elementName isEqualToString:@"Name"]) 
        {
            [currentEntity setValue:trimmed forKey:elementName];
        }
        
        //End of Entity/Entry, add current entity to collection
        else if([elementName isEqualToString:@"entry"])
        {
            [collection addObject:currentEntity];
        }
    }
    
    self.currentProperty = [[NSMutableString alloc]initWithString:@""];
}


- (void)parserDidStartDocument:(NSXMLParser *)parser{
	NSLog(@"parserDidStartDocument");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
	NSLog(@"parserDidEndDocument");
    if(self.delegate)
    {
        [self.delegate parseDidReturnResults:collection forService:self.service];
    }
    else
    {
        NSLog(@"RequestParserDelegate not set!");
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"XML ERROR:%@", [parseError localizedDescription]);
}

#pragma mark -

@end

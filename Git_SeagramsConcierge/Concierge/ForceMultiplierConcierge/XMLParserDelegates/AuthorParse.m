//
//  AuthorParse.m
//  FM-WebServiceTester
//
//  Created by Garrett Shearer on 7/9/11.
//  Copyright 2011 Emerge Partners, Inc. All rights reserved.
//

#import "AuthorParse.h"


@implementation AuthorParse

@synthesize currentParent, currentProperty, currentEntity, collection, delegate, service;

#pragma mark -

-(id)initWithDelegate:(id)aDelegate forService:(NSString*)aService
{
    [super init];
    
    self.service = aService;
   
    self.delegate = aDelegate;
    
    self.currentParent = [[NSString alloc]initWithString:@""];
    self.currentProperty = [[NSMutableString alloc]initWithString:@""];
    //self.currentEntity = [[NSMutableDictionary alloc] initWithCapacity:0];
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
        self.currentEntity = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
{
    if (qualifiedName) {
        elementName = qualifiedName;
    }
    
    
    // Check if the "d:" namespace is present in the elementname,
    //  and strip it out if necessary
    NSString *namespace;
    NSString *newElementName;
    namespace = [elementName substringWithRange:NSMakeRange(0, 2)];
    if([namespace isEqualToString:@"d:"]){
        newElementName = [elementName substringWithRange:NSMakeRange(2,[elementName length]-2)];
    }else{
        newElementName = elementName;
    }

                           
    NSString *trimmed = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([currentParent isEqualToString:@"entry"])
    {
        if([newElementName isEqualToString:@"AuthorID"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorStudyID"]) 
        {
            [currentEntity setValue:[NSNumber numberWithInt:[trimmed integerValue]] forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorName"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorFirstName"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorLastName"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorAge"]) 
        {
            [currentEntity setValue:[NSNumber numberWithInt:[trimmed integerValue]] forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorGender"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"LanguageID"]) 
        {
            [currentEntity setValue:[NSNumber numberWithInt:[trimmed integerValue]] forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorLocation"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorCity"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorState"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorZip"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorZip4"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorDateCreated"]) 
        {
            [currentEntity setValue:[self parseDateString:trimmed] forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorDateUpdated"]) 
        {
            [currentEntity setValue:[self parseDateString:trimmed] forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"CountryID"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorCredabilityScore"]) 
        {
            [currentEntity setValue:[NSNumber numberWithInt:[trimmed integerValue]] forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorCompanyName"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorTitle"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorEmail"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"UserManaged"]) 
        {
            NSNumber *flag = [NSNumber numberWithInt:0];
            if([trimmed isEqualToString:@"true"]){
                flag = [NSNumber numberWithInt:1];
            }else{
                flag = [NSNumber numberWithInt:0];
            }
            [currentEntity setValue:flag forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorDOB"]) 
        {
            [currentEntity setValue:[self parseDateString:trimmed] forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorStreet1"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorStreet2"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"AuthorCountry"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"RemoteSystemID"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"MetaData1"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"MetaData2"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        else if([newElementName isEqualToString:@"ProvinceID"]) 
        {
            [currentEntity setValue:trimmed forKey:newElementName];
        }
        
        //End of Entity/Entry, add current entity to collection
        else if([newElementName isEqualToString:@"entry"])
        {
            [collection addObject:currentEntity];
            [currentEntity release];
        }
    }else if([newElementName isEqualToString:@"error"])
    {
        [parser abortParsing];
        NSLog(@"WCF ERROR: %@",trimmed);
        if(self.delegate)
        {
            [self.delegate parseDidFail];
        }
        else
        {
            NSLog(@"RequestParserDelegate not set!");
        }
    }
    [currentProperty release];
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

-(NSDate*) parseDateString:(NSString*)aDateString{
    if([aDateString length] > 18) aDateString = [aDateString substringToIndex:18];
  
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];

    NSDate *newDate = [outputFormatter dateFromString:aDateString];
    [outputFormatter release];
   
    return newDate;
    // For US English, the output is:
    // newDateString 10:30 on Sunday July 11
}

@end

//
//  GSXMLParse.m
//  ForceMultiplier
//
//  Created by Garrett Shearer on 5/25/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import "GSXMLParse.h"



@implementation GSXMLParse

@synthesize currentRequest, currentParent, currentProperty, currentEntity, instruments, context, coordinator,requestQueue, busy, da, authorID;

-(id)init{
    [super init];
	busy = NO;
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    coordinator = [appDelegate persistentStoreCoordinator];
    
    
    da = [appDelegate da];
    
    
    requestQueue = [[NSMutableArray alloc] initWithCapacity:0];
    
     self.authorID = [[NSString alloc]initWithString:@""];
    self.currentRequest = [[NSMutableString alloc]initWithString:@""];
    self.currentParent = [[NSString alloc]initWithString:@""];
    NSLog(@"init - currentParent retainCount: %d",[self.currentParent retainCount]);
    self.currentProperty = [[NSMutableString alloc]initWithString:@""];
    self.currentEntity = [[NSMutableDictionary alloc] initWithCapacity:0];//[NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:context];
    
    return self;
}

- (void)parseXMLString:(NSString*)xmlString {
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    da = [appDelegate da];
    
    NSLog(@"XMLParser - parseXMLString:");
    [self addRequestToQueue:xmlString];
     
    if([requestQueue count]==1)
    {
        NSLog(@"XMLParser - parseXMLString: - nextRequest");
        [self nextRequest];
    }
}

- (void)beginParse:(NSString*)xmlString {
    NSLog(@"XMLParser - beginParse:");
   
    
    //self.currentRequest = [NSMutableString string];
    //self.currentParent = [NSMutableString string];
    NSLog(@"begin parse - currentParent retainCount: %d",[self.currentParent retainCount]);
    //self.currentProperty = [NSMutableString string];
    //self.currentEntity = [NSMutableString string];
    
    //NSLog(@"parseData! data=%@",xmlString);
	xml = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    
	//NSLog(@"xml=%@",xml);
	if(! array) array = [[NSMutableArray alloc] init]; //lazy
	[array removeAllObjects];
	[xml setDelegate:self];
	[xml setShouldResolveExternalEntities:NO];
	[xml setShouldProcessNamespaces:NO];
	[xml setShouldReportNamespacePrefixes:NO];
	if (![xml parse]){
		NSLog(@"errorr in parse, error=%@",[xml parseError] );
		if(xml) [xml release];
	}
}

#pragma mark -
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
     */
	if (qualifiedName) {
        elementName = qualifiedName;
    }
    if(![currentParent isEqualToString:@""])
    {
        if([currentParent isEqualToString:@"feed"])
        {
            if([elementName isEqualToString:@"link"])
            {
                NSString *title=[attributeDict objectForKey:@"title"];
                if(title != nil)
                {
                    if([title isEqualToString:@"GetStudyEventTimes"])
                    {
                        self.currentRequest = title;
                    }
                    /*
                    else if([title isEqualToString:@"EventTimes"])
                    {
                        self.currentRequest = title;
                    }
                    else if([title isEqualToString:@"Events"])
                    {
                        self.currentRequest = title;
                    }
                     */
                    
                }
                // self.currentFeed = [[Instrument alloc] init];
            }
            else if([elementName isEqualToString:@"entry"])
            {
                self.currentParent = @"entry";//[elementName retain];
                NSLog(@"entry - currentParent retainCount: %d",[self.currentParent retainCount]);
                NSString *entityName;
                //NSLog(@"currentRequest: %@",currentRequest);
                if([currentRequest isEqualToString:@"GetStudyEventTimes"])
                {
                    NSLog(@"set entity name");
                    entityName = @"Session";
                }
                /*
                else if([currentRequest isEqualToString:@"EventTimes"])
                {
                    NSLog(@"set entity name");
                    entityName = @"Session";
                }
                 */
                currentEntity = [[NSMutableDictionary alloc] initWithCapacity:0];//[NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
            }
        } else if([currentParent isEqualToString:@"entry"])
        {
            if([elementName isEqualToString:@"link"])
            {
                NSString *title=[attributeDict objectForKey:@"title"];
                if(title != nil)
                {
                    if([title isEqualToString:@"Author"])
                    {
                        self.currentRequest = title;
                    }
                }
            }
        }       
    } else if ([elementName isEqualToString:@"feed"]) {
        NSLog(@"found feed");
        self.currentParent = @"feed";//[elementName retain];
        NSLog(@"feed - currentParent retainCount: %d",[self.currentParent retainCount]);
    } else if ([elementName isEqualToString:@"entry"]) {
        NSLog(@"found entry");
        self.currentParent = @"entry";//[elementName retain];
        NSLog(@"feed - currentParent retainCount: %d",[self.currentParent retainCount]);
    }
		
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName {
    if (qualifiedName) {
        elementName = qualifiedName;
    }
    
    NSString *trimmed = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
    AuthorizedConnector *auth = [appDelegate web];
    
    if([currentParent isEqualToString:@"entry"])
    {
        //NSLog(@"parent is 'entry'");
        if([currentRequest isEqualToString:@"GetStudyEventTimes"])
        {
            /*
             NSLog(@"XMLParser - parser:(NSXMLParser *)parser didEndElement: \n elementName: %@ \n elementValue: %@ \n parentName: %@ \n request: %@ \n currentEntity: %@",
                  elementName, trimmed,currentParent,currentRequest,currentEntity);
            //*/
           // NSLog(@"request is 'GetStudyEventTimes'");
            if([elementName isEqualToString:@"d:StudyID"])
            {
                //NSLog(@"StudyID: %@", trimmed);
                //NSLog(@"currentEntity: %@", currentEntity);
                
                [currentEntity setValue:trimmed forKey:@"StudyID"];
            }
            else if([elementName isEqualToString:@"d:EventID"])
            {
                //NSLog(@"EventID: %@", trimmed);
                [currentEntity setValue:trimmed forKey:@"EventID"]; 
            }
            else if([elementName isEqualToString:@"d:TimeID"])
            {
                //NSLog(@"TimeyID: %@", trimmed);
                [currentEntity setValue:trimmed forKey:@"TimeID"];  
            }
            else if([elementName isEqualToString:@"d:RegistrationsCount"])
            {
                //NSLog(@"RegistrationsCountID: %@", trimmed);
                [currentEntity setValue:[NSNumber numberWithInteger:[trimmed integerValue]] forKey:@"RegistrationsCount"];   
            }
            else if([elementName isEqualToString:@"d:City"])
            {
                //NSLog(@"city: %@", trimmed);
                [currentEntity setValue:trimmed forKey:@"Location"];   
            }
            else if([elementName isEqualToString:@"d:Name"])
            {
                //NSLog(@"Name: %@", trimmed);
                [currentEntity setValue:trimmed forKey:@"Name"];   
            }
            else if([elementName isEqualToString:@"d:StartDateT"])
            {
                //NSLog(@"StartDateT: %@", trimmed);
                [currentEntity setValue:[self parseDateString:trimmed] forKey:@"DateTime"];   
            }
            else if([elementName isEqualToString:@"d:SessionName"])
            {
                //NSLog(@"Name: %@", trimmed);
                [currentEntity setValue:trimmed forKey:@"SessionName"];   
            }
            else if([elementName isEqualToString:@"d:EndDateT"])
            {
                //NSLog(@"StartDateT: %@", trimmed);
                [currentEntity setValue:[self parseDateString:trimmed] forKey:@"EndDateTime"];   
            }
            //Reached End, do something
            else if([elementName isEqualToString:@"entry"]) 
            {
                NSLog(@"XMLParser - addNewSession: %@", currentEntity);
                NSLog(@"dataAccess: %@",da);
                [da addSession:currentEntity];
                [da saveNewSyncTS];
                //[da addSession:nil];
                
            }else if([elementName isEqualToString:@"feed"]) 
            {
                //NSLog(@"XMLParser - addNewSession: %@", currentEntity);
                NSLog(@"didEnd - feed - currentParent retainCount: %d",[self.currentParent retainCount]);
                currentParent = @"";   
                NSLog(@"didEnd - feed - currentParent retainCount: %d",[self.currentParent retainCount]);
            }
        } 
        else if([currentRequest isEqualToString:@"Author"])
        {
            if([elementName isEqualToString:@"d:AuthorID"]) 
            {
                NSLog(@"XMLParser - authorID: %@", trimmed);
                self.authorID = trimmed;
                //[da saveNewSyncTS];
            }
            
            if([elementName isEqualToString:@"d:RemoteSystemID"]) 
            {
                NSLog(@"XMLParser - self.authorID: %@", self.authorID);
                [[appDelegate da] addAuthorID:self.authorID ForURIString:trimmed];
                [auth addRegistrationForPerson:trimmed];
                [da saveNewSyncTS];
            }
        }
        /*
        else if([currentRequest isEqualToString:@"Events"])
        {
            if([elementName isEqualToString:@"EventID"])
            {
                [currentEntity setValue:currentProperty forKey:@"EventID"];
            }
            else if([elementName isEqualToString:@"AddressID"])
            {
                [currentEntity setValue:currentProperty forKey:@"AddressID"]; 
                [auth getAddress:currentProperty];
            }
            //Reached End, do something
            else if([elementName isEqualToString:@"entry"]) 
            {
                //[auth addLocationToSession:currentEntity];   
            }
        }
        else if([currentRequest isEqualToString:@"EventTimes"])
        {
            if([elementName isEqualToString:@"TimeID"])
            {
                [currentEntity setValue:currentProperty forKey:@"TimeID"];
            }
            else if([elementName isEqualToString:@"StartDate"])
            {
                [currentEntity setValue:currentProperty forKey:@"Time"]; 
            }
            //Reached End, do something
            else if([elementName isEqualToString:@"entry"]) 
            {
                [auth addTimeToSession:currentEntity];   
            }
        }
        else if([currentRequest isEqualToString:@"EventAddresses"])
        {
            if([elementName isEqualToString:@"TimeID"])
            {
                [currentEntity setValue:currentProperty forKey:@"TimeID"];
            }
            else if([elementName isEqualToString:@"StartDate"])
            {
                [currentEntity setValue:currentProperty forKey:@"Time"]; 
            }
            //Reached End, do something
            else if([elementName isEqualToString:@"entry"]) 
            {
                [auth addTimeToSession:currentEntity];   
            }
        }
         */

    }

	/*
    if (self.currentInstrumentString) { // Are we in a
        // Check for standard nodes
        if ([elementName isEqualToString:@"string_id"]) {
            self.currentInstrumentString.string_id = self.currentProperty;
        } else if ([elementName isEqualToString:@"string_note"]) {
            self.currentInstrumentString.string_note = self.currentProperty;
        } else if ([elementName isEqualToString:@"string_quality"]) {
            self.currentInstrumentString.string_quality = self.currentProperty;
        } else if ([elementName isEqualToString:@"string_octave"]) {
            self.currentInstrumentString.string_octave = self.currentProperty;
			// Are we at the end?
        } else if ([elementName isEqualToString:@"string"]) {
            [currentTuning addString:self.currentInstrumentString]; // Add to parent
            self.currentInstrumentString = nil; // Set nil
        }
    } else if (self.currentTuning) { // Are we in a
        // Check for standard nodes
        if ([elementName isEqualToString:@"tuning_id"]) {
            self.currentTuning.tuning_id = self.currentProperty;
        } else if ([elementName isEqualToString:@"tuning_name"]) {
            self.currentTuning.tuning_name = self.currentProperty;
			// Are we at the end?
        } else if ([elementName isEqualToString:@"tuning"]) {
            [currentInstrument addTuning:self.currentTuning]; // Add to parent
            self.currentTuning = nil; // Set nil
        }
    } else if (self.currentInstrument) { // Are we in a  ?
        // Check for standard nodes
        if ([elementName isEqualToString:@"instrument_id"]) {
            self.currentInstrument.instrument_id = self.currentProperty;
        } else if ([elementName isEqualToString:@"instrument_name"]) {
            self.currentInstrument.instrument_name = self.currentProperty;
		} else if ([elementName isEqualToString:@"instrument_string_count"]) {
            self.currentInstrument.instrument_string_count = self.currentProperty;
		} else if ([elementName isEqualToString:@"instrument_western"]) {
            self.currentInstrument.instrument_western = self.currentProperty;
			// Are we at the end?
        } else if ([elementName isEqualToString:@"instrument"]) { // Corrected thanks to Muhammad Ishaq
			[instruments addObject:self.currentInstrument]; // Add to the result node
			self.currentInstrument = nil; // Set nil
        }
    }
	*/
    // We reset the currentProperty, for the next textnodes..
    //NSLog(@"current Node: %@",elementName);
    //NSLog(@"current textNodeValue: %@",currentProperty);
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

#pragma mark -


#pragma mark queue methods

-(void)addRequestToQueue:(NSString*)xmlString
{
    [requestQueue addObject:xmlString];
}

-(void)nextRequest
{
    NSLog(@"XMLParser - nextRequest");
    if([requestQueue count]>0 && !busy)
    {
        NSLog(@"XMLParser - parseXMLString: - beginParse");
        busy = YES;
        
        self.currentRequest = [NSMutableString stringWithString:@""];
        self.currentParent = [NSString stringWithString:@""];
   //     NSLog(@"nextRequest - currentParent retainCount: %d",[self.currentParent retainCount]);
        self.currentProperty = [NSMutableString stringWithString:@""];
        if(self.currentEntity==nil){
            NSLog(@"currentEntity not nil");
            self.currentEntity = [[NSMutableDictionary alloc] initWithCapacity:0];//[NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:context];
        }
        [self beginParse:[requestQueue objectAtIndex:0]];
    }else{
        if([requestQueue count]==0){
            NSLog(@"completed queue");
            //ForceMultiplierAppDelegate *appDelegate = (ForceMultiplierAppDelegate*)[[UIApplication sharedApplication] delegate];
            //[[appDelegate rootVC]syncSucceeded];
        }
    }
}

-(void)popRequest
{
    busy = NO;
    [requestQueue removeObjectAtIndex:0];
    [self nextRequest];
}

#pragma -

-(NSDate*) parseDateString:(NSString*)aDateString{
    NSLog(@"a DateString: %@",aDateString);
    aDateString = [aDateString substringToIndex:18];
    NSLog(@"a DateString: %@",aDateString);
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate *newDate = [outputFormatter dateFromString:aDateString];
    
    
	[outputFormatter release];
	
    return newDate;
    // For US English, the output is:
    // newDateString 10:30 on Sunday July 11
}

//*/
- (void)dealloc {
	[responseData release];
	[array release];
	[parsedArray release];
	[urlString release];
//	[xml release];
    [super dealloc];
}
@end

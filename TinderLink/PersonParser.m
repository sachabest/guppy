//
//  PersonParser.m
//  TinderLink
//
//  Created by Sebastian Lozano on 7/3/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import "PersonParser.h"
#import "Person.h"

@interface PersonParser ()

@property NSXMLParser *parser;
@property NSString *element;

//Person Properties
@property NSString* currentFirstName;
@property NSString* currentLastName;
@property NSString* currentHeadline;
@property NSString* currentIndustry;


@end

@implementation PersonParser

- (id) initWithArray: (NSMutableArray *)personArray {
    self = [super init];
    if (self) {
        self.personArray = personArray;
    }
    return self;
}

- (void) parseXMLFile {
    
    
    
}

@end

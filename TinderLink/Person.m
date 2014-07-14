//
//  Person.m
//  TinderLink
//
//  Created by Sebastian Lozano on 7/3/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id) initWithName: (NSString *)firstName
           lastName: (NSString *)lastName
           headline: (NSString *)headline
           industry: (NSString *)industry
              photoURL: (NSURL *) photoURL {
    
    self = [super init];
    
    if (self) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.headline = headline;
        self.industry = industry;
        self.photoURL = photoURL;
    }
    
    return self;
}

@end

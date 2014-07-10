//
//  Person.h
//  TinderLink
//
//  Created by Sebastian Lozano on 7/3/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property NSString* firstName;
@property NSString* lastName;
@property NSString* headline;
//@property NSString* location;
@property NSString* industry;

- (id) initWithName: (NSString *)firstName
           lastName: (NSString *)lastName
           headline: (NSString *)headline
           industry: (NSString *)industry;

@end

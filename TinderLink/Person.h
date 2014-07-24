//
//  Person.h
//  TinderLink
//
//  Created by Sebastian Lozano on 7/3/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Person : NSObject

@property NSString* firstName;
@property NSString* lastName;
@property NSString* headline;
//@property NSString* location;
@property NSString* industry;
@property NSURL* photoURL;
@property NSString* userID;
@property PFUser* parseUser;

//designated initializer
- (id) initWithName: (NSString *)firstName
           lastName: (NSString *)lastName
           headline: (NSString *)headline
           industry: (NSString *)industry
              photoURL: (NSURL *)photoURL
             userID:(NSString *)userID
          parseUser:(PFUser *)parseUser;


@end

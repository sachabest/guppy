//
//  PersonParser.h
//  TinderLink
//
//  Created by Sebastian Lozano on 7/3/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonParser : NSObject

@property NSMutableArray *personArray;

- (id) initWithArray: (NSMutableArray *)personArray;

- (void) parseXMLFile;


@end

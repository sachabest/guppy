//
//  MainViewController.h
//  TinderLink
//
//  Created by Sebastian Lozano on 6/13/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LIALinkedInApplication.h"
#import "LIALinkedInAuthorizationViewController.h"
#import "LIALinkedInHttpClient.h"

@interface MainViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate > {

    NSArray *connectionsInfo;
    NSMutableData *data;
    
}


-(IBAction)logOut:(id)sender;

@end

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
    
}


@property (strong, nonatomic) IBOutlet UILabel *connectionsLabel;
@property(strong, nonatomic) NSMutableArray *connections;
-(IBAction)logOut:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;

@end

//
//  ViewController.m
//  TinderLink
//
//  Created by Sebastian Lozano on 6/11/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "LIALinkedInApplication.h"
#import "LIALinkedInAuthorizationViewController.h"
#import "LIALinkedInHttpClient.h"


@interface ViewController ()

@end

@implementation ViewController

/*d
- (void)viewDidLoad
{
    [super viewDidLoad];
	
}*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        logInViewController.delegate = self;
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        signUpViewController.delegate = self;// Set ourselves as the delegate
        
        LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"http://www.ancientprogramming.com/liaexample"
                                                                        clientId:@"75t78lkjc036lt"
                                                                                    clientSecret:@"dl4C98WcMNyMDSb4"
                                                                                           state:@"DCEEFWF45453sdffef424"
                                                                                   grantedAccess:@[@"r_fullprofile", @"r_emailaddress",@" r_contactinfo"]];
        
        [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:NO completion:NULL];
    } else {
        [self performSegueWithIdentifier:@"toMainScreen" sender:self];
    }
    
    
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

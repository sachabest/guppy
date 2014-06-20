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
#import "Auth0Client.h"


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
    
    

    
    Auth0Client *client = [Auth0Client auth0Client:@"tinderlink.auth0.com"
                                          clientId:@"1zzjGNuROeyCBrKlEZpVWV7mCXSGKTve"];
    
    [client loginAsync:self withCompletionHandler:^(NSMutableDictionary* error) {
        if (error) {
            NSLog(@"Error authenticating: %@", [error objectForKey:@"error"]);
        }
        else {
            
            [self performSegueWithIdentifier:@"toMainScreen" sender:self];
            
            // * Use client.auth0User to do wonderful things, e.g.:
            // - get user email => [client.auth0User.Profile objectForKey:@"email"]
            // - get facebook/google/twitter/etc access token => [[[client.auth0User.Profile objectForKey:@"identities"] objectAtIndex:0] objectForKey:@"access_token"]
            // - get Windows Azure AD groups => [client.auth0User.Profile objectForKey:@"groups"]
            // - etc.
        }
    }];
    

    
    /*
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        
        logInViewController.fields = PFLogInFieldsLogInButton | PFLogInFieldsUsernameAndPassword;
        
        logInViewController.delegate = self;
        
        
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:NO completion:NULL];
    } else {
     
    }*/
    
    
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

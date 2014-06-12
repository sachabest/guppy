//
//  LoginViewController.m
//  TinderLink
//
//  Created by Sebastian Lozano on 6/11/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![PFUser currentUser]) { // No user logged in
        

        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        signUpViewController.delegate = self;// Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [self setSignUpController:signUpViewController];
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [self performSegueWithIdentifier:@"toMainScreen" sender:self];
    
    
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

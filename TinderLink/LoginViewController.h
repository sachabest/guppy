//
//  LoginViewController.h
//  TinderLink
//
//  Created by Sebastian Lozano on 6/11/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import <Parse/Parse.h>

@interface LoginViewController : PFLogInViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIViewControllerTransitioningDelegate>


- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user;


@end

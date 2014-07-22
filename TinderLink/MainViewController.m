//
//  MainViewController.m
//  TinderLink
//
//  Created by Sebastian Lozano on 6/13/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import "MainViewController.h"
#import "MDCSwipeToChoose.h"
#import "Auth0Client.h"
#import "Person.h"
#import "ChoosePersonViewController.h"
#import <Parse/Parse.h>
#pragma mark - Creating and Customizing a MDCSwipeToChooseView

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)presentLogin {
    Auth0Client *client = [Auth0Client auth0Client:@"tinderlink.auth0.com"
                                          clientId:@"1zzjGNuROeyCBrKlEZpVWV7mCXSGKTve"];
    
    [client loginAsync:self withCompletionHandler:^(NSMutableDictionary* error) {
        if (error) {
            NSLog(@"Error authenticating: %@", [error objectForKey:@"error"]);
        }
        else {
            
            // * Use client.auth0User to do wonderful things, e.g.:
            // - get user email => [client.auth0User.Profile objectForKey:@"email"]
            // - get facebook/google/twitter/etc access token => [[[client.auth0User.Profile objectForKey:@"identities"] objectAtIndex:0] objectForKey:@"access_token"]
            // - get Windows Azure AD groups => [client.auth0User.Profile objectForKey:@"groups"]
            // - etc.
            
            self.login = TRUE;
            
            NSString *token = [[[client.auth0User.Profile objectForKey:@"identities"] objectAtIndex:0] objectForKey:@"access_token"];

            
            NSString *url = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/connections?format=json&oauth2_access_token=%@", token];
            
            NSURL *enpoint = [NSURL URLWithString:url];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:enpoint];
            [request setHTTPMethod:@"GET"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            

            dispatch_async(dispatch_get_main_queue(), ^{
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                 {
                     NSError* parseError;
                     NSDictionary *connectionsData =
                     [NSJSONSerialization
                      JSONObjectWithData:data
                      options:kNilOptions
                      error:&parseError];
                     
                     
                     //user's connections
                     NSArray *connectionsArray = [connectionsData objectForKey:@"values"];
                     self.connections = [NSMutableArray array];
                     
                     
                     for (NSDictionary *personDict in connectionsArray) {
                         NSString *firstName = [personDict objectForKey:@"firstName"];
                         NSString *lastName = [personDict objectForKey:@"lastName"];
                         NSString *headline = [personDict objectForKey:@"headline"];
                         NSString *industry = [personDict objectForKey:@"industry"];
                         NSURL *photoURL = [NSURL URLWithString:[personDict objectForKey:@"pictureUrl"]];
                         
                         if (photoURL == nil) {
                             photoURL = [NSURL URLWithString:@"http://cosmichomicide.files.wordpress.com/2013/09/linkedin-default.png"];
                         }
                         
                         if (industry == nil) {
                             industry = @"Not specified";
                         }
                         
                         Person *connection = [[Person alloc] initWithName:firstName lastName:lastName headline:headline industry:industry photoURL:photoURL];
                         
                         
                         
                         [self.connections addObject:connection];
                         
                         PFUser *newUser = [PFUser user];
                         
                         
                         
                     }
                     
                     [self performSegueWithIdentifier:@"toSwipeView" sender:self];
                     
                     
                     
                 }];

            });
  
        }
        
        
    }];
     
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toSwipeView"]) {
        //UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        ChoosePersonViewController *controller = (ChoosePersonViewController *)segue.destinationViewController;
        
        controller.connections = self.connections;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/*
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}*/

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"Couldn't decide, huh?");
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"Photo deleted!");
    } else {
        NSLog(@"Photo saved!");
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)logOut:(id)sender {
    NSLog(@"fired");
    [PFUser logOut];
    [self presentLogin];
    self.login = FALSE;
    
    
    
}
@end

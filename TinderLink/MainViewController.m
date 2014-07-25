//
//  MainViewController.m
//  TinderLink
//
//  Created by Sebastian Lozano on 6/13/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import "MainViewController.h"
#import "ChoosePersonViewController.h"
#import "MDCSwipeToChoose.h"
#import "Auth0Client.h"
#import "Person.h"
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
    if ([PFUser currentUser] == nil) {
        [self presentLogin];
    }
    
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
            
            
            NSString *username = [client.auth0User.Profile objectForKey:@"email"];
            NSString *password = @"dummy";
            NSString *email = [client.auth0User.Profile objectForKey:@"email"];
            NSString *location = [[client.auth0User.Profile objectForKey:@"location"] objectForKey:@"name"];
            NSString *authUserID = [client.auth0User.Profile objectForKey:@"user_id"];
            
            [self signUpUser:username password:password email:email location:location userID:authUserID];
            
            
            //current connections code -- will throw out later
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
                     
                     
                     
                     NSArray *connectionsArray = [connectionsData objectForKey:@"values"];
                     self.connections = [NSMutableArray array];
                     
                     
                     for (NSDictionary *personDict in connectionsArray) {
                         
                         NSString *firstName = [personDict objectForKey:@"firstName"];
                         NSString *lastName = [personDict objectForKey:@"lastName"];
                         NSString *headline = [personDict objectForKey:@"headline"];
                         NSString *industry = [personDict objectForKey:@"industry"];
                         NSURL *photoURL = [NSURL URLWithString:[personDict objectForKey:@"pictureUrl"]];
                        
                         NSString *userID = [personDict objectForKey:@"user_id"];
                         
                         if (photoURL == nil) {
                             photoURL = [NSURL URLWithString:@"http://cosmichomicide.files.wordpress.com/2013/09/linkedin-default.png"];
                         }
                         
                         if (industry == nil) {
                             industry = @"Not specified";
                         }
                         
                         Person *connection = [[Person alloc] initWithName:firstName lastName:lastName headline:headline industry:industry photoURL:photoURL userID:userID parseUser:nil];
                         
                         
                         
                         [self.connections addObject:connection];
                         
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
        self.suggestedConnections = [self suggestedConnections];
        
        controller.suggestedConnections = self.suggestedConnections;
        
    }
}

- (void) signUpUser:(NSString *)username password:(NSString *)password email:(NSString *)email location:(NSString *)location userID:(NSString *)userID {
    
    PFUser *newUser = [PFUser user];
    newUser.username = username;
    newUser.password = password;
    newUser.email = email;
    [newUser setObject:location forKey:@"location"];
    [newUser setObject:userID forKey:@"user_id"];
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error || [[error userInfo][@"error"] isEqualToString:[NSString stringWithFormat:@"username %@ already taken", username]]) {
            [PFUser logInWithUsernameInBackground:newUser.username password:newUser.password
                                            block:^(PFUser *user, NSError *error) {
                                                if (user) {
                                                    // Do stuff after successful login.
                                                    
                                                } else {
                                                    // The login failed. Check error to see why.
                                                    NSString *errorString = [error userInfo][@"error"];
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                                    [alertView show];
                                                }
                                            }];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }];
    
}

- (NSMutableArray *) suggestedConnections {
    
    PFUser *currentUser = [PFUser currentUser];
    NSString *userLocation = [currentUser objectForKey:@"location"];
    
    PFQuery *query = [PFUser query];
    
    //get all suggested connections just by location
    [query whereKey:@"location" equalTo:userLocation];
    NSMutableArray *suggestedConnections = [[query findObjects] mutableCopy];
    
    
    //narrow it down to viable ones (eliminate previous decisions and people who are already connected)
    for (PFUser *user2 in suggestedConnections) {
        
        PFQuery *decisionQuery = [PFQuery queryWithClassName:@"Decision"];
        [decisionQuery whereKey:@"user1" equalTo:currentUser];
        [decisionQuery whereKey:@"user2" equalTo:user2];
        
        PFObject *filteredDecision = [decisionQuery getFirstObject];
        
        
        if (filteredDecision != nil) {
            if ([filteredDecision objectForKey:@"choice1"] != nil && [filteredDecision objectForKey:@"choice2"] != nil) {
                 [suggestedConnections removeObject:user2];
                 continue;
            }
        }
        
        NSString *userID = [user2 objectForKey:@"user_id"];
        for (Person *connection in self.connections) {
            if ([connection.userID isEqualToString:userID]) {
                [suggestedConnections removeObject:user2];
                continue;
            }
        }
    }
    
    return suggestedConnections;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
}
@end

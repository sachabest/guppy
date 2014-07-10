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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // You can customize MDCSwipeToChooseView using MDCSwipeToChooseViewOptions.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.likedText = @"Keep";
    options.likedColor = [UIColor blueColor];
    options.nopeText = @"Delete";
    options.onPan = ^(MDCPanState *state){
        if (state.thresholdRatio == 1.f && state.direction == MDCSwipeDirectionLeft) {
            NSLog(@"Let go now to delete the photo!");
        }
    };
    
    MDCSwipeToChooseView *view = [[MDCSwipeToChooseView alloc] initWithFrame:self.view.bounds
                                                                     options:options];
    view.imageView.image = [UIImage imageNamed:@"photo"];
    [self.view addSubview:view];
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
            
            NSString *token = [[[client.auth0User.Profile objectForKey:@"identities"] objectAtIndex:0] objectForKey:@"access_token"];

            
            NSString *url = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/connections?format=json&oauth2_access_token=%@", token];
            
            NSURL *enpoint = [NSURL URLWithString:url];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:enpoint];
            [request setHTTPMethod:@"GET"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            /*[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
             {
                 NSError* parseError;
                 NSMutableDictionary *parseData = [[NSMutableDictionary alloc] initWithDictionary:
                                                   [NSJSONSerialization
                                                                        JSONObjectWithData:data
                                                                          options:kNilOptions
                                                                         error:&parseError]];
             

                 
             */
        }
        
        
    }];
}


        
        
    
    
     
     

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    data = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData {
    [data appendData:theData];
}

-(void)connectionDidFinishLoading: (NSURLConnection *)connection {
    NSMutableDictionary *parseData = [[NSMutableDictionary alloc] initWithDictionary:
                                      [NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:kNilOptions
                                       error:nil]];
    
    
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
    
    
}
@end

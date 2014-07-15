//
//  SwipeToChooseViewController.m
//  TinderLink
//
//  Created by Sebastian Lozano on 7/14/14.
//  Copyright (c) 2014 Me. All rights reserved.
//

#import "SwipeToChooseViewController.h"
#import "MDCSwipeToChoose.h"
#import "Auth0Client.h"
#import "Person.h"

@interface SwipeToChooseViewController ()

@end

@implementation SwipeToChooseViewController

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
    
    
    for (int i = 0; i < self.connections.count; i++) {

        
        MDCSwipeToChooseView *view = [[MDCSwipeToChooseView alloc] initWithFrame:self.view.bounds
                                                                         options:options];
        Person *currentPerson = [self.connections objectAtIndex:i];
        
        NSURL *profilePictureURL = currentPerson.photoURL;
        view.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:profilePictureURL]];
        [self.view addSubview:view];
        
        
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

@end

//
//  ViewController.m
//  SampleProject
//
//  Created by URMANI on 10/4/17.
//  Copyright © 2017 URMANI. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <GIDSignInDelegate, GIDSignInUIDelegate>

@end

@implementation ViewController

#pragma mark - View life cycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

-(void)commonInit{
    
    [GIDSignInButton class];
    
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.shouldFetchBasicProfile = YES;
    signIn.delegate = self;
    signIn.uiDelegate = self;

    self.service = [[GTLRYouTubeService alloc] init];

}

#pragma mark - GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error) {
        NSLog(@"error = %@",error);
        return;
    }
    [self reportAuthStatus];
    [self updateButtons];
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error) {
        NSLog(@"error = %@",error);
    } else {
        NSLog(@"Status: Disconnected ");
    }
    [self reportAuthStatus];
    [self updateButtons];
}

- (void)presentSignInViewController:(UIViewController *)viewController {
    [[self navigationController] pushViewController:viewController animated:YES];
}

#pragma mark - Helper methods

// Updates the GIDSignIn shared instance and the GIDSignInButton
// to reflect the configuration settings that the user set

// Temporarily force the sign in button to adopt its minimum allowed frame
// so that we can find out its minimum allowed width (used for setting the
// range of the width slider).
- (CGFloat)minimumButtonWidth {
    CGRect frame = self.signInButton.frame;
    self.signInButton.frame = CGRectZero;
    
    CGFloat minimumWidth = self.signInButton.frame.size.width;
    self.signInButton.frame = frame;
    
    return minimumWidth;
}

- (void)reportAuthStatus {
    GIDGoogleUser *googleUser = [[GIDSignIn sharedInstance] currentUser];
    if (googleUser.authentication) {
        NSLog(@"Status: Authenticated");
    } else {
        NSLog(@"Status: Not Authenticated");
        // To authenticate, use Google+ sign-in button.
    }
    
    [self refreshUserInfo];
}

// Update the interface elements containing user data to reflect the
// currently signed in user.
- (void)refreshUserInfo {
    if ([GIDSignIn sharedInstance].currentUser.authentication == nil) {
       // self.userName.text = kPlaceholderUserName;
       // self.userEmailAddress.text = kPlaceholderEmailAddress;
       // self.userAvatar.image = [UIImage imageNamed:kPlaceholderAvatarImageName];
        return;
    }
    
    NSLog(@"Email = %@",[GIDSignIn sharedInstance].currentUser.profile.email);
    NSLog(@"Email = %@",[GIDSignIn sharedInstance].currentUser.profile.name);
    
    self.service.authorizer = [GIDSignIn sharedInstance].currentUser.authentication.fetcherAuthorizer;
    [self fetchChannelResource];

   // SearchVideoVC *searchVideoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchVideoVC"];
  //  [self.navigationController pushViewController:searchVideoVC animated:TRUE];
    
    if (![GIDSignIn sharedInstance].currentUser.profile.hasImage) {
        // There is no Profile Image to be loaded.
        return;
    }
    // Load avatar image asynchronously, in background
    
 /*   dispatch_queue_t backgroundQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __weak SignInViewController *weakSelf = self;
    
    dispatch_async(backgroundQueue, ^{
        NSUInteger dimension = round(self.userAvatar.frame.size.width * [[UIScreen mainScreen] scale]);
        NSURL *imageURL =
        [[GIDSignIn sharedInstance].currentUser.profile imageURLWithDimension:dimension];
        NSData *avatarData = [NSData dataWithContentsOfURL:imageURL];
        
        if (avatarData) {
            // Update UI from the main thread when available
            dispatch_async(dispatch_get_main_queue(), ^{
                SignInViewController *strongSelf = weakSelf;
                if (strongSelf) {
                    strongSelf.userAvatar.image = [UIImage imageWithData:avatarData];
                }
            });
        }
    }); */
    
    
}

// Adjusts "Sign in", "Sign out", and "Disconnect" buttons to reflect
// the current sign-in state (ie, the "Sign in" button becomes disabled
// when a user is already signed in).
- (void)updateButtons {
    BOOL authenticated = ([GIDSignIn sharedInstance].currentUser.authentication != nil);
    
    self.signInButton.enabled = !authenticated;
  //  self.signOutButton.enabled = authenticated;
    
    if (authenticated) {
        self.signInButton.alpha = 0.5;
    } else {
        self.signInButton.alpha = 1.0;
    }
}

// Construct a query and retrieve the channel resource for the GoogleDevelopers
// YouTube channel. Display the channel title, description, and view count.
- (void)fetchChannelResource {
    
    GTLRYouTubeQuery_ChannelsList *query = [GTLRYouTubeQuery_ChannelsList queryWithPart:@"snippet,statistics"];
    
    //query.identifier = @"AIzaSyChvKwY7yRnT6JuDSgd9RKdjXaY6huF-iY";
    // To retrieve data for the current user's channel, comment out the previous
    // line (query.identifier ...) and uncomment the next line (query.mine ...).
    // query.mine = true;
    
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}

// Process the response and display output
- (void)displayResultWithTicket:(GTLRServiceTicket *)ticket
             finishedWithObject:(GTLRYouTube_ChannelListResponse *)channels
                          error:(NSError *)error {
    if (error == nil) {
        NSMutableString *output = [[NSMutableString alloc] init];
        if (channels.items.count > 0) {
            [output appendString:@"Channel information:\n"];
            for (GTLRYouTube_Channel *channel in channels) {
                NSString *title = channel.snippet.title;
                NSString *description = channel.snippet.description;
                NSNumber *viewCount = channel.statistics.viewCount;
                [output appendFormat:@"Title: %@\nDescription: %@\nViewCount: %@\n", title, description, viewCount];
            }
        } else {
            [output appendString:@"Channel not found."];
        }
        
        NSLog(@"output = %@",output);
        
       // self.output.text = output;
    } else {
        
        NSLog(@"error.localizedDescription = %@",error.localizedDescription);
        
        [self showAlert:@"Error" message:error.localizedDescription];
    }
}



// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

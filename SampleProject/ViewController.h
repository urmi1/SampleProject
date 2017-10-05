//
//  ViewController.h
//  SampleProject
//
//  Created by URMANI on 10/4/17.
//  Copyright © 2017 URMANI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
//#import <Google/SignIn.h>
#import "SearchVideoVC.h"


@interface ViewController : UIViewController <GIDSignInDelegate>

@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (nonatomic, strong) GTLRYouTubeService *service;


@end


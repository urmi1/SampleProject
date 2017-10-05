//
//  AppDelegate.h
//  SampleProject
//
//  Created by URMANI on 10/4/17.
//  Copyright © 2017 URMANI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import "ViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;


@end


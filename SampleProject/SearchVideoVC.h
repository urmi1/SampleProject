//
//  SearchVideoVC.h
//  SampleProject
//
//  Created by URMANI on 10/4/17.
//  Copyright © 2017 URMANI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchVideoCell.h"
#import <GTLRYouTube.h>
#import <Google/SignIn.h>

@interface SearchVideoVC : UIViewController

@property (nonatomic, strong) NSMutableArray *arrSearchVideos;
@property (nonatomic, weak) IBOutlet UITableView *tblSearch;

@property (nonatomic, strong) UITextView *output;
@property (nonatomic, strong) GTLRYouTubeService *service;


@end

//
//  SearchVideoVC.m
//  SampleProject
//
//  Created by URMANI on 10/4/17.
//  Copyright © 2017 URMANI. All rights reserved.
//

#import "SearchVideoVC.h"

@interface SearchVideoVC ()

@end

@implementation SearchVideoVC

#pragma mark - View life cycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"viewDidLoadviewDidLoad");
    
    self.arrSearchVideos = [[NSMutableArray alloc] init];
    
    // Create a UITextView to display output.
    self.output = [[UITextView alloc] initWithFrame:CGRectMake(0, 70, 300, 40)];
    self.output.editable = false;
    [self.output setBackgroundColor:[UIColor redColor]];
   // self.output.contentInset = UIEdgeInsetsMake(20.0, 50.0, 20.0, 0.0);
    self.output.hidden = false;
    [self.view addSubview:self.output];
    
    NSLog(@"HI = %@",[GIDSignIn sharedInstance].currentUser.authentication.fetcherAuthorizer);
    

    // Initialize the service object.
    self.service = [[GTLRYouTubeService alloc] init];
    
    self.service.authorizer = [GIDSignIn sharedInstance].currentUser.authentication.fetcherAuthorizer;
    [self fetchChannelResource];

}


// Construct a query and retrieve the channel resource for the GoogleDevelopers
// YouTube channel. Display the channel title, description, and view count.
- (void)fetchChannelResource {
    GTLRYouTubeQuery_ChannelsList *query =
    [GTLRYouTubeQuery_ChannelsList queryWithPart:@"snippet,statistics"];
    query.identifier = @"907109971285-j6o3q0of3jqe327g6vher2k5m8334g18.apps.googleusercontent.com";
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
        self.output.text = output;
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


#pragma mark - UITableview Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrSearchVideos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"SearchVideoCell";
    SearchVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchVideoCell" owner:self options:nil] objectAtIndex:0];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


@end

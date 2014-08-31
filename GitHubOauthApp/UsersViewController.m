//
//  UsersViewController.m
//  GitHubOauthApp
//
//  Created by Victor  Adu on 8/29/14.
//  Copyright (c) 2014 Victor  Adu. All rights reserved.
//

#import "UsersViewController.h"
#import "NetworkController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "User.h"

@interface UsersViewController () <NetworkControllerDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *myUserFollowers;
@property (weak, nonatomic) IBOutlet UITableView *userstableView;

@end

@implementation UsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.networkController.delegate = self;
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.myUserFollowers == nil) {
        NSString *urlString = [NSString stringWithFormat:kGitHubOAuthURL, kGitHubClientID, kGitHubCallbackURI, @"user,repo"];
        NSLog(@"%@", urlString);
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }
}

-(void)followersFinishedParsing:(NSArray *)jsonArray {
    NSMutableArray *followers = [[NSMutableArray alloc]init];
    
    for (NSDictionary *followerDict in jsonArray) {
        User *follower = [[User alloc]initFromDictionary:followerDict];
        [followers addObject:follower];
        
    }
    self.myUserFollowers = followers;
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [self.userstableView reloadData];
    }];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myFollowerCell" forIndexPath:indexPath];
    
    User *follower = self.myUserFollowers[indexPath.row];
    cell.textLabel.text = follower.avatarURL;
    cell.textLabel.adjustsFontSizeToFitWidth = true;
    cell.imageView.image = follower.avatarImage;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myUserFollowers.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

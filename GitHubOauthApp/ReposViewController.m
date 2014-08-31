//
//  ReposViewController.m
//  GitHubOauthApp
//
//  Created by Victor  Adu on 8/29/14.
//  Copyright (c) 2014 Victor  Adu. All rights reserved.
//

#import "ReposViewController.h"
#import "NetworkController.h"
#import "AppDelegate.h"
#import "Constants.h"


@interface ReposViewController () <UITableViewDataSource, UITableViewDelegate, NetworkControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *reposTableView;
@property (strong, nonatomic) NSMutableArray *myRepos;

@end

@implementation ReposViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.networkController.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.myRepos == nil) {
        NSString *urlString = [NSString stringWithFormat:kGitHubOAuthURL, kGitHubClientID, kGitHubCallbackURI, @"user,repo"];
        NSLog(@"%@", urlString);
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }
}

#pragma UTableViewDataSource methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myRepos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repoCell" forIndexPath:indexPath];
    
    Repository *repo = self.myRepos[indexPath.row];
    
    cell.textLabel.text = repo.name;
    cell.detailTextLabel.text = repo.language;
    
    return cell;
}

#pragma NetworkControllerDelegate Method
//We need to implement this to conform to the 'NetworkControllerDelegate' protocol
-(void)reposFinishedParsing:(NSArray *)jsonArray {
    NSMutableArray *repos = [[NSMutableArray alloc]init];
    
    for (NSDictionary *repoDict in jsonArray) {
        Repository *repo = [[Repository alloc]initFromDictionary:repoDict];
        [repos addObject:repo];
    }
    
    self.myRepos = repos;
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        self.reposTableView.hidden = false;
        
        [self.reposTableView reloadData];
    }];
};

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

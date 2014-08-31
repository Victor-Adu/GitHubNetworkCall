//
//  SearchViewController.m
//  GitHubOauthApp
//
//  Created by Victor  Adu on 8/30/14.
//  Copyright (c) 2014 Victor  Adu. All rights reserved.
//

#import "SearchViewController.h"
#import "NetworkController.h"
#import "Constants.h"
#import "Repository.h"
#import "User.h"
#import "Follower.h"
#import "CollectionViewController.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];

}

#pragma UITabeViewDataSource Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"githubSearch" forIndexPath:indexPath];
    
    
    
    if (self.searchBar.selectedScopeButtonIndex == 0) {
        Repository *result = self.searchResults[indexPath.row];
        if (result) {
            cell.textLabel.text = result.name;
            cell.textLabel.adjustsFontSizeToFitWidth = true;
            cell.detailTextLabel.text = result.language;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = true;
        } else {
            cell.textLabel.text = @"Nothing Found";
        }
    } else if (self.searchBar.selectedScopeButtonIndex == 1) {
        Follower *result = self.searchResults[indexPath.row];
        if (result) {
            cell.textLabel.text = result.name;
        } else {
            cell.textLabel.text = @"Nothing Found";
        }
    } else {
        User *result = self.searchResults[indexPath.row];
        if (result) {
            cell.textLabel.text = result.htmlURL;
        } else {
            cell.textLabel.text = @"Nothing Found";
        }
    }
    return cell;
}

#pragma UITableViewDelegate Method
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self performSegueWithIdentifier:@"UserCollectionCell" sender:self];  ///---

}


#pragma PrepareForSegue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"UserCollectionCell"])
    {
        NSString *collectionVC = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        collectionVC = selectedIndexPath;
    }
}



-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchTerm = searchBar.text;
    [searchBar resignFirstResponder];
    self.tableView.hidden = true;
    
    if (searchBar.selectedScopeButtonIndex == 0) {
        NSString *repositories = @"Repository";
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        
        
      ///  activityIndicator.center = self.collectionView.center;  ///---
        [activityIndicator startAnimating];
        [self.view addSubview:activityIndicator];
        
        [NetworkController fetchRepositoriesForSearchTerm:searchTerm forEndPoint:repositories withCompletion:^(NSArray *repositories, NSString *errorDescription) {
            _searchResults = repositories;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"Reloading Table");
                [activityIndicator stopAnimating];
                
                [self.tableView reloadData];
        }];
    }];
        
    } else if (searchBar.selectedScopeButtonIndex == 1) {
        NSString *code = @"Followers";
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        
        [NetworkController fetchRepositoriesForSearchTerm:searchTerm forEndPoint:code withCompletion:^(NSArray *repositories, NSString *errorDescription) {
            _searchResults = repositories;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"Reloading Table");
                [activityIndicator stopAnimating];
                
                [self.tableView reloadData];
            }];
        }];

    } else if (searchBar.selectedScopeButtonIndex == 2){
        NSString *code = @"Users";

        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
        //activityIndicator.center = self.collectionView.center;  ///---
        [activityIndicator startAnimating];
        [self.view addSubview:activityIndicator];
        
        [NetworkController fetchRepositoriesForSearchTerm:searchTerm forEndPoint:code withCompletion:^(NSArray *repositories, NSString *errorDescription) {
            _searchResults = repositories;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"Reloading Table");
                [activityIndicator stopAnimating];
                
                [self.tableView reloadData];
            }];
        }];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = YES;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = NO;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

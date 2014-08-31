//
//  CollectionViewController.m
//  GitHubOauthApp
//
//  Created by Victor  Adu on 8/30/14.
//  Copyright (c) 2014 Victor  Adu. All rights reserved.
//

#import "CollectionViewController.h"
#import "User.h"
#import "UsersCollectionCell.h"
#import "SearchViewController.h"


@interface CollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *mySearchResults;

///How do I make 'searchResults' from CollectionViewController accessible to this 'CollectionViewController'????


@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /// Try and set 'mySearchResults' to 'searchResults' from 'SearchViewController'....How...???
   
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UsersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCollectionCell" forIndexPath:indexPath];
    
        User *user = self.mySearchResults[indexPath.row];
    
    
        cell.imageView.image = user.avatarImage;  ///----
        cell.loginLabel.text = user.login;               ///---
        cell.loginLabel.adjustsFontSizeToFitWidth = true;    ///---
    
    return cell;
    }


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.mySearchResults.count;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

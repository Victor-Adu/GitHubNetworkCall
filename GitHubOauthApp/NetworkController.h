//
//  NetworkController.h
//  GitHubOauthApp
//
//  Created by Victor  Adu on 8/26/14.
//  Copyright (c) 2014 Victor  Adu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Repository.h"

@protocol NetworkControllerDelegate <NSObject>

@optional
-(void)reposFinishedParsing:(NSArray *)jsonArray;
-(void)followersFinishedParsing:(NSArray *)jsonArray;
-(void) usersFinishedParsing:(NSArray *)jsonArray;

@end

@interface NetworkController : NSObject

+(void)fetchRepositoriesForSearchTerm:(NSString *)searchterm forEndPoint:(NSString *)endPoint withCompletion:(void(^)(NSArray *repositories, NSString *errorDescription))completionHandler;

-(void)handleCallBackURL:(NSURL *)url;

@property (nonatomic, weak) id<NetworkControllerDelegate> delegate;


@end

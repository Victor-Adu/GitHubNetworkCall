//
//  Constants.m
//  GitHubOauthApp
//
//  Created by Victor  Adu on 8/26/14.
//  Copyright (c) 2014 Victor  Adu. All rights reserved.
//

#import "Constants.h"

@implementation Constants
//Putting 'k' infront of the constant is just a convention
NSString *const kGitHubClientID = @"25e0ca38d3eeee70dfed";
NSString *const kGitHubClientSecret = @"2e41c9ed5b5ff32f6d418d8fb178d18b50bc2159";
NSString *const kGitHubCallbackURI = @"githuboauth://git_callback";
NSString *const kGitHubOAuthURL = @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@";

@end

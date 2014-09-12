//
//  NetworkController.m
//  GitHubOauthApp
//
//  Created by Victor  Adu on 8/26/14.
//  Copyright (c) 2014 Victor  Adu. All rights reserved.
//

#import "NetworkController.h"
#import "Constants.h"
#import "Repository.h"
#import "User.h"
#import "Follower.h"


@interface NetworkController ()

@property (strong,nonatomic) NSURLSession *session;
@property (strong,nonatomic) NSString *token;

@end

@implementation NetworkController

-(instancetype)init {
    if (self = [super init]) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}


//Make network call to github API
+(void)fetchRepositoriesForSearchTerm:(NSString *)searchterm forEndPoint:(NSString *)endPoint withCompletion:(void(^)(NSArray *repositories, NSString *errorDescription))completionHandler;{
    
    //https://api.github.com/search/repositories?&sort=stars&order=desc&q=
    
    NSString *mainDomain = (@"https://api.github.com/search/");
    NSString *myEndPoint = (@"%@", endPoint);
    NSString *parameters = [[NSString alloc] init];
    
    if ([endPoint isEqualToString:@"repositories"]) {
        parameters = (@"?&order=desc&sort=stars");
    } else if ([endPoint isEqualToString:@"followers"]) {   ///---Check
        parameters = (@"?&order=desc&sort=indexed");
    } else {
        parameters = (@"?&order=desc&sort=followers");
    }
    
    NSString *searchTermURL = ([@"&q=" stringByAppendingString:(@"%@", searchterm)]);
    NSString *newsearchTermURL = [searchTermURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    
    NSString *urlString = [[[mainDomain stringByAppendingString:myEndPoint]
                            stringByAppendingString:parameters]
                           stringByAppendingString:newsearchTermURL];

    
    NSLog(@"%@", urlString);
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"General Error");
            NSLog(@"%@", error.localizedDescription);
        } else {
            if ([response respondsToSelector:@selector(statusCode)]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSInteger responseCode = [httpResponse statusCode];
                switch (responseCode) {
                    case 200:
                        NSLog(@"Everything Looks Great");
                        completionHandler([NetworkController parseSuccessfulResponse:data andEndPoint:endPoint], nil);
                        break;
                    case 400:
                        completionHandler(nil, @"400 Bad Parameters: Error in fetching data");
                        break;
                    case 401:
                        completionHandler(nil, @"401 Unauthorized: Authentication is required");
                        break;
                    case 403:
                        completionHandler(nil, @"403 Forbidden: Request was valid, but server refuses to respond");
                        break;
                    case 404:
                        completionHandler(nil, @"404 Not found: Requested resource not found");
                        break;
                    case 500:
                        completionHandler(nil, @"500: Error in fetching data. Try again next time");
                        break;
                    default:
                        NSLog(@"Request Error. Try again next time");
                        break;
                }
            } else {
                NSLog(@"Invalid Response Object: %@", response);
                completionHandler(nil, @"5xx Unknown Server Error");
            }
        }
    }];
    [dataTask resume];
    
}


//Parse through the fetched JSON GitHub data
+(NSArray *) parseSuccessfulResponse:(NSData *)responseData andEndPoint:(NSString *)endPoint {
    NSMutableArray *fetchedResponse = [[NSMutableArray alloc]init];
    
    NSError *error = nil;
    NSDictionary *itemDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    if (error != nil) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    NSArray *parseJSONArray = itemDict[@"items"];
    
    for (NSDictionary *responseDict in parseJSONArray) {
        
        if ([endPoint isEqualToString:@"repositories"])  {
            Repository *repo = [[Repository alloc]initFromDictionary:responseDict];
            [fetchedResponse addObject:repo];
        } else if ([endPoint isEqualToString:@"followers"]) {   ///---- Check
            Follower *followers = [[Follower alloc]initFromDictionary:responseDict];
            [fetchedResponse addObject:followers];
        } else {
            User *user = [[User alloc]initFromDictionary:responseDict];
            [fetchedResponse addObject:user];
        }
        
    }
    
    return fetchedResponse;
}


-(void)handleCallBackURL:(NSURL *)url {
    NSLog(@" %@",url);
    //parsing the url given back to us after login
    NSString *query = url.query;
    NSArray *components = [query componentsSeparatedByString:@"code="];  ///---
   
    //this is our temp code
    NSString *code = components.lastObject;
    
    //setting up our parameters for our POST
    NSString *postString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@",kGitHubClientID,kGitHubClientSecret,code];
    
    //convert the parameters to data for sending
    NSData *data = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
   
    //get the length
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[data length]];
  
    //creating our request for our data task
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //set a bunch properties on our request
    [request setURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]];
    [request setHTTPMethod:@"POST"];
    
    //we need the length of the data we are posting
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //tell it the type of data
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    NSURLSessionDataTask *postDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //log error
        if (error) {
            NSLog(@" %@",error.localizedDescription);
        } else {
            NSLog(@" %@", response);
            self.token = [self convertDataToToken:data];
            NSLog(@"%@",self.token);
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            
            //once we set this field, all calls made with this session are authenticated
            [configuration setHTTPAdditionalHeaders:@{@"Authorization": [NSString stringWithFormat:@"token %@",self.token]}];
            
            self.session = [NSURLSession sessionWithConfiguration:configuration];
            
            [self fetchReposUsersFollowers];
        }
        
    }];
    [postDataTask resume];
}

-(NSString *)convertDataToToken:(NSData *)data {
    
    //parsing the data we got back, turning it into a string first
    NSString *response = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    //cutting it in half at the &
    NSArray *tokenComponents = [response componentsSeparatedByString:@"&"];
    NSString *tokenWithCode = tokenComponents[0];
    //cutting it in half again at the =
    NSArray *tokenArray = [tokenWithCode componentsSeparatedByString:@"="];
    return tokenArray.lastObject;
    
}

-(void)fetchReposUsersFollowers{  ///----
    
    NSURL *repoURL = [[NSURL alloc] initWithString:@"https://api.github.com/user/repos"];
    NSURL *userURL = [[NSURL alloc]initWithString:@"https://api.github.com/user"];
    NSURL *followerURL = [[NSURL alloc]initWithString:@"https://api.github.com/user/followers"]; ///---

    //For Repos
    [[self.session dataTaskWithURL:repoURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSLog(@"%@", response);
        }
        NSArray *reposJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(reposFinishedParsing:)]) {
            [self.delegate reposFinishedParsing:reposJson];
        }
    }] resume];
    
    //For Users
    [[self.session dataTaskWithURL:userURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSLog(@"%@", response);
        }
        NSArray *followersJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(followersFinishedParsing:)]) {
            [self.delegate followersFinishedParsing:followersJson];
        }
    }] resume];
    
    //For Follower(s)
    [[self.session dataTaskWithURL:followerURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSLog(@"%@", response);
        }
        NSArray *followersJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(followersFinishedParsing:)]) {
            [self.delegate followersFinishedParsing:followersJson];
        }
    }] resume];
}

-(void)beginOAuth {
    self.token = [[NSUserDefaults standardUserDefaults]objectForKey:kGitHubAuthToken];
    if (!self.token) {
        NSString *urlString = [NSString stringWithFormat:kGitHubOAuthURL, kGitHubClientID, kGitHubCallbackURI, @"user,repo"];
        NSLog(@"%@", urlString);
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    } else {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [configuration setHTTPAdditionalHeaders:@{@"Authorization": [NSString stringWithFormat:@"token %@", self.token]}];
        self.session = [NSURLSession sessionWithConfiguration:configuration];
        [self fetchReposUsersFollowers];
    }
    
}

-(void)createRepoWithName:(NSString *)repoName {
    NSDictionary *post = @{@"name": repoName};
    NSData *data = [NSJSONSerialization dataWithJSONObject:post options:0 error:nil];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:@"https://api.github.com/user/repos"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:[NSString stringWithFormat:@"token %@", self.token] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"%@", responseData);
}


@end

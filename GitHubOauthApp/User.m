//
//  User.m
//  GitHubOauthApp
//
//  Created by Victor  Adu on 8/29/14.
//  Copyright (c) 2014 Victor  Adu. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)initFromDictionary:(NSDictionary*)myDict{
    self = [super init];
    
    if (self){
        _login = [myDict objectForKey:@"login"];
        _avatarURL = [myDict objectForKey:@"avatar_url"];
        _htmlURL = [myDict objectForKey:@"html_url"];
        _followersURL = [myDict objectForKey:@"followers_url"];
        
        NSURL *avatarURL = [NSURL URLWithString:self.avatarURL];
        NSData *data = [NSData dataWithContentsOfURL:avatarURL];
        self.avatarImage = [UIImage imageWithData:data];
    }
    return self;
}



@end

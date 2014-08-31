//
//  Follower.m
//  GitHubOauthApp
//
//  Created by Victor  Adu on 8/29/14.
//  Copyright (c) 2014 Victor  Adu. All rights reserved.
//

#import "Follower.h"

@implementation Follower

-(instancetype)initFromDictionary:(NSDictionary*)myDict;
{
    self = [super self];
    
    if (self) {
        _name = [myDict objectForKey:@"login"]; //This line is same as below.
        _html_url = myDict[@"html_url"];
    }
    return self;
}

@end

//
//  Repository.m
//  GitHubOauthApp
//
//  Created by Victor  Adu on 8/29/14.
//  Copyright (c) 2014 Victor  Adu. All rights reserved.
//

#import "Repository.h"

@implementation Repository

-(instancetype)initFromDictionary:(NSDictionary*)myDict;
{
    self = [super init];
    
    if (self){
        
        self.name = myDict[@"name"];
        self.htmlURL = myDict[@"html_url"];
        self.myDescription = @"Test";
        self.language = [myDict objectForKey:@"language"]; //Same as "myDict[@"language"];"
        
        NSDictionary *owner = myDict[@"owner"];
        self.login = owner[@"login"];
        self.url = owner[@"url"];
        
    }
    
    return self;
}

@end


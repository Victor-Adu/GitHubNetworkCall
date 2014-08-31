//
//  Follower.h
//  GitHubOauthApp
//
//  Created by Victor  Adu on 8/29/14.
//  Copyright (c) 2014 Victor  Adu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Follower : NSObject

@property (readonly) NSString *name;
@property (readonly) NSString *html_url;

-(instancetype)initFromDictionary:(NSDictionary*)myDict;

@end

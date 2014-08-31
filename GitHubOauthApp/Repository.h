//
//  Repository.h
//  GitHubOauthApp
//
//  Created by Victor  Adu on 8/29/14.
//  Copyright (c) 2014 Victor  Adu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repository : NSObject

@property(nonatomic,retain) NSString * url;
@property(nonatomic,retain) NSString * htmlURL;
@property(nonatomic,retain) NSString * myDescription;
@property(nonatomic,retain) NSString * language;
@property(nonatomic,retain) NSString * login;
@property(nonatomic,retain) NSString * name;

-(instancetype)initFromDictionary:(NSDictionary*)dictionary;

@end

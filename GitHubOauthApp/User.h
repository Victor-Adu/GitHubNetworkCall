//
//  User.h
//  GitHubOauthApp
//
//  Created by Victor  Adu on 8/29/14.
//  Copyright (c) 2014 Victor  Adu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (readonly) NSString *login;
@property (readonly) NSString *avatarURL;
@property (readonly) NSString *htmlURL;
@property (strong, nonatomic) NSString *followersURL;
@property (nonatomic) UIImage *avatarImage;


-(instancetype)initFromDictionary:(NSDictionary*)dictionary;

@end

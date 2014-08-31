//
//  AppDelegate.h
//  GitHubOauthApp
//
//  Created by Victor  Adu on 8/26/14.
//  Copyright (c) 2014 Victor  Adu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NetworkController *networkController;


@end


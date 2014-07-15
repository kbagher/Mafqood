//
//  AppDelegate.h
//  MafqoodApp
//
//  Created by Kassem M. Bagher on 27/4/13.
//  Copyright (c) 2013 Mafqood. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *nav;
@property BOOL ShowAllCountries;
@property BOOL AppFirstLaunch;

@end

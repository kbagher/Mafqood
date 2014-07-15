//
//  AppDelegate.m
//  MafqoodApp
//
//  Created by Kassem M. Bagher on 27/4/13.
//  Copyright (c) 2013 Mafqood. All rights reserved.
//

#import "AppDelegate.h"

#import "PostViewController.h"

@implementation AppDelegate
@synthesize ShowAllCountries;

void uncaughtExceptionHandler(NSException *exception) {
    [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    
    self.ShowAllCountries=NO;
    application.applicationSupportsShakeToEdit = YES;

    
    [Parse setApplicationId:@"AppID" clientKey:@"ClinetID"];

    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    // Live Key: QWVBCQ3Y825W6BJGMFQM
    // Dev Key:  J8GBW2GQ7RY88S6WYFNQ

    [Flurry startSession:@"FlurryAPIKey"];

    
    
    [Flurry setSecureTransportEnabled:YES];
    [Flurry setCrashReportingEnabled:YES];
    [Flurry setSessionReportsOnPauseEnabled:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Override point for customization after application launch.
    UIViewController *viewController1 = [[PostViewController alloc] initWithNibName:@"PostViewController" bundle:nil];
    
    self.nav = [[UINavigationController alloc] initWithRootViewController:viewController1];
    self.nav.navigationBar.tintColor = [UIColor whiteColor];

    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:40.0/255.0 green:153.0/255.0 blue:147.0/255.0 alpha:1]];
//    [[UINavigationItem a]]
    
    [Flurry logAllPageViews:self.nav];
    self.window.rootViewController = self.nav;
    self.window.tintColor = [UIColor colorWithRed:7.0/255.0 green:130.0/255.0 blue:35.0/255.0 alpha:1];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if ([[PFUser currentUser] isAuthenticated])
    {
        NSLog(@"Sendening Notification Broadcast");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTheData" object:self];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown))
        return YES;
    
    return NO;
}

@end

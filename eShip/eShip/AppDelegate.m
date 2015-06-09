//
//  AppDelegate.m
//  eShip
//
//  Created by Bin Lang on 5/7/15.
//  Copyright (c) 2015 eShip. All rights reserved.
//

#import "AppDelegate.h"
#import "APIKey.h"
#import <MAMapKit/MAMapKit.h>
#import <CoreData/CoreData.h>
#import "TheSidebarController.h"
#import "LeftViewController.h"
#import "MapViewController.h"
#import "CRGradientNavigationBar.h"
#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue&0xFF0000)>>16))/255.0 green:((float)((rgbValue&0xFF00)>>8))/255.0 blue:((float)(rgbValue&0xFF))/255.0 alpha:1.0]

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self configureAPIKey];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[CRGradientNavigationBar class] toolbarClass:nil];
    
    UIColor *firstColor = UIColorFromRGB(0x52EDC7);
    UIColor *secondColor = UIColorFromRGB(0x5AC8FB);
    
    NSArray *colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
    
    [[CRGradientNavigationBar appearance] setBarTintGradientColors:colors];
    [[navigationController navigationBar] setTranslucent:NO]; // Remember, the default value is YES.
    MapViewController *contentViewController = [[MapViewController alloc] init];
    [navigationController setViewControllers:@[contentViewController]];
    navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    navigationController.view.layer.shadowOffset = (CGSize){0.0, 0.0};
    navigationController.view.layer.shadowOpacity = 0.8;
    navigationController.view.layer.shadowRadius = 10.0;
    
    LeftViewController *leftSidebarViewController = [[LeftViewController alloc] init];
    leftSidebarViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"left-menu.png"]];
    
    TheSidebarController *sidebarController = [[TheSidebarController alloc] initWithContentViewController:navigationController leftSidebarViewController:leftSidebarViewController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = sidebarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end

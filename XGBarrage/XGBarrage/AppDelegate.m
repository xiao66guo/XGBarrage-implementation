//
//  AppDelegate.m
//  XGBarrage
//
//  Created by 小果 on 16/9/30.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "AppDelegate.h"
#import "XGBarrageController.h"
#import "KMCGeigerCounter/KMCGeigerCounter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_window makeKeyAndVisible];
        [KMCGeigerCounter sharedGeigerCounter].enabled = YES;
    });
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    XGBarrageController *barrage = [[XGBarrageController alloc] init];
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = [UIColor purpleColor];
    titleLab.font = [UIFont boldSystemFontOfSize:25];
    titleLab.text =@"仿写弹幕的实现";
    [titleLab sizeToFit];
    barrage.navigationItem.titleView = titleLab;
    barrage.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:barrage];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    

    
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

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    NSLog(@"%s",__FUNCTION__);
}
@end

//
//  ZLAppDelegate.m
//  UriRouter
//
//  Created by RichieZhl on 04/02/2018.
//  Copyright (c) 2018 RichieZhl. All rights reserved.
//

#import "ZLAppDelegate.h"
#import <UriRouter/UriRouter.h>

@implementation ZLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UriRouter shared] registerUri:@"helloworld" withBlock:^NSString *(id properties) {
        NSLog(@"call helloworld");
        return @"call helloworld success";
    }];
    [[UriRouter shared] registerUri:@"alert" withBlock:^id(NSDictionary *properties) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:properties[@"title"] message:properties[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:properties[@"ok"] style:UIAlertActionStyleDefault handler:nil]];
            [UriRouter.currentVC presentViewController:alert animated:YES completion:nil];
        });
        return @(YES);
    }];
    NSLog(@"%@", [[UriRouter shared] openUri:@"helloworld"]);
    NSLog(@"%@", [[UriRouter shared] openUri:@"alert" withProperties:@{@"title": @"测试", @"message": @"内容", @"ok": @"确定"}]);
    [UriRouter destory];
    [[UriRouter shared] openUri:@"helloworld"];
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

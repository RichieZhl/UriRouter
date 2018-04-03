//
//  UriRouter.m
//  demo1
//
//  Created by lylaut on 2018/3/31.
//  Copyright © 2018年 lylaut. All rights reserved.
//

#import "UriRouter.h"
#import <map>

UIViewController *topMost(UIViewController *viewController) {
    if (viewController.presentedViewController) {
        return topMost(viewController.presentedViewController);
    }
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return topMost(((UITabBarController *)viewController).selectedViewController);
    }
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        return topMost(((UINavigationController *)viewController).visibleViewController);
    }
    if ([viewController isKindOfClass:[UIPageViewController class]]) {
        return topMost(((UIPageViewController *)viewController).viewControllers.firstObject);
    }
    
    if (viewController == nil) {
        return nil;
    }
    for (UIView *subView in viewController.view.subviews) {
        UIResponder *responder = subView.nextResponder;
        if ([responder isKindOfClass:[UIViewController class]]) {
            return topMost((UIViewController *)responder);
        }
    }
    
    return viewController;
}

@interface UriRouter() {
    std::map<NSString *, CFTypeRef> uriMaps;
}

@end

@implementation UriRouter

+ (UIViewController *)currentVC {
    NSArray *windows = [UIApplication sharedApplication].windows;
    if (windows == nil) {
        return nil;
    }
    
    UIViewController *rootViewController = nil;
    for (UIWindow *window in windows) {
        if (window.rootViewController) {
            rootViewController = window.rootViewController;
            break;
        }
    }
    
    return topMost(rootViewController);
}

static UriRouter *uriRouter = nil;
NSLock *lock = [NSLock new];

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uriRouter = [UriRouter new];
    });
    if (uriRouter == nil) {
        [lock lock];
        if (uriRouter == nil) {
            uriRouter = [UriRouter new];
        }
        [lock unlock];
    }
    return uriRouter;
}

+ (void)destory {
    uriRouter = nil;
}

- (void)registerUri:(NSString *)uri withBlock:(id (^)(id properties))block {
    uriMaps.insert(std::pair<NSString *, CFTypeRef>(uri, CFBridgingRetain([block copy])));
}

- (id)openUri:(NSString *)uri withProperties:(id)properties {
    for (auto it = uriMaps.begin(); it != uriMaps.end(); ++it) {
        if ([it->first isEqualToString:uri]) {
            id (^block)(id) = (__bridge id (^)(id))it->second;
            if (block == nil) {
                return nil;
            }
            return block(properties);
        }
    }

    return nil;
}

- (id)openUri:(NSString *)uri {
    return [self openUri:uri withProperties:nil];
}

- (void)dealloc {
    for (auto it = uriMaps.begin(); it != uriMaps.end(); ++it) {
        CFBridgingRelease(it->second);
    }
    uriMaps.clear();
}

@end

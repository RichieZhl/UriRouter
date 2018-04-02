//
//  UriRouter.h
//  demo1
//
//  Created by lylaut on 2018/3/31.
//  Copyright © 2018年 lylaut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UriRouter : NSObject

+ (UIViewController *)currentVC;

+ (instancetype)shared;

+ (void)destory;

- (void)registerUri:(NSString *)uri withBlock:(id (^)(id))block;

- (id)openUri:(NSString *)uri;

- (id)openUri:(NSString *)uri withProperties:(id)properties;

@end

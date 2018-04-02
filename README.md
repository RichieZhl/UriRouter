# UriRouter

[![CI Status](http://img.shields.io/travis/RichieZhl/UriRouter.svg?style=flat)](https://travis-ci.org/RichieZhl/UriRouter)
[![Version](https://img.shields.io/cocoapods/v/UriRouter.svg?style=flat)](http://cocoapods.org/pods/UriRouter)
[![License](https://img.shields.io/cocoapods/l/UriRouter.svg?style=flat)](http://cocoapods.org/pods/UriRouter)
[![Platform](https://img.shields.io/cocoapods/p/UriRouter.svg?style=flat)](http://cocoapods.org/pods/UriRouter)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Uses
```SwiftObjectiveC
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
```

## Installation

UriRouter is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'UriRouter'
```

## Author

RichieZhl, lylaut@163.com

## License

UriRouter is available under the MIT license. See the LICENSE file for more info.

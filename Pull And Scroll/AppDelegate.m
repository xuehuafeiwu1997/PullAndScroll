//
//  AppDelegate.m
//  Pull And Scroll
//
//  Created by 许明洋 on 2021/1/19.
//

#import "AppDelegate.h"
#import "PullScrollViewController.h"
#import "TestViewController.h"
#import "Test2ViewController.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    PullScrollViewController *vc = [[PullScrollViewController alloc] init];
//    TestViewController *vc = [[TestViewController alloc] init];
//    Test2ViewController *vc = [[Test2ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    return YES;
}


@end

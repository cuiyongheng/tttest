//
//  AppDelegate.m
//  IMtest
//
//  Created by MAC on 2017/3/3.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <UMSocialNetwork/UMSocialNetwork.h>
#import <UMSocialCore/UMSocialCore.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    HOptions *option = [[HOptions alloc] init];
//    option.appkey = @"1121170303178423#fcwc"; //(必填项)
//    option.tenantId = @"翡翠王朝证书p12";//(必填项)
//    //推送证书名字
//    option.apnsCertName = @"your apnsCerName";//(集成离线推送必填)
//    //Kefu SDK 初始化,初始化失败后将不能使用Kefu SDK
//    HError *initError = [[HChatClient sharedClient] initializeSDKWithOptions:option];
//    if (initError) { // 初始化错误
//        
//    }

    ViewController *VC = [[ViewController alloc] init];
    UINavigationController *NaVC = [[UINavigationController alloc] initWithRootViewController:VC];
    self.window.rootViewController = NaVC;
    
    
    
    
    
    [self UMinit];
    
    
    
    
    return YES;
}

- (void)UMinit {
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"8c3b3fb024cf2206"];
    
    [self configUSharePlatforms];
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx8c3b3fb024cf2206" appSecret:@"5c3f9f5d6bc81e08bd76f40b9c2dd102" redirectURL:@"http://baidu.com/"];
       
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

//
//  AppDelegate.m
//  iOS10-Notification
//
//  Created by AndyDev on 16/8/24.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //1. 请求通知权限, 本地和远程共用
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"请求成功");
        } else {
            NSLog(@"请求失败");
        }
    }];
    
    
    
    //2. 设置代理 --> 为了实现新的2个处理方法
    center.delegate = self;
    
    //3. 注册远程通知
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    return YES;
}

//4. 获取DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"token:%@", deviceToken);
}


/**
 应用在前台时,接收到远程推送&本地推送都会调用该方法
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
//    if (userInfo[@"aps"][@"alert"]) {
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor redColor];
        label.frame = CGRectMake(0, 0, 300, 300);
        label.text = userInfo.description;
        label.numberOfLines = 0;
        [[UIApplication sharedApplication].keyWindow addSubview:label];
//    }
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

/**
  接收到本地推送&远程推送时,应用前台/后台/应用退出,点击横幅都会调用该方法
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    NSString *actionStr = response.actionIdentifier;
    
    NSLog(@"actionStr: %@", actionStr);
    if ([actionStr isEqualToString:@"action1"]) {
        NSLog(@"action1");
    } else {
        NSLog(@"action2");
    }
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor greenColor];
    label.frame = CGRectMake(0, 400, 300, 300);
    label.text = userInfo.description;
    label.numberOfLines = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    
    completionHandler();
}


/**
 - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo NS_DEPRECATED_IOS(3_0, 10_0, 
 
 
    如果你需要接收推送通知. 那么需要实现3个方法
    1. willPresentNotification:withCompletionHandler
    2. didReceiveNotificationResponse:withCompletionHandler
    3. didReceiveRemoteNotification:fetchCompletionHandler: 用于静默推送
 
 
    "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] for user visible notifications and -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:] for silent remote notifications");
 */


/**
 静默推送 --> iOS7以后出现, 不会出现提醒及声音
 1. 推送的payload中不能包含alert及sound字段
 2. 需要添加content-available字段, 并设置值为1
 */

//iOS10之前, 前台/后台/退出/静默推送都可以处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor blueColor];
    label.frame = CGRectMake(0, 200, 300, 300);
    label.text = userInfo.description;
    label.numberOfLines = 0;
    [application.keyWindow addSubview:label];
    
    completionHandler(UIBackgroundFetchResultNewData);
}


@end

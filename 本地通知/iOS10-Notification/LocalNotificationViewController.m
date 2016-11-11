//
//  LocalNotificationViewController.m
//  iOS10-Notification
//
//  Created by AndyDev on 16/8/24.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "LocalNotificationViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface LocalNotificationViewController ()

@end

@implementation LocalNotificationViewController


- (IBAction)localNotificationClick:(id)sender {
    
//    UILocalNotification *local = [UILocalNotification new];
//    
//    local.fireDate;
//    local.alertTitle;
//    local.soundName; UILocalNotificationDefaultSoundName;
//    local.applicationIconBadgeNumber;
//    
//    [[UIApplication sharedApplication] scheduleLocalNotification:local];
    
    
    //1. 设置分类
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"确定" options:UNNotificationActionOptionForeground];

    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"延迟" options:UNNotificationActionOptionDestructive];
    
    UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"action3" title:@"取消" options:UNNotificationActionOptionAuthenticationRequired];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"category" actions:@[action1, action2, action3] intentIdentifiers:@[@"action1", @"action2", @"action3"] options:UNNotificationCategoryOptionNone];
    
    NSSet *set = [NSSet setWithObjects:category, nil];
    
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:set];
    
    //2. 设置本地通知相关的属性 如果希望一个通知可以下拉出现按钮, 就必须给这个通知设置分类标识符
    // 应该使用UNNotificationContent的子类来进行设定
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    
    // 设置应用程序的数字角标
    content.badge = @11;
    
    // 设置声音
    content.sound = [UNNotificationSound defaultSound];
    
    // 设置文字
    content.body = @"你好, 吃了没?";
    
    // 设置标题和子标题
    content.title = @"传智播客";
    content.subtitle = @"黑马程序员";
    
    // 设置分类 --> iOS8出现了分类
    content.categoryIdentifier = @"category";
    
    content.userInfo = @{@"title":@"iOS10"};
    
    //3. 设置触发时间及重复 用UNNotificationTrigger的子类实现
    
    //触发时间, 被封装成了2个子类.
    //TimeInterval: 方便指定多少秒之后发送
    //DateComponent: 方便指定年月日时分秒
    
    //TimeInterval: 发送通知的时间
    //repeats: 设置重复
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
    
    //4. 创建请求
    //Identifier: 通知的标示符, 用于区分不同的本地通知的
    //content: 相当于以前的设置本地通知属性的步骤
    //trigger: 设置触发时间及重复的类
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"local" content:content trigger:trigger];
    
    
    //5. 通过用户通知中心来添加一个本地通知的请求
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
}




@end

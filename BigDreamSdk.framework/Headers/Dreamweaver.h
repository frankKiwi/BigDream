//
//  Dreamweaver.h
//  DreamCloud
//
//  Created by LWW on 2018/12/11.
//  Copyright © 2018 LWW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Dreamweaver : NSObject

+ (instancetype)DreamInstance;
@property (nonatomic,assign)BOOL isDebug;

- (void)initConfigwithUrl:(NSString *)url andAppId:(NSString *)appid  withlaunchOptions:(NSDictionary*)launchOptions;

@end

NS_ASSUME_NONNULL_END

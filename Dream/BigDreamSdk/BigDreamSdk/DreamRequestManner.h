//
//  DreamRequestManner.h
//  DreamCloud
//
//  Created by LWW on 2018/12/10.
//  Copyright © 2018 LWW. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//成功block
typedef void (^SuccessBlock)(NSDictionary *data);
//失败block
typedef void (^FailureBlock)(NSError *error);
@interface DreamRequestManner : NSObject
+ (instancetype)requestInstance;
@property (copy, nonatomic) NSString *DreamUrl;

/**
 *  发送get请求
 *
 *  @param urlString       请求的网址字符串
 *  @param parameters      请求的参数
 *  @param successBlock    请求成功的回调
 *  @param failureBlock    请求失败的回调
 */
- (void)getWithURLString:(NSString *)urlString
                    widh:(NSString*)appid
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END

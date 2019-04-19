//
//  DreamRequestManner.m
//  DreamCloud
//
//  Created by LWW on 2018/12/10.
//  Copyright © 2018 LWW. All rights reserved.
//

#import "DreamRequestManner.h"

@implementation DreamRequestManner
+ (instancetype)requestInstance{
    static DreamRequestManner *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DreamRequestManner alloc] init];
    });
    return manager;
}
- (void)getWithURLString:(NSString *)urlString
                 widh:(NSString*)appid
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?appid=%@&&type=ios",urlString,appid]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (error == nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"get 请求成功 %@", dic);
            successBlock(dict);
        }else{
            failureBlock(error);

        }
       
        NSLog(@"%@", dict);
    }];
    [dataTask resume];
    
}
@end

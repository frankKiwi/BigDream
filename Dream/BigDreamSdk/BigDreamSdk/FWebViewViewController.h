//
//  FWebViewViewController.h
//  FWebView
//
//  Created by Frank on 2017/7/13.
//  Copyright © 2017年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWebViewViewController : UIViewController

/**
 通过网页链接初始化
 FWebViewViewController *vc = [[FWebViewViewController alloc] initWithURL:@"http://www.baidu.com"];
 [self.navigationController pushViewController:vc animated:true];
 @param url 链接
 @return return value description
 */
- (instancetype)initWithURL:(NSString *)url;


/**
 通过本地文件初始化
 FWebViewViewController *web = [[FWebViewViewController alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"]];
 [self.navigationController pushViewController:web animated:true];
 @param filePath 本地文件位置
 @return return value description
 */
- (instancetype)initWithFilePath:(NSString *)filePath;

@end

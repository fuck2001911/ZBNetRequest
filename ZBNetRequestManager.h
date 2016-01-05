//
//  ZBNetRequestManager.h
//  Underground
//
//  Created by qmap01 on 15/11/30.
//  Copyright © 2015年 xt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZBNetRequestManagerDelegate <NSObject>

- (void)getDataMessage:(NSMutableData *)data;

- (void)requestFailure:(NSString *)message;

@end

@interface ZBNetRequestManager : NSObject<NSURLConnectionDataDelegate>

{
    //用来接收数据
    NSMutableData *_webData;
    //主域名
    NSString *_baseURL;
    //传参
    NSDictionary *_parame;
    //接口地址
    NSString *_subURL;
    
}
@property (nonatomic,assign)id<ZBNetRequestManagerDelegate>delegate;



//单例
+ (ZBNetRequestManager *)shareSingleton;
//传入详细地址
- (void)sendRequestURL:(NSString *)url;
//传入请求的参数
- (void)sendRequestParame:(NSDictionary *)param;
//发送get请求
- (void)sendGetRequest;
//发送post请求
- (void)sendPostRequest;



@end

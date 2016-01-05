//
//  ZBNetRequestManager.m
//  Underground
//
//  Created by qmap01 on 15/11/30.
//  Copyright © 2015年 xt. All rights reserved.
//

#import "ZBNetRequestManager.h"
#import "AppDelegate.h"
static ZBNetRequestManager *manager =nil;

@implementation ZBNetRequestManager

@synthesize delegate=_delegate;


+ (ZBNetRequestManager *)shareSingleton {
    @synchronized (self) {
        if (!manager) {
            manager = [[self alloc] init];
        }
    }
    return manager;
}
- (id)init {
    self = [super init];
    if (self) {
        _baseURL = [BaseURL copy];
        _webData = [[NSMutableData alloc] initWithCapacity:0];
    }
    return self;
}


//传入详细地址
- (void)sendRequestURL:(NSString *)url {
    _subURL = [url copy];
}

//发送get请求 需要带参数
- (void)sendGetRequest {
    NSString *urlString = [NSString stringWithFormat:@"%@%@?%@", _baseURL, _subURL, [self createParameString]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [self sendRequestToServer:request];
}

//发送post请求
- (void)sendPostRequest {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _baseURL, _subURL]]];
    //设置请求方式
    [request setHTTPMethod:@"POST"];
    //设置请求头信息
    //[request setValue:@"text/html" forHTTPHeaderField:@"Content-type"];
    //设置请求体信息
    if (_parame==nil) {
        [self sendRequestToServer:request];
    }else {
        //设置请求体信息
        NSData *body = [[self createParameString] dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:body];
        [self sendRequestToServer:request];
    }
    
    

}

- (void)sendRequestToServer:(NSURLRequest *)request {
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
}

- (NSString *)createParameString {
    //整理参数的容器字符串
    NSString *urlString = @"";
    for (NSString *key in _parame.allKeys) {
        //取出value
        NSString *value = [_parame objectForKey:key];
        //初始化字符串
        NSString *param = [NSString stringWithFormat:@"%@=%@&", key, value];
        //添加到容器中
        urlString = [urlString stringByAppendingString:param];
    }
    urlString = [urlString substringToIndex:[urlString length] - 1];
    return urlString;
}

- (void)sendRequestParame:(NSDictionary *)param {
    _parame = param;
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"请求失败");
    if (_delegate&&[_delegate respondsToSelector:@selector(requestFailure:)]) {
        [_delegate requestFailure:@"请求失败"];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"返回数据");
    [_webData appendData:data];
    if (_delegate&&[_delegate respondsToSelector:@selector(getDataMessage:)]) {
        [_delegate getDataMessage:_webData];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"返回响应");
    [_webData setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"请求完成");
    id json = [NSJSONSerialization JSONObjectWithData:_webData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",json);
}


@end

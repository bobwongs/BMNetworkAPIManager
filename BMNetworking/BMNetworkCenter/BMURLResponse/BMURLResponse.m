//
//  BMURLResponse.m
//  BlueMoonBlueHouse
//
//  Created by fenglh on 15/9/25.
//  Copyright (c) 2015年 fenglh. All rights reserved.
//

#import "BMURLResponse.h"
#import "NSURLRequest+AIFNetworkingMethods.h"
#import "NSObject+AXNetworkingMethods.h"

#import "BMAPICalledProxy.h"

@interface BMURLResponse ()

@property (nonatomic, assign, readwrite) BMURLResponseStatus status;
@property (nonatomic, copy, readwrite) NSString *contentString;
@property (nonatomic, copy, readwrite) id content;
@property (nonatomic, copy, readwrite) NSError *error;
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (nonatomic, copy, readwrite) NSURLRequest *request;
@property (nonatomic, copy, readwrite) NSData *responseData;
@property (nonatomic, assign, readwrite) BOOL isCache;

@end

@implementation BMURLResponse

#pragma mark - 生命周期

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData status:(BMURLResponseStatus)status
{
    self = [super init];
    if (self) {
        self.contentString = responseString;
        self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        self.status = status;
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.requestParams;//关联，主要给request添加一个属性用来hold住requestParams然后调试
        self.isCache = NO; //表示该response对象还没有进行缓存
    }
    return self;
}

-(instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error
{
    self = [super init];
    if (self) {
        self.contentString = [responseString AIF_defaultValue:@""];//处理nil、null @""的情况 --note
        self.error = error;
        self.status = [self responseStatusWithError:error];
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.requestParams;
        self.isCache = NO;//表示该response对象还没有进行缓存
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        }else{
            self.content = nil;
        }
        
    }
    return self;
}



- (instancetype)initWithData:(NSData *)data
{
    self = [super self];
    if (self) {
        self.contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.status = [self responseStatusWithError:nil];
        self.requestId = [[[BMAPICalledProxy sharedInstance] generateRequestId] integerValue];
        self.request = nil;
        self.responseData = [data copy];
        self.content =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        self.isCache = YES;
    }
    return self;
}

#pragma  mark - 私有方法
-(BMURLResponseStatus)responseStatusWithError:(NSError *)error
{
    if (error) {
        BMURLResponseStatus result;
        switch (error.code) {
            case NSURLErrorTimedOut:
                result = BMURLResponseStatusErrorTimeout;
                break;
            case NSURLErrorCannotConnectToHost:
                result = NSURLResponseStatusErrorCannotConnectToHost;
                break;
            case NSURLErrorCannotFindHost:
                result = NSURLResponseStatusErrorCannotFindHost;
                break;
            case NSURLErrorBadServerResponse:
                result = NSURLResponseStatusErrorBadServerResponse;
                break;
            case NSURLErrorNotConnectedToInternet:
                result = NSURLResponseStatusErrorNotConnectedToInternet;
                break;
            case NSURLErrorNetworkConnectionLost:
                result  = NSURLResponseStatusErrorNetworkConnectionLost;
                break;
            default:
                result = BMURLResponseStatusErrorUnknowError;
                break;
        }
        return result;
    }else{
        return BMURLResponseStatusSuccess;
    }
}



@end

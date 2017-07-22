//
//  LSHttpTool.h
//  LifeStyle
//
//  Created by huangzhifei on 16/1/7.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface LSHttpTool : AFHTTPSessionManager

+ (instancetype)sharedInstance;

/**
 *  发送一个get请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
- (void)getWithURL:(NSString *)urlString
            params:(NSDictionary *)params
           success:(void (^)(id json))sucess
           failure:(void (^)(NSError *error))failure;

/**
 *  发送一个post请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
- (void)postWithURL:(NSString *)urlString
             params:(NSDictionary *)params
            success:(void(^)(id responseObject))success
            failure:(void(^)(NSError *error))failure;

@end

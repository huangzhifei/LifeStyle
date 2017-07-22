//
//  LSHttpTool.m
//  LifeStyle
//
//  Created by huangzhifei on 16/1/7.
//  Copyright © 2016年 huangzhifei. All rights reserved.
//

#import "LSHttpTool.h"

@implementation LSHttpTool

+ (instancetype)sharedInstance
{
    static LSHttpTool *manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        manager = [LSHttpTool manager];
        [manager commonInit];
        
    });
    
    return manager;
}

- (void)commonInit
{
    self.securityPolicy.allowInvalidCertificates = YES;
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:APIStoreKey forHTTPHeaderField:@"apikey"];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    [self.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
}

- (void)getWithURL:(NSString *)urlString
            params:(NSDictionary *)params
           success:(void (^)(id json))sucess
           failure:(void (^)(NSError *error))failure
{
    [self GET:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if( sucess )
        {
            sucess(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if( failure )
        {
            failure(error);
        }
    }];

}

- (void)postWithURL:(NSString *)urlString
             params:(NSDictionary *)params
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure
{
    [self POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    NSLog(@"baseUrl: %@", self.baseURL);
}

@end

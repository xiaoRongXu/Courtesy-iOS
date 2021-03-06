//
//  CourtesyAccountModel.m
//  Courtesy
//
//  Created by Zheng on 2/23/16.
//  Copyright © 2016 82Flex. All rights reserved.
//

#import "JSONHTTPClient.h"
#import "CourtesyCommonRequestModel.h"
#import "CourtesyAccountModel.h"
#import "CourtesyAccountProfileModel.h"

@implementation CourtesyAccountModel {
    CourtesyCommonRequestModel *fetchDict;
    BOOL isFetching;
    BOOL fetched;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    if (
        [propertyName isEqualToString:@"incognitoMode"] ||
        [propertyName isEqualToString:@"tencentModel"] ||
        [propertyName isEqualToString:@"weiboModel"] ||
        [propertyName isEqualToString:@"profile"]
        ) {
        return YES;
    }
    return NO;
}

- (instancetype)init {
    if (self = [super init]) {
        _profile = [CourtesyAccountProfileModel new];
        isFetching = NO;
    }
    return self;
}

- (instancetype)initWithDelegate:(id)delegate {
    if (self = [self init]) {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - Setter, Getter

- (void)setEmail:(NSString *)email {
    _email = email;
    if (!_profile) {
        return;
    }
    [_profile setNick:_email];
}

- (CourtesyWeiboUserModel *)weiboModel {
    if (!_weiboModel) {
        _weiboModel = [CourtesyWeiboUserModel new];
    }
    return _weiboModel;
}

- (BOOL)hasWeiboAccount {
    if (!_weiboModel || !_weiboModel.accessToken) {
        return NO;
    }
    return YES;
}

- (CourtesyTencentAccountModel *)tencentModel {
    if (!_tencentModel) {
        _tencentModel = [[CourtesyTencentAccountModel alloc] init];
    }
    return _tencentModel;
}

- (BOOL)hasTencentAccount {
    if (!_tencentModel || !_tencentModel.accessToken) {
        return NO;
    }
    return YES;
}

- (CourtesyWeixinAccountModel *)weixinModel {
    if (!_weixinModel) {
        _weixinModel = [[CourtesyWeixinAccountModel alloc] init];
    }
    return _weixinModel;
}

- (BOOL)hasWeixinAccount {
    if (!_weixinModel || !_weixinModel.accessToken) {
        return NO;
    }
    return YES;
}

#pragma mark - 获取请求状态

- (BOOL)isRequestingFetchAccountInfo {
    return isFetching;
}

#pragma mark - 构造请求

- (BOOL)makeRequest {
    fetchDict = [CourtesyCommonRequestModel new];
    fetchDict.action = @"user_info";
    CYLog(@"%@", [fetchDict toJSONString]);
    return YES;
}

#pragma mark - 发送委托方法

- (void)callbackDelegateWithErrorMessage:(NSString *)message {
    if (!_delegate || ![_delegate respondsToSelector:@selector(fetchAccountInfoFailed:errorMessage:)]) {
        CYLog(@"No delegate found!");
        return;
    }
    [_delegate fetchAccountInfoFailed:self errorMessage:message];
}

- (void)callbackDelegateSucceed {
    if (!_delegate || ![_delegate respondsToSelector:@selector(fetchAccountInfoSucceed:)]) {
        CYLog(@"No delegate found!");
        return;
    }
    [_delegate fetchAccountInfoSucceed:self];
}

#pragma mark - 发送请求

- (void)sendRequestFetchAccountInfo {
    if ([self isRequestingFetchAccountInfo] || ![self makeRequest]) {
        return;
    }
    JSONObjectBlock handler = ^(id json, JSONModelError *err) {
        CYLog(@"%@", json);
        @try {
            if (err) {
                @throw NSCustomException(kCourtesyInvalidHttpResponse, [err localizedDescription]);
            }
            if (!json ||
                ![json isKindOfClass:[NSDictionary class]]) {
                @throw NSCustomException(kCourtesyInvalidHttpResponse, @"服务器错误");
            }
            NSDictionary *dict = (NSDictionary *)json;
            if (![dict hasKey:@"error"]) {
                @throw NSCustomException(kCourtesyUnexceptedObject, @"服务器错误");
            }
            NSInteger errorCode = [[dict objectForKey:@"error"] integerValue];
            if (errorCode == 403) {
                @throw NSCustomException(kCourtesyForbidden, @"请重新登录");
            } else if (errorCode == 0) {
                NSError *error = nil;
                if ([dict hasKey:@"account_info"]) dict = [dict objectForKey:@"account_info"];
                CourtesyAccountModel *newAccount = [[CourtesyAccountModel alloc] initWithDictionary:dict error:&error];
                if (error) {
                    @throw NSCustomException(kCourtesyUnexceptedObject, @"数据解析失败");
                }
                [sharedSettings setCurrentAccount:newAccount];
                [sharedSettings setFetchedCurrentAccount:YES];
                [sharedSettings reloadAccount];
                [self callbackDelegateSucceed];
                return;
            }
            @throw NSCustomException(kCourtesyUnexceptedStatus, ([NSString stringWithFormat:@"未知错误 (%ld)", (long)errorCode]));
        }
        @catch (NSException *exception) {
            if ([exception.name isEqualToString:kCourtesyForbidden]) {
                [sharedSettings setHasLogin:NO];
            }
            [self callbackDelegateWithErrorMessage:exception.reason];
            return;
        }
        @finally {
            isFetching = NO;
        }
    };
    isFetching = YES;
    [JSONHTTPClient postJSONFromURLWithString:API_URL
                                   bodyString:[fetchDict toJSONString]
                                   completion:handler];
}

- (void)dealloc {
    CYLog(@"");
}

@end

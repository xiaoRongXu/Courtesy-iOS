//
//  CourtesyAccountProfileModel.h
//  Courtesy
//
//  Created by Zheng on 2/24/16.
//  Copyright © 2016 82Flex. All rights reserved.
//

#import "JSONModel.h"
#import "CourtesyCommonRequestModel.h"

@class CourtesyAccountProfileModel;

@protocol CourtesyEditProfileDelegate <NSObject>

@optional
- (void)editProfileSucceed:(CourtesyAccountProfileModel *)sender;
@optional
- (void)editProfileFailed:(CourtesyAccountProfileModel *)sender
             errorMessage:(NSString *)message;

@end

@protocol CourtesyUploadAvatarDelegate <NSObject>

@optional
- (void)uploadAvatarSucceed:(CourtesyAccountProfileModel *)sender;
@optional
- (void)uploadAvatarFailed:(CourtesyAccountProfileModel *)sender
              errorMessage:(NSString *)message;

@end

@interface CourtesyAccountProfileModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *nick;
@property (nonatomic, assign) NSUInteger gender;
@property (nonatomic, copy) NSString<Optional> *avatar;
@property (nonatomic, copy) NSURL<Ignore> *avatar_url;
@property (nonatomic, copy) NSString<Optional> *mobile;
@property (nonatomic, copy) NSString<Optional> *birthday;
@property (nonatomic, copy) NSString<Optional> *province;
@property (nonatomic, copy) NSString<Optional> *city;
@property (nonatomic, copy) NSString<Optional> *area;
@property (nonatomic, copy) NSString<Optional> *introduction;
// ... any profile info

@property (nonatomic, weak) id<Ignore, CourtesyEditProfileDelegate, CourtesyUploadAvatarDelegate> delegate;

- (void)editProfile;
- (void)uploadAvatar:(UIImage *)avatar;
- (BOOL)isEditing;

@end

@interface CourtesyEditProfileRequestModel : CourtesyCommonRequestModel

@property (nonatomic, strong) CourtesyAccountProfileModel* profile;

@end

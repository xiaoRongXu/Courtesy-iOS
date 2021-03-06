//
//  CourtesyCardModel.h
//  Courtesy
//
//  Created by Zheng on 3/10/16.
//  Copyright © 2016 82Flex. All rights reserved.
//

#import "CourtesyAccountModel.h"
#import "CourtesyCardDataModel.h"

@class CourtesyCardModel;

@protocol CourtesyCardDelegate <NSObject>
@optional
- (void)cardDidFinishSaving:(CourtesyCardModel *)card;
@optional
- (void)cardDidFailedSaving:(CourtesyCardModel *)card withError:(NSError *)error;

@end

@interface CourtesyCardModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *qr_id;
@property (nonatomic, assign) BOOL is_editable;
@property (nonatomic, assign) BOOL is_banned;
@property (nonatomic, assign) NSUInteger view_count;
@property (nonatomic, assign) NSUInteger created_at;
@property (nonatomic, assign) NSUInteger modified_at;
@property (nonatomic, assign) NSUInteger first_read_at;
@property (nonatomic, assign) NSUInteger visible_at;

@property (nonatomic, copy)   NSString *token;
@property (nonatomic, assign) NSUInteger edited_count;
@property (nonatomic, assign) NSUInteger stars;
@property (nonatomic, strong) CourtesyAccountModel *author;
@property (nonatomic, strong) CourtesyAccountModel<Optional> *read_by;
@property (nonatomic, strong) CourtesyCardDataModel *local_template;

@property (nonatomic, assign) BOOL isNewCard;
@property (nonatomic, assign) BOOL isNewRecord;
@property (nonatomic, assign) BOOL hasPublished;
@property (nonatomic, assign) BOOL willPublish;
@property (nonatomic, assign) BOOL shouldNotify;
@property (nonatomic, assign) BOOL shouldRemove;

@property (nonatomic, weak)   id<Ignore, CourtesyCardDelegate> delegate;

- (instancetype)initWithCardToken:(NSString *)token;
- (NSString *)saveToLocalDatabase;
- (void)deleteInLocalDatabase;
- (BOOL)isCardCached;

- (BOOL)isMyCard;
- (BOOL)isReadByMe;

@end

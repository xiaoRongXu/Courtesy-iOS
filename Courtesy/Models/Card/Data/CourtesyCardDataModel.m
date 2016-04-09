//
//  CourtesyCardDataModel.m
//  Courtesy
//
//  Created by Zheng on 3/10/16.
//  Copyright © 2016 82Flex. All rights reserved.
//

#import "CourtesyCardDataModel.h"
#import "CourtesyCardAttachmentModel.h"
#import "CourtesyCardStyleManager.h"

@interface CourtesyCardDataModel ()

@end

@implementation CourtesyCardDataModel {
    NSURL *_thumbnailURL;
}

#pragma mark - Init

- (instancetype)initWithCardToken:(NSString *)token {
    if (self = [super init]) {
        _card_token = token;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict andCardToken:(NSString *)token error:(NSError *__autoreleasing *)err {
    _card_token = token; // Set token before lazy loading
    if (self = [super initWithDictionary:dict error:err]) {
        
    }
    return self;
}

#pragma mark - Getter / Setter

- (void)setContent:(NSString *)content {
    _content = content;
    // 清除缩略图
    _thumbnailURL = nil;
    BOOL mainTitled = NO;
    BOOL briefTitled = NO;
    content = [content stringByReplacingOccurrencesOfString:@"\U0000fffc" withString:@""];
    NSRange breakPos = [content rangeOfString:@"\n"];
    while (breakPos.length > 0) {
        NSString *sub = [[content substringToIndex:breakPos.location] stringByTrim];
        if (sub.length > 0) {
            if (!mainTitled) {
                mainTitled = YES;
                _mainTitle = sub;
            } else {
                briefTitled = YES;
                _briefTitle = sub;
                return;
            }
        }
        content = [[content substringFromIndex:breakPos.location] stringByTrim];
        breakPos = [content rangeOfString:@"\n"];
    }
    if (!mainTitled) {
        _mainTitle = @"无标题卡片";
    }
    if (!briefTitled) {
        _briefTitle = content;
    }
}

- (void)setAttachments:(NSArray<Ignore> *)attachments {
    _attachments = attachments;
    NSMutableArray *newAttachmentsHashesArr = [NSMutableArray new];
    for (CourtesyCardAttachmentModel *m in attachments) {
        [newAttachmentsHashesArr addObject:m.salt_hash];
    }
    _attachments_hashes = newAttachmentsHashesArr;
}

- (void)setAttachments_hashes:(NSArray<NSString *> *)attachments_hashes {
    _attachments_hashes = attachments_hashes;
    NSMutableArray *newAttachmentsArr = [NSMutableArray new];
    for (NSString *hash in attachments_hashes) {
        CourtesyCardAttachmentModel *a = [[CourtesyCardAttachmentModel alloc] initWithSaltHash:hash andCardToken:self.card_token fromDatabase:YES];
        NSAssert(a != nil, @"Cannot load attachment hash!");
        [newAttachmentsArr addObject:a];
    }
    _attachments = [newAttachmentsArr copy];
}

- (NSURL *)smallThumbnailURL {
    if (!_thumbnailURL) {
        if (!self.attachments || [[self attachments] count] == 0) {
            return nil;
        }
        for (CourtesyCardAttachmentModel *m in self.attachments) {
            NSURL *thumbnailURL = [m thumbnailImageURLWithSize:kCardThumbnailImageSmall];
            if (thumbnailURL) {
                _thumbnailURL = thumbnailURL;
                break;
            }
        }
    }
    return _thumbnailURL;
}

- (CourtesyCardStyleModel *)style { // Lazy Loading
    if (!_style) {
        _style = [[CourtesyCardStyleManager sharedManager] styleWithID:self.styleID];
    }
    return _style;
}

@end

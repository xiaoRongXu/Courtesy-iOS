//
//  CourtesyCardStyleModel.h
//  Courtesy
//
//  Created by Zheng on 3/10/16.
//  Copyright © 2016 82Flex. All rights reserved.
//

#import "CourtesyFontManager.h"
#import "CourtesyPreviewStyleModel.h"

typedef enum : NSUInteger {
    kCourtesyCardStyleDefault = 0
} CourtesyCardStyleID;

@interface CourtesyCardStyleModel : JSONModel

@property (nonatomic, strong) UIColor      *statusBarColor; // 状态栏颜色
@property (nonatomic, strong) UIColor      *buttonTintColor; // 浮动按钮颜色
@property (nonatomic, strong) UIColor      *buttonBackgroundColor; // 浮动按钮背景颜色

@property (nonatomic, strong) UIColor      *toolbarColor; // 工具栏背景色
@property (nonatomic, strong) UIColor      *toolbarTintColor; // 工具栏按钮颜色
@property (nonatomic, strong) UIColor      *toolbarBarTintColor; // 工具栏前景色

@property (nonatomic, strong) UIFont<Ignore> *cardFont; // 卡片字体
@property (nonatomic, assign) NSUInteger   cardFontType; // 卡片字体编号
@property (nonatomic, strong) NSDictionary *cardContentAttributes; // 卡片内容原始属性
@property (nonatomic, strong) UIColor      *cardBackgroundColor; // 卡片背景色
@property (nonatomic, strong) UIColor      *cardTextColor; // 卡片文字颜色
@property (nonatomic, strong) NSNumber     *cardFontSize; // 卡片字体大小
@property (nonatomic, strong) NSNumber     *cardLineSpacing; // 卡片行距
@property (nonatomic, strong) NSNumber     *cardLineHeight; // 卡片固定行高
@property (nonatomic, copy)   NSString     *placeholderText; // 卡片空白提示文字
@property (nonatomic, strong) UIColor      *placeholderColor; // 卡片空白提示文字颜色
@property (nonatomic, strong) UIColor      *indicatorColor; // 闪烁光标颜色
@property (nonatomic, strong) UIColor      *cardElementBackgroundColor; // 卡片元素背景颜色
@property (nonatomic, strong) UIColor      *cardElementTintColor; // 卡片元素前景颜色
@property (nonatomic, strong) UIColor      *cardElementTintFocusColor; // 卡片元素强调前景颜色
@property (nonatomic, strong) UIColor      *cardElementTextColor; // 卡片元素文字颜色
@property (nonatomic, strong) UIColor      *cardElementShadowColor; // 卡片元素阴影颜色
@property (nonatomic, strong) NSNumber     *cardTitleFontSize; // 卡片标题（时间）字体大小
@property (nonatomic, strong) UIColor      *dateLabelTextColor; // 显示日期颜色（不显示可设为透明色）
@property (nonatomic, strong) NSNumber     *standardAlpha; // 标准透明度

@property (nonatomic, strong) NSNumber     *defaultAnimationDuration;
@property (nonatomic, copy)   NSString     *cardCreateTimeFormat; // 卡片时间格式
@property (nonatomic, strong) NSNumber     *maxAudioNum; // 最多音频数量
@property (nonatomic, strong) NSNumber     *maxImageNum; // 最多图像数量
@property (nonatomic, strong) NSNumber     *maxVideoNum; // 最多视频数量
@property (nonatomic, strong) NSNumber     *maxContentLength; // 限制内容长度

// Markdown
@property (nonatomic) NSNumber *headerFontSize;
@property (nonatomic, strong) UIColor *controlTextColor;
@property (nonatomic, strong) UIColor *headerTextColor;
@property (nonatomic, strong) UIColor *inlineTextColor;
@property (nonatomic, strong) UIColor *codeTextColor;
@property (nonatomic, strong) UIColor *linkTextColor;

@property (nonatomic, strong) CourtesyPreviewStyleModel<Ignore> *previewStyle;
@property (nonatomic, assign) NSUInteger previewType;

@end

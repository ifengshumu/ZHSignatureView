//
//  ZHSignatureView.h
//
//  Created by 李志华 on 2017/4/1.
//  Copyright © 2017年 leezhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHSignatureView : UIView
/**
 已签名的照片,跳转传入
 */
@property(nonatomic, strong) UIImage *signImage;

/**
 签名笔划颜色，默认blackColor
 */
@property(nonatomic, strong) UIColor *lineColor;

/**
 签名笔划宽度，默认3.3
 */
@property(nonatomic, assign) CGFloat lineWidth;

/**
 无签名时占位文字，默认"签名区域"
 */
@property(nonatomic, copy) NSString *placeHoalder;

/**
 占位文字字体颜色，默认grayColor
 */
@property(nonatomic, strong) UIColor *placeHoalderTextColor;

/**
 占位文字字体大小，默认35
 */
@property(nonatomic, strong) UIFont *placeHoalderTextFont;

/**
 签名完成的回调Block,签名图片
 */
@property(nonatomic, copy) void(^signDone)(UIImage *signImage);

/**
 清除Blcok,可调用- (void)clearSignature;进行清除已有签名
 */
@property(nonatomic, copy) void(^signClear)(ZHSignatureView *signView);

/**
 清除签名
 */
- (void)clearSignature;

@end

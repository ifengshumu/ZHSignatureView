//
//  ZHSignatureView.m
//
//  Created by 李志华 on 2017/4/1.
//  Copyright © 2017年 leezhihua. All rights reserved.
//

#define SPACE           10
#define BUTTON_WIDTH    100
#define BUTTON_HEIGHT   50


#import "ZHSignatureView.h"

@interface ZHSignatureView ()
@property(nonatomic, strong) UIImageView *signImageView;
@property(nonatomic, strong) UILabel *placeHoalderLabel;
@property(nonatomic, assign) CGPoint lastPoint;
@property(nonatomic, assign) BOOL isSwiping;
@property(nonatomic, strong) NSMutableArray *pointXs;
@property(nonatomic, strong) NSMutableArray *pointYs;
@end

@implementation ZHSignatureView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pointXs = [NSMutableArray arrayWithCapacity:0];
        self.pointYs = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SPACE, SPACE, size.width-SPACE*2, size.height-SPACE*3-BUTTON_HEIGHT)];
    imageView.layer.cornerRadius = SPACE;
    imageView.layer.masksToBounds = YES;
    imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.signImageView = imageView;
    [self addSubview:imageView];
    UILabel *placeHoalderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (size.height-100)/2.0, imageView.frame.size.width, 100)];
    placeHoalderLabel.textAlignment = NSTextAlignmentCenter;
    placeHoalderLabel.alpha = 0.8;
    if (self.placeHoalder) {
        placeHoalderLabel.text = self.placeHoalder;
    } else {
        placeHoalderLabel.text = @"签名区域";
    }
    if (self.placeHoalderTextFont) {
        placeHoalderLabel.font = self.placeHoalderTextFont;
    } else {
        placeHoalderLabel.font = [UIFont systemFontOfSize:35];
    }
    if (self.placeHoalderTextColor) {
        placeHoalderLabel.textColor = self.placeHoalderTextColor;
    } else {
        placeHoalderLabel.textColor = [UIColor grayColor];
    }
    self.placeHoalderLabel = placeHoalderLabel;
    [self addSubview:placeHoalderLabel];
    
    //
    CGFloat buttonSpace = (size.width-BUTTON_WIDTH*2)/3.0;
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(buttonSpace, CGRectGetMaxY(imageView.frame)+SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
    clearBtn.layer.cornerRadius = BUTTON_HEIGHT/2.0;
    clearBtn.layer.masksToBounds = YES;
    NSString *title = @"清除";
    if (self.signImage) {
        imageView.image = self.signImage;
        placeHoalderLabel.hidden = YES;
    }
    [clearBtn setTitle:title forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearSignAction:) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.8];
    [self addSubview:clearBtn];
    
    UIButton *signDone = [UIButton buttonWithType:UIButtonTypeCustom];
    signDone.frame = CGRectMake(CGRectGetMaxX(clearBtn.frame)+buttonSpace, clearBtn.frame.origin.y, BUTTON_WIDTH, BUTTON_HEIGHT);
    signDone.layer.borderColor = [UIColor redColor].CGColor;
    signDone.layer.borderWidth = 1.0;
    signDone.layer.cornerRadius = BUTTON_HEIGHT/2.0;
    signDone.layer.masksToBounds = YES;
    [signDone setTitle:@"完成" forState:UIControlStateNormal];
    [signDone setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [signDone addTarget:self action:@selector(signDoneAction:) forControlEvents:UIControlEventTouchUpInside];
    signDone.backgroundColor = [UIColor whiteColor];
    [self addSubview:signDone];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isSwiping = NO;
    UITouch * touch = touches.anyObject;
    self.lastPoint = [touch locationInView:self.signImageView];
    if (self.lastPoint.x > 0) {
        self.placeHoalderLabel.text = nil;
    }
    [self.pointXs addObject:[NSNumber numberWithFloat:self.lastPoint.x]];
    [self.pointYs addObject:[NSNumber numberWithFloat:self.lastPoint.y]];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isSwiping = YES;
    UITouch * touch = touches.anyObject;
    CGPoint currentPoint = [touch locationInView:self.signImageView];
    UIGraphicsBeginImageContext(self.signImageView.frame.size);
    [self.signImageView.image drawInRect:(CGRectMake(0, 0, self.signImageView.frame.size.width, self.signImageView.frame.size.height))];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(),kCGLineCapRound);
    CGFloat lineWidth = 3.3;
    if (self.lineWidth) {
        lineWidth = self.lineWidth;
    }
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth);
    CGFloat red = 0.0, green = 0.0, blue = 0.0;
    if (self.lineColor) {
        NSDictionary *rgbDic = [self RGBDictionaryByColor:self.lineColor];
        red = [rgbDic[@"red"] floatValue];
        green = [rgbDic[@"green"] floatValue];
        blue = [rgbDic[@"blue"] floatValue];
    }
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),red, green, blue, 1.0);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.signImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.lastPoint = currentPoint;
    [self.pointXs addObject:[NSNumber numberWithFloat:self.lastPoint.x]];
    [self.pointYs addObject:[NSNumber numberWithFloat:self.lastPoint.y]];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(!self.isSwiping) {
        UIGraphicsBeginImageContext(self.signImageView.frame.size);
        [self.signImageView.image drawInRect:(CGRectMake(0, 0, self.signImageView.frame.size.width, self.signImageView.frame.size.height))];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.signImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
}
#pragma mark getter && setter
- (void)signDoneAction:(UIButton *)sender {
    if (self.signDone) {
        self.signDone(self.signImageView.image);
    }
}

- (void)clearSignAction:(UIButton *)sender {
    if (self.signClear) {
        self.signClear(self);
    }
}
- (void)clearSignature {
    self.signImageView.image = nil;
    self.placeHoalderLabel.hidden = NO;
    if (self.placeHoalder) {
        self.placeHoalderLabel.text = self.placeHoalder;
    } else {
        self.placeHoalderLabel.text = @"签名区域";
    }
}

- (NSDictionary *)RGBDictionaryByColor:(UIColor *)color {
    CGFloat red = 0, green = 0, blue = 0, alpha = 0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
    } else {
        const CGFloat *compoments = CGColorGetComponents(color.CGColor);
        red = compoments[0];
        green = compoments[1];
        blue = compoments[2];
        alpha = compoments[3];
    }
    return @{@"red":@(red), @"green":@(green), @"blue":@(blue), @"alpha":@(alpha)};
}


@end

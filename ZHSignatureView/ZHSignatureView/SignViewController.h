//
//  SignViewController.h
//  ZHSignatureView
//
//  Created by 李志华 on 2017/3/29.
//  Copyright © 2017年 leezhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignViewController : UIViewController
@property(nonatomic, copy) void(^signResult)(UIImage *signImage);
@end

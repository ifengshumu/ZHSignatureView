//
//  SignViewController.m
//  ZHSignatureView
//
//  Created by 李志华 on 2017/3/29.
//  Copyright © 2017年 leezhihua. All rights reserved.
//

#import "SignViewController.h"
#import "ZHSignatureView.h"

@interface SignViewController ()

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电子签名";
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //push过来，设置横屏
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];

    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];

    //初始化，在设置横屏后布局，否则获取的是横屏状态下的size
    CGSize size = UIScreen.mainScreen.bounds.size;
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    self.navigationController.navigationBar.translucent = NO;
    ZHSignatureView *sign = [[ZHSignatureView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height-navHeight)];
    sign.lineColor = [UIColor blueColor];
    sign.signDone = ^(UIImage *signImage) {
        self.signResult(signImage);
        [self.navigationController popViewControllerAnimated:YES];
    };
    sign.signClear = ^(ZHSignatureView *signView) {
        [signView clearSignature];
    };
    [self.view addSubview:sign];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //push过来，页面消失时设置成竖屏，要不然返回到前一个页面也会成横屏，
    //如果在此不设置，可以在前一个页面设置支持方向也行
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];

    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 如果是psesent,下面代码就可以实现横屏
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

@end

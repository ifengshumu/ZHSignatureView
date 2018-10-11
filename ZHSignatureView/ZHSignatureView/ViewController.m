//
//  ViewController.m
//  ZHSignatureView
//
//  Created by 李志华 on 2017/4/1.
//  Copyright © 2017年 leezhihua. All rights reserved.
//

#import "ViewController.h"
#import "SignViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电子签名";
    self.signImageView.layer.borderColor = [UIColor redColor].CGColor;
    self.signImageView.layer.borderWidth = 1.0;
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)SignAction:(UIButton *)sender {
    SignViewController *signVC = [[SignViewController alloc] init];
    [self.navigationController pushViewController:signVC animated:YES];
    signVC.signResult = ^(UIImage *signImage) {
        self.signImageView.image = signImage;
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate {
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

@end

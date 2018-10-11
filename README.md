# 电子签名

### 调用
```
SignViewController *signVC = [[SignViewController alloc] init];
[self.navigationController pushViewController:signVC animated:YES];
signVC.signResult = ^(UIImage *signImage) {
   self.signImageView.image = signImage;
};
```

### 初始化
#### 如果要横屏，在横屏之后布局
```
CGSize size = UIScreen.mainScreen.bounds.size;
CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
self.navigationController.navigationBar.translucent = NO;
ElectronicSignView *sign = [[ElectronicSignView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height-navHeight)];
sign.lineColor = [UIColor blueColor];
sign.signDone = ^(UIImage *signImage) {
  self.signResult(signImage);
  [self.navigationController popViewControllerAnimated:YES];
};
[self.view addSubview:sign];
```

### 至于如何设置横屏，请下载demo查看

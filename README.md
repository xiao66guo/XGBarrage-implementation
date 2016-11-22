# XGBarrage-implementation

用完全绘制的方式实现弹幕及自定义表情和系统键盘间切换

1️⃣用绘制的方式来实现弹幕的内容；

2️⃣自定义表情键盘来实现与系统键盘之间的切换功能；

3️⃣用放大器来查看选中的表情功能；

4️⃣用Switch开关来实现是否显示弹幕；

5️⃣通过输入的弹幕的内容来实现“发送”按钮是否为可用；


在控制器中加载弹幕的方法:
   -(void)loadBarrageViewSource{
    NSInteger arcIndex = arc4random_uniform((u_int32_t)_barrageArray.count);
    XGBarrageModel *barrage = _barrageArray[arcIndex];

    XGImage *image = [XGBarrageView xg_imageWithBarrage:barrage];
    image.imageX = self.view.bounds.size.width;
    image.imageY = arc4random_uniform(_barrageView.bounds.size.height - image.size.height);

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGRect rect = imageView.frame;
    rect.origin.x = image.imageX;
    rect.origin.y = image.imageY;
    imageView.frame = rect;
    
    [_barrageView addSubview:imageView];
    
    CABasicAnimation *anim = [[CABasicAnimation alloc] init];
    anim.keyPath = @"position.x";
    anim.toValue = @(-image.imageX);
    anim.duration = XGAnimationDuration;
    [imageView.layer addAnimation:anim forKey:@"animKey"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(XGAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imageView removeFromSuperview];
    });}



# XGBarrage-implementation

用完全绘制的方式实现弹幕及自定义表情和系统键盘间切换

项目功能介绍：

1️⃣用完全绘制的方式来实现弹幕的内容；

2️⃣实现自定义表情键盘和系统键盘之间的切换功能；

3️⃣实现通过放大器来查看选中表情的功能；

4️⃣用Switch开关来实现弹幕的显示与隐藏功能；

5️⃣通过是否输入弹幕的内容来监听“发送”按钮是否可用；

6️⃣对自定义表情键盘进行单独的抽取和封装，可以单独使用；

7️⃣对绘制弹幕的方法进行单独的抽取和疯转，可以单独使用；

8️⃣实现对计算文字的真实尺寸的方法进行封装；

9️⃣可实现全屏（或满屏）弹幕的功能；

在控制器中加载弹幕的方法:
```
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
    });
    }
  ```
绘制弹幕内容的部分代码：
```
+(XGImage *)xg_imageWithBarrage:(XGBarrageModel *)barrage{
     
    CGFloat marginX = 5;
    CGFloat expressionW = XGBarrageExpressionW;
    CGFloat expressionH = expressionW;
    CGFloat iconW = XGBarrageH;
    CGFloat iconH = iconW;
    CGSize userNameSize = [barrage.userName sizeWithFont:XGBarrageUserNameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize contentSize = [barrage.content sizeWithFont:XGBarrageContentFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];

    CGFloat contentTextW = iconH + marginX * 4 + userNameSize.width + contentSize.width + barrage.expression.count * expressionH;
    CGFloat contentTextH = XGBarrageH;
    CGSize contentTextSize = CGSizeMake(contentTextW, contentTextH);

    UIGraphicsBeginImageContextWithOptions(contentTextSize, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, iconW, iconH));
    UIImage *icon = [UIImage imageNamed:barrage.icon];
    CGContextClip(ctx);
    [icon drawInRect:CGRectMake(0, 0, iconW, iconH)];
    CGContextRestoreGState(ctx);
    
    CGFloat bgX = iconW + marginX;
    CGFloat bgW = contentTextW - bgX;
    CGRect bgF = CGRectMake(bgX, 0, bgW, contentTextH);
    barrage.type ? [[UIColor clearColor] set] : [[UIColor clearColor] set];
    [[UIBezierPath bezierPathWithRoundedRect:bgF cornerRadius:XGBarrageH * 0.5] fill];
    
    CGFloat userNameX = bgX + marginX;
    CGFloat userNameY = (contentTextH - userNameSize.height) * 0.5;
    [barrage.userName drawAtPoint:CGPointMake(userNameX, userNameY) withAttributes:@{NSFontAttributeName:XGBarrageUserNameFont,NSForegroundColorAttributeName:barrage.type ? [UIColor magentaColor] : [UIColor redColor]}];
    
    CGFloat contentX = userNameX + userNameSize.width + marginX;
    [barrage.content drawAtPoint:CGPointMake(contentX, userNameY) withAttributes:@{NSFontAttributeName:XGBarrageContentFont,NSForegroundColorAttributeName:barrage.type ? [UIColor whiteColor] : [UIColor whiteColor]}];
    
    __block CGFloat expressionX = contentX + contentSize.width;
    CGFloat expressionY = (contentTextH - expressionH) * 0.5;
    [barrage.expression enumerateObjectsUsingBlock:^(NSString *expressionName, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *expression = [UIImage imageNamed:expressionName];
        [expression drawInRect:CGRectMake(expressionX, expressionY, expressionW, expressionH)];
        expressionX += expressionW;
    }];
    
    // 从当前位图上下文获得图片
    UIImage *userIcon = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    ctx = nil;
```

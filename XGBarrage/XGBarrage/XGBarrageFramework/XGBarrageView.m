//
//  XGBarrageView.m
//  XGBarrage
//
//  Created by 小果 on 16/9/30.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGBarrageView.h"
#import "XGImage.h"
#import "XGBarrageModel.h"

#define XGMovementSpeed 2
#define XGBarrageH 40
#define XGBarrageUserNameFont [UIFont boldSystemFontOfSize:25]
#define XGBarrageContentFont [UIFont systemFontOfSize:25]
#define XGBarrageExpressionW 32

@implementation XGBarrageView{
    NSMutableArray *_images;        //用来存放绘制的图片
    NSMutableArray *_deleteImages;  // 用来存放删除超出屏幕的图片
}

#pragma mark - 弹幕开关
-(void)xg_openOrCloseWithBarrage:(BOOL)open{
    self.hidden = !open;
}

#pragma mark - 根据模型产生一张图片
+(XGImage *)xg_imageWithBarrage:(XGBarrageModel *)barrage{
     
    // 弹幕内容之间的间距
    CGFloat marginX = 5;
    // 用户输入的表情的尺寸
    CGFloat expressionW = XGBarrageExpressionW;
    CGFloat expressionH = expressionW;
    // 头像的尺寸
    CGFloat iconW = XGBarrageH;
    CGFloat iconH = iconW;
    // 计算用户名的尺寸
    CGSize userNameSize = [barrage.userName sizeWithFont:XGBarrageUserNameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    // 计算内容的尺寸
    CGSize contentSize = [barrage.content sizeWithFont:XGBarrageContentFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];

    // 开启上下文
    CGFloat contentTextW = iconH + marginX * 4 + userNameSize.width + contentSize.width + barrage.expression.count * expressionH;
    CGFloat contentTextH = XGBarrageH;
    CGSize contentTextSize = CGSizeMake(contentTextW, contentTextH);

    UIGraphicsBeginImageContextWithOptions(contentTextSize, NO, 0.0);
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 保存图形上下文到栈里面
    CGContextSaveGState(ctx);
    
    // 绘制圆形图片
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, iconW, iconH));
    // 绘制图片
    UIImage *icon = [UIImage imageNamed:barrage.icon];
    // 剪掉超出圆形的图片内容(也就是说后面绘制的所有的内容都会在这个圆形内部进行绘制)
    CGContextClip(ctx);
    [icon drawInRect:CGRectMake(0, 0, iconW, iconH)];
    
    // 将图形上下文移出栈
    CGContextRestoreGState(ctx);
    
    // 绘制背景图片
    CGFloat bgX = iconW + marginX;
    CGFloat bgW = contentTextW - bgX;
    CGRect bgF = CGRectMake(bgX, 0, bgW, contentTextH);
    barrage.type ? [[UIColor clearColor] set] : [[UIColor clearColor] set];
    [[UIBezierPath bezierPathWithRoundedRect:bgF cornerRadius:XGBarrageH * 0.5] fill];
    
    // 绘制用户名
    CGFloat userNameX = bgX + marginX;
    CGFloat userNameY = (contentTextH - userNameSize.height) * 0.5;
    [barrage.userName drawAtPoint:CGPointMake(userNameX, userNameY) withAttributes:@{NSFontAttributeName:XGBarrageUserNameFont,NSForegroundColorAttributeName:barrage.type ? [UIColor magentaColor] : [UIColor redColor]}];
    
    // 绘制用户输入的内容
    CGFloat contentX = userNameX + userNameSize.width + marginX;
    [barrage.content drawAtPoint:CGPointMake(contentX, userNameY) withAttributes:@{NSFontAttributeName:XGBarrageContentFont,NSForegroundColorAttributeName:barrage.type ? [UIColor whiteColor] : [UIColor whiteColor]}];
    
    // 绘制表情
    __block CGFloat expressionX = contentX + contentSize.width;
    CGFloat expressionY = (contentTextH - expressionH) * 0.5;
    [barrage.expression enumerateObjectsUsingBlock:^(NSString *expressionName, NSUInteger idx, BOOL * _Nonnull stop) {
        // 加载表情
        UIImage *expression = [UIImage imageNamed:expressionName];
        // 绘制表情
        [expression drawInRect:CGRectMake(expressionX, expressionY, expressionW, expressionH)];
        // 表情之间的间距进行累加
        expressionX += expressionW;
    }];
    
   
    // 从当前位图上下文获得图片
    UIImage *userIcon = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    ctx = nil;
    
    XGImage *resultImage = [[XGImage alloc] initWithCGImage:userIcon.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return resultImage;
}

#pragma mark - 刷新弹幕的内容的位置
-(void)updateWithImageLocation{
    [self setNeedsDisplay];
}
#pragma mark - 懒加载
-(NSMutableArray *)images{
    if (nil == _images) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}
-(NSMutableArray *)deleteImages{
    if (nil == _deleteImages) {
        _deleteImages = [[NSMutableArray alloc] init];
    }
    return _deleteImages;
}

@end

//
//  UIImage+Extension.m
//  
//
//  Created by 小果 on 16/10/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+(UIImage *)imageWithName:(NSString *)name
{
    UIImage *image = nil;
    if (iOS7){   // 处理iOS7的情况
        NSString *newName = [name stringByAppendingString:@"_os7"];
        image = [UIImage imageNamed:newName];
    }
    if (image == nil){
        image = [UIImage imageNamed:name];
    }
    return image;
}


/**
 *  返回一张可以随意拉伸但不变形的图片
 */
+(UIImage *)resizedImage:(NSString *)name{
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat W = normal.size.width * 0.5;
    CGFloat H = normal.size.height * 0.5;
    return  [normal resizableImageWithCapInsets:UIEdgeInsetsMake(H, W, H, W)];
}

/**
 *  返回一张添加水印的图片
 */
+(instancetype)waterImageWithBackground:(NSString *)bg logo:(NSString *)logo{
    // 1、加载原图
    UIImage *bgImage = [UIImage imageNamed:bg];
    
    // 2、开启上下文
    UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, 0.0);
    // 3、画背景图片
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    // 4、画右下角的水印
    UIImage *waterImage = [UIImage imageNamed:logo];
        // 4.1 图片缩放的比例
    CGFloat scale = 0.2;
        // 4.2 间距
    CGFloat margin = 5;
        // 4.3 设置水印的位置和尺寸
    CGFloat waterW = waterImage.size.width * scale;
    CGFloat waterH = waterImage.size.height *scale;
    CGFloat waterX = bgImage.size.width - waterW - margin;
    CGFloat waterY = bgImage.size.height - waterH - margin;
    [waterImage drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];
    
    // 5、从上下文中取出制作完毕的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6、结束上下文
    UIGraphicsEndImageContext();
    
    // 7、将iamge对象压缩成PNG格式的二进制数据
    NSData *data = UIImagePNGRepresentation(newImage);
    
    // 8、写入文件
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"new.png"];
    [data writeToFile:path atomically:YES];
    
    return newImage;
}

/**
 *  返回一张带边框的圆形图
 */
+(instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    // 1、加载原图
    UIImage *oldImage = [UIImage imageNamed:name];
    
    // 2、开启上下文
    CGFloat imageW = oldImage.size.width + borderWidth * 2;
    CGFloat imageH = oldImage.size.height + borderWidth * 2;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3、取得当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4、设置颜色
    [borderColor set];
    // 5、画大圆
        // 5.1 大圆半径
    CGFloat bigRadius = imageW * 0.5;
        // 5.2 大圆的位置
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    
    // 6、画小圆
        // 6.1 小圆半径
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 7、裁剪(这一步只有后面的东西才会受影响）
    CGContextClip(ctx);
    
    // 8、画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 9、取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 10、结束上下文
    UIGraphicsEndImageContext();
    
    
    return newImage;
}

/**
 *  返回截屏后的图片
 */
+(instancetype)captureWithView:(UIView *)view{
    // 1、开启上下文
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0);
    
    // 2、将控制器view的layer渲染到上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 3、取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4、结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end

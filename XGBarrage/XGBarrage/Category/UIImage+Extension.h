//
//  UIImage+Extension.h
//  
//
//  Created by 小果 on 16/10/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  根据图片名自动加载适配ios7he 7
 */
+(UIImage *)imageWithName:(NSString *)name;

/**
 *  返回一张可以随意拉伸但不变形的图片
 */
+(UIImage *)resizedImage:(NSString *)name;

/**
 *  返回一张加水印的图片
 *
 *  @param bg   被加水印的图片
 *  @param logo 即将添加的图片
 *
 *  @return 制作完毕的水印图片
 */

+(instancetype)waterImageWithBackground:(NSString *)bg logo:(NSString *)logo;
/**
 *  返回带边框的圆环形图
 *
 *  @param name        图片的名字
 *  @param borderWidth 圆环的线宽
 *  @param borderColor 圆环的颜色
 *
 *  @return 带边框的圆形图
 */
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  返回截屏的view
 *
 *  @param view 要截取的view
 *
 *  @return 截屏后的图片
 */
+ (instancetype)captureWithView:(UIView *)view;


@end

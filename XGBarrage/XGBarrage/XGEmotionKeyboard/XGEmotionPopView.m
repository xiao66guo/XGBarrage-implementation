//
//  XGEmotionPopView.m
//  XGBarrage
//
//  Created by 小果 on 16/10/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGEmotionPopView.h"
#import "XGEmotionView.h"
@interface XGEmotionPopView ()
@property (weak, nonatomic) IBOutlet XGEmotionView *emotionView;

@end

@implementation XGEmotionPopView

+(instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XGEmotionPopView" owner:nil options:nil] lastObject];
}

-(void)showFromEmotionView:(XGEmotionView *)fromEmotionView
{
    if (fromEmotionView == nil) return;
    // 1、显示表情
    self.emotionView.emotion = fromEmotionView.emotion;
    
    // 2、添加到windows窗口上的最后一个控件的上面
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    // 3、设置控件的位置
    CGFloat centerX = fromEmotionView.centerX;
    CGFloat centerY = fromEmotionView.centerY - self.height * 0.5;
    CGPoint center = CGPointMake(centerX, centerY);
    self.center = [window convertPoint:center fromView:fromEmotionView.superview];
}


-(void)dismiss
{
    [self removeFromSuperview];
}
/**
 *  当一个空间显示之前会调用一次（如果空间在显示之前没有尺寸，不会调用这个方法）
 *
 *  @param rect 控件的bounds
 */

-(void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"emoticon_keyboard_magnifier"] drawInRect:rect];
}


@end

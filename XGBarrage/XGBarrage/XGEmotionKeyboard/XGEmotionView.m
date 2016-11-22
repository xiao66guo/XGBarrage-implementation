//
//  XGEmotionView.m
//  XGBarrage
//
//  Created by 小果 on 16/10/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGEmotionView.h"
#import "XGEmotion.h"
@implementation XGEmotionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 取消点击效果
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}
-(void)setEmotion:(XGEmotion *)emotion
{
    _emotion = emotion;
    
    if (emotion.code){    // emoji表情
        
        // 取消动画效果
        [UIView setAnimationsEnabled:NO];
        // emoji的大小取决于字体的大小
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        [self setTitle:emotion.emoji forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
        // 再次开启动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView setAnimationsEnabled:YES];
        });
    }else {    // 图片表情
        NSString *icon = [NSString stringWithFormat:@"%@",emotion.png];
        UIImage *image = [UIImage imageWithName:icon];
        if (iOS7) {
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
    }
}


@end

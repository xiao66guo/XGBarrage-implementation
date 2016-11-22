//
//  XGEmotionAttachment.m
//  XGBarrage
//
//  Created by 小果 on 16/10/4.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGEmotionAttachment.h"
#import "XGEmotion.h"
@implementation XGEmotionAttachment

-(void)setEmotion:(XGEmotion *)emotion{
    _emotion = emotion;
    self.image = [UIImage imageWithName:[NSString stringWithFormat:@"%@",emotion.png]];
}
@end

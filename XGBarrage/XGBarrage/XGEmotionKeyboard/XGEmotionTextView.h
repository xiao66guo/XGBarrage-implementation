//
//  XGEmotionTextView.h
//  XGBarrage
//
//  Created by 小果 on 16/10/4.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGTextView.h"
@class XGEmotion;
@interface XGEmotionTextView : XGTextView
/**
 *  拼接表情到最后面
 */
- (void)appendEmotion:(XGEmotion *)emotion;

/**
 *  具体的文字内容
 */
- (NSString *)realText;

@end

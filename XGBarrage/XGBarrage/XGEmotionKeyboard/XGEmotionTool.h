//
//  XGEmotionTool.h
//  XGBarrage
//
//  Created by 小果 on 16/10/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XGEmotion;
@interface XGEmotionTool : NSObject
/**
 *  默认表情
 */
+(NSArray *)defaultEmotions;
/**
 *  emoji表情
 */
+(NSArray *)emojiEmotions;
/**
 *  浪小花表情
 */
+(NSArray *)lxhEmotions;
/**
 *  最近表情
 */
+(NSArray *)recentEmotions;

/**
 *  根据表情的文字描述找出对应的表情对象
 */
+(XGEmotion *)emotionWithDesc:(NSString *)desc;

/**
 *  保存最近使用的表情
 */
+(void)addRecentEmotion:(XGEmotion *)emotion;
@end

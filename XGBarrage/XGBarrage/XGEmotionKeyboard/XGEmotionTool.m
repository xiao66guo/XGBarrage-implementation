//
//  XGEmotionTool.m
//  XGBarrage
//
//  Created by 小果 on 16/10/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGEmotionTool.h"
#import "XGEmotion.h"

@implementation XGEmotionTool

/**   默认表情   */
static NSArray *_defaultEmotions;
/**   emoji表情   */
static NSArray *_emojiEmotions;
/**   浪小花表情   */
static NSArray *_lxhEmotions;

/**   最近表情   */
static NSMutableArray *_recentEmotions;

+(NSArray *)defaultEmotions
{
    if (!_defaultEmotions){
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"default.plist" ofType:nil];
        _defaultEmotions = [XGEmotion mj_objectArrayWithFile:plist];
        
    }
    return _defaultEmotions;
}

+(NSArray *)emojiEmotions
{
    if (!_emojiEmotions){
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"emoji.plist" ofType:nil];
        _emojiEmotions = [XGEmotion mj_objectArrayWithFile:plist];
    }
    return _emojiEmotions;
}

+(NSArray *)lxhEmotions
{
    if (!_lxhEmotions){
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"lxh.plist" ofType:nil];
        _lxhEmotions = [XGEmotion mj_objectArrayWithFile:plist];
    }
    return _lxhEmotions;
}

+(NSArray *)recentEmotions
{
    if (!_recentEmotions) {
        // 到沙盒中加载最近使用的表情数据
        _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:XGRecentFilepath];
        
        if (!_recentEmotions){  // 如果沙盒中没有任何数据
            _recentEmotions = [NSMutableArray array];
        }
    }
    return _recentEmotions;
}

+(void)addRecentEmotion:(XGEmotion *)emotion
{
    // 加载最近的表情数据
    [self recentEmotions];
    
    // 删除之前的表情
    [_recentEmotions removeObject:emotion];
    
    // 添加最新的表情
    [_recentEmotions insertObject:emotion atIndex:0];
    
    // 存储到沙盒中
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:XGRecentFilepath];
}

+(XGEmotion *)emotionWithDesc:(NSString *)desc
{
    if (!desc) return  nil;
    
    __block XGEmotion *foundEmotion = nil;
    // 从默认表情中找
    [[self defaultEmotions] enumerateObjectsUsingBlock:^(XGEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]){
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    if (foundEmotion) return foundEmotion;
    
    // 从浪小花表情中找
    [[self lxhEmotions]  enumerateObjectsUsingBlock:^(XGEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]){
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    return foundEmotion;
}

@end

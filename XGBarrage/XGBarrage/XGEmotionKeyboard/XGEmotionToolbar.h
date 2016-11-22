//
//  XGEmotionToolbar.h
//  XGBarrage
//
//  Created by 小果 on 16/10/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XGEmotionToolbar;

typedef enum{
    XGEmotionTypeRecent,   // 最近
    XGEmotionTypeDefault,  // 默认
    XGEmotionTypeEmoji,    // Emoji
    XGEmotionTypeLxh       // 浪小花
}XGEmotionType;

@protocol XGEmotionToolbarDelegate <NSObject>

@optional
-(void)emotionToolbar:(XGEmotionToolbar *)toolbar didSelectedButton:(XGEmotionType)emotionType;

@end

@interface XGEmotionToolbar : UIView
@property (nonatomic, weak) id<XGEmotionToolbarDelegate> delegate;
@end

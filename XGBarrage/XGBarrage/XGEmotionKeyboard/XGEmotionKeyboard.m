//
//  XGEmotionKeyboard.m
//  XGBarrage
//
//  Created by 小果 on 16/10/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGEmotionKeyboard.h"
#import "XGEmotionListView.h"
#import "XGEmotionToolbar.h"
#import "XGEmotionTool.h"

@interface XGEmotionKeyboard ()<XGEmotionToolbarDelegate>
/**  表情列表   */
@property (nonatomic, weak) XGEmotionListView *listView;
/**  表情工具条   */
@property (nonatomic, weak) XGEmotionToolbar *toolBar;

@end
@implementation XGEmotionKeyboard
+(instancetype)xg_keyboard{
    return [[self alloc] init];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background"]];
        
        // 1、添加表情列表
        XGEmotionListView *listView = [[XGEmotionListView alloc] init];
        //        listView.backgroundColor = [UIColor greenColor];
        [self addSubview:listView];
        self.listView = listView;
        
        // 2、添加表情工具条
        XGEmotionToolbar *toolbar = [[XGEmotionToolbar alloc] init];
        toolbar.delegate = self;
        [self addSubview:toolbar];
        self.toolBar = toolbar;
        
    }
    return self;
}

#pragma mark - 设置frame
/**
 *  设置frame
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1、设置工具条的frame
    self.toolBar.width = self.width;
    self.toolBar.height = 44;
    //    self.toolBar.x = 0;
    self.toolBar.y = self.height - self.toolBar.height;
    
    // 2、设置表情的frame
    self.listView.width = self.width;
    self.listView.height = self.toolBar.y;
}

#pragma mark - XGEmotionToolbarDelegate
-(void)emotionToolbar:(XGEmotionToolbar *)toolbar didSelectedButton:(XGEmotionType)emotionType
{
    switch (emotionType) {
        case XGEmotionTypeDefault:   // 默认
            self.listView.emotions = [XGEmotionTool defaultEmotions];
            break;
            
        case XGEmotionTypeEmoji:   // Emoji
            self.listView.emotions = [XGEmotionTool emojiEmotions];
            break;
            
        case XGEmotionTypeLxh:   // 浪小花
            self.listView.emotions = [XGEmotionTool lxhEmotions];
            break;
            
        case XGEmotionTypeRecent:   // 最近
            self.listView.emotions = [XGEmotionTool recentEmotions];
            break;
    }
}


@end

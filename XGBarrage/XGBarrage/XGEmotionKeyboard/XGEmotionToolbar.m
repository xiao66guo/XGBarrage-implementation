//
//  XGEmotionToolbar.m
//  XGBarrage
//
//  Created by 小果 on 16/10/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#define XGEmotionToolbarButtonMaxCount 4

#import "XGEmotionToolbar.h"

@interface XGEmotionToolbar ()

/** 记录当前选中的按钮  */
@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation XGEmotionToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1、在工具条上添加4个按钮
        [self setupButton:@"最近" tag:XGEmotionTypeRecent];
        [self setupButton:@"默认" tag:XGEmotionTypeDefault];
        [self setupButton:@"Emoji" tag:XGEmotionTypeEmoji];
        [self setupButton:@"浪小花" tag:XGEmotionTypeLxh];
        
        // 2、监听表情选中的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:XGEmotionDedDeleteNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *  表情选中
 */
-(void)emotionDidSelected:(NSNotification *)note
{
    if (self.selectedButton.tag == XGEmotionTypeRecent){
        [self buttonClick:self.selectedButton];
    }
}
/**
 *  在工具条上添加4个按钮
 *
 *  @param title 按钮上的文字
 */
-(UIButton *)setupButton:(NSString *)title tag:(XGEmotionType)tag
{
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    
    // 文字
    [button setTitle:title forState:UIControlStateNormal];
    // 普通状态下文字的颜色
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 选中状态下文字的颜色
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    // 监听按钮的点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    // 文字的大小
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    
    // 将按钮添加到工具条上
    [self addSubview:button];
    
    // 设置按钮的背景图片
    NSInteger count = self.subviews.count;
    if (count == 1) {   // 第一个按钮
        // 普通状态下按钮的背景图片
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_left_normal"] forState:UIControlStateNormal];
        // 选中状态下按钮的背景图片
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_left_selected"] forState:UIControlStateSelected];
        
    }else if (count == XGEmotionToolbarButtonMaxCount){   // 最后一个按钮
        // 普通状态下按钮的背景图片
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_right_normal"] forState:UIControlStateNormal];
        // 选中状态下按钮的背景图片
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_right_selected"] forState:UIControlStateSelected];
        
    }else{   // 中间的按钮
        // 普通状态下按钮的背景图片
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_mid_normal"] forState:UIControlStateNormal];
        // 选中状态下按钮的背景图片
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_mid_selected"] forState:UIControlStateSelected];
    }
    return button;
}
/**
 *  监听按钮的点击
 */
-(void)buttonClick:(UIButton *)button
{
    // 1、控制按钮的状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    // 2、通知代理
    if ([self.delegate respondsToSelector:@selector(emotionToolbar:didSelectedButton:)]){
        [self.delegate emotionToolbar:self didSelectedButton:(XGEmotionType)button.tag];
    }
}

-(void)setDelegate:(id<XGEmotionToolbarDelegate>)delegate
{
    _delegate = delegate;
    
    // 获得“默认”按钮
    UIButton *defaultButton = (UIButton *)[self viewWithTag:XGEmotionTypeDefault];
    
    // 默认选中”默认"按钮
    [self buttonClick:defaultButton];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置工具条按钮的frame
    CGFloat buttonW = self.width / XGEmotionToolbarButtonMaxCount;
    CGFloat buttonH = self.height;
    for (int i = 0; i < XGEmotionToolbarButtonMaxCount; i++) {
        UIButton *button = self.subviews[i];
        button.width = buttonW;
        button.height = buttonH;
        button.x = i * buttonW;
    }
}
@end
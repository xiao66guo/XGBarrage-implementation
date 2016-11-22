//
//  XGEmotionGridView.m
//  XGBarrage
//
//  Created by 小果 on 16/10/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGEmotionGridView.h"
#import "XGEmotionPopView.h"
#import "XGEmotionView.h"
#import "XGEmotionTool.h"

@interface XGEmotionGridView ()

@property (nonatomic, weak) UIButton *deleteButton;
@property (nonatomic, strong) NSMutableArray *emotionViews;
@property (nonatomic, strong) XGEmotionPopView *popView;

@end
@implementation XGEmotionGridView
-(XGEmotionPopView *)popView
{
    if (!_popView){
        self.popView = [XGEmotionPopView popView];
    }
    return _popView;
}

/**   存放所有的表情  */
-(NSMutableArray *)emotionViews
{
    if (!_emotionViews){
        self.emotionViews = [NSMutableArray array];
    }
    return _emotionViews;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加删除按钮
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        
        // 监听删除按钮的点击
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
        
        // 给自己添加一个长按手势识别器
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] init];
        [recognizer addTarget:self action:@selector(longPress:)];
        // 添加手势识别器
        [self addGestureRecognizer:recognizer];
    }
    return self;
}
-(XGEmotionView *)emotionViewWithPoint:(CGPoint)point
{
    __block XGEmotionView *foundEmotionView = nil;
    [self.emotionViews enumerateObjectsUsingBlock:^(XGEmotionView *emotionView, NSUInteger idx, BOOL *stop) {
        
        if (CGRectContainsPoint(emotionView.frame, point) && emotionView.hidden == NO){
            foundEmotionView = emotionView;
            // 停止遍历
            *stop = YES;
        }
    }];
    return foundEmotionView;
}
/**
 *  监听触发长按的手势
 */
-(void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    // 1、捕获触摸点
    CGPoint point = [recognizer locationInView:recognizer.view];
    
    // 2、检测触摸点落在哪个表情上
    XGEmotionView *emotionView = [self emotionViewWithPoint:point];
    
    if (recognizer.state == UIGestureRecognizerStateEnded){   // 手松开了
        // 移除表情弹出的控件
        [self.popView dismiss];
        
        // 选中表情
        [self selecteEmotion:emotionView.emotion];
    }else{   // 手没有松开
        // 显示表情弹出控件
        [self.popView showFromEmotionView:emotionView];
    }
}
-(void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    // 添加表情
    NSInteger count = emotions.count;   // 所有表情的个数
    NSInteger currentEmotionViewCount = self.emotionViews.count;  // 当前页中的表情的总个数
    
    for (int i = 0; i < count; i++) {
        XGEmotionView *emotionView = nil;
        
        if (i >= currentEmotionViewCount){
            emotionView = [[XGEmotionView alloc] init];

            // 监听按钮的点击
            [emotionView addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:emotionView];
            [self.emotionViews addObject:emotionView];
        }else {
            emotionView = self.emotionViews[i];
        }
        // 传递模型数据
        emotionView.emotion = emotions[i];
        emotionView.hidden = NO;
    }
    // 隐藏多余的emotionView
    for (NSInteger i = count; i < currentEmotionViewCount; i++) {
        UIButton *emotionView = self.emotionViews[i];
        emotionView.hidden = YES;
    }
}

// 实现监听按钮的单击方法
-(void)emotionClick:(XGEmotionView *)emotionView
{
    [self.popView showFromEmotionView:emotionView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView dismiss];
        
        // 选中表情
        [self selecteEmotion:emotionView.emotion];
//        NSLog(@"选中的表情：%@",emotionView.emotion);
    });
    
}
/**
 *  选中表情
 */
-(void)selecteEmotion:(XGEmotion *)emotion
{
    if (emotion == nil) return;
    
    // 保存使用记录
    [XGEmotionTool addRecentEmotion:emotion];
    
    // 发出一个选中表情的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:XGEmotionDidSelectedNotification object:nil userInfo:@{XGSelectedEmotion : emotion}];
}
-(void)deleteClick
{
    // 发出一个删除按钮的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:XGEmotionDedDeleteNotification object:nil userInfo:nil];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat leftInset = 15;  // 左边间距
    CGFloat topInset = 15;   // 顶部间距
    
    NSInteger count = self.emotionViews.count;
    CGFloat emotionViewW = (self.width - 2 * leftInset) / XGEmotionMaxCols;
    CGFloat emotionViewH = (self.height - topInset) / XGEmotionMaxRows;
    
    for (int i = 0; i < count; i++) {
        UIButton *emotionView = self.emotionViews[i];
//        emotionView.backgroundColor = [UIColor magentaColor];
        emotionView.x = leftInset + (i % XGEmotionMaxCols) * emotionViewW;
        emotionView.y = topInset + (i / XGEmotionMaxCols) * emotionViewW;
        emotionView.width = emotionViewW;
        emotionView.height = emotionViewH;
    }
    // 2、删除按钮
    self.deleteButton.width = emotionViewW;
    self.deleteButton.height = emotionViewH;
    self.deleteButton.x = self.width - leftInset - self.deleteButton.width;
#warning Modify the position of the delete button
    self.deleteButton.y = self.height - self.deleteButton.height - 10;
    
}
@end

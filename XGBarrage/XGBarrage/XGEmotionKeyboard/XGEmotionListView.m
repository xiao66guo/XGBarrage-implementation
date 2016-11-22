//
//  XGEmotionListView.m
//  XGBarrage
//
//  Created by 小果 on 16/10/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGEmotionListView.h"
#import "XGEmotionGridView.h"

@interface XGEmotionListView () <UIScrollViewDelegate>
/**  显示表情的UIScrollView   */
@property (nonatomic, weak) UIScrollView *scrollView;
/**  显示页码的UIPageControl  */
@property (nonatomic, weak) UIPageControl *pageControl;

@end
@implementation XGEmotionListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1、显示表情的UIScrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        // 滚动条是UIScrollView的子控件
        // 隐藏滚动条，可以屏蔽多余的子控件
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        //        scrollView.backgroundColor = [UIColor greenColor];
        
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // 2、显示页码的UIPageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];

        pageControl.hidesForSinglePage = YES;
        //        pageControl.backgroundColor = [UIColor blueColor];
        // 设置页码的图片
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKey:@"_currentPageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKey:@"_pageImage"];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}
-(void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    // 设置总页数
    NSInteger totalPages = (emotions.count + XGEmotionMaxCountPage - 1) / XGEmotionMaxCountPage;
    // 当前gridView的个数
    NSInteger currentGridViewCount = self.scrollView.subviews.count;
    self.pageControl.numberOfPages = totalPages;
    self.pageControl.currentPage = 0;
    // 如果页数 <= 1 是隐藏页码图片
    //    self.pageControl.hidden = totalPages <= 1;
    
    // 决定scrollView显示多少页表情
    for (int i = 0; i < self.pageControl.numberOfPages; i++) {
        // 获得i位置对应的XGEmotionGridView
        XGEmotionGridView *gridView = nil;
        if (i >= currentGridViewCount){  // 说明XGEmotionGridView的个数不够
            gridView = [[XGEmotionGridView alloc] init];
            //            gridView.backgroundColor = XGRandomColor;
            [self.scrollView addSubview:gridView];
        }else{  // 说明XGEmotionGridView的个数足够，从self.scrollView.subViews中取出XGEmotionGridView
            gridView = self.scrollView.subviews[i];
        }
        
        // 给XGEmotionGridView设置表情数据
        NSInteger loc = i * XGEmotionMaxCountPage;  // i * 每页表情的最大个数
        NSInteger len = XGEmotionMaxCountPage;
        if (loc + len > emotions.count){  // 对越界进行判断处理
            len = emotions.count - loc;
        }
        NSRange gridViewEmotionsRange = NSMakeRange(loc, len);
        NSArray *gridViewEmotions = [emotions subarrayWithRange:gridViewEmotionsRange];
        gridView.emotions = gridViewEmotions;
        gridView.hidden = NO;
    }
    // 隐藏后面不需要用到的gridView
    for (NSInteger i = totalPages; i < currentGridViewCount; i++) {
        XGEmotionGridView *gridView = self.scrollView.subviews[i];
        gridView.hidden = YES;
    }
    
    // 重新布局子控件
    [self setNeedsLayout];
    
    // 表情滚动到最前面
    self.scrollView.contentOffset = CGPointZero;
    
    //    XGLog(@"setEmotions----%d",self.scrollView.subviews.count);
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1、设置UIPageControl的frame
    self.pageControl.width = self.width;
    self.pageControl.height = 35;
    self.pageControl.y = self.height - self.pageControl.height;
    
    // 2、设置UIScrollView的frame
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    
    // 3、设置UIScrollView内部控件的尺寸
    NSInteger count = self.pageControl.numberOfPages;
    CGFloat gridW = self.scrollView.width;
    CGFloat gridH = self.scrollView.height;
    // 设置UIScrollView的滚动范围
    self.scrollView.contentSize = CGSizeMake(count * gridW, 0);
    for (int i = 0; i < count; i++) {
        XGEmotionGridView *gridView = self.scrollView.subviews[i];
        gridView.width = gridW;
        gridView.height = gridH;
        gridView.x = i * gridW;
    }
}
#pragma - mark UIScrollView的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.width + 0.5);
}
@end
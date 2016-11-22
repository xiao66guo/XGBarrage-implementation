//
//  XGBarrageView.h
//  XGBarrage
//
//  Created by 小果 on 16/9/30.
//  Copyright © 2016年 小果. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XGImage,XGBarrageModel;
@interface XGBarrageView : UIView

/**
 *  根据弹幕模型生成一张图片
 */
+(XGImage *)xg_imageWithBarrage:(XGBarrageModel *)barrage;
/**
 *  弹幕开关
 */
-(void)xg_openOrCloseWithBarrage:(BOOL)open;

@property (nonatomic, strong) CADisplayLink *link;
@end

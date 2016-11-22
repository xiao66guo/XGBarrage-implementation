//
//  XGEmotionPopView.h
//  XGBarrage
//
//  Created by 小果 on 16/10/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XGEmotionView;
@interface XGEmotionPopView : UIView
+(instancetype)popView;

/**
 *  显示表情的观察器
 */
-(void)showFromEmotionView:(XGEmotionView *)fromEmotionView;
-(void)dismiss;
@end

//
//  XGBarrageModel.h
//  XGBarrage
//
//  Created by 小果 on 16/10/1.
//  Copyright © 2016年 小果. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XGBarrageModel : NSObject
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *userName;
/**
 *  用户头像
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  用户输入的内容
 */
@property (nonatomic, copy) NSString *content;
/**
 *  用户的类型
 */
@property (nonatomic, assign) BOOL type;
/**
 *  用户输入的表情：YES : me   NO : other
 */
@property (nonatomic, strong) NSArray *expression;

+(instancetype)xg_barrageWithDict:(NSDictionary *)dict;
@end

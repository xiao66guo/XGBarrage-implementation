//
//  XGBarrageModel.m
//  XGBarrage
//
//  Created by 小果 on 16/10/1.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGBarrageModel.h"

@implementation XGBarrageModel

+(instancetype)xg_barrageWithDict:(NSDictionary *)dict{
    id objc = [[self alloc] init];
    [objc setValuesForKeysWithDictionary:dict];
    return objc;
}
@end
 
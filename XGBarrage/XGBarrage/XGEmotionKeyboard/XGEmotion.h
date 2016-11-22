//
//  XGEmotion.h
//  XGBarrage
//
//  Created by 小果 on 16/10/3.
//  Copyright © 2016年 小果. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XGEmotion : NSObject<NSCoding>
/**  表情的文字描述  */
@property (nonatomic, copy) NSString *chs;

@property (nonatomic, copy) NSString *cht;
/**  表情的PNG图片名  */
@property (nonatomic, copy) NSString *png;

/**  emoji表情的编码  */
@property (nonatomic, copy) NSString *code;


/**  表情存放的文件夹及目录  */
//@property (nonatomic, copy) NSString *directory;

/**  emoji表情的字符  */
@property (nonatomic, copy) NSString *emoji;
@end

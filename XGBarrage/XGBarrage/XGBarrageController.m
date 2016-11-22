//
//  XGBarrageController.m
//  XGBarrage
//
//  Created by 小果 on 16/9/30.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGBarrageController.h"
#import "XGBarrage.h"
#import "XGKeyboard.h"
#define XGAnimationDuration 4
@implementation XGBarrageController{
    UIImageView       *_barrageBackgroundImage; // 动画的view
    UISwitch          *_barrageSwitch;          // 动画的开关
    NSTimer           *_timer;                  // 用来随机加载弹幕的时间
    UIView            *_toolView;               // 底部的工具条
    UIButton          *_emotionBtn;             // 表情和键盘的切换按钮
    UIButton          *_send;                   // 发送按钮
    NSMutableArray    *_barrageArray;           // 弹幕的个数
    XGBarrageView     *_barrageView;            // 弹幕的view
    XGEmotionTextView *_textView;               // 用来输入表情的TextView
    XGEmotionKeyboard *_keyboard;               // 表情键盘
    BOOL              _isChangingKeyboard;
}
-(XGEmotionKeyboard *)keyboard{
    if (nil == _keyboard) {
        _keyboard = [XGEmotionKeyboard xg_keyboard];
        _keyboard.width = ScreenW;
        _keyboard.height = 258;
    }
    return _keyboard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置弹幕的内容
    [self setupBarrageViewWithContent];
    
    // 设置底部工具条
    [self createBarrageWithBottomToolbar];
    
    // 键盘即将显示，就会发出UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xg_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏，就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xg_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 监听表情的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xg_emotionDidSelected:) name:XGEmotionDidSelectedNotification object:nil];
    // 监听删除按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xg_emotionDidDeleted:) name:XGEmotionDedDeleteNotification object:nil];
}

#pragma mark - 设置弹幕内容
-(void)setupBarrageViewWithContent{
    // 弹幕的背景
    _barrageBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, 300)];
    _barrageBackgroundImage.opaque = YES;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"bgP.gif" withExtension:nil];
    [_barrageBackgroundImage sd_setImageWithURL:url];
    [self.view addSubview:_barrageBackgroundImage];
    
    // 显示弹幕的View
    _barrageView = [[XGBarrageView alloc] initWithFrame:_barrageBackgroundImage.bounds];
    _barrageView.backgroundColor = [UIColor clearColor];
    [_barrageBackgroundImage addSubview:_barrageView];
    
    // 加载数据
    [self loadData:@"XGBarrage.plist"];
    
    // 弹幕开关
    _barrageSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenW - 60, _barrageBackgroundImage.height+20, 0, 0)];
    [_barrageSwitch setOn:NO animated:YES];
    [_barrageSwitch addTarget:self action:@selector(barrageSwitchValueChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_barrageSwitch];
    _barrageSwitch.onTintColor = [UIColor magentaColor];
    _barrageSwitch.thumbTintColor = [UIColor redColor];
    _barrageSwitch.tintColor = [UIColor yellowColor];
}

#pragma mark - 移除定时器
-(void)deleteTimer{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - 控制是否显示弹幕
-(void)barrageSwitchValueChange:(UISwitch *)sender{
    if (_barrageSwitch.isOn) {
        _barrageSwitch.thumbTintColor = [UIColor greenColor];
        [self addMainTimer];
    }else{
        _barrageSwitch.thumbTintColor = [UIColor redColor];
        [self deleteTimer];
    }
    [_barrageView xg_openOrCloseWithBarrage:sender.on];
}

#pragma mark - 添加定时器
-(void)addMainTimer{
    NSInteger Index = arc4random_uniform(1)+1;
    _timer = [NSTimer scheduledTimerWithTimeInterval:Index target:self selector:@selector(loadBarrageViewSource) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}


#pragma mark - 加载数据
-(void)loadData:(NSString *)fileName{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    _barrageArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        XGBarrageModel *model = [XGBarrageModel xg_barrageWithDict:dict];
        [_barrageArray addObject:model];
    }];
}

#pragma mark - 加载弹幕的方法
-(void)loadBarrageViewSource{
    // 加载随机的弹幕模型
    NSInteger arcIndex = arc4random_uniform((u_int32_t)_barrageArray.count);
    XGBarrageModel *barrage = _barrageArray[arcIndex];
    // 用随机的弹幕模型产生一张图片
    XGImage *image = [XGBarrageView xg_imageWithBarrage:barrage];
    image.imageX = self.view.bounds.size.width;
    image.imageY = arc4random_uniform(_barrageView.bounds.size.height - image.size.height);

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGRect rect = imageView.frame;
    rect.origin.x = image.imageX;
    rect.origin.y = image.imageY;
    imageView.frame = rect;
    
    [_barrageView addSubview:imageView];
    
    CABasicAnimation *anim = [[CABasicAnimation alloc] init];
    anim.keyPath = @"position.x";
    anim.toValue = @(-image.imageX);
    anim.duration = XGAnimationDuration;
    [imageView.layer addAnimation:anim forKey:@"animKey"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(XGAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imageView removeFromSuperview];
    });
}

#pragma mark - 设置底部工具条
-(void)createBarrageWithBottomToolbar{
    // 底部工具条
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 43, ScreenW, 44)];
    _toolView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chat_bottom_bg"]];
    [self.view addSubview:_toolView];
    
    _send = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 55, 7, 50, 30)];
    _send.layer.cornerRadius = 5;
    _send.layer.masksToBounds = YES;
    _send.backgroundColor = [UIColor lightGrayColor];
    _send.enabled = NO;
    [_send setTitle:@"发送" forState:UIControlStateNormal];
    [_send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_send.titleLabel sizeToFit];
    [_send addTarget:self action:@selector(xg_sendWithBarrageContent) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:_send];

    // 表情按钮
    _emotionBtn = [[UIButton alloc] initWithFrame:CGRectMake(_send.x - 44, 0, 44, 44)];
    [_emotionBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
    [_emotionBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_emotionBtn addTarget:self action:@selector(xg_openEmotionKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:_emotionBtn];
    
    _textView = [[XGEmotionTextView alloc] initWithFrame:CGRectMake(5, 5, ScreenW - _emotionBtn.width - _send.width - 10, 34)];
    _textView.layer.cornerRadius = 5;
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.alwaysBounceVertical = YES;
    _textView.delegate = self;
    _textView.placehoder = @"请输入弹幕的内容";
    [_toolView addSubview:_textView];
}

#pragma mark - 键盘即将隐藏的方法
-(void)xg_keyboardWillHide:(NSNotification *)noti
{
    if (_isChangingKeyboard){
        _isChangingKeyboard = NO;
        return;
    }
    // 1、键盘隐藏时需要的时间
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2、动画
    [UIView animateWithDuration:duration animations:^{
    _toolView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - 键盘即将弹出的方法
-(void)xg_keyboardWillShow:(NSNotification *)noti
{
    // 1、键盘弹出时需要的时间
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2、动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘的高度
        CGRect keyboardF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        _toolView.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
    }];
}

#pragma mark - 移除通知
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - view显示完毕的时候在弹出键盘，为了避免在显示控制器的时候会卡住
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_textView becomeFirstResponder];
}

#pragma mark - 点击表情按钮时打开键盘的方法
-(void)xg_openEmotionKeyboard{
    _isChangingKeyboard = YES;
    
    if (_textView.inputView) { // 当前显示的是自定义键盘，切换为系统自带的键盘
        [_emotionBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
        
        _textView.inputView = nil;
        
    }else{// 当前显示的是系统自带的键盘，切换为自定义的键盘
        [_emotionBtn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        // 如果临时更换了文本框的键盘，就需要重新打开键盘
        _textView.inputView = self.keyboard;
    }
    // 关闭键盘
    [_textView resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 打开键盘
        [_textView becomeFirstResponder];
    });
}

#pragma mark - 选中表情时的方法
-(void)xg_emotionDidSelected:(NSNotification *)noti{
    XGEmotion *emotion = noti.userInfo[XGSelectedEmotion];
    
    // 拼接表情
    [_textView appendEmotion:emotion];
    
}

#pragma mark - 删除表情的方法
-(void)xg_emotionDidDeleted:(NSNotification *)noti{
    [_textView deleteBackward];
}

#pragma mark - textView中的文字改变时调用的方法
-(void)textViewDidChange:(UITextView *)textView{
    _send.backgroundColor = _textView.realText.length ? [UIColor colorWithRed:0/255.0 green:128/255.0 blue:255/255.0 alpha:1.0] : [UIColor lightGrayColor];
    _send.enabled = _textView.realText.length;
}

#pragma mark - 点击发送按钮执行的方法
-(void)xg_sendWithBarrageContent{
    _send.backgroundColor = [UIColor lightGrayColor];
    _send.enabled = NO;
        
    // 让textView失去第一响应
    [_textView resignFirstResponder];
    _textView.text = nil;
}

@end

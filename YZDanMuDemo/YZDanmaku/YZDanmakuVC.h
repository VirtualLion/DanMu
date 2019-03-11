//
//  YZDanmakuVC.h
//  YZDanmaku
//
//  Created by 韩云智 on 16/7/4.
//  Copyright © 2016年 YZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZDanmakuVC : UIViewController

//弹幕区域视图
@property (nonatomic, strong) UIView * danmakuView;
//间距
@property (nonatomic, assign) CGFloat interval;
//轨道高度
@property (nonatomic, assign) CGFloat rowHeight;

- (instancetype)initWithFrame:(CGRect)frame turnFrame:(CGRect)turnFrame isUp:(BOOL)isUp;

- (void)danmakuText:(NSString *)text withFont:(UIFont *)font;

- (void)danmakuInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration;

- (void)changeDanmakuFrame:(CGRect)frame;

@end

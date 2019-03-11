//
//  YZDanmakuVC.m
//  YZDanmaku
//
//  Created by 韩云智 on 16/7/4.
//  Copyright © 2016年 YZ. All rights reserved.
//

#import "YZDanmakuVC.h"

@interface YZDanmakuVC ()

@property (nonatomic, strong) NSMutableArray * reusePool;
@property (nonatomic, strong) NSMutableArray * usingLabels;

@property (nonatomic, strong) NSMutableDictionary * beginDict;
@property (nonatomic, strong) NSMutableDictionary * turnDict;

@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic, assign) BOOL isTimer;

@property (nonatomic, assign) CGRect turnFrame;
@property (nonatomic, assign) CGRect beginFrame;

@property (nonatomic, assign) BOOL isUporDown;

@end

@implementation YZDanmakuVC

- (instancetype)initWithFrame:(CGRect)frame turnFrame:(CGRect)turnFrame isUp:(BOOL)isUp{
    
    self = [super init];
    if (self) {
        _interval = 0;
        _rowHeight = 20;
        _isUporDown = isUp;
        _beginFrame = frame;
        _turnFrame = turnFrame;
        
        _reusePool = [[NSMutableArray alloc]init];
        _usingLabels = [[NSMutableArray alloc]init];

        _beginDict = [[NSMutableDictionary alloc]init];
        _turnDict = [[NSMutableDictionary alloc]init];
        
        if (isUp) {
            _rowHeight *= [UIScreen mainScreen].bounds.size.width/320;
            [self createViewWithFrame:frame];
        }else{
            _rowHeight *= [UIScreen mainScreen].bounds.size.height/320;
            [self createViewWithFrame:turnFrame];
        }
        
    }
    return self;
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

- (void)createViewWithFrame:(CGRect)frame{
    
    _danmakuView = [[UIView alloc]initWithFrame:frame];
    _danmakuView.userInteractionEnabled = NO;
    _danmakuView.backgroundColor = [UIColor clearColor];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
    _isTimer = NO;
}

#pragma mark ----- NSTimer 【S】
- (void)letTimerRun{
    _isTimer = YES;
    [self beginTimer];
}

- (void)letTimerStop{
    [self endTimer];
    _isTimer = NO;
}

- (void)beginTimer{
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
}

- (void)endTimer{
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)timerFired:(NSTimer *)timer{
    
    if (!_usingLabels.count) {
        [self letTimerStop];
        return;
    }
    
    NSArray * array = [NSArray arrayWithArray:_usingLabels];
    
    for (UILabel * label in array) {
        
        NSMutableDictionary * dict;
        if (_isUporDown) {
            dict = _beginDict;
        }else{
            dict = _turnDict;
        }
        
        if (!CGRectIntersectsRect(_danmakuView.frame, label.frame)) {
            CGRect checkFrame = CGRectZero;
            CGRect labelFrame = label.frame;
            NSString * key = @"";
            
            labelFrame.origin.x = _danmakuView.bounds.size.width;
            labelFrame.origin.y -= _interval;
            do {
                labelFrame.origin.y += _interval;
                key = [NSString stringWithFormat:@"%.2f",labelFrame.origin.y];
                UILabel * checkLabel = [dict valueForKey:key];
                checkFrame = checkLabel.frame;
            } while ([self chcckLabelFrame:checkFrame toFrame:labelFrame]);
            
            if (labelFrame.origin.y + _interval <= _danmakuView.frame.size.height) {
                label.frame = labelFrame;
                if (labelFrame.origin.y + _interval <= _beginFrame.size.height) {
                    [_beginDict setValue:label forKey:key];
                }
                if (labelFrame.origin.y + _interval <= _turnFrame.size.height) {
                    [_turnDict setValue:label forKey:key];
                }
            }else{
                break;
            }
        }
        
        CGRect frame = label.frame;
        frame.origin.x -= 1;
        label.frame = frame;
        
        NSUInteger index = [dict.allValues indexOfObject:label];
        
        if (index < dict.allValues.count
            &&
            CGRectContainsRect(_danmakuView.frame, label.frame)) {
            [_beginDict removeObjectForKey:[NSString stringWithFormat:@"%.2f",label.frame.origin.y]];
            [_turnDict removeObjectForKey:[NSString stringWithFormat:@"%.2f",label.frame.origin.y]];
        }
        
        if (label.frame.origin.x + label.frame.size.width <= 0) {
            [_reusePool insertObject:label atIndex:0];
            [_usingLabels removeObject:label];
            [label removeFromSuperview];
        }
    }
}
#pragma mark ----- NSTimer 【E】

- (void)danmakuText:(NSString *)text withFont:(UIFont *)font{
    
    UILabel * label;
    if (_reusePool.count) {
        label=_reusePool.lastObject;
        [_reusePool removeLastObject];
    }else{
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setNumberOfLines:1];
    }
    
    label.font = font;
    CGSize labelsize = [text sizeWithFont:font];
    
    label.frame = CGRectMake(_danmakuView.bounds.size.width, 0, labelsize.width, labelsize.height);
    label.text = text;
    
    [_danmakuView addSubview:label];
    [_usingLabels addObject:label];
    
    
    if (!_isTimer) {
        [self letTimerRun];
    }
}

- (void)danmakuInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
    

    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            //home健在下
//            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            //home健在上
            if (!_isUporDown) {
                _isUporDown = YES;
                [self changeDanmakuFrame:_beginFrame];
            }
            break;
        case UIInterfaceOrientationLandscapeLeft:
            //home健在左
//            break;
        case UIInterfaceOrientationLandscapeRight:
            //home健在右
            if (_isUporDown) {
                _isUporDown = NO;
                [self changeDanmakuFrame:_turnFrame];
            }
            break;
        default:
            break;
            
            
    }
}

- (void)changeDanmakuFrame:(CGRect)frame{
    if (!CGRectEqualToRect(_danmakuView.frame, frame)) {
        
        for (UILabel * label in _usingLabels) {
            CGRect lFrame = label.frame;
            lFrame.origin.x *= frame.size.width/_danmakuView.frame.size.width;
            label.frame = lFrame;
        }
        
        _danmakuView.frame = frame;
    }
}

- (BOOL)chcckLabelFrame:(CGRect)frame1 toFrame:(CGRect)frame2{
    
    CGRect one = frame1;
    CGRect another = frame2;
    
    one.size.width += _interval;
    another.size.width += _interval;
    
    return CGRectIntersectsRect(one, another);
}

@end

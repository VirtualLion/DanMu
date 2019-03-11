//
//  ViewController.m
//  YZDanmaku
//
//  Created by 韩云智 on 16/7/4.
//  Copyright © 2016年 YZ. All rights reserved.
//

#import "ViewController.h"

#import "YZDanmakuVC.h"

@interface ViewController (){
    NSMutableArray * _dataSource;
    YZDanmakuVC * _vc;
    UIButton * _btn;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataSource = [NSMutableArray array];
    
    [_dataSource addObjectsFromArray:
  @[@"侠客行",
    @"赵客缦胡缨⑵，吴钩霜雪明⑶。",
    @"银鞍照白马，飒沓如流星⑷。",
    @"十步杀一人，千里不留行⑸。",
    @"事了拂衣去，深藏身与名。",
    @"闲过信陵饮⑹，脱剑膝前横。",
    @"将炙啖朱亥，持觞劝侯嬴⑺。",
    @"三杯吐然诺，五岳倒为轻⑻。",
    @"眼花耳热后，意气素霓生⑼。",
    @"救赵挥金锤，邯郸先震惊⑽。",
    @"千秋二壮士，烜赫大梁城。",
    @"纵死侠骨香，不惭世上英。",
    @"谁能书阁下，白首太玄经⑾。[1]"]];

    _vc = [[YZDanmakuVC alloc]initWithFrame:self.view.bounds turnFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width) isUp:YES];
    _vc.interval = 30;
    
    [self.view addSubview:_vc.danmakuView];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn addTarget:self action:@selector(onBtn) forControlEvents:UIControlEventTouchUpInside];
    btn.center = self.view.center;
    
    [self.view addSubview:btn];
    _btn = btn;
    
    
    
}

- (void)onBtn{
    static int i = 0;
    
    int x = i++ % _dataSource.count;
    
    [_vc danmakuText:_dataSource[x] withFont:[UIFont systemFontOfSize:15]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
    _btn.center = self.view.center;
    [_vc danmakuInterfaceOrientation:interfaceOrientation duration:duration];
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            //home健在下
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            //home健在上
            break;
        case UIInterfaceOrientationLandscapeLeft:
            //home健在左
            break;
        case UIInterfaceOrientationLandscapeRight:
            //home健在右
            break;
        default:
            break;
            
            
    }
}



@end

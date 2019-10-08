//
//  UserRightVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/20.
//  Copyright © 2018 mh. All rights reserved.
//

#import "UserRightVC.h"
#import "UIViewController+CWLateralSlide.h"
#import "SetHomePageVC.h"

@interface UserRightVC ()

@end

@implementation UserRightVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor base_color];

    [self buildViews];
}
-(void)buildViews
{
    NSArray * imgArr = @[@"user_right_icon1",@"user_right_icon1",@"user_right_icon1"];
    NSArray * titleArr = @[@"编辑个人资料",@"分享个人主页",@"设置"];
    for (int i = 0; i < 3; i ++) {
        UIView * item = [[UIView alloc] initWithFrame:CGRectMake(0, K_StatusHeight + Width(30) + Width(50)*i, Screen_WIDTH/3*2, Width(50))];
        [self.view addSubview:item];
        
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(Width(10), 0, Width(20), Width(50))];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.clipsToBounds = YES;
        img.image = [UIImage imageNamed:imgArr[i]];
        [item addSubview:img];
        
        UILabel * lab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentLeft];
        lab.text = titleArr[i];
        lab.frame = CGRectMake(Width(40), 0, Screen_WIDTH/3*2 - Width(40), Width(50));
        [item addSubview:lab];
        
        UIButton * btn = [UIButton buttonWithType:0];
        btn.frame = item.bounds;
        btn.tag = 3330 + i;
        [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [item addSubview:btn];
    }
}
-(void)itemClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - 3330;
    if (tag == 0) {
        //编辑个人资料
    }else if (tag == 1) {
        //分享个人主页
    }else{
        //设置
        SetHomePageVC * vc = [[SetHomePageVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self cw_pushViewController:vc];
    }
}
@end

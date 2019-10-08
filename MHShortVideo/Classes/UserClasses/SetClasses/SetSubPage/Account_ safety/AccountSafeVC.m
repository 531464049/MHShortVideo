//
//  AccountSafeVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/21.
//  Copyright © 2018 mh. All rights reserved.
//

#import "AccountSafeVC.h"

@interface AccountSafeVC ()

@end

@implementation AccountSafeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commit_navBar];
}
#pragma mark - 初始化导航栏
-(void)commit_navBar
{
    self.mhNavBar.hidden = NO;
    [self mh_setNeedBackItemWithTitle:@"账号与安全"];
    [self mh_setNavBottomlineHiden:NO];
}

@end

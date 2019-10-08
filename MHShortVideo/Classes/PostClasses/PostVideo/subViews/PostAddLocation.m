//
//  PostAddLocation.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/11/30.
//  Copyright © 2018 mh. All rights reserved.
//

#import "PostAddLocation.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface PostAddLocation ()<AMapSearchDelegate>

@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)NSArray * dataArr;//位置数据源

@property(nonatomic,strong)AMapSearchAPI * search;

@end

@implementation PostAddLocation

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commit_subviews];
    }
    return self;
}
#pragma mark - 初始化ui
-(void)commit_subviews
{
    self.dataArr = @[];
    
    UIImageView * icon = [[UIImageView alloc] init];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.clipsToBounds = YES;
    icon.image = [UIImage imageNamed:@"location"];
    [self addSubview:icon];
    icon.sd_layout.leftSpaceToView(self, Width(10)).topSpaceToView(self,Width(20)).widthIs(Width(20)).heightEqualToWidth();
    
    UILabel * titleLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentLeft];
    titleLab.text = @"添加位置";
    [self addSubview:titleLab];
    titleLab.sd_layout.leftSpaceToView(icon, Width(10)).centerYEqualToView(icon).heightIs(Width(20)).widthIs(200);
    
    UIImageView * rightIcon = [[UIImageView alloc] init];
    rightIcon.image = [UIImage imageNamed:@"common_next"];
    [self addSubview:rightIcon];
    rightIcon.sd_layout.rightSpaceToView(self,0).centerYEqualToView(icon).widthIs(Width(40)).heightEqualToWidth();

    
    UIButton * moreBtn = [UIButton buttonWithType:0];
    [moreBtn addTarget:self action:@selector(more_itemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreBtn];
    moreBtn.sd_layout.rightSpaceToView(self,0).centerYEqualToView(icon).widthIs(Width(80)).heightEqualToWidth();
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self addSubview:self.scrollView];
    self.scrollView.sd_layout.leftSpaceToView(self, 0).bottomSpaceToView(self, Width(0)).rightSpaceToView(self, 0).heightIs(Width(50));
    [self.scrollView updateLayout];
    
    //更新位置信息 默认无位置
    [self updateContentItems];
    //获取位置
    [self requestLocations];
}
#pragma mark - 更新位置数据
-(void)updateContentItems
{
    for (UIView * subitem in self.scrollView.subviews) {
        [subitem removeFromSuperview];
    }
    
    if (!self.dataArr || self.dataArr.count == 0) {
        //无数据
        UIButton * noLocationItem = [self b_item:@"无位置信息" index:0];
        CGRect frame = noLocationItem.frame;
        frame.origin.x = Width(15);
        frame.origin.y = Width(10);
        noLocationItem.frame = frame;
        [self.scrollView addSubview:noLocationItem];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        return;
    }
    CGFloat offX = Width(15);
    for (int i = 0; i < self.dataArr.count; i++) {
        UIButton * locationItem = [self b_item:self.dataArr[i] index:i];
        CGRect frame = locationItem.frame;
        frame.origin.x = offX;
        frame.origin.y = Width(10);
        locationItem.frame = frame;
        [self.scrollView addSubview:locationItem];
        
        if (i == self.dataArr.count - 1) {
            //最后一个
            offX = offX + locationItem.frame.size.width + Width(15);
        }else{
            offX = offX + locationItem.frame.size.width + Width(10);
        }
    }
    self.scrollView.contentSize = CGSizeMake(offX, self.scrollView.frame.size.height);
}
#pragma mark - 更新位置选中状态
-(void)updateItemState
{
    if (!self.dataArr || self.dataArr.count == 0) {
        //无数据
        return;
    }
    for (int i = 0; i < self.dataArr.count; i ++) {
        UIButton * item = (UIButton *)[self viewWithTag:i + 3500];
        if ([self.curentLocationName isEqualToString:item.titleLabel.text]) {
            item.layer.borderWidth = 1.0;
            item.layer.borderColor = [UIColor yellowColor].CGColor;
            [item setTitleColor:[UIColor yellowColor] forState:0];
        }else{
            item.layer.borderWidth = 1.0;
            item.layer.borderColor = [UIColor grayColor].CGColor;
            [item setTitleColor:[UIColor grayColor] forState:0];
        }
    }
}
- (void)setCurentLocationName:(NSString *)curentLocationName
{
    _curentLocationName = curentLocationName;
    [self updateItemState];
}
#pragma mark - 位置点击
-(void)locationItemClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 3500;
    if (!self.dataArr || self.dataArr.count < index+1) {
        self.curentLocationName = @"";
        [self callBackChoosedLocation];
        return;
    }
    NSString * selectedLocation = self.dataArr[index];
    self.curentLocationName = selectedLocation;
    [self callBackChoosedLocation];
    [self updateItemState];
}
-(void)callBackChoosedLocation
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(postAddLocationChoosedLocation:)]) {
        [self.delegate postAddLocationChoosedLocation:self.curentLocationName];
    }
}
#pragma mark - 更多按钮点击
-(void)more_itemClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(postAddLocationMoreItemHandle)]) {
        [self.delegate postAddLocationMoreItemHandle];
    }
}
-(UIButton *)b_item:(NSString *)title index:(NSInteger)index
{
    //计算按钮文字宽度
    CGFloat titleWidth = [title textForLabWidthWithTextHeight:20 font:FONT(14)];
    
    UIButton * btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(0, 0, titleWidth + Width(20), Width(30));
    [btn setTitle:title forState:0];
    [btn setTitleColor:[UIColor grayColor] forState:0];
    btn.titleLabel.font = FONT(14);
    btn.layer.cornerRadius = 2;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    
    btn.tag = 3500 + index;
    [btn addTarget:self action:@selector(locationItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
#pragma mark - 获取附近的位置
-(void)requestLocations
{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    AMapPOIAroundSearchRequest * request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:AppInfo.sharedInstance.userLatitude longitude:AppInfo.sharedInstance.userLongitude];
    request.keywords = @"";
    request.sortrule = 0;//按照距离排序
    request.requireExtension = YES;
    request.offset = 5;
    
    [self.search AMapPOIAroundSearch:request];
}
#pragma mark - POI 搜索回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0) {
        return;
    }
    NSMutableArray * mArr = [NSMutableArray arrayWithCapacity:0];
    for (AMapPOI * poi in response.pois) {
        NSLog(@"%@",poi.name);
        [mArr addObject:poi.name];
    }
    self.dataArr = [NSArray arrayWithArray:mArr];
    [self updateContentItems];
}
@end

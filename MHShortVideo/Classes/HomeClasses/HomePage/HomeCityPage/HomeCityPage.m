//
//  HomeCityPage.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/7.
//  Copyright © 2018 mh. All rights reserved.
//

#import "HomeCityPage.h"
#import "XRWaterfallLayout.h"
#import "HomeCityPageCell.h"

@interface HomeCityPage ()<UICollectionViewDelegate,UICollectionViewDataSource, XRWaterfallLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSMutableArray * dataArr;
@property(nonatomic,assign)NSInteger page;

@end

@implementation HomeCityPage

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
        _page = 1;
        [self commit_UI];
        [MHLoading showloading];
        [self requestDataWithPage:_page];
    }
    return self;
}
#pragma mark - 初始化页面
-(void)commit_UI
{
    //创建瀑布流布局
    XRWaterfallLayout *waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
    [waterfall setColumnSpacing:5 rowSpacing:10 sectionInset:UIEdgeInsetsMake(NavHeight, 10, TabBarHeight, 10)];
    waterfall.headerReferenceSize = CGSizeMake(self.frame.size.width, Width(130));
    waterfall.delegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:waterfall];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //注册cell
    [self.collectionView registerClass:[HomeCityPageCell class] forCellWithReuseIdentifier:@"WaterFallCellWaterFallCellWaterFallCell"];
    // 注册头视图
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self addSubview:self.collectionView];
    self.collectionView.mj_footer = [MHMjFooter footerWithRefreshingTarget:self refreshingAction:@selector(footer_refresh)];
    self.collectionView.mj_header = [MHMjHeader headerWithRefreshingTarget:self refreshingAction:@selector(header_refresh)];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    HomeCityCellModel * model = (HomeCityCellModel *)_dataArr[indexPath.row];
    return model.cellHeight;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCityPageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WaterFallCellWaterFallCellWaterFallCell" forIndexPath:indexPath];
    HomeCityCellModel * model = (HomeCityCellModel *)_dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(nonnull NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath
{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    for (UIView * subV in header.subviews) {
        [subV removeFromSuperview];
    }
    
    UIView * vvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, Width(130))];
    
    UIImageView * locationIcon = [[UIImageView alloc] init];
    locationIcon.contentMode = UIViewContentModeScaleAspectFit;
    locationIcon.clipsToBounds = YES;
    locationIcon.image = [UIImage imageNamed:@"location"];
    [vvv addSubview:locationIcon];
    locationIcon.sd_layout.leftSpaceToView(vvv, Width(15)).centerYIs(Width(15)).widthIs(20).heightEqualToWidth();
    
    UILabel * locationlab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentLeft];
    locationlab.text = @"自动定位：深圳";
    [vvv addSubview:locationlab];
    locationlab.sd_layout.leftSpaceToView(locationIcon, 5).centerYEqualToView(locationIcon).heightIs(20);
    [locationlab setSingleLineAutoResizeWithMaxWidth:200];
    
    UIButton * changeBtn = [UIButton buttonWithType:0];
    [changeBtn setTitle:@"切换 >" forState:0];
    [changeBtn setTitleColor:[UIColor grayColor] forState:0];
    changeBtn.titleLabel.font = FONT(14);
    [changeBtn addTarget:self action:@selector(changeLocation) forControlEvents:UIControlEventTouchUpInside];
    [vvv addSubview:changeBtn];
    changeBtn.sd_layout.rightSpaceToView(vvv, 20).centerYEqualToView(locationIcon).widthIs(65).heightIs(20);
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(Width(15), Width(30)-0.5, Screen_WIDTH - Width(30), 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [vvv addSubview:line];
    
    UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Width(30), Screen_WIDTH, Width(100))];
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    [vvv addSubview:scroll];
    
    CGFloat itemWidth = Width(80);
    CGFloat itemHeight = Width(100);
    NSArray * titleArr = @[@"美食",@"景点",@"文化",@"玩乐",@"酒店",@"购物",@"运动"];
    scroll.contentSize = CGSizeMake(itemWidth * titleArr.count, itemHeight);
    for (int i = 0; i < titleArr.count; i ++) {
        UIView * item = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, itemHeight)];
        [scroll addSubview:item];
        
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width(40), Width(40))];
        img.center = CGPointMake(itemWidth/2, Width(40));
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.clipsToBounds = YES;
        img.backgroundColor = [UIColor random_Color];
        img.layer.cornerRadius = 8;
        img.layer.masksToBounds = YES;
        [item addSubview:img];
        
        UILabel * lab = [UILabel labTextColor:[UIColor grayColor] font:FONT(14) aligent:NSTextAlignmentCenter];
        lab.text = titleArr[i];
        lab.frame = CGRectMake(0, CGRectGetMaxY(img.frame), itemWidth, Width(30));
        [item addSubview:lab];
        
        UIButton * btn = [UIButton buttonWithType:0];
        btn.frame = item.bounds;
        [btn addTarget:self action:@selector(topItemClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 6000 + i;
        [item addSubview:btn];
    }
    
    [header addSubview:vvv];
    
    return header;
}
-(void)changeLocation
{
    
}
-(void)topItemClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - 6000;
    NSArray * titleArr = @[@"美食",@"景点",@"文化",@"玩乐",@"酒店",@"购物",@"运动"];
    NSString * title = titleArr[tag];
    NSLog(@"%@",title);
    [MHHUD showTips:title];
}
-(void)requestDataWithPage:(NSInteger)page
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray * arr = [HomeCityCellModel getSomemModels];
        if (page == 1) {
            [self.dataArr removeAllObjects];
        }
        [self.dataArr addObjectsFromArray:arr];
        [MHLoading stopLoading];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
    });
}
-(void)footer_refresh
{
    [self requestDataWithPage:2];
}
-(void)header_refresh
{
    [self requestDataWithPage:1];
}
@end

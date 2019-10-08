//
//  UserProductionPage.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/19.
//  Copyright © 2018 mh. All rights reserved.
//

#import "UserProductionPage.h"
#import "UserProductionCell.h"
#import "VideoDetailPageVC.h"

@interface UserProductionPage ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,assign)BOOL isFirstTime;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)UICollectionView * collectionView;

@end

@implementation UserProductionPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)curentViewDidLoad
{
    if (!_isFirstTime) {
        _isFirstTime = YES;
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        [self buildCollectionView];
        [self requestData];
    }
}
-(void)buildCollectionView
{
    CGFloat itemWidth = (Screen_WIDTH-4) / 3;
    CGFloat itemHeight = Width(165);
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[UserProductionCell class] forCellWithReuseIdentifier:@"yonghuzuopinasdsd"];
    [self.collectionView mh_fixIphoneXBottomMargin];
    [self.view addSubview:self.collectionView];
    if (!self.isOtherUser) {
        UIEdgeInsets insets = self.collectionView.contentInset;
        self.collectionView.contentInset = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom + TabBarHeight, insets.right);
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserProductionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"yonghuzuopinasdsd" forIndexPath:indexPath];
    UserProductionModel * model = (UserProductionModel *)self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoDetailPageVC * vc = [[VideoDetailPageVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.videoModel = [HomeVideoModel randomAModel];
    [self.curentNav pushViewController:vc animated:YES];
}
-(void)requestData
{
    NSArray * arr = [UserProductionModel testProductionModels];
    [self.dataArr addObjectsFromArray:arr];
    [self.collectionView reloadData];
}
-(void)setCanScroll:(BOOL)canScroll
{
    _canScroll = canScroll;
    if (!canScroll) {
        self.collectionView.contentOffset = CGPointZero;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_canScroll) {
        self.collectionView.contentOffset = CGPointZero;
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(childScrollViewDidScroll:)]) {
            [self.delegate childScrollViewDidScroll:scrollView];
        }
    }
}

@end

//
//  FDGuessLikeUser.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/14.
//  Copyright © 2018 mh. All rights reserved.
//

#import "FDGuessLikeUser.h"
#import "FDGuessLikeCell.h"

@interface FDGuessLikeUser ()<UICollectionViewDelegate,UICollectionViewDataSource,FDGuessLikeCellDelegate>

@property(nonatomic,strong)UIView * topLine;//顶部分割线
@property(nonatomic,strong)UIView * bottomLine;//底部分割线

@property(nonatomic,strong)UICollectionView * collection;
@property(nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation FDGuessLikeUser

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor base_color];
        [self commit_subViews];
    }
    return self;
}
#pragma mark - 初始化
-(void)commit_subViews
{
    self.topLine = [[UIView alloc] init];
    self.topLine.backgroundColor = [UIColor grayColor];
    [self addSubview:self.topLine];
    self.topLine.sd_layout.leftSpaceToView(self, Width(15)).topEqualToView(self).rightSpaceToView(self, Width(15)).heightIs(0.5);
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor grayColor];
    [self addSubview:self.bottomLine];
    self.bottomLine.sd_layout.leftSpaceToView(self, Width(15)).bottomEqualToView(self).rightSpaceToView(self, Width(15)).heightIs(0.5);
    
    UILabel * topLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(13) aligent:NSTextAlignmentLeft];
    topLab.text = @"你可能感兴趣";
    [self addSubview:topLab];
    topLab.sd_layout.leftSpaceToView(self, Width(15)).topSpaceToView(self, Width(10)).widthIs(200).heightIs(Width(30));
    
    UIButton * moreBtn = [UIButton buttonWithType:0];
    [moreBtn setTitle:@"查看更多 >" forState:0];
    [moreBtn setTitleColor:[UIColor grayColor] forState:0];
    moreBtn.titleLabel.font = FONT(13);
    [moreBtn addTarget:self action:@selector(checkMoreItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreBtn];
    moreBtn.sd_layout.rightSpaceToView(self, 0).topSpaceToView(self, Width(10)).heightIs(Width(30)).widthIs(Width(90));
    
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    CGFloat itemWidth = Width(130);
    CGFloat itemHeight = self.frame.size.height - Width(40) - Width(25);
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, Width(15), 0, Width(15));
    
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Width(40), self.frame.size.width, itemHeight) collectionViewLayout:layout];
    self.collection.backgroundColor = [UIColor clearColor];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.showsVerticalScrollIndicator = NO;
    self.collection.showsHorizontalScrollIndicator = NO;
    [self.collection registerClass:[FDGuessLikeCell class] forCellWithReuseIdentifier:@"cainixihuanguanzhuderenliebaocell"];
    [self addSubview:self.collection];
    
    [self requestLikeData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FDGuessLikeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cainixihuanguanzhuderenliebaocell" forIndexPath:indexPath];
    FDGuessLikeModel * model = (FDGuessLikeModel *)self.dataArr[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    cell.cellIndex = indexPath.row;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fdGuessLikeUserHandleSelectedUser:)]) {
        [self.delegate fdGuessLikeUserHandleSelectedUser:@"二狗"];
    }
}
#pragma mark - 关注点击
-(void)guessLikeCellFocusItemClick:(NSInteger)cellIndex
{
    
}
#pragma mark - 删除
-(void)guessLikeCellDeleteItemClick:(NSInteger)cellIndex
{
    [self.dataArr removeObjectAtIndex:cellIndex];
    [self.collection reloadData];
}
-(void)requestLikeData
{
    NSArray * arr = [FDGuessLikeModel random_models];
    [self.dataArr addObjectsFromArray:arr];
    [self.collection reloadData];
}
#pragma mark - 查看更多
-(void)checkMoreItemClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fdGuessLikeUserHandleCheckMore)]) {
        [self.delegate fdGuessLikeUserHandleCheckMore];
    }
}
@end

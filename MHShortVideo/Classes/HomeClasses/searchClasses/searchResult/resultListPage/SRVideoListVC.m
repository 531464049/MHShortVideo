//
//  SRVideoListVC.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import "SRVideoListVC.h"
#import "SRVideoCell.h"

@interface SRVideoListVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView * collection;
@property(nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation SRVideoListVC
-(void)curentViewDidLoad
{
    if (!self.isFirstTimeShow) {
        self.isFirstTimeShow = YES;
        [self buildCollection];
    }
}
-(void)buildCollection
{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    CGFloat itemWidth = (Screen_WIDTH-5) / 2;
    CGFloat itemHeight = Width(250);
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    self.collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collection.backgroundColor = [UIColor clearColor];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.showsVerticalScrollIndicator = NO;
    self.collection.showsHorizontalScrollIndicator = NO;
    [self.collection registerClass:[SRVideoCell class] forCellWithReuseIdentifier:@"SRVideoCellSRVideoCell"];
    [self.collection mh_fixIphoneXBottomMargin];
    [self.view addSubview:self.collection];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SRVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SRVideoCellSRVideoCell" forIndexPath:indexPath];
    cell.cellIndex = indexPath.row;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

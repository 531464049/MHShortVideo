//
//  MHEmotionInputView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/6.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MHEmotionInputView.h"
#import "CommentHelper.h"

#define k_EmoticonHeight             50   //表情cell高度
#define k_EmotionPageControlHeight   20   //表情底部pagecontrol高度
#define k_EmotionToolbarHeight       44   //底部bar高度
#define k_OnePageCount               20   //每页表情个数

@interface MHEmotionInputView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView * collection;
@property(nonatomic,strong)UIPageControl * pageControl;
@property(nonatomic,strong)UIView * toolBar;

@property(nonatomic,strong)NSArray * emotionDataArr;

@end

@implementation MHEmotionInputView

+(MHEmotionInputView *)sharedInstance
{
    static MHEmotionInputView * _emotionInput;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emotionInput = [[MHEmotionInputView alloc] init];
    });
    return _emotionInput;
}
- (instancetype)init {
    self = [super init];
    self.frame = CGRectMake(0, 0, Screen_WIDTH, k_EmoticonHeight*3 + k_EmotionPageControlHeight + k_EmotionToolbarHeight + k_bottom_margin);
    self.backgroundColor = [UIColor base_color];
    
    [self commit_data];
    [self commit_collection];
    [self commit_pageControl];
    [self commit_toolBar];
    return self;
}
#pragma mark - 初始化数据
-(void)commit_data
{
    NSMutableArray * muArr = [NSMutableArray arrayWithCapacity:0];
    NSArray * emotionArr = [NSArray arrayWithArray:[MHEmotionModel getAllModels]];
    for (int i = 0; i < emotionArr.count; i ++) {
        MHEmotionModel * model = (MHEmotionModel *)emotionArr[i];
        
        if (i % k_OnePageCount == 0) {
            NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
            [muArr addObject:arr];
        }
        
        NSMutableArray * mArr = [NSMutableArray arrayWithArray:[muArr lastObject]];
        [mArr addObject:model];
        [muArr replaceObjectAtIndex:muArr.count - 1 withObject:mArr];
    }
    self.emotionDataArr = [NSArray arrayWithArray:muArr];
}
#pragma mark - 初始化表情collection
-(void)commit_collection
{
    CGFloat itemWidth = Screen_WIDTH / 7.0;
    CGFloat itemHeight = k_EmoticonHeight;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, k_EmoticonHeight*3) collectionViewLayout:layout];
    self.collection.backgroundColor = [UIColor clearColor];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.showsVerticalScrollIndicator = NO;
    self.collection.showsHorizontalScrollIndicator = NO;
    self.collection.pagingEnabled = YES;
    [self.collection registerClass:[MHEmoticonCell class] forCellWithReuseIdentifier:@"mhbiaoqingliebaolcjkjkslkcellid"];
    [self addSubview:self.collection];
}
#pragma mark - 初始化pagecontrol
-(void)commit_pageControl
{
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, k_EmoticonHeight*3, Screen_WIDTH, k_EmotionPageControlHeight)];
    self.pageControl.numberOfPages = self.emotionDataArr.count;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor base_yellow_color];
    [self addSubview:self.pageControl];
}
#pragma mark - 初始化toolbar
-(void)commit_toolBar
{
    self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, k_EmoticonHeight*3 + k_EmotionPageControlHeight, Screen_WIDTH, k_EmotionToolbarHeight)];
    self.toolBar.backgroundColor = [UIColor base_color];
    [self addSubview:self.toolBar];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_WIDTH, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [self.toolBar addSubview:line];
    
    UIButton * btn1 = [UIButton buttonWithType:0];
    btn1.frame = CGRectMake(0, 0, k_EmotionToolbarHeight, k_EmotionToolbarHeight);
    [btn1 setImage:[UIImage imageNamed:@"common_emotion"] forState:0];
    [self.toolBar addSubview:btn1];
    
    UIButton * sendSendBtn = [UIButton buttonWithType:0];
    sendSendBtn.frame = CGRectMake(Screen_WIDTH - Width(60), Width(5), Width(50), k_EmotionToolbarHeight - Width(5)*2);
    [sendSendBtn setTitle:@"发送" forState:0];
    [sendSendBtn setTitleColor:[UIColor base_yellow_color] forState:0];
    sendSendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    sendSendBtn.layer.cornerRadius = 3;
    sendSendBtn.layer.masksToBounds = YES;
    sendSendBtn.layer.borderWidth = 1.0;
    sendSendBtn.layer.borderColor = [UIColor base_yellow_color].CGColor;
    [sendSendBtn addTarget:self action:@selector(sendItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:sendSendBtn];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.emotionDataArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return k_OnePageCount + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MHEmoticonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mhbiaoqingliebaolcjkjkslkcellid" forIndexPath:indexPath];
    if (indexPath.row == k_OnePageCount) {
        cell.isDelete = YES;
        cell.emoticon = nil;
    } else {
        cell.isDelete = NO;
        cell.emoticon = [self emotionForIndexPath:indexPath];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == k_OnePageCount) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(emoticonInputDidTapBackspace)]) {
            [self.delegate emoticonInputDidTapBackspace];
        }
    } else {
        MHEmotionModel * model = [self emotionForIndexPath:indexPath];
        if (model && model.emotionChs.length > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(emoticonInputDidTapText:)]) {
                [self.delegate emoticonInputDidTapText:model.emotionChs];
            }
        }
    }
}
-(MHEmotionModel *)emotionForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSArray * arr = (NSArray *)self.emotionDataArr[section];
    if (arr.count > indexPath.row) {
        MHEmotionModel * model = (MHEmotionModel *)arr[indexPath.row];
        return model;
    }
    return nil;
}
#pragma mark - 松手时已经静止, 只会调用scrollViewDidEndDragging
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate == NO){
        // scrollView已经完全静止
        [self hanldeScerollEndOffx:scrollView.contentOffset.x];
    }
}
#pragma mark - 松手时还在运动, 先调用scrollViewDidEndDragging, 再调用scrollViewDidEndDecelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // scrollView已经完全静止
    [self hanldeScerollEndOffx:scrollView.contentOffset.x];
}
-(void)hanldeScerollEndOffx:(CGFloat)offx
{
    NSInteger page = offx / Screen_WIDTH;
    [self.pageControl setCurrentPage:page];
}
#pragma mark - 发送
-(void)sendItemClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emoticonInputDidTapSend)]) {
        [self.delegate emoticonInputDidTapSend];
    }
}
@end

#pragma mark - ----------------------表情cell-------------------
@interface MHEmoticonCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MHEmoticonCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    _imageView = [UIImageView new];
    _imageView.frame = CGRectMake(0, 0, 36, 36);
    _imageView.center = CGPointMake(width/2, height/2);
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
    return self;
}
- (void)setEmoticon:(MHEmotionModel *)emoticon
{
    _emoticon = emoticon;
    [self updateContent];
}
- (void)setIsDelete:(BOOL)isDelete
{
    _isDelete = isDelete;
    [self updateContent];
}
-(void)updateContent
{
    _imageView.image = nil;
    if (_isDelete) {
        _imageView.image = [UIImage imageNamed:@"compose_emotion_delete"];
    }else{
        if (_emoticon.emotionPngName && _emoticon.emotionPngName.length > 0) {
            UIImage *image = [CommentHelper emotionWithName:_emoticon.emotionPngName];
            if (image) {
                _imageView.image = image;
            }
        }
    }
}
@end


#pragma mark - ----------------------表情模型-------------------
@implementation MHEmotionModel
+ (NSArray<MHEmotionModel *> *)getAllModels
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    
    NSString * emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"weiboEmotioninfo" ofType:@"plist"];
    NSArray * emotionArr = [NSArray arrayWithContentsOfFile:emoticonBundlePath];
    
    for (NSDictionary * emotionDic in emotionArr) {
        NSString * png = emotionDic[@"png"];
        if (png.length == 0) {
            continue;
        }
        NSString * chs = emotionDic[@"chs"];
        if (chs.length > 0) {
            MHEmotionModel * model = [[MHEmotionModel alloc] init];
            model.emotionPngName = png;
            model.emotionChs = chs;
            [arr addObject:model];
        }
    }
    
    return [NSArray arrayWithArray:arr];
}
@end

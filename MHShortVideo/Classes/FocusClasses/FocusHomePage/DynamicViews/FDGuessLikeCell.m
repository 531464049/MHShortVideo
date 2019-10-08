//
//  FDGuessLikeCell.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/14.
//  Copyright © 2018 mh. All rights reserved.
//

#import "FDGuessLikeCell.h"

@interface FDGuessLikeCell ()

@property(nonatomic,strong)UIImageView * headerImage;
@property(nonatomic,strong)UILabel * nameLab;
@property(nonatomic,strong)UILabel * desLab;
@property(nonatomic,strong)UIButton * focusBtn;
@property(nonatomic,strong)UIButton * delBtn;

@end

@implementation FDGuessLikeCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = RGB(27, 28, 36);
//        CGFloat cellWidth = CGRectGetWidth(self.frame);
//        CGFloat cellHeight = CGRectGetHeight(self.frame);
        
        self.contentView.layer.cornerRadius = 2;
        self.contentView.layer.masksToBounds = YES;
        
        self.headerImage = [[UIImageView alloc] init];
        self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImage.clipsToBounds = YES;
        self.headerImage.layer.cornerRadius = Width(75)/2;
        self.headerImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headerImage];
        self.headerImage.sd_layout.centerXEqualToView(self.contentView).topSpaceToView(self.contentView, 10).widthIs(Width(75)).heightEqualToWidth();
        
        self.nameLab = [UILabel labTextColor:[UIColor whiteColor] font:FONT(15) aligent:NSTextAlignmentCenter];
        self.nameLab.numberOfLines = 1;
        [self.contentView addSubview:self.nameLab];
        self.nameLab.sd_layout.leftSpaceToView(self.contentView, Width(10)).topSpaceToView(self.headerImage, 3).rightSpaceToView(self.contentView, Width(10)).heightIs(Width(20));
        
        self.desLab = [UILabel labTextColor:[UIColor grayColor] font:FONT(12) aligent:NSTextAlignmentCenter];
        self.desLab.numberOfLines = 0;
        [self.contentView addSubview:self.desLab];
        self.desLab.sd_layout.leftSpaceToView(self.contentView, Width(10)).topSpaceToView(self.nameLab, 0).rightSpaceToView(self.contentView, Width(10)).heightIs(Width(30));
        
        self.focusBtn = [UIButton buttonWithType:0];
        self.focusBtn.backgroundColor = [UIColor redColor];
        [self.focusBtn setTitle:@"关注" forState:0];
        [self.focusBtn setTitleColor:[UIColor whiteColor] forState:0];
        self.focusBtn.titleLabel.font = FONT(15);
        self.focusBtn.layer.cornerRadius = 2;
        self.focusBtn.layer.masksToBounds = YES;
        [self.focusBtn addTarget:self action:@selector(focusItemClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.focusBtn];
        self.focusBtn.sd_layout.leftSpaceToView(self.contentView, Width(10)).bottomSpaceToView(self.contentView, Width(10)).rightSpaceToView(self.contentView, Width(10)).heightIs(Width(30));
        
        self.delBtn = [UIButton buttonWithType:0];
        [self.delBtn setImage:[UIImage imageNamed:@"common_close"] forState:0];
        [self.delBtn addTarget:self action:@selector(delItemCLick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.delBtn];
        self.delBtn.sd_layout.rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).heightIs(Width(30)).widthEqualToHeight();
    }
    return self;
}
- (void)setModel:(FDGuessLikeModel *)model
{
    _model = model;
    
    [self.headerImage yy_setImageWithURL:[NSURL URLWithString:model.userImage] placeholder:nil];
    self.nameLab.text = model.userName;
    self.desLab.text = model.desStr;
}
-(void)focusItemClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(guessLikeCellFocusItemClick:)]) {
        [self.delegate guessLikeCellFocusItemClick:self.cellIndex];
    }
}
-(void)delItemCLick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(guessLikeCellDeleteItemClick:)]) {
        [self.delegate guessLikeCellDeleteItemClick:self.cellIndex];
    }
}
@end




@implementation FDGuessLikeModel

+(NSArray *)random_models
{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    
    NSArray * nameArr = @[@"京张高铁",@"八达岭隧道",@"12月13日上午10点18分",@"一声爆破后顺利贯通",@"八达岭隧道建设历时",@"中新社记者 贾天勇",@"图为挖掘机",@"在隧道内清理爆破后",@"施工难度最大的隧道",@"贾天勇"];
    for (int i = 0; i < 10; i ++) {
        FDGuessLikeModel * model = [[FDGuessLikeModel alloc] init];
        model.userImage = @"http://pic32.photophoto.cn/20140819/0008020285038599_b.jpg";
        model.userName = nameArr[i];
        model.desStr = @"京张高铁正线十座隧道全部实现贯通";
        [arr addObject:model];
    }
    
    return [NSArray arrayWithArray:arr];
}

@end

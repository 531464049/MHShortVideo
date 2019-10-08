//
//  FocusDynamicCell.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/13.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"
#import "FocusDynamicModel.h"

@protocol FocusDynamicCellDelegate <NSObject>



@end

@interface FocusDynamicCell : BaseCell

@property(nonatomic,strong)FocusDynamicModel * model;
@property(nonatomic,assign)BOOL isSectionLastCell;//是否是当前section最后一个cell 隐藏底部分割线

-(void)play;

@end

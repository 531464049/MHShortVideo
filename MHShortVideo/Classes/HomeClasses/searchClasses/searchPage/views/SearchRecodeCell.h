//
//  SearchRecodeCell.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/13.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"

@protocol SearchRecodeCellDelegate <NSObject>

@optional
-(void)searchRecodeCellDelete:(NSInteger)cellIndex;

@end

@interface SearchRecodeCell : BaseCell

@property(nonatomic,weak)id <SearchRecodeCellDelegate> delegate;
@property(nonatomic,copy)NSString * recodeStr;
@property(nonatomic,assign)NSInteger cellIndex;

@end

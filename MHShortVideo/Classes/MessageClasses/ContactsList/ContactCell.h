//
//  ContactCell.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/17.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"
#import "ContactModel.h"

@protocol ContactCellDelegate;
@interface ContactCell : BaseCell

@property(nonatomic,strong)ContactModel * model;
@property(nonatomic,strong)id <ContactCellDelegate> delegate;

@end


@protocol ContactCellDelegate <NSObject>

@optional
/** 聊天按钮点击回调 联系人model */
-(void)contactCellHandleChat:(ContactModel *)contactModel;

@end

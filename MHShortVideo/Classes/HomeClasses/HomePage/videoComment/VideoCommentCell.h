//
//  VideoCommentCell.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/5.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"
#import "CommentModel.h"

@class CommentCellContent;

@interface VideoCommentCell : BaseCell

@property(nonatomic,strong)CommentModel * model;

@end



@interface CommentCellContent : UIView

@property(nonatomic,strong)CommentModel * model;

@end

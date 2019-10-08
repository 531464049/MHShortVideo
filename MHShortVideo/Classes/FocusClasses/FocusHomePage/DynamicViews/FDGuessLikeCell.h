//
//  FDGuessLikeCell.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/14.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FDGuessLikeModel;
@protocol FDGuessLikeCellDelegate;
@interface FDGuessLikeCell : UICollectionViewCell

@property(nonatomic,weak)id <FDGuessLikeCellDelegate> delegate;
@property(nonatomic,assign)NSInteger cellIndex;
@property(nonatomic,strong)FDGuessLikeModel * model;

@end


@protocol FDGuessLikeCellDelegate <NSObject>

@optional
/** 关注点击回调 */
-(void)guessLikeCellFocusItemClick:(NSInteger)cellIndex;
/** 删除点击回调 */
-(void)guessLikeCellDeleteItemClick:(NSInteger)cellIndex;

@end




@interface FDGuessLikeModel : NSObject

@property(nonatomic,copy)NSString * userImage;
@property(nonatomic,copy)NSString * userName;
@property(nonatomic,copy)NSString * desStr;


+(NSArray *)random_models;
@end

//
//  MHEmotionInputView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/6.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHEmoticonCell;
@class MHEmotionModel;

@protocol MHEmotionInputViewDelegate <NSObject>

@optional
- (void)emoticonInputDidTapText:(NSString *)text;
- (void)emoticonInputDidTapBackspace;
- (void)emoticonInputDidTapSend;

@end

@interface MHEmotionInputView : UIView

@property (nonatomic, weak) id<MHEmotionInputViewDelegate> delegate;

+(MHEmotionInputView *)sharedInstance;

@end


@interface MHEmoticonCell : UICollectionViewCell

@property (nonatomic, strong) MHEmotionModel * emoticon;
@property (nonatomic, assign) BOOL isDelete;

@end

/** 表情模型 */
@interface MHEmotionModel : NSObject

@property(nonatomic,copy)NSString * emotionPngName;//表情图标名字   d_zuiyou.png
@property(nonatomic,copy)NSString * emotionChs;//表情正则字符串     [最右]

+(NSArray<MHEmotionModel *> *)getAllModels;

@end

//
//  MHCellAutoPlayer.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/13.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHCellAutoPlayer : UIView

-(void)playVideo:(NSString *)videoUrl frame:(CGRect)frame;
/** 清除播放器信息 */
-(void)clearAllPlayInfo;
/** 播放器单例 */
+ (instancetype)sharedPlayer;

@end

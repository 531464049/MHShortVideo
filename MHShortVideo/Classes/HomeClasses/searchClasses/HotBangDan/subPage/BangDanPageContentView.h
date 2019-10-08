//
//  BangDanPageContentView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BangDanPageContentDelegate <NSObject>

@optional
-(void)bangDanPageContentIsScroll:(BOOL)isScroll;
-(void)childPageDidScroll:(UIScrollView *)scroll;

@end

@interface BangDanPageContentView : UIView

@property(nonatomic,weak)id <BangDanPageContentDelegate> delegate;

@property(nonatomic,assign)BOOL listCanScroll;

@end


//
//  PostChooseLocationVC.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/3.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseViewController.h"

@protocol ChooseLocationDelegate;
@interface PostChooseLocationVC : BaseViewController

@property(nonatomic,weak)id <ChooseLocationDelegate> delegate;

@end


@protocol ChooseLocationDelegate <NSObject>

@optional
-(void)postChooseLocationCallBack:(NSString *)locationName;

@end

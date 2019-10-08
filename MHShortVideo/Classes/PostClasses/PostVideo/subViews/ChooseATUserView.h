//
//  ChooseATUserView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/6.
//  Copyright © 2018 mh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^chooseATUserCallBack)(UserModel * user);

@interface ChooseATUserView : UIView

+(void)showChooseATUserWithCallBack:(chooseATUserCallBack)callBack;

@end

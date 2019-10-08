//
//  SearchInputView.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/12.
//  Copyright © 2018 mh. All rights reserved.
//

#import "BaseView.h"

@interface SearchInputView : BaseView

+(void)showWithSearchKey:(NSString *)searchKey callBack:(void(^)(NSString * searchKey))callBack;

@end

//
//  ContactModel.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/17.
//  Copyright © 2018 mh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject

@property(nonatomic,copy)NSString * userImage;
@property(nonatomic,copy)NSString * userName;

+(NSArray *)contactList;

@end

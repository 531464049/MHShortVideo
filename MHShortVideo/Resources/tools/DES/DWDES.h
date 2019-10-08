//
//  DWDES.h
//  Doudou
//
//  Created by dw on 14/11/27.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface DWDES : NSObject

+(NSString*)encryptWithContent:(NSString*)content type:(CCOperation)type key:(NSString*)aKey;

@end

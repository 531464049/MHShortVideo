//
//  MHMutipleGeatureScrollView.m
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#import "MHMutipleGeatureScrollView.h"

@implementation MHMutipleGeatureScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSString * ccc = NSStringFromClass(gestureRecognizer.view.class);
    NSString * ccc2 = NSStringFromClass(otherGestureRecognizer.view.class);
//    NSLog(@"-%@ -%@",ccc,ccc2);
    if ([ccc isEqualToString:@"MHMutipleGeatureScrollView"] && [ccc2 isEqualToString:@"UIView"]) {
        return NO;
    }
    return YES;
}

@end

//
//  MHMultipleGestureHeader.h
//  MHShortVideo
//
//  Created by 马浩 on 2018/12/11.
//  Copyright © 2018 mh. All rights reserved.
//

#ifndef MHMultipleGestureHeader_h
#define MHMultipleGestureHeader_h

@protocol ChildScrollViewDidScrollDelegate<NSObject>
@optional
- (void)childScrollViewDidScroll:(UIScrollView *)scrollView;
@end

#endif /* MHMultipleGestureHeader_h */

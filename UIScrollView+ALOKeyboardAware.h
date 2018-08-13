//
//  UIScrollView+ALOKeyboardAware.h
//  
//
//  Created by 李宗良 on 2018/8/13.
//  Copyright © 2018年 李宗良. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ALOKeyboardAware)

@property (nonatomic, assign) BOOL alo_autoResizeContent;
@property (nonatomic, assign) BOOL alo_autoScrollFirstResponder;

@end

//
//  UIResponder+ALOFirstResponder.h
//  
//
//  Created by 李宗良 on 2018/8/13.
//  Copyright © 2018年 李宗良. All rights reserved.
//

#import <UIKit/UIKit.h>

// 参考：https://www.jianshu.com/p/84c0eddf2378

@interface UIResponder (ALOFirstResponder)

+ (id)alo_currentFirstResponder;

@end

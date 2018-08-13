//
//  UIResponder+ALOFirstResponder.m
//  
//
//  Created by 李宗良 on 2018/8/13.
//  Copyright © 2018年 李宗良. All rights reserved.
//

#import "UIResponder+ALOFirstResponder.h"

static __weak id alo_currentFirstResponder;

@implementation UIResponder (ALOFirstResponder)

#pragma mark - funcation

+ (id)alo_currentFirstResponder {
    alo_currentFirstResponder = nil;
    // 通过将target设置为nil，让系统自动遍历响应链
    // 从而响应链当前第一响应者响应我们自定义的方法
    [[UIApplication sharedApplication] sendAction:@selector(alo_findFirstResponder:)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    return alo_currentFirstResponder;
}

- (void)alo_findFirstResponder:(id)sender {
    // 第一响应者会响应这个方法，并且将静态变量wty_currentFirstResponder设置为自己
    alo_currentFirstResponder = self;
}

@end

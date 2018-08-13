//
//  UIScrollView+ALOKeyboardAware.m
//  
//
//  Created by 李宗良 on 2018/8/13.
//  Copyright © 2018年 李宗良. All rights reserved.
//

#import "UIScrollView+ALOKeyboardAware.h"
#import <objc/runtime.h>
#import "UIResponder+ALOFirstResponder.h"

static char *kAOLKeyboardAwareAutoResizeContent = "kAOLKeyboardAwareAutoResizeContent";
static char *kAOLKeyboardAwareInitialContentInset = "kAOLKeyboardAwareInitialContentInset";
static char *kAOLKeyboardAwareAutoScrollFirstResponder = "kAOLKeyboardAwareAutoScrollFirstResponder";

@interface UIScrollView ()

@property (nonatomic, copy) NSValue *alo_initialContentInset;

@end

@implementation UIScrollView (ALOKeyboardAware)

#pragma mark - life circle

- (void)dealloc {
    if ([objc_getAssociatedObject(self, kAOLKeyboardAwareAutoResizeContent) boolValue]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

#pragma mark - private

- (void)p_removeNogification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)p_registerNogification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Notification response

- (void)keyboardWillShow:(NSNotification *)notification {
    if (!self.alo_initialContentInset) {
        NSValue *value = [NSValue valueWithUIEdgeInsets:self.contentInset];
        self.alo_initialContentInset = value;
    }
    
    NSDictionary *userInfo = notification.userInfo;
    NSValue *rectValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval timeInterval = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardRect = [rectValue CGRectValue];
    
    UIView *window = [UIApplication sharedApplication].keyWindow;
    CGRect scrollRectInWindow = [self convertRect:self.bounds toView:window];
    
    CGFloat maxYOfScrollView = CGRectGetMaxY(scrollRectInWindow);
    UIEdgeInsets newContentInset = [self.alo_initialContentInset UIEdgeInsetsValue];
    if (maxYOfScrollView > keyboardRect.origin.y) {
        CGFloat bottomEdge = maxYOfScrollView - keyboardRect.origin.y;
        newContentInset.bottom += bottomEdge;
    }
    
    if (!UIEdgeInsetsEqualToEdgeInsets(self.contentInset, newContentInset)) {
        BOOL moveResponder = self.alo_autoScrollFirstResponder;
        CGRect rectOfFirstResponderInScrollView = CGRectZero;
        if (moveResponder) {
            UIView *firstResponder = [UIResponder alo_currentFirstResponder];
            rectOfFirstResponderInScrollView = [firstResponder convertRect:firstResponder.bounds toView:self];
        }
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:timeInterval animations:^{
            [weakSelf setContentInset:newContentInset];
            if (moveResponder) {
                [weakSelf scrollRectToVisible:rectOfFirstResponderInScrollView animated:NO];
            }
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets newContentInset = [self.alo_initialContentInset UIEdgeInsetsValue];
    NSTimeInterval timeInterval = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (!UIEdgeInsetsEqualToEdgeInsets(self.contentInset, newContentInset)) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:timeInterval animations:^{
            [weakSelf setContentInset:newContentInset];
        }];
    }
    self.alo_initialContentInset = nil;
}

#pragma mark - getter & setter

- (NSValue *)alo_initialContentInset {
    return objc_getAssociatedObject(self, kAOLKeyboardAwareInitialContentInset);
}

- (void)setAlo_initialContentInset:(NSValue *)initialContentInset {
    objc_setAssociatedObject(self, kAOLKeyboardAwareInitialContentInset, initialContentInset, OBJC_ASSOCIATION_COPY);
}

- (BOOL)alo_autoScrollFirstResponder {
    return [objc_getAssociatedObject(self, kAOLKeyboardAwareAutoScrollFirstResponder) boolValue];
}

- (void)setAlo_autoScrollFirstResponder:(BOOL)autoScrollFirstResponder {
    objc_setAssociatedObject(self, kAOLKeyboardAwareAutoScrollFirstResponder, [NSNumber numberWithBool:autoScrollFirstResponder], OBJC_ASSOCIATION_COPY);
}

- (BOOL)alo_autoResizeContent {
    return [objc_getAssociatedObject(self, kAOLKeyboardAwareAutoResizeContent) boolValue];
}

- (void)setAlo_autoResizeContent:(BOOL)autoResizeContent {
    if (autoResizeContent) {
        [self p_registerNogification];
    }
    else {
        [self p_removeNogification];
    }
    objc_setAssociatedObject(self, kAOLKeyboardAwareAutoResizeContent, [NSNumber numberWithBool:autoResizeContent], OBJC_ASSOCIATION_COPY);
}

@end

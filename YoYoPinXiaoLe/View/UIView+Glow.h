//
//  UIView+Glow.m
//  YoYoPinXiaoLe
//
//  Created by gozap on 2021/4/25.
//

#import <UIKit/UIKit.h>

@interface UIView (Glow)

@property (nonatomic, readonly) UIView* glowView;

- (void) startGlowing;
- (void) startGlowingWithColor:(UIColor*)color intensity:(CGFloat)intensity;

- (void) stopGlowing;

@end

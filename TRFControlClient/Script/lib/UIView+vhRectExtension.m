//
//  UIView+vhRectExtension.m
//  VRHouse
//
//  Created by SunSi on 16/6/21.
//  Copyright © 2016年 纬线. All rights reserved.
//

#import "UIView+vhRectExtension.h"

@implementation UIView (vhRectExtension)



-(CGFloat)width{
    return self.frame.size.width;
}
-(void)setWidth:(CGFloat)width{
    CGRect frame=self.frame;
    frame.size.width=width;
    self.frame=frame;
}

-(CGFloat)height{
    return  self.frame.size.height;
}
-(void)setHeight:(CGFloat)height{
    CGRect frame=self.frame;
    frame.size.height=height;
    self.frame=frame;
}

-(void)setX:(CGFloat)x{
    CGRect frame=self.frame;
    frame.origin.x=x;
    self.frame=frame;
}
-(CGFloat)x{
    return  self.frame.origin.x;
}

-(CGFloat)y{
    return  self.frame.origin.y;
}
-(void)setY:(CGFloat)y{
    CGRect frame= self.frame;
    frame.origin.y=y;
    self.frame=frame;
}

-(void)setSize:(CGSize)size{
    CGRect frame= self.frame;
    frame.size=size;
    self.frame=frame;
}
-(CGSize)size{
    return  self.frame.size;
}

-(void)setCenterX:(CGFloat)centerX{
    CGPoint center=self.center;
    center.x=centerX;
    self.center=center;
}
-(void)setCenterY:(CGFloat)centerY{
    CGPoint center=self.center;
    center.y=centerY;
    self.center=center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (CGFloat)centerX
{
    return self.center.x;
}

-(BOOL)isShowingOnKeyWindow{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //Convert the coordinates to the current visible window
    CGRect newFrame = [self.superview convertRect:self.frame toView:nil];
    CGRect winBounds = keyWindow.bounds;
    BOOL interSects = CGRectIntersectsRect(newFrame, winBounds);
    return self.isHidden == NO && self.alpha > 0.01 && interSects && self.window == keyWindow;
}

@end












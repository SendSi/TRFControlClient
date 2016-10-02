//
//  UIView+vhRectExtension.h
//  VRHouse
//
//  Created by SunSi on 16/6/21.
//  Copyright © 2016年 纬线. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (vhRectExtension)

/** width  */
@property (assign,nonatomic) CGFloat width;

/** height  */
@property (assign,nonatomic) CGFloat height;

/** x  */
@property (assign,nonatomic) CGFloat x;

/** y  */
@property (assign,nonatomic) CGFloat y;

/** size  */
@property (assign,nonatomic) CGSize     size;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

-(BOOL)isShowingOnKeyWindow;
@end

//
//  UIBarButtonItem+vhBarButtonTool.m
//  VRHouse
//
//  Created by SunSi on 16/6/21.
//  Copyright © 2016年 纬线. All rights reserved.
//

#import "UIBarButtonItem+vhBarButtonTool.h"

@implementation UIBarButtonItem (vhBarButtonTool)
/** uibarButtonItem的创建  只有图片*/
+(instancetype)initWithBarButtonNorImage:(NSString *)norImage highImage:(NSString *)highImage target:(id)target action:(SEL) action{
    UIButton *button=[[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size=CGSizeMake(100, 60);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}



+(instancetype)initWithBarButtonNorImage:(NSString *)norImage highImage:(NSString *)highImage showTitle:(NSString *)showTitle target:(id)target action:(SEL) action{
    UIButton *button=[[UIButton alloc] init];
    [button setTitle:showTitle forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size=button.currentImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

/** uibarButtonItem的创建  只有文字 黑色字*/
+(instancetype)initWithBarButtonNorTitle:(NSString *)norTitle target:(id)target action:(SEL) action{
    UIButton *button=[[UIButton alloc] init];
    [button setTitle:norTitle forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return [[self alloc] initWithCustomView:button];

}

/** uibarButtonItem的创建  只有文字 自控颜色字*/
+(instancetype)initWithBarButtonNorTitle:(NSString *)norTitle titleColor:(UIColor *)titleColor target:(id)target action:(SEL) action{
    UIButton *button=[[UIButton alloc] init];
    [button setTitle:norTitle forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return [[self alloc] initWithCustomView:button];
}




@end

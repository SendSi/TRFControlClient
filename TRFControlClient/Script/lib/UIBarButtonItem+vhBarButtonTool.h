//
//  UIBarButtonItem+vhBarButtonTool.h
//  VRHouse
//
//  Created by SunSi on 16/6/21.
//  Copyright © 2016年 纬线. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (vhBarButtonTool)

+(instancetype)initWithBarButtonNorImage:(NSString *)norImage highImage:(NSString *)highImage target:(id)target action:(SEL) action;

+(instancetype)initWithBarButtonNorImage:(NSString *)norImage highImage:(NSString *)highImage showTitle:(NSString *)showTitle target:(id)target action:(SEL) action;

/** uibarButtonItem的创建  只有文字 黑色字*/
+(instancetype)initWithBarButtonNorTitle:(NSString *)norTitle target:(id)target action:(SEL) action;

/** uibarButtonItem的创建  只有文字 自控颜色字*/
+(instancetype)initWithBarButtonNorTitle:(NSString *)norTitle titleColor:(UIColor *)titleColor target:(id)target action:(SEL) action;
@end

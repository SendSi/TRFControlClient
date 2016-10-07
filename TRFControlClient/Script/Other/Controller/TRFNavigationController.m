//
//  TRFNavigationController.m
//  TRFControlClient
//
//  Created by SunSi on 16/10/6.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import "TRFNavigationController.h"

@interface TRFNavigationController ()

@end

@implementation TRFNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
       UIViewController *vc= self.childViewControllers.lastObject;
        NSLogs(@"vc.title===%@",vc.title);
         UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:vc.title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        button.size = CGSizeMake(150, 100);
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        [button sizeToFit];
        // 让按钮的内容往左边偏移10
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        // 修改导航栏左边的item
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
    
}

+(void)initialize{
    
}

- (void)back
{
    [self popViewControllerAnimated:YES];
    UINavigationBar *bar = [self.navigationController navigationBar];
    CGFloat navBarHeight = 80;
    CGRect frame = CGRectMake(0, 0, pchScreenWidth, navBarHeight);
    [bar setFrame:frame];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    UINavigationBar *navb=[UINavigationBar appearance];
    //设置头部 字体颜色与大小
    NSMutableDictionary *attr=[NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName]=[UIColor blackColor];
    attr[NSFontAttributeName]=[UIFont systemFontOfSize:40];
    [navb setTitleTextAttributes:attr];
}


@end

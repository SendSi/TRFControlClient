//
//  TRFMainUIViewController.m
//  TRFControlClient
//
//  Created by SunSi on 16/10/1.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import "TRFMainUIViewController.h"
#import "UIBarButtonItem+vhBarButtonTool.h"

@interface TRFMainUIViewController ()

@end

@implementation TRFMainUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
self.navigationItem.rightBarButtonItem=[UIBarButtonItem initWithBarButtonNorTitle:@"测试" target:self action:@selector(hjExit)];
}
-(void)hjExit{
    pchLogClass;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

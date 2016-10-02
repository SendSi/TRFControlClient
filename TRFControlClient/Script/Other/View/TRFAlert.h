//
//  TRFAlert.h
//  Enjoy
//
//  Created by 邓朝文 on 16/5/11.
//  Copyright © 2016年 hejing. All rights reserved.
//

#import <UIKit/UIKit.h>
//公用Block
typedef void(^voidBlock)();
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight        [UIScreen mainScreen].bounds.size.height

@interface TRFAlert : UIView
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *certanButton;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
- (IBAction)cancelClick:(id)sender;
- (IBAction)certanClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warnLabelH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warnLabelYToTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cancelLayout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *certanLayout;


@property (nonatomic, copy) voidBlock certanBlock;
+ (instancetype)exitLoginView;
+ (instancetype)exitLoginViewWithWarnTitle:(NSString *)warnTitle;

/**
    TRFAlert *quit=[TRFAlert exitLoginViewWithWarnTitle:@"你确定要退出问诊?"];
        [self.view addSubview:quit];
    quit.certanBlock=^{

    };
*/
@end

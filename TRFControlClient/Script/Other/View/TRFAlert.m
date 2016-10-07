//
//  TRFAlert.m
//  Enjoy
//
//  Created by 邓朝文 on 16/5/11.
//  Copyright © 2016年 hejing. All rights reserved.
//

#import "TRFAlert.h"

@implementation TRFAlert

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.baseView.layer.cornerRadius = 6;
    self.cancelButton.layer.cornerRadius = 3;
    self.certanButton.layer.cornerRadius = 3;
    self.frame = CGRectMake(0, 0,kScreenWidth , kScreenHeight);
}

+ (instancetype)exitLoginView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TRFAlert" owner:nil options:nil] lastObject];
}

+ (instancetype)exitLoginViewWithWarnTitle:(NSString *)warnTitle
{
    TRFAlert *view = [TRFAlert exitLoginView];
    view.warnLabel.text = warnTitle;
    view.warnLabelH.constant = 60;
    view.warnLabelYToTop.constant = 8;
    return view;
}

- (IBAction)cancelClick:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)certanClick:(id)sender {
    self.certanBlock();
        [self removeFromSuperview];
}


@end

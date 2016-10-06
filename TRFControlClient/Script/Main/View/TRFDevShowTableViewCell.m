//
//  TRFDevShowTableViewCell.m
//  TRFControlClient
//
//  Created by SunSi on 16/10/5.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import "TRFDevShowTableViewCell.h"


@implementation TRFDevShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor=pchColor(36,37,38);

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)loadDataInfo: (NSString *)name tag:(NSInteger )tag state:(NSInteger)state{
    [self.buttonShowLabelName setTitle:name forState:UIControlStateHighlighted];
    [self.buttonShowLabelName setTitle:name forState:UIControlStateNormal];
    self.buttonShowLabelName.tag=tag;
    // 1.已开启,所以展示 关闭按钮      0.已关闭,民示  开启按钮
}

- (IBAction)ClickButtonClose:(UIButton *)sender {
    if([self.delegateCell respondsToSelector:@selector(devShowTableViewCellClickRight:tag:)]){
        [self.delegateCell devShowTableViewCellClickRight:self tag:self.buttonShowLabelName.tag];
    }
}

- (IBAction)ClickButtonOpen:(UIButton *)sender {
    if([self.delegateCell respondsToSelector:@selector(devShowTableViewCellClickLeftOpen:tag:)]){
        [self.delegateCell devShowTableViewCellClickLeftOpen:self tag:self.buttonShowLabelName.tag];
    }
}

@end

















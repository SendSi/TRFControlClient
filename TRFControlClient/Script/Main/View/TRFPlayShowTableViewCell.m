//
//  TRFPlayShowTableViewCell.m
//  TRFControlClient
//
//  Created by SunSi on 16/10/6.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import "TRFPlayShowTableViewCell.h"

@implementation TRFPlayShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor=pchColor(36,37,38);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)ClickPlay:(UIButton *)sender {
    if([self.delegateCell respondsToSelector:@selector(playShowTableViewCellClickPlay:tag:strTitle:)]){
        [self.delegateCell playShowTableViewCellClickPlay:self tag:self.buttonShowLabelName.tag strTitle:self.buttonShowLabelName.titleLabel.text];
    }
}

- (IBAction)ClickStop:(UIButton *)sender {
    if([self.delegateCell respondsToSelector:@selector(playShowTableViewCellClickStop:tag:)]){
        [self.delegateCell playShowTableViewCellClickStop:self tag:self.buttonShowLabelName.tag];
    }
}

-(void)loadDataInfo: (NSString *)name tag:(NSInteger )tag state:(NSInteger)state{
    [self.buttonShowLabelName setTitle:name forState:UIControlStateNormal];
    [self.buttonShowLabelName setTitle:name forState:UIControlStateHighlighted];
    self.buttonShowLabelName.tag=tag;//也就是 index
    
}
@end

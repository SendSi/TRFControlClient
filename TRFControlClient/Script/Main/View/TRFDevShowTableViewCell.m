//
//  TRFDevShowTableViewCell.m
//  TRFControlClient
//
//  Created by SunSi on 16/10/5.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import "TRFDevShowTableViewCell.h"
#import "TRFDevShowModel.h"

@implementation TRFDevShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setDevModel:(TRFDevShowModel *)devModel{
    _devModel=devModel;
    self.labelName.text=devModel.name;
}

@end

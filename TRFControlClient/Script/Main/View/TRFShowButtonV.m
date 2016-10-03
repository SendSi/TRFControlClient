//
//  TRFShowButtonV.m
//  TRFControlClient
//
//  Created by SunSi on 16/10/2.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import "TRFShowButtonV.h"

@implementation TRFShowButtonV

+(instancetype)initWithShowButton{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}



-(IBAction)clickButtonShow:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(showButtonShowClick:buttonText:)]){
        [self.delegate showButtonShowClick:self buttonText:btn.titleLabel.text];
    }
}

@end

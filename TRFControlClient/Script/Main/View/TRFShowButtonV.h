//
//  TRFShowButtonV.h
//  TRFControlClient
//
//  Created by SunSi on 16/10/2.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRFShowButtonV;
@protocol TRFShowButtonShowVDelegate <NSObject>
@optional
-(void)showButtonShowClick:(TRFShowButtonV *)vc buttonText:(NSString *)buttonText;

@end


@interface TRFShowButtonV : UIView
@property (weak, nonatomic) IBOutlet UIButton *buttonShowTitle;
+(instancetype)initWithShowButton;
/** 代理 */
@property (weak,nonatomic) id<TRFShowButtonShowVDelegate> delegate;

@end

//
//  TRFConnectControl.h
//  TRFControlClient
//
//  Created by SunSi on 16/10/1.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 当 未有ip等配置时,主动加载  */
@interface TRFConnectControl : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textField_IP;
@property (weak, nonatomic) IBOutlet UITextField *textField_Port;
@property (weak, nonatomic) IBOutlet UITextField *textField_MACAddress;
@property (weak, nonatomic) IBOutlet UITextField *textField_Device;

/** 关机按钮  */
@property (weak, nonatomic) IBOutlet UIButton *buttonCloseCom;
/** 开机按钮  */
@property (weak, nonatomic) IBOutlet UIButton *buttonOpenCom;
@property (weak, nonatomic) IBOutlet UIButton *buttonSaveInfo;




@end
/** label 位置 以  [ 中控端口号: ] 为基准  */

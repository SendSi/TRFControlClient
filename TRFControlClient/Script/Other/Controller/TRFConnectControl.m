//
//  TRFConnectControl.m
//  TRFControlClient
//
//  Created by SunSi on 16/10/1.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import "TRFConnectControl.h"
#import "TRFAlert.h"
#import "SVProgressHUD.h"
#import "UIBarButtonItem+vhBarButtonTool.h"

@interface TRFConnectControl ()<UITextFieldDelegate>

@end

@implementation TRFConnectControl

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title =@"设置";
        self.navigationItem.leftBarButtonItem=[UIBarButtonItem initWithBarButtonNorTitle:@"取消" titleColor:[UIColor blackColor] target:self action:@selector(Click_Cancel)];
    
    [self getUserDefaultsInfo];//NSUserDefaults
}

-(void)Click_Cancel{
    [self dismissViewControllerAnimated:YES completion:^{
        pchLogClass;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSetting];
}
/** delegate  addTarget  */
-(void)initSetting{
    self.textField_IP.delegate=self;
    self.textField_Port.delegate=self;
    self.textField_MACAddress.delegate=self;
    self.textField_Device.delegate=self;
    [self.buttonOpenCom addTarget:self action:@selector(clickOpenCom) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonCloseCom addTarget:self action:@selector(clickCloseCom) forControlEvents:UIControlEventTouchUpInside ];
   self.navigationItem.rightBarButtonItem= [UIBarButtonItem initWithBarButtonNorTitle:@"保存" target:self action:@selector(clickSaveInfo)];
}
/** 关机 点击事件  */
-(void)clickCloseCom{
    TRFAlert *quit=[TRFAlert exitLoginViewWithWarnTitle:@"你确定要关机吗?"];
    [self.view addSubview:quit];
    quit.certanBlock=^{
        NSLogs(@"关机");
        //will 写 成功代码
    };
    NSLogs(@"关机中");
}
/** 开机 点击事件  */
-(void)clickOpenCom{
    
}
/** 保存 点击事件  */
-(void)clickSaveInfo{
    //1.长度不能为空
    //2.判断 可用性
    //3.保存
    NSInteger ipLength=removeTrimGetLength(self.textField_IP.text);
    NSInteger portLength=removeTrimGetLength(self.textField_Port.text);
    NSInteger macLength=removeTrimGetLength(self.textField_MACAddress.text);
    NSInteger devLength=removeTrimGetLength(self.textField_Device.text);
    if(ipLength==0||portLength==0||macLength==0||devLength==0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的内容"];
        return;
    }
    //判断IP 可用性
    if([self validInput:@"^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$" inputContent:self.textField_IP.text]==NO){
        [SVProgressHUD showErrorWithStatus:@"IP不可用,请检查"];
        return ;
    }
    //判断 端口号 可用性
    if([self validInput:@"^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]{1}|6553[0-5])$" inputContent:self.textField_Port.text]==NO){
        [SVProgressHUD showErrorWithStatus:@"端口号不可用,请检查"];
        return ;
    }
    //判断 端口号 可用性
    if([self validInput:@"[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]" inputContent:self.textField_MACAddress.text]==NO){
        [SVProgressHUD showErrorWithStatus:@"Mac地址不可用,请检查"];
        return ;
    }
    
    
       //去除空格 保存
        self.textField_IP.text=removeTrim(self.textField_IP.text);
        self.textField_Device.text=removeTrim(self.textField_Device.text);
        self.textField_MACAddress.text=removeTrim(self.textField_MACAddress.text);
        self.textField_Port.text=removeTrim(self.textField_Port.text);
        NSUserDefaults *useDef= [NSUserDefaults standardUserDefaults];
        [useDef setObject:self.textField_IP.text forKey:@"ipAddress"];
        [useDef setObject:self.textField_MACAddress.text forKey:@"macAddress"];
        [useDef setObject:self.textField_Device.text forKey:@"devAddress"];
        [useDef setObject:self.textField_Port.text  forKey:@"portAddress"];
        [useDef synchronize];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }];
}

-(Boolean)validInput:(NSString *)regexMac inputContent:(NSString *)inputContent{    
    NSPredicate *predicateMac = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexMac];
    BOOL isValidMac= [predicateMac evaluateWithObject:inputContent];
    return isValidMac;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField==self.textField_IP){
        self.view.y -= 60;
    }
    else {
        self.view.y -=160;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.view.y =0;
}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

-(void)getUserDefaultsInfo{
    NSUserDefaults *useDef= [NSUserDefaults standardUserDefaults];
    self.textField_Port.text=[useDef objectForKey:@"portAddress"];
    self.textField_Device.text=[useDef objectForKey:@"devAddress"];
    self.textField_MACAddress.text=[useDef objectForKey:@"macAddress"];
    self.textField_IP.text=[useDef objectForKey:@"ipAddress"];
}


@end




















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
#import "TRFCommMethod.h"
#import "AsyncUdpSocket.h"

@interface TRFConnectControl ()<UITextFieldDelegate,AsyncUdpSocketDelegate>
@property (nonatomic, retain) AsyncUdpSocket *udpSocket;
@end

@implementation TRFConnectControl

-(void)viewWillAppear:(BOOL)animated{
        UINavigationBar *bar = [self.navigationController navigationBar];
        CGFloat navBarHeight = 80;
        CGRect frame = CGRectMake(0, 0, pchScreenWidth, navBarHeight);
        [bar setFrame:frame];
    [super viewWillAppear:animated];
    self.title =@"设置";
    [self getUserDefaultsInfo];//NSUserDefaults
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
        [TRFCommMethod asyncCtrPlay:@"ShutDown" indexId:@""];
    };
    NSLogs(@"关机中");
}
/** 开机 点击事件  */
-(void)clickOpenCom{
//NSString *macAddress= self
    if (12 == self.textField_MACAddress.text.length)  // mac地址长度为12个字节的字符串
    {
        // 组装唤醒包
        Byte arrPacket[102]; // = (Byte *)[102];
        int iIndex = 0;
        for (int i = 0; i < 6; i++){
            arrPacket[iIndex++] = 0xFF;
        }

        for (int i = 0; i < 16; i++) {
            for (int j = 0; j < self.textField_MACAddress.text.length; )
            {
                NSString* pTmp = [self.textField_MACAddress.text substringWithRange:NSMakeRange(j, 2)];
                arrPacket[iIndex++] = (Byte)strtol([pTmp UTF8String], 0, 16);
                j += 2;
            }
        }
        if (nil == self.udpSocket)
        {
            _udpSocket = [[AsyncUdpSocket alloc]initWithDelegate:self];
            // 启用广播
            [_udpSocket  enableBroadcast:YES error:nil];
        }
        NSTimeInterval timeout = 5000;
        NSData* pSend = [[NSData alloc]initWithBytes:arrPacket length:102];


        BOOL res = [self.udpSocket sendData:pSend toHost:@"255.255.255.255" port:2304 withTimeout:timeout tag:1];
        if (!res)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示"
                                                            message: @"开机指令发送失败！"
                                                           delegate: self
                                                  cancelButtonTitle: @"取消"
                                                  otherButtonTitles: nil];
            [alert show];
   
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"系统提示"
                                                       message:@"请填写正确的中控MAC地址，长度为12。"
                                                      delegate:self
                                             cancelButtonTitle:@"确 定"
                                             otherButtonTitles:nil];
        [alert show];
    }
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
    //判断 mac 可用性
    //    if([self validInput:@"[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]:[0-9A-F][0-9A-F]" inputContent:self.textField_MACAddress.text]==NO){
    //        [SVProgressHUD showErrorWithStatus:@"Mac地址不可用,请检查"];
    //        return ;
    //    }
    
    
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
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
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


#pragma mark - udp 代理
//************************UDP***************************
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"代理Udp 0%s %d,tag=%ld", __FUNCTION__, __LINE__, tag);
}
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"代理Udp 1%s %d", __FUNCTION__, __LINE__);
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSString *s = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] ;
    NSLog(@"代理Udp 2didReceiveData, host = %@, tag = %ld, s = %@", host, tag, s);
    
    return NO;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"代理Udp 3%s %d", __FUNCTION__, __LINE__);
}


- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
    NSLog(@"代理Udp 4 %s %d", __FUNCTION__, __LINE__);
}

@end




















//
//  TRFDevShowController.m
//  TRFControlClient
//
//  Created by SunSi on 16/10/2.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import "TRFDevShowController.h"
#import "TRFMainUIViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "GDataXMLNode.h"
#import "AsyncSocket.h"

@interface TRFDevShowController ()<AsyncSocketDelegate>
/** trfMain   */
@property (strong,nonatomic) AppDelegate *myDelegate;

/** async   */
@property (strong,nonatomic) AsyncSocket *devSendSocket;
@end

@implementation TRFDevShowController

- (void)viewDidLoad {
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.myDelegate=myDelegate;
    
    self.title=@"设备列表";
    [super viewDidLoad];
    [self loadInfoAsync];
}

-(void)loadInfoAsync{
    self.myDelegate.connecttype= @"DeviceQueryReq";
    
    if (self.myDelegate.isDevicetablelist)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *Devicetablelist = [userDefaults objectForKey:@"Devicetablelist"];
        //设备查询
        [self xmlPaserWithXMLDeviceQueryReq:Devicetablelist];
    }
    else
    {
        if (!self.myDelegate.connectOK)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"系统提示"
                                                           message:@"请先连接到中控"
                                                          delegate:self
                                                 cancelButtonTitle:@"确 定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            //等待提示
            [SVProgressHUD show];
            //设备查询
            //NSString *xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Packet><Header><CmdID>DeviceQueryReq</CmdID><From>%@</From></Header><Body><Index>0</Index></Body></Packet>",_index.text];
            NSString *xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Packet><Header><CmdID>DeviceQueryReq</CmdID><From>6689</From></Header><Body><Index>0</Index></Body></Packet>"];
            NSData *data = [xmlstr dataUsingEncoding: NSUTF8StringEncoding];
            
            [self willConnect];
            if (self.myDelegate.connectOK)
            {
                [self.myDelegate.sendSocket writeData: data withTimeout: -1 tag: 0];
            }
        }
    }
}
#pragma mark - tcp onSocket
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLogs(@"dev 代理socket 连接成功%s %d", __FUNCTION__, __LINE__);
    [SVProgressHUD showSuccessWithStatus:@"连接中控成功"];
    [self.myDelegate.sendSocket readDataWithTimeout: -1 tag: 0];
}
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLogs(@"dev 代理==onSocket:didWriteDataWithTag:  %s %d, tag = %ld", __FUNCTION__, __LINE__, tag);
    [self.myDelegate.sendSocket readDataWithTimeout: -1 tag: 0];
}
// 这里必须要使用流式数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    pchLogClass;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);  NSString *message = [[NSString alloc] initWithData:data encoding:enc];
    NSLogs(@"这里必须要使用流式数据dev is: \n%@",message);
    
    self.myDelegate.xmlcacle =[self.myDelegate.xmlcacle stringByAppendingString:message];
   if (tag==2) {
        [ self.myDelegate.sendSocket disconnect];
    }
    //是否包结尾
    if ([self.myDelegate.xmlcacle hasSuffix:@"</Packet>"]){
          if ([ self.myDelegate.connecttype isEqualToString:@"DeviceQueryReq"]){
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.myDelegate.xmlcacle forKey:@"Devicetablelist"];
             self.myDelegate.isDevicetablelist=YES;
            //设备查询
            NSLogs(@"==========设备查询===========");
            [self xmlPaserWithXMLDeviceQueryReq:self.myDelegate.xmlcacle];
        }
    }
      [self.myDelegate.sendSocket readDataWithTimeout: -1 tag: 0];
}


#pragma mark - 关于xml 方法
- (void)xmlPaserWithXMLDeviceQueryReq:(NSString *)xml
{
    GDataXMLDocument *document  = [[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:nil] ;
    GDataXMLElement *rootElement = [document rootElement];
    
    NSMutableArray *index =[[NSMutableArray alloc] init];
    NSMutableArray *name =[[NSMutableArray alloc] init];
    NSMutableArray *state =[[NSMutableArray alloc] init];
    NSMutableArray *nsdate=[[NSMutableArray alloc]init];
    BOOL bHideReset = YES;
    for(GDataXMLElement *element in [rootElement elementsForName:@"Body"])
    {
        for(id ele in [element elementsForName:@"Device"])
        {
            [index addObject:[[[ele elementsForName:@"Index"] objectAtIndex:0] stringValue]];
            [name addObject:[[[ele elementsForName:@"Name"] objectAtIndex:0] stringValue]];
            [state addObject:[[[ele elementsForName:@"State"] objectAtIndex:0] stringValue]];
            NSDate *date=[[NSDate date] initWithTimeIntervalSinceNow:10];
            [nsdate addObject:date];
            NSString* strReset = [[[ele elementsForName:@"Reset"] objectAtIndex:0] stringValue];
            if ([strReset isEqualToString:@"1"])
            {
                bHideReset = NO;
            }
            NSLogs(@"[xmlPaserWithXMLDeviceQueryReq] name=%@,reset=%@", [[[ele elementsForName:@"Name"] objectAtIndex:0] stringValue],
                  [[[ele elementsForName:@"Reset"] objectAtIndex:0] stringValue]);
        }
    }
}

/** 连接的代码  */
-(void)willConnect{
    if (!self.myDelegate.sendSocket)
    {
        NSUserDefaults *useDef=[NSUserDefaults standardUserDefaults];
        NSString *ipAddress=    [useDef objectForKey:@"ipAddress"];
        NSString *portAddress=[useDef objectForKey:@"portAddress"];
        NSString *devAddress=[useDef objectForKey:@"devAddress"];
        
        if (ipAddress.length>0&&portAddress.length>0&&devAddress.length>0)
        {
            self.myDelegate.connecttype=@"VerifyReq";
            self.myDelegate.sendSocket= [[AsyncSocket alloc] initWithDelegate: self] ;
            NSError *error;
            self.myDelegate.connectOK = [self.myDelegate.sendSocket connectToHost: ipAddress onPort: [portAddress intValue]  error: &error];
            [self.myDelegate.sendSocket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            [SVProgressHUD show];
        }else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"系统提示"
                                                           message:@"请先设置中控参数和设备标示！"
                                                          delegate:self
                                                 cancelButtonTitle:@"确 定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
}

/** 断开的连接  的代码  */
-(void)willDisConnect{
    [self.myDelegate.sendSocket setDelegate:nil];
    [self.myDelegate.sendSocket disconnect];
    self.myDelegate.connectOK=NO;
    self.myDelegate.isPlaytablelist=NO;
    self.myDelegate.isDevicetablelist=NO;
    self.myDelegate.sendSocket = nil;
    [SVProgressHUD showSuccessWithStatus:@"断开中控成功"];
}










- (void)didReceiveMemoryWarning {    [super didReceiveMemoryWarning];}
@end


























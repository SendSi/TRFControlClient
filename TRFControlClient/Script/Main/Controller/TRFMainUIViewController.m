//
//  TRFMainUIViewController.m
//  TRFControlClient
//
//  Created by SunSi on 16/10/1.
//  Copyright © 2016年 SunSi. All rights reserved.
//


#import "TRFMainUIViewController.h"
#import "UIBarButtonItem+vhBarButtonTool.h"
#import "TRFConnectControl.h"
#import "TRFShowButtonV.h"
#import "TRFDevShowController.h"
#import "AsyncSocket.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "GDataXMLNode.h"
#import "TRFPlayShowController.h"
#import "TRFCommMethod.h"

@interface TRFMainUIViewController ()<TRFShowButtonShowVDelegate,AsyncSocketDelegate>{
    // CommentsCell *cell;
    
}
/** app.plist 的内容 */
@property (nonatomic ,strong ) NSArray *appItems;
/** leftButton  show  ---->  on or off*/
@property (weak,nonatomic) UIButton  *buttonLeft;
/** app.plist 的内容 */
@property (nonatomic ,strong ) AppDelegate *myDelegate;
@property (nonatomic ,strong ) TRFDevShowController *devController;
@property (nonatomic ,strong ) TRFPlayShowController *playController;

@property (nonatomic,strong) NSMutableArray *listname;
@property (nonatomic,strong) NSMutableArray *listindex;
@property (nonatomic,strong) NSMutableArray *liststate;
@property (nonatomic,strong) NSMutableArray *listcmdid;
@property (nonatomic,strong) NSMutableArray *listdate;
/** nsarray */
@property (nonatomic ,strong ) NSMutableArray<TRFShowButtonV *> *arrButton;
@end

@implementation TRFMainUIViewController
-(void)viewDidAppear:(BOOL)animated{
    UINavigationBar *bar = [self.navigationController navigationBar];
    CGFloat navBarHeight = 80;
    CGRect frame = CGRectMake(0, 0, pchScreenWidth, navBarHeight);
    [bar setFrame:frame];
    
    [super viewDidAppear:animated];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.myDelegate=myDelegate;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //修改NavigaionBar的高度  d8sz  trfClickSetting
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem  initWithBarButtonNorImage:@"d8sz" highImage:@"d8sz" showTitle:nil target:self action:@selector(trfClickSetting)];
      self.title=@"主页";
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem initWithBarButtonNorImage:@"titel_lianjie_on" highImage:@"titel_lianjie_on" target:self action:@selector(clickConnection:) ];
    [self validHasKey];/** 验证有无 key   (无key就跳到设置页面)  */
}
/** 连接 断开 按钮  */
-(void)clickConnection:(UIButton *)btn{
    self.buttonLeft=btn;
    if (!self.myDelegate.connectOK){
        [self willConnect];
    }else{
        [self willDisConnect];
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
    [self.buttonLeft setBackgroundImage:[UIImage imageNamed:@"titel_lianjie_on.png"] forState:UIControlStateNormal];
    [self.buttonLeft setBackgroundImage:[UIImage imageNamed:@"titel_lianjie_on.png"] forState:UIControlStateHighlighted];
    [SVProgressHUD showSuccessWithStatus:@"断开中控成功"];
    
    [self setShowHideArrButton:YES];
}

/** 验证有有 key (加载) */
-(void)validHasKey{
    NSString *strIP=[[NSUserDefaults standardUserDefaults] objectForKey:@"ipAddress"];
    NSString *strPort=[[NSUserDefaults standardUserDefaults] objectForKey:@"portAddress"];
    if(strIP==nil&&strPort==nil){
        [self trfClickSetting];
    }
}
/** 跳到 设置 页面  */
-(void)trfClickSetting{
    pchLogClass;
    TRFConnectControl *conn=[[TRFConnectControl alloc] init];
   UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:conn];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        nav.navigationBar.frame= CGRectMake(0, 0, pchScreenWidth, 80);
    }];
//    [self.navigationController pushViewController:conn animated:YES];
}
/** 设备 按钮 主页*/
-(void)setButtonShowUI{
    CGFloat appH=120,appW=300;
    int totalCol=3;//6列
    CGFloat offsetX=(pchScreenWidth-appW*totalCol)/(totalCol+1);//17
    CGFloat offsetY=20;
    NSInteger count=self.appItems.count;
    NSLogs(@"count==%ld,pchScreen==%f",(long)count,pchScreenWidth);
    for (int index=0; index<count; index++) {
        int rowNumber=index/totalCol;
        int colNumber=index % totalCol;
        CGFloat appx=offsetX+colNumber*(appW+offsetX);
        CGFloat appy=30+74+rowNumber*(appH+offsetY);
        
        NSDictionary *dic= self.appItems[index];
        TRFShowButtonV *buttonTrf=    [TRFShowButtonV initWithShowButton];
        [buttonTrf.buttonShowTitle setTitle:dic[@"name"] forState:UIControlStateNormal];
        buttonTrf.frame=CGRectMake(appx    , appy, 300, 120);
        buttonTrf.delegate=self;
        [self.view addSubview:buttonTrf];
        [self.arrButton addObject:buttonTrf];
    }
}
-(NSMutableArray<TRFShowButtonV *> *)arrButton{
    if(_arrButton==nil){
        _arrButton=[NSMutableArray<TRFShowButtonV *> array];
    }
    return _arrButton;
}

/** no 为显示   yes为不显示  */
-(void)setShowHideArrButton:(Boolean) boShow{
    if(self.arrButton.count>0){
        for(TRFShowButtonV *trfBtn in self.arrButton ){
            trfBtn.hidden=boShow;
        }
    }
}

-(NSArray *)appItems{
    if(_appItems==nil)
    {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"app.plist" ofType:nil];
        _appItems=[NSArray arrayWithContentsOfFile:path];
    }
    return _appItems;
}

/** 代理 跳转页面  */
-(void)showButtonShowClick:(TRFShowButtonV *)vc buttonText:(NSString *)buttonText{
    if([buttonText isEqualToString:@"设备列表"])
    {
        TRFDevShowController *vcController=[[TRFDevShowController alloc] init];
        self.devController=vcController;
        [self.navigationController pushViewController:vcController animated:YES];
    }
    else if([buttonText isEqualToString:@"播放控制"]){
        TRFPlayShowController *vcController=[[TRFPlayShowController alloc] init];
        self.playController=vcController;
        [self.navigationController pushViewController:vcController animated:YES];
    }
}

#pragma  - mark 代理 Socket  的代理
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLogs(@"代理socket 连接成功%s %d", __FUNCTION__, __LINE__);
    [SVProgressHUD showSuccessWithStatus:@"连接中控成功"];
    [self.buttonLeft setBackgroundImage:[UIImage imageNamed:@"titel_lianjie_off.png"] forState:UIControlStateNormal];
    [self.buttonLeft setBackgroundImage:[UIImage imageNamed:@"titel_lianjie_off.png"] forState:UIControlStateHighlighted];
    [self.myDelegate.sendSocket readDataWithTimeout: -1 tag: 0];
    
    [self setShowHideArrButton:NO];
    
    [self setButtonShowUI];
}
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLogs(@"代理==onSocket:didWriteDataWithTag:  %s %d, tag = %ld", __FUNCTION__, __LINE__, tag);
    [self.myDelegate.sendSocket readDataWithTimeout: -1 tag: 0];
}
// 这里必须要使用流式数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);  NSString *message = [[NSString alloc] initWithData:data encoding:enc];
    NSLogs(@"流式数据  message  --->         :        %@",message);
    if(self.myDelegate.xmlcacle==nil) self.myDelegate.xmlcacle=@"";
    self.myDelegate.xmlcacle =[self.myDelegate.xmlcacle stringByAppendingString:message];
    if (tag==2) {
        [self.myDelegate.sendSocket disconnect];
    }
    
    //是否包结尾
    if ([self.myDelegate.xmlcacle hasSuffix:@"</Packet>"]){
        NSLogs(@"req==res=%@",self.myDelegate.connecttype);
        
        if ([self.myDelegate.connecttype isEqualToString:@"DeviceQueryReq"]){
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.myDelegate.xmlcacle forKey:@"Devicetablelist"];
            self.myDelegate.isDevicetablelist=YES;
            //设备查询
            [self xmlPaserWithXMLDeviceQueryReq:self.myDelegate.xmlcacle];
        }
        else if ([self.myDelegate.connecttype isEqualToString:@"PlayQueryReq"]){
            self.myDelegate.isPlaytablelist=YES;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.myDelegate.xmlcacle forKey:@"Playtablelist"];
            //播放查询
            [self xmlPaserWithXMLPlayQueryReq:self.myDelegate.xmlcacle];
        }
        else if ([self.myDelegate.connecttype isEqualToString:@"DeviceCtrlReq"]){
            //控制请求
            [self xmlPaserWithXMLDeviceCtrlReq:self.myDelegate.xmlcacle];
        }
        else if ([self.myDelegate.connecttype isEqualToString:@"PlayReq"]){
            //控制请求 播放视频
            [self xmlPaserWithXMLPlayRes:self.myDelegate.xmlcacle];
        }
        else if ([self.myDelegate.connecttype isEqualToString:@"PlayEnd"]){
            NSLogs(@"播放完成===============");
            return;
        }
        else if ([self.myDelegate.connecttype isEqualToString:@"PlayStopReq"]){
            //新加的
            [SVProgressHUD dismiss];
        }
        else if ([self.myDelegate.connecttype isEqualToString:@"PauseReq"]){
              //新加的
            [SVProgressHUD dismiss];
        }
        else if ([self.myDelegate.connecttype isEqualToString:@"VolCtrReq"]){
            //新加的
            [SVProgressHUD dismiss];
        }
        else if ([self.myDelegate.connecttype isEqualToString:@"DeviceResetReq"])    {
            // 设备重置请求
            [self xmlParserWithXMLDeviceReset:self.myDelegate.xmlcacle];
        }
        
        else if ([self.myDelegate.connecttype isEqualToString:@"ShutDown"]){
            //关闭中控
            [self willDisConnect];
            [SVProgressHUD dismiss];
        }
        else if ([self.myDelegate.connecttype isEqualToString:@"VerifyReq"]){
            //关闭中控
            [self xmlPaserWithXMLVerifyReq:self.myDelegate.xmlcacle];
        }
        //清空
        self.myDelegate.xmlcacle =@"";
        //多包  粘结
    }
    [self.myDelegate.sendSocket readDataWithTimeout: -1 tag: 0];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    [SVProgressHUD showErrorWithStatus:@"网络错误,连接不到中控"];
    [self.buttonLeft setBackgroundImage:[UIImage imageNamed:@"titel_lianjie_on.png"] forState:UIControlStateNormal];
    NSLogs(@"网络错误001-->%s %d, err = %@", __FUNCTION__, __LINE__, err);
   self.myDelegate.connectOK =NO;
}
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLogs(@"网络错误002-->%s %d", __FUNCTION__, __LINE__);
    [SVProgressHUD showErrorWithStatus:@"网络错误,连接不到中控"];
    [self.buttonLeft setBackgroundImage:[UIImage imageNamed:@"titel_lianjie_on.png"] forState:UIControlStateNormal];
    [self.buttonLeft setBackgroundImage:[UIImage imageNamed:@"titel_lianjie_on.png"] forState:UIControlStateHighlighted];
      self.myDelegate.connectOK =NO;
    self.myDelegate.sendSocket = nil;
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
        }
    }
    NSLogs(@"首次 进入 name=%@,state=%@",name,state);

    
    self.listname = name;
    self.listindex = index;
    self.liststate = state;
    self.listdate=nsdate;
 
    [self.devController loadInfoArray_listName:self.listname listIndex:self.listindex listState:self.liststate listDate:self.listdate];
}

- (void)xmlPaserWithXMLPlayQueryReq:(NSString *)xml
{
    GDataXMLDocument *document  = [[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:nil] ;
    GDataXMLElement *rootElement = [document rootElement];
    
    NSMutableArray *index =[[NSMutableArray alloc] init];
    NSMutableArray *name =[[NSMutableArray alloc] init];
    NSMutableArray *state =[[NSMutableArray alloc] init];
    
    for(GDataXMLElement *element in [rootElement elementsForName:@"Body"])
    {
        for(id ele in [element elementsForName:@"Play"])
        {            
            [index addObject:[[[ele elementsForName:@"Index"] objectAtIndex:0] stringValue]];
            [name addObject:[[[ele elementsForName:@"Name"] objectAtIndex:0] stringValue]];
            [state addObject:@"Play"];
          }
    }
    
    self.listname = name;
    self.listindex = index;
    self.liststate = state;
    
    
  [self.playController loadInfoArray_listName:self.listname listIndex:self.listindex listState:self.liststate listDate:self.listdate];
    
}

- (void)xmlPaserWithXMLDeviceCtrlReq:(NSString *)xml
{
    
    GDataXMLDocument *document  = [[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:nil] ;
    //取出xml的根节点
    GDataXMLElement* rootElement = [document rootElement];
   
    //取出某一个具体节点(body节点)
    GDataXMLElement* bodyElement = [[rootElement elementsForName:@"Body"]objectAtIndex:0];
    
    //某个具体节点的文本内容
    NSString* Result = [[[bodyElement elementsForName:@"Result"] objectAtIndex:0] stringValue];
    NSString* Reason = [[[bodyElement elementsForName:@"Reason"] objectAtIndex:0] stringValue];
    
    if ([Result isEqualToString:@"1"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"系统提示"
                                                       message:Reason
                                                      delegate:self
                                             cancelButtonTitle:@"确 定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    [SVProgressHUD dismiss];
    NSLogs(@"请求完成--->003");
}

- (void)xmlPaserWithXMLPlayRes:(NSString *)xml
{
    GDataXMLDocument *document  = [[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:nil] ;
    //取出xml的根节点
    GDataXMLElement* rootElement = [document rootElement];
    GDataXMLElement* headElement = [[rootElement elementsForName:@"Header"]objectAtIndex:0];
    //取出某一个具体节点(body节点)
    GDataXMLElement* bodyElement = [[rootElement elementsForName:@"Body"]objectAtIndex:0];
    //某个具体节点的文本内容
    NSString* cmdid = [[[headElement elementsForName:@"CmdID"] objectAtIndex:0] stringValue];
    NSString* Result = [[[bodyElement elementsForName:@"Result"] objectAtIndex:0] stringValue];
    NSString* Reason = [[[bodyElement elementsForName:@"Reason"] objectAtIndex:0] stringValue];
    if ([Result isEqualToString:@"1"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"系统提示"
                                                       message:Reason
                                                      delegate:self
                                             cancelButtonTitle:@"确 定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
    if (([Result isEqualToString:@"0"])&&([cmdid isEqualToString:@"PlayRes"]))
    {
        [SVProgressHUD dismiss];
        NSLogs(@"播放 影片 在 此 监听了,成功播放了");
    }
    else if (Result==nil &&([cmdid isEqualToString:@"PlayEnd"]))
    {
       self.myDelegate.connecttype=@"PlayEnd";
    }
}
-(void)xmlParserWithXMLDeviceReset:(NSString *)xml
{
    NSLog(@"xmlParserWithXMLDeviceReset");
    GDataXMLDocument *document  = [[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:nil] ;
    //取出xml的根节点
    GDataXMLElement* rootElement = [document rootElement];
    //取出某一个具体节点(body节点)
    GDataXMLElement* bodyElement = [[rootElement elementsForName:@"Body"]objectAtIndex:0];
    NSString* Result = [[[bodyElement elementsForName:@"Result"] objectAtIndex:0] stringValue];
    if ([Result isEqualToString:@"1"])
    {
        NSString* Reason = [[[bodyElement elementsForName:@"Reason"] objectAtIndex:0] stringValue];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"系统提示"
                                                       message:Reason
                                                      delegate:self
                                             cancelButtonTitle:@"确 定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"系统提示"
                                                       message:@"设备重置成功。"
                                                      delegate:self
                                             cancelButtonTitle:@"确 定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

- (void)xmlPaserWithXMLVerifyReq:(NSString *)xml
{
    GDataXMLDocument *document  = [[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:nil] ;
    //取出xml的根节点
    GDataXMLElement* rootElement = [document rootElement];
       //取出某一个具体节点(body节点)
    GDataXMLElement* bodyElement = [[rootElement elementsForName:@"Body"]objectAtIndex:0];
    
    //某个具体节点的文本内容
        NSString* Result = [[[bodyElement elementsForName:@"Result"] objectAtIndex:0] stringValue];
    
    NSString* Reason = [[[bodyElement elementsForName:@"Reason"] objectAtIndex:0] stringValue];
    
    if ([Result isEqualToString:@"1"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"系统提示"
                                                       message:Reason
                                                      delegate:self
                                             cancelButtonTitle:@"确 定"
                                             otherButtonTitles:nil];
        [alert show];
        [self willDisConnect];
    }
}



- (void)didReceiveMemoryWarning {    [super didReceiveMemoryWarning];}
@end






















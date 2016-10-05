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
#import "TRFDevShowTableViewCell.h"

@interface TRFDevShowController ()<AsyncSocketDelegate,UITableViewDelegate,UITableViewDataSource>
/** appDelegate   */
@property (strong,nonatomic) AppDelegate *myDelegate;
/** trfMain   */
@property (strong,nonatomic) TRFMainUIViewController *trfMain;
/** async   */
@property (strong,nonatomic) AsyncSocket *devSendSocket;

/** listName   */
@property (strong,nonatomic) NSMutableArray  *listName;
/** listIndex   */
@property (strong,nonatomic) NSMutableArray  *listIndex;
/** listState   */
@property (strong,nonatomic) NSMutableArray  *listState;

@end

@implementation TRFDevShowController

- (void)viewDidLoad {
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.myDelegate=myDelegate;
    
    self.title=@"设备列表";
    
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TRFDevShowTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"TRFDevShowTableViewCell"];
    [self loadInfoAsync];
}

-(void)loadInfoArray_listName:(NSArray *)listName listIndex:(NSArray *)listIndex listState:(NSArray *)listState listDate:(NSArray *)listDate{
    [SVProgressHUD dismiss];
    NSLogs(@"刷新 数据==%@",listName);
    self.listName=(NSMutableArray *)listName;
    self.listState=(NSMutableArray *)listState;
    self.listIndex=(NSMutableArray *)listIndex;
    [self.tableView reloadData];
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
            NSString *devAddress=[[NSUserDefaults standardUserDefaults] objectForKey:@"devAddress"];
            NSString *xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Packet><Header><CmdID>DeviceQueryReq</CmdID><From>%@</From></Header><Body><Index>0</Index></Body></Packet>",devAddress];
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

#pragma mark - 关于xml 方法
- (void)xmlPaserWithXMLDeviceQueryReq:(NSString *)xml
{
    GDataXMLDocument *document  = [[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:nil] ;
    GDataXMLElement *rootElement = [document rootElement];
    NSMutableArray *nsdate=[[NSMutableArray alloc]init];
    for(GDataXMLElement *element in [rootElement elementsForName:@"Body"])
    {
        for(id ele in [element elementsForName:@"Device"])
        {
            [self.listIndex addObject:[[[ele elementsForName:@"Index"] objectAtIndex:0] stringValue]];
            [self.listName addObject:[[[ele elementsForName:@"Name"] objectAtIndex:0] stringValue]];
            [self.listState addObject:[[[ele elementsForName:@"State"] objectAtIndex:0] stringValue]];
            NSDate *date=[[NSDate date] initWithTimeIntervalSinceNow:10];
            [nsdate addObject:date];
        }
    }
    NSLogs(@"再次进入");
    [self.tableView reloadData];
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


#pragma mark -   懒加载
-(NSMutableArray *)listName{
    if(_listName==nil){        _listName=[NSMutableArray array];    }
    return _listName;
}
-(NSMutableArray *)listState{
    if(_listState==nil){        _listState=[NSMutableArray array];    }
    return _listState;
}
-(NSMutableArray *)listIndex{
    if(_listIndex==nil){        _listIndex=[NSMutableArray array];    }
    return _listIndex;
}

#pragma mark -   UITableView 的代理们
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TRFDevShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRFDevShowTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.listName.count>0)
    {
        cell.labelName.text=self.listName[indexPath.section];
        cell.buttonPic.tag=[self.listIndex[indexPath.section] integerValue];
        // 1.已开启,所以展示 关闭按钮      0.已关闭,民示  开启按钮
        NSInteger nsState=[self.listState[indexPath.section] integerValue];
        if(nsState==0){//list_off  list_on
            [cell.buttonPic setImage:[UIImage imageNamed:@"list_on"] forState:UIControlStateNormal];
            [cell.buttonPic setImage:[UIImage imageNamed:@"list_on"] forState:UIControlStateHighlighted];
        }else{
            [cell.buttonPic setImage:[UIImage imageNamed:@"list_off"] forState:UIControlStateNormal];
            [cell.buttonPic setImage:[UIImage imageNamed:@"list_off"] forState:UIControlStateHighlighted];
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listName.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 3;
}







- (void)didReceiveMemoryWarning {    [super didReceiveMemoryWarning];}
@end


























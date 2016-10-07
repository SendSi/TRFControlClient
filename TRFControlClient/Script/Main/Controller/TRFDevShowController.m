//
//  TRFDevShowController.m
//  TRFControlClient
//
//  Created by SunSi on 16/10/2.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import "TRFDevShowController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "GDataXMLNode.h"
#import "TRFDevShowTableViewCell.h"
#import "AsyncSocket.h"
#import "TRFCommMethod.h"

@interface TRFDevShowController ()<UITableViewDelegate,UITableViewDataSource,TRFDevShowTableViewCellDelegate>
/** appDelegate   */
@property (strong,nonatomic) AppDelegate *myDelegate;
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
    self.view.backgroundColor=pchColor(16, 17, 18);
    
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TRFDevShowTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"TRFDevShowTableViewCell"];
    [self loadInfoAsync];
}
/** 首次 进入 列表 加载的 数据   */
-(void)loadInfoArray_listName:(NSArray *)listName listIndex:(NSArray *)listIndex listState:(NSArray *)listState listDate:(NSArray *)listDate{
    [SVProgressHUD dismiss];
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
        NSString *Devicetablelist = [userDefaults stringForKey:@"Devicetablelist"];
        
        //设备查询
        [self xmlPaserWithXMLDeviceQueryReq:Devicetablelist];
    }
    else{
        [TRFCommMethod asyncCtrPlay:@"DeviceQueryReq" indexId:@"0" indexLaterStr:@"" indexLaterValue:@""];
    }
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
    NSLogs(@"第二次+  进入 列表 ");
    [self.tableView reloadData];
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
    [cell loadDataInfo:self.listName[indexPath.section] tag:[self.listIndex[indexPath.section] integerValue] state:[self.listState[indexPath.section] integerValue]];
    cell.delegateCell=self;
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


#pragma  mark - cell 里面的 代理
-(void)devShowTableViewCellClickLeftOpen:(TRFDevShowTableViewCell *)vc tag:(NSInteger)tag{
    pchLogClass;
    [TRFCommMethod asyncSelectHasCtr:tag ifType1:@"DeviceQueryReq" ifType2:@"DeviceCtrlReq" ifType3:@"PlayReq" elseReq:@"PlayReq" state:@"1"];
}

/** right也就关闭 [按钮]  */
-(void)devShowTableViewCellClickRight:(TRFDevShowTableViewCell *)vc tag:(NSInteger)tag{//right也就关闭 按钮
    [TRFCommMethod asyncSelectHasCtr:tag ifType1:@"DeviceQueryReq" ifType2:@"DeviceCtrlReq" ifType3:@"PlayReq" elseReq:@"PlayStopReq" state:@"0"];
}





- (void)didReceiveMemoryWarning {    [super didReceiveMemoryWarning];}
@end



/** 关闭  */
//    NSString *rowValue = [NSString stringWithFormat:@"%ld",(long)tag];
//    NSString *xmlstr=nil;
//    NSString *devStr=[[NSUserDefaults standardUserDefaults] objectForKey:@"devAddress"];
//    //等待提示
//    [SVProgressHUD show];
//    if (([self.myDelegate.connecttype isEqualToString:@"DeviceQueryReq"])||([self.myDelegate.connecttype isEqualToString:@"DeviceCtrlReq"])){
//        self.myDelegate.connecttype= @"DeviceCtrlReq";
//        //设备查询
//        xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Packet><Header><CmdID>%@</CmdID><From>%@</From></Header><Body><Index>%@</Index><State>0</State></Body></Packet>",self.myDelegate.connecttype,devStr, rowValue];
//    }else {
//       self.myDelegate.connecttype= @"PlayReq";
//        //播放请求
//        xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Packet><Header><CmdID>%@</CmdID><From>%@</From></Header><Body><Index>%@</Index></Body></Packet>",@"PlayStopReq",devStr, rowValue];
//    }
//    NSData *data = [xmlstr dataUsingEncoding: NSUTF8StringEncoding];
//    if (self.myDelegate.connectOK)
//    {
//        [self.myDelegate.sendSocket writeData: data withTimeout: -1 tag: 0];
//    }


/** 关启  */
//           NSString *devStr=[[NSUserDefaults standardUserDefaults] objectForKey:@"devAddress"];
//            NSString *rowValue = [NSString stringWithFormat:@"%ld",(long)tag];
//            NSString *xmlstr=nil;
//            //等待提示
//             [SVProgressHUD show];
//
//            if (([self.myDelegate.connecttype isEqualToString:@"DeviceQueryReq"])||([self.myDelegate.connecttype isEqualToString:@"DeviceCtrlReq"])){
//                self.myDelegate.connecttype= @"DeviceCtrlReq";
//                //设备查询
//                xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Packet><Header><CmdID>%@</CmdID><From>%@</From></Header><Body><Index>%@</Index><State>1</State></Body></Packet>",self.myDelegate.connecttype,devStr, rowValue];
//            }
//            else {
//                self.myDelegate.connecttype= @"PlayReq";
//                //播放请求
//                xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Packet><Header><CmdID>%@</CmdID><From>%@</From></Header><Body><Index>%@</Index></Body></Packet>",@"PlayReq",devStr,rowValue];
//            }
//            NSData *data = [xmlstr dataUsingEncoding: NSUTF8StringEncoding];
//
//            if (self.myDelegate.connectOK)
//            {
//                [self.myDelegate.sendSocket writeData: data withTimeout: -1 tag: 0];
//            }


















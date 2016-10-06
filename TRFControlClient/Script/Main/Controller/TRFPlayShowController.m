//
//  TRFPlayShowController.m
//  TRFControlClient
//
//  Created by SunSi on 16/10/6.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import "TRFPlayShowController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "TRFPlayShowTableViewCell.h"
#import "AsyncSocket.h"
#import "TRFPlayingCtrController.h"
#import "GDataXMLNode.h"

@interface TRFPlayShowController ()<TRFPlayShowTableViewCellDelegate>
/** appDelegate   */
@property (strong,nonatomic) AppDelegate *myDelegate;
/** listName   */
@property (strong,nonatomic) NSMutableArray  *listName;
/** listIndex   */
@property (strong,nonatomic) NSMutableArray  *listIndex;
/** listState   */
@property (strong,nonatomic) NSMutableArray  *listState;
@end

@implementation TRFPlayShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.myDelegate=myDelegate;
    self.title=@"播放控制";
    self.view.backgroundColor=pchColor(16, 17, 18);
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TRFPlayShowTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"TRFPlayShowTableViewCell"];
    [self loadInfoAsync];
}

-(void)loadInfoAsync{
   self.myDelegate.connecttype= @"PlayQueryReq";
    if (self.myDelegate.isPlaytablelist){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *Playtablelist = [userDefaults stringForKey:@"Playtablelist"];
        //播放查询
        [self xmlPaserWithXMLPlayQueryReq:Playtablelist];
    }else{
        if (! self.myDelegate.connectOK)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"系统提示"
                                                           message:@"请先连接到中控"
                                                          delegate:self
                                                 cancelButtonTitle:@"确 定"
                                                 otherButtonTitles:nil];
            [alert show];
        }else{
            //等待提示
            //播放查询
            [SVProgressHUD show];
            NSString *devStr=[[NSUserDefaults standardUserDefaults] objectForKey:@"devAddress"];
            NSString *xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Packet><Header><CmdID>PlayQueryReq</CmdID><From>%@</From></Header></Packet>",devStr];
            NSData *data = [xmlstr dataUsingEncoding: NSUTF8StringEncoding];
            
            if ( self.myDelegate.connectOK)
            {
                [ self.myDelegate.sendSocket writeData: data withTimeout: -1 tag: 0];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {    [super didReceiveMemoryWarning];}

- (void)xmlPaserWithXMLPlayQueryReq:(NSString *)xml
{
    GDataXMLDocument *document  = [[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:nil] ;
    GDataXMLElement *rootElement = [document rootElement];
 
    NSMutableArray *state =[[NSMutableArray alloc] init];
    
    for(GDataXMLElement *element in [rootElement elementsForName:@"Body"])
    {
        for(id ele in [element elementsForName:@"Play"])
        {
            [  self.listIndex   addObject:[[[ele elementsForName:@"Index"] objectAtIndex:0] stringValue]];
            [self.listName  addObject:[[[ele elementsForName:@"Name"] objectAtIndex:0] stringValue]];
            [state addObject:@"Play"];
        }
    }
 NSLogs(@"第二次+  进入 列表  play ");
    self.listState = state;
    [self.tableView reloadData];
}


/** 首次 进入 列表 加载的 数据   */
-(void)loadInfoArray_listName:(NSArray *)listName listIndex:(NSArray *)listIndex listState:(NSArray *)listState listDate:(NSArray *)listDate{
    [SVProgressHUD dismiss];
    self.listName=(NSMutableArray *)listName;
    self.listState=(NSMutableArray *)listState;
    self.listIndex=(NSMutableArray *)listIndex;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TRFPlayShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRFPlayShowTableViewCell"];
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
/** 代理   */
-(void)playShowTableViewCellClickPlay:(TRFPlayShowTableViewCell *)vc tag:(NSInteger)tag strTitle:(NSString *)strTitle{//播放
    TRFPlayingCtrController *playingCtr=[[TRFPlayingCtrController alloc] init];
    playingCtr.indexId=[NSString stringWithFormat:@"%ld", tag];
    playingCtr.title=strTitle;
    [self.navigationController pushViewController:playingCtr animated:YES];
}
/** 代理   */
-(void)playShowTableViewCellClickStop:(TRFPlayShowTableViewCell *)vc tag:(NSInteger)tag{
    NSString *strDev=[[NSUserDefaults standardUserDefaults] objectForKey:@"devAddress"];
    NSString *rowValue = [NSString stringWithFormat:@"%ld",tag];
    NSString *xmlstr=nil;
    //等待提示
    [SVProgressHUD  show];
    if (([self.myDelegate.connecttype isEqualToString:@"DeviceQueryReq"])||([self.myDelegate.connecttype isEqualToString:@"DeviceCtrlReq"])){
        self.myDelegate.connecttype= @"DeviceCtrlReq";
        //设备查询
        xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Packet><Header><CmdID>%@</CmdID><From>%@</From></Header><Body><Index>%@</Index><State>0</State></Body></Packet>",self.myDelegate.connecttype,strDev, rowValue];
    }else {
        self.myDelegate.connecttype= @"PlayStopReq";
        //播放请求
        xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Packet><Header><CmdID>%@</CmdID><From>%@</From></Header><Body><Index>%@</Index></Body></Packet>",@"PlayStopReq",strDev, rowValue];        
    }
    NSData *data = [xmlstr dataUsingEncoding: NSUTF8StringEncoding];
    //[self connect];
    if (self.myDelegate.connectOK)
    {
        [self.myDelegate.sendSocket writeData: data withTimeout: -1 tag: 0];
    }

}




@end





































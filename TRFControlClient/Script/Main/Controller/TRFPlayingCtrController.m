//
//  TRFPlayingCtrController.m
//  TRFControlClient
//
//  Created by SunSi on 16/10/6.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import "TRFPlayingCtrController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "AsyncSocket.h"

@interface TRFPlayingCtrController ()
/** appDelegate   */
@property (strong,nonatomic) AppDelegate *myDelegate;
/** listName   */
@property (strong,nonatomic) NSMutableArray  *listName;
/** listIndex   */
@property (strong,nonatomic) NSMutableArray  *listIndex;
/** listState   */
@property (strong,nonatomic) NSMutableArray  *listState;
@end

@implementation TRFPlayingCtrController

- (void)viewDidLoad {
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.myDelegate=myDelegate;
    self.view.backgroundColor=pchColor(16, 17, 18);
    [super viewDidLoad];
    
        [self loadAsyncPlay];
}
-(void)loadAsyncPlay{
    self.myDelegate.connecttype= @"PlayReq";
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
        NSString *xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Packet><Header><CmdID>%@</CmdID><From>%@</From></Header><Body><Index>%@</Index></Body></Packet>",@"PlayReq",devStr,self.indexId];
        NSData *data = [xmlstr dataUsingEncoding: NSUTF8StringEncoding];        
        if ( self.myDelegate.connectOK)
        {
            [ self.myDelegate.sendSocket writeData: data withTimeout: -1 tag: 0];
        }
    }
}


/** 首次 进入 列表 加载的 数据   */
-(void)loadInfoArray_listName:(NSArray *)listName listIndex:(NSArray *)listIndex listState:(NSArray *)listState listDate:(NSArray *)listDate{
    [SVProgressHUD dismiss];
    self.listName=(NSMutableArray *)listName;
    self.listState=(NSMutableArray *)listState;
    self.listIndex=(NSMutableArray *)listIndex;
}

- (IBAction)ClickButtonPause:(UIButton *)sender {
    if([sender.titleLabel.text isEqualToString:@"暂停"])
    {
        [sender setTitle:@"播放" forState:UIControlStateNormal];
        [self loadAsyncPause];
    }
    else if([sender.titleLabel.text isEqualToString:@"播放"]){
                [sender setTitle:@"暂停" forState:UIControlStateNormal];
        [self loadAsyncPlay];
    }

}


-(void)loadAsyncPause{
    self.myDelegate.connecttype= @"PauseReq";
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
        NSString *xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\" ?><Packet><Header><CmdID>%@</CmdID><From>%@</From></Header><Body><Index>%@</Index></Body></Packet>",@"PauseReq",devStr,self.indexId];
        
        NSData *data = [xmlstr dataUsingEncoding: NSUTF8StringEncoding];
        if ( self.myDelegate.connectOK)
        {
            [ self.myDelegate.sendSocket writeData: data withTimeout: -1 tag: 0];
        }
    }
}


- (IBAction)ClickButtonVolumn:(UIButton *)sender {
    self.myDelegate.connecttype= @"VolCtrReq";
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
        NSString *xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\" ?><Packet><Header><CmdID>%@</CmdID><From>%@</From></Header><Body><Index>%@</Index><Volume>100</Volume></Body></Packet>",@"VolCtrReq",devStr,self.indexId];
        NSData *data = [xmlstr dataUsingEncoding: NSUTF8StringEncoding];
        if ( self.myDelegate.connectOK)
        {
            [ self.myDelegate.sendSocket writeData: data withTimeout: -1 tag: 0];
        }
    }

}

- (IBAction)ClickButtonVolumnRemove:(UIButton *)sender {
    self.myDelegate.connecttype= @"VolCtrReq";
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
        NSString *xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\" ?><Packet><Header><CmdID>%@</CmdID><From>%@</From></Header><Body><Index>%@</Index><Volume>2</Volume></Body></Packet>",@"VolCtrReq",devStr,self.indexId];
        NSData *data = [xmlstr dataUsingEncoding: NSUTF8StringEncoding];
        if ( self.myDelegate.connectOK)
        {
            [ self.myDelegate.sendSocket writeData: data withTimeout: -1 tag: 0];
        }
    }

}





















- (void)didReceiveMemoryWarning {  [super didReceiveMemoryWarning];}



@end







































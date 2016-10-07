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
#import "TRFCommMethod.h"

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
    [TRFCommMethod asyncCtrPlay:@"PlayReq" indexId:self.indexId];
}


/** 首次 进入 列表 加载的 数据   */
-(void)loadInfoArray_listName:(NSArray *)listName listIndex:(NSArray *)listIndex listState:(NSArray *)listState listDate:(NSArray *)listDate{
    [SVProgressHUD dismiss];
    self.listName=(NSMutableArray *)listName;
    self.listState=(NSMutableArray *)listState;
    self.listIndex=(NSMutableArray *)listIndex;
}
/** 播放与暂停 控制 [按钮] */
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

/** 暂停 控制  */
-(void)loadAsyncPause{
    [TRFCommMethod asyncCtrPlay:@"PauseReq" indexId:self.indexId indexLaterStr:@"" indexLaterValue:@""];
}

/** 音量 控制 [滑动条] */
- (IBAction)MoveSlider:(UISlider *)sender {
    sender.continuous=NO;
  NSString *strValue=[NSString stringWithFormat:@"%f",sender.value *100]  ;
    [TRFCommMethod asyncCtrPlay:@"VolCtrReq" indexId:self.indexId indexLaterStr:@"<Volume>" indexLaterValue:strValue];
}






















- (void)didReceiveMemoryWarning {  [super didReceiveMemoryWarning];}



@end







































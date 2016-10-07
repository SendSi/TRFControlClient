//
//  TRFCommMethod.m
//  TRFControlClient
//
//  Created by SunSi on 16/10/7.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import "TRFCommMethod.h"
#import "AsyncSocket.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"

@interface TRFCommMethod()
/** appDelegate  */
@property (strong,nonatomic) AppDelegate *myDelegate;


@end

@implementation TRFCommMethod

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.myDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

+(void)asyncCtrPlay:(NSString *)connecttype indexId:(NSString *)indexId{
    [self asyncCtrPlay:connecttype indexId:indexId indexLaterStr:@"" indexLaterValue:@""];
}
/** indexLater 是给index后面的有值使用的,像Volumn      若无indexLater 全写 @""(不传nil)  */
+(void)asyncCtrPlay:(NSString *)connecttype indexId:(NSString *)indexId indexLaterStr:(NSString *) indexLaterStr indexLaterValue:(NSString *)indexLaterValue{
    TRFCommMethod *trfSelf  =[[TRFCommMethod alloc] init];
    
    NSMutableString *indexLaterStr2=nil;
    if(![indexLaterStr isEqualToString:@""]){
       indexLaterStr2=[[NSMutableString alloc] initWithString:indexLaterStr];
      [indexLaterStr2 insertString:@"/" atIndex:1];
    }
    
    
    trfSelf.myDelegate.connecttype= connecttype;
    if (! trfSelf.myDelegate.connectOK)
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
        NSString *xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Packet><Header><CmdID>%@</CmdID><From>%@</From></Header><Body><Index>%@</Index>%@%@%@</Body></Packet>",connecttype,devStr,indexId,indexLaterStr,indexLaterValue,indexLaterStr2];
        NSData *data = [xmlstr dataUsingEncoding: NSUTF8StringEncoding];
        if ( trfSelf.myDelegate.connectOK)
        {
            [ trfSelf.myDelegate.sendSocket writeData: data withTimeout: -1 tag: 0];
        }
    }
}
/** if里 type里 会选择的ifType2的       else里的ifType3        state 0是关 1是开*/
+(void)asyncSelectHasCtr:(NSInteger)index ifType1:(NSString *)ifType1 ifType2:(NSString *)ifType2 ifType3:(NSString *)ifType3 elseReq:(NSString *)elseReq state:(NSString *)state{
     TRFCommMethod *trfSelf  =[[TRFCommMethod alloc] init];
    NSString *rowValue = [NSString stringWithFormat:@"%ld",(long)index];
    NSString *xmlstr=nil;
    NSString *devStr=[[NSUserDefaults standardUserDefaults] objectForKey:@"devAddress"];
    //等待提示
    [SVProgressHUD show];
    if (([trfSelf.myDelegate.connecttype isEqualToString:ifType1])||([trfSelf.myDelegate.connecttype isEqualToString:ifType2])){
        trfSelf.myDelegate.connecttype= ifType2;
        //设备查询
        xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Packet><Header><CmdID>%@</CmdID><From>%@</From></Header><Body><Index>%@</Index><State>%@</State></Body></Packet>",trfSelf.myDelegate.connecttype,devStr, rowValue,state];
    }else {
        trfSelf.myDelegate.connecttype= ifType3;
        //播放请求
        xmlstr = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><Packet><Header><CmdID>%@</CmdID><From>%@</From></Header><Body><Index>%@</Index></Body></Packet>",elseReq,devStr, rowValue];
    }
    NSData *data = [xmlstr dataUsingEncoding: NSUTF8StringEncoding];
    if (trfSelf.myDelegate.connectOK)
    {
        [trfSelf.myDelegate.sendSocket writeData: data withTimeout: -1 tag: 0];
    }
}



//.m
+ (UIView *) changeNavTitleByFontSize:(NSString *)strTitle
{
    //自定义标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 150, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName: @"Helvetica" size: 40];
    titleLabel.textColor = [UIColor blackColor];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = strTitle;
    return titleLabel;
}

@end























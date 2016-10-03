//
//  AppDelegate.h
//  TRFControlClient
//
//  Created by SunSi on 16/10/1.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AsyncSocket;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, copy) NSString  *connecttype ;//= @"DeviceQueryReq";//VerifyReq;
@property  BOOL isDevicetablelist;// = NO;
@property  BOOL isPlaytablelist;// = NO;
@property  BOOL connectOK ;//= NO;
/**  全局的sendSocket */
@property (strong,nonatomic)  AsyncSocket  *sendSocket;
@property (copy,nonatomic) NSString *xmlcacle ;//= @"";
@end


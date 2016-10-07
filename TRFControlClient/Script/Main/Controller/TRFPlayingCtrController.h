//
//  TRFPlayingCtrController.h
//  TRFControlClient
//
//  Created by SunSi on 16/10/6.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 播放中 的控制  */
@interface TRFPlayingCtrController : UIViewController
/** indexId  */
@property (copy,nonatomic) NSString *indexId;
-(void)loadInfoArray_listName:(NSArray *)listName listIndex:(NSArray *)listIndex listState:(NSArray *)listState listDate:(NSArray *)listDate;
- (IBAction)ClickButtonPause:(UIButton *)sender;
- (IBAction)MoveSlider:(UISlider *)sender;

@end

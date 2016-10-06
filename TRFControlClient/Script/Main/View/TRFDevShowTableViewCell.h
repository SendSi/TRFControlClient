//
//  TRFDevShowTableViewCell.h
//  TRFControlClient
//
//  Created by SunSi on 16/10/5.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRFDevShowTableViewCell;
@protocol TRFDevShowTableViewCellDelegate <NSObject>

@optional
-(void)devShowTableViewCellClickRight:(TRFDevShowTableViewCell *)vc tag:(NSInteger )tag;
-(void)devShowTableViewCellClickLeftOpen:(TRFDevShowTableViewCell *)vc tag:(NSInteger )tag;
@end


@interface TRFDevShowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *buttonShowLabelName;
@property (weak, nonatomic) IBOutlet UIButton *buttonClose;

-(void)loadDataInfo: (NSString *)name tag:(NSInteger )tag state:(NSInteger)state;

- (IBAction)ClickButtonClose:(UIButton *)sender;
- (IBAction)ClickButtonOpen:(UIButton *)sender;

/** 代理 */
@property (weak,nonatomic) id<TRFDevShowTableViewCellDelegate> delegateCell;

@end

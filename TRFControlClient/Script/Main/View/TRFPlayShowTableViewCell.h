//
//  TRFPlayShowTableViewCell.h
//  TRFControlClient
//
//  Created by SunSi on 16/10/6.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRFPlayShowTableViewCell;
@protocol TRFPlayShowTableViewCellDelegate <NSObject>

@optional
-(void)playShowTableViewCellClickPlay:(TRFPlayShowTableViewCell *)vc tag:(NSInteger )tag strTitle:(NSString *)strTitle;
-(void)playShowTableViewCellClickStop:(TRFPlayShowTableViewCell *)vc tag:(NSInteger )tag;
@end
@interface TRFPlayShowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *buttonShowLabelName;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlay;
@property (weak, nonatomic) IBOutlet UIButton *buttonStop;

- (IBAction)ClickPlay:(UIButton *)sender;
- (IBAction)ClickStop:(UIButton *)sender;

/** 代理 */
@property (weak,nonatomic) id<TRFPlayShowTableViewCellDelegate> delegateCell;
-(void)loadDataInfo: (NSString *)name tag:(NSInteger )tag state:(NSInteger)state;


@end

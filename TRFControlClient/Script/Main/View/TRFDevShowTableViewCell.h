//
//  TRFDevShowTableViewCell.h
//  TRFControlClient
//
//  Created by SunSi on 16/10/5.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  TRFDevShowModel;

@interface TRFDevShowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIButton *buttonPic;

/** <#abs#>  */
@property (strong,nonatomic) TRFDevShowModel *devModel;


@end

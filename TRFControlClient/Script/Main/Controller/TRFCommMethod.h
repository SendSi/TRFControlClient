//
//  TRFCommMethod.h
//  TRFControlClient
//
//  Created by SunSi on 16/10/7.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class
@interface TRFCommMethod : NSObject
/** 此方法可不用.使用下一方法 含有indexLater的  */
+(void)asyncCtrPlay:(NSString *)connecttype indexId:(NSString *)indexId;

/** indexLater 是给index后面的有值使用的,像Volumn      若无indexLater 全写 @""(不传nil)  */
+(void)asyncCtrPlay:(NSString *)connecttype indexId:(NSString *)indexId indexLaterStr:(NSString *) indexLaterStr indexLaterValue:(NSString *)indexLaterValue;

/** if里 type里 会选择的ifType2的   else里的ifType3*/
+(void)asyncSelectHasCtr:(NSInteger)index ifType1:(NSString *)ifType1 ifType2:(NSString *)ifType2 ifType3:(NSString *)ifType3 elseReq:(NSString *)elseReq state:(NSString *)state;



//.h
+ (UIView *) changeNavTitleByFontSize:(NSString *)strTitle;
@end

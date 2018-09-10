//
//  UIColor+MZAdd.h
//  AmberSDK
//
//  Created by 马忠 on 2017/11/1.
//  Copyright © 2017年 马忠. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (MZAdd)
+ (UIColor *)mz_colorWithHexString:(NSString *)hexString;
+ (UIColor *)mz_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
@end

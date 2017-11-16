//
//  JQPrintTool.h
//  bleDemo
//
//  Created by wuyaju on 2017/6/22.
//  Copyright © 2017年 wuyaju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JQPrintTool : NSObject

/**
 * 打印两列
 *
 * @param leftText  左侧文字
 * @param rightText 右侧文字
 * @return
 */
+ (NSString *)printTwoData:(NSString *)leftText rightText:(NSString *)rightText;

/**
 * 打印三列
 *
 * @param leftText   左侧文字
 * @param middleText 中间文字
 * @param rightText  右侧文字
 * @return
 */
+ (NSString *)printThreeData:(NSString *)leftText middleText:(NSString *)middleText rightText:(NSString *)rightText;

/**
 * 格式化菜品名称，最多显示MEAL_NAME_MAX_LENGTH个数
 *
 * @param name
 * @return
 */
+ (NSString *)formatMealName:(NSString *)name;

@end

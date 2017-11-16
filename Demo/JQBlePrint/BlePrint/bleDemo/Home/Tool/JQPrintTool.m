//
//  JQPrintTool.m
//  bleDemo
//
//  Created by wuyaju on 2017/6/22.
//  Copyright © 2017年 wuyaju. All rights reserved.
//

#import "JQPrintTool.h"

/**
 * 打印纸一行最大的字节
 */
static NSUInteger LINE_BYTE_SIZE = 32;

static NSUInteger LEFT_LENGTH = 20;

static NSUInteger RIGHT_LENGTH = 12;
/**
 * 左侧汉字最多显示几个文字
 */
static NSUInteger LEFT_TEXT_MAX_LENGTH = 8;

/**
 * 小票打印菜品的名称，上限调到8个字
 */
static NSUInteger MEAL_NAME_MAX_LENGTH = 8;

@implementation JQPrintTool

/**
 * 获取数据长度
 *
 * @param msg
 * @return
 */
+ (NSUInteger)getBytesLength:(NSString *)msg {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [msg dataUsingEncoding:enc];
    return data.length;
}

/**
 * 打印两列
 *
 * @param leftText  左侧文字
 * @param rightText 右侧文字
 * @return
 */
+ (NSString *)printTwoData:(NSString *)leftText rightText:(NSString *)rightText {
    NSMutableString *sb = [NSMutableString string];
    NSUInteger leftTextLength = [self getBytesLength:leftText];
    NSUInteger rightTextLength = [self getBytesLength:rightText];
    [sb appendString:leftText];
    
    // 计算两侧文字中间的空格
    NSUInteger marginBetweenMiddleAndRight = LINE_BYTE_SIZE - leftTextLength - rightTextLength;
    
    for (int i = 0; i < marginBetweenMiddleAndRight; i++) {
        [sb appendString:@" "];
    }
    
    [sb appendString:rightText];

    return sb;
}

/**
 * 打印三列
 *
 * @param leftText   左侧文字
 * @param middleText 中间文字
 * @param rightText  右侧文字
 * @return
 */
+ (NSString *)printThreeData:(NSString *)leftText middleText:(NSString *)middleText rightText:(NSString *)rightText {
    NSMutableString *sb = [NSMutableString string];
    // 左边最多显示 LEFT_TEXT_MAX_LENGTH 个汉字 + 两个点
    if (leftText.length > LEFT_TEXT_MAX_LENGTH) {
        leftText = [leftText substringToIndex:LEFT_TEXT_MAX_LENGTH];
        leftText = [NSString stringWithFormat:@"%@..", leftText];
    }
    NSUInteger leftTextLength = [self getBytesLength:leftText];
    NSUInteger middleTextLength = [self getBytesLength:middleText];
    NSUInteger rightTextLength = [self getBytesLength:rightText];
    
    [sb appendString:leftText];
    // 计算左侧文字和中间文字的空格长度
    NSUInteger marginBetweenLeftAndMiddle = LEFT_LENGTH - leftTextLength - middleTextLength / 2;
    
    for (int i = 0; i < marginBetweenLeftAndMiddle; i++) {
        [sb appendString:@" "];
    }
    [sb appendString:middleText];
    
    // 计算右侧文字和中间文字的空格长度
    NSUInteger marginBetweenMiddleAndRight = RIGHT_LENGTH - middleTextLength / 2 - rightTextLength;
    
    // 打印的时候发现，最右边的文字总是偏右一个字符，所以需要删除一个空格
    for (int i = 0; i < marginBetweenMiddleAndRight - 1; i++) {
        [sb appendString:@" "];
    }
    
    // 打印的时候发现，最右边的文字总是偏右一个字符，所以需要删除一个空格
    [sb appendString:rightText];
    return sb;
}

/**
 * 格式化菜品名称，最多显示MEAL_NAME_MAX_LENGTH个数
 *
 * @param name
 * @return
 */
+ (NSString *)formatMealName:(NSString *)name {
    if (name.length > MEAL_NAME_MAX_LENGTH) {
        name = [name substringToIndex:MEAL_NAME_MAX_LENGTH];
        name = [NSString stringWithFormat:@"%@..", name];
        
        return name;
    }
    return name;
}

@end

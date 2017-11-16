//
//  JQSendFooterView.m
//  bleDemo
//
//  Created by wuyaju on 2017/6/24.
//  Copyright © 2017年 wuyaju. All rights reserved.
//

#import "JQSendFooterView.h"

@implementation JQSendFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.sendBtn.layer.cornerRadius = 5;
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.backgroundColor = [UIColor orangeColor];
    [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.defaultBtn.layer.cornerRadius = 5;
    self.defaultBtn.layer.masksToBounds = YES;
    self.defaultBtn.backgroundColor = [UIColor orangeColor];
    [self.defaultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end

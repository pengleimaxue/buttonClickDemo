//防止button被重复点击类别
//  UIButton+button_ClickOnce.h
//  buttonClickDemo
//
//  Created by 万安 on 16/6/18.
//  Copyright © 2016年 penglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (button_ClickOnce)

//重复点击时间间隔
@property(nonatomic,assign)NSTimeInterval timeInterval;



@end

//
//  ViewController.m
//  buttonClickDemo
//
//  Created by 万安 on 16/6/18.
//  Copyright © 2016年 penglei. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+button_ClickOnce.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _clickButton.timeInterval = 5;
    [_clickButton addTarget:self action:@selector(run) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)run{
    NSLog(@"－－－－－允许了吗");

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  UIButton+button_ClickOnce.m
//  buttonClickDemo
//
//  Created by penglei on 16/6/18.
//  Copyright © 2016年 penglei. All rights reserved.
//

#import "UIButton+button_ClickOnce.h"
@interface UIButton()
/*bool 类型 YES 不允许点击   NO 允许点击   设置是否执行点UI方法*/
@property (nonatomic, assign) BOOL isforbidClick;
@end
#import <objc/runtime.h>

//默认时间间隔
#define  defaultInerval 0.5

@implementation UIButton (button_ClickOnce)


-(void)setTimeInterval:(NSTimeInterval)timeInterval{

    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(NSTimeInterval)timeInterval{
     //_cmd在Objective-C的方法中表示当前方法的selector，正如同self表示当前方法调用的对象实例。
    return [objc_getAssociatedObject(self, _cmd)doubleValue];
}

-(void)setIsforbidClick:(BOOL)isforbidClick{

    objc_setAssociatedObject(self, @selector(isforbidClick), @(isforbidClick), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}
-(BOOL)isforbidClick{

    return [objc_getAssociatedObject(self, _cmd)boolValue];

}
-(void)resetState{
    
    [self setIsforbidClick:NO];

}
//load方法会在类第一次加载的时候被调用,调用的时间比较靠前，适合在这个方法里做方法交换,方法交换应该被保证，在程序中只会执行一次。
+(void)load{

    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
     
        SEL selSendAction = @selector(sendAction:to:forEvent:);
        SEL selMySendAction = @selector(mySendAction:to:forEvent:);
        //获取类方法
        Method methondSendAction = class_getInstanceMethod(self, selSendAction);
        Method methondMySendAction = class_getInstanceMethod(self, selMySendAction);
        //先尝试给源方法添加实现，避免源方法没有实现的情况
        BOOL isSuccess = class_addMethod(self, selSendAction, method_getImplementation(methondMySendAction), method_getTypeEncoding(methondMySendAction));
        if (isSuccess) {
            //添加成功说明就将要的实现方法的指针换成原始方法的指针,：将源方法的实现替换到交换方法的实现
            class_replaceMethod(self, selMySendAction, method_getImplementation(methondSendAction), method_getTypeEncoding(methondSendAction));
            
        }else{
           //添加失败：说明源方法已经有实现，直接将两个方法的实现交换即
            method_exchangeImplementations(methondSendAction, methondMySendAction);
        }
    
    
    });


}
-(void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    self.timeInterval = self.timeInterval <= 0 ? defaultInerval:self.timeInterval;

    if (self.isforbidClick) {
        return;
    }else if(self.timeInterval >0){
    
        [self performSelector:@selector(resetState) withObject:nil afterDelay:self.timeInterval];
    
    }
    self.isforbidClick= YES;
    [self mySendAction:action to:target forEvent:event];
}
@end

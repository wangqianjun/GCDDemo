//
//  ASERunLoopThread.m
//  GCDDemo
//
//  Created by 王钱钧 on 14/12/2.
//  Copyright (c) 2014年 王钱钧. All rights reserved.
//

#import "ASERunLoopThread.h"

/*
 NSRunLoop的运行接口：
 //运行 NSRunLoop，运行模式为默认的NSDefaultRunLoopMode模式，没有超时限制
 - (void)run;
 
 //运行 NSRunLoop: 参数为运行模式、时间期限，返回值为YES表示是处理事件后返回的，NO表示是超时或者停止运行导致返回的
 - (BOOL)runMode:(NSString *)mode beforeDate:(NSDate *)limitDate;
 
 //运行 NSRunLoop: 参数为运时间期限，运行模式为默认的NSDefaultRunLoopMode模式
 -(void)runUntilDate:(NSDate *)limitDate;
 
 
 CFRunLoopRef的运行接口：
 //运行 CFRunLoopRef
 void CFRunLoopRun();
 
 //运行 CFRunLoopRef: 参数为运行模式、时间和是否在处理Input Source后退出标志，返回值是exit原因
 SInt32 CFRunLoopRunInMode (mode, seconds, returnAfterSourceHandled);
 
 //停止运行 CFRunLoopRef
 void CFRunLoopStop( CFRunLoopRef rl );
 
 //唤醒 CFRunLoopRef
 void CFRunLoopWakeUp ( CFRunLoopRef rl );
 
 
 
 Run Loop的运行模式Mode：
 1) NSDefaultRunLoopMode: 默认的运行模式，除了NSConnection对象的事件。
 
 2) NSRunLoopCommonModes: 是一组常用的模式集合，将一个input source关联到这个模式集合上，等于将input source关联到这个模式集合中的所有模式上
   （NSDefaultRunLoopMode、NSTaskDeathCheckMode、UITrackingRunLoopMode）
 
 3) UITrackingRunLoopMode: 用于跟踪触摸事件触发的模式（例如UIScrollView上下滚动），主线程当触摸事件触发时会设置为这个模式，可以用来在控件事件触发过程中设置Timer。
 
 4) GSEventReceiveRunLoopMode: 用于接受系统事件，属于内部的Run Loop模式。
 
 5) 自定义Mode：可以设置自定义的运行模式Mode，你也可以用CFRunLoopAddCommonMode添加到NSRunLoopCommonModes中。
 */


static int RunLoopThreadIndex = 0;
static NSString *CustomRunloopMode = @"CustomRunloopMode";

@implementation ASERunLoopThread

- (void)main {
    @autoreleasepool {
        NSLog(@"a se thread starting ...");
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(doTimerTask) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        // perform
        [self performSelector:@selector(doPerformTask) withObject:nil afterDelay:1];
        
        //将自定义模式添加到这个NSRunLoopCommonModes模式中
        CFRunLoopAddCommonMode(CFRunLoopGetCurrent(), (__bridge CFStringRef)CustomRunloopMode);
        
        // port source
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
        
        // 如果事件源没有发生时，runloop 可以让线程进入asleep状态
        while (!self.isCancelled) {
            [self doOtherTask];
            
            //Timer source比较特殊，Timer Source事件发生处理后，Run Loop运行[- (BOOL)runMode:(NSString *)mode beforeDate:(NSDate *)limitDate] ,不会返回

            // 等待消息处理
            BOOL ret = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            NSLog(@"after runloop counting.....:%d", ret);
        }
        
        NSLog(@"a se thread finishing...");
    }
}

- (void)doPerformTask {
    
    NSLog(@"do perform task");
    
}

- (void)doTimerTask {
    RunLoopThreadIndex++;
    if (RunLoopThreadIndex > 5) {
        CFRunLoopStop(CFRunLoopGetCurrent());
        [self cancel]; // finishing thread
    }
    NSLog(@"do timer task");
}

- (void)doOtherTask
{
    NSLog(@"do other task");
}

- (void)dealloc {
    
}
//http://www.hrchen.com/2013/06/multi-threading-programming-of-ios-part-1/#comment-1261151516

@end

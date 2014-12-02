//
//  ASERunLoopThread.m
//  GCDDemo
//
//  Created by 王钱钧 on 14/12/2.
//  Copyright (c) 2014年 王钱钧. All rights reserved.
//

#import "ASERunLoopThread.h"

@implementation ASERunLoopThread

- (void)main {
    @autoreleasepool {
        NSLog(@"a se thread starting ...");
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(doTimerTask) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        while (!self.isCancelled) {
            [self doOtherTask];
            BOOL ret = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            NSLog(@"after runloop counting.....:%d", ret);
        }
        
        NSLog(@"a se thread finishing...");
    }
}

- (void)doTimerTask {
    NSLog(@"do timer task");
}

- (void)doOtherTask
{
    NSLog(@"do other task");
}

//http://www.hrchen.com/2013/06/multi-threading-programming-of-ios-part-1/#comment-1261151516

@end

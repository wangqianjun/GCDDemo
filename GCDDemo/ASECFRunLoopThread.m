//
//  ASECFRunLoopThread.m
//  GCDDemo
//
//  Created by 王钱钧 on 14/12/4.
//  Copyright (c) 2014年 王钱钧. All rights reserved.
//

#import "ASECFRunLoopThread.h"

static int CFRunLoopThreadTimerIndex = 0;

@implementation ASECFRunLoopThread


- (void)main {
    @autoreleasepool {
        
        // Timer source - normal
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(doTimerTask) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        // perform
        [self performSelector:@selector(doPerformTask) withObject:nil];
        
        while (!self.isCancelled) {
            SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2, YES);
            if (result == kCFRunLoopRunStopped) {
                [self cancel];
            }
            
            NSLog(@"exit run loop.........: %d", result);
        }
        
        NSLog(@"finishing thread.........");
        
    }
}

- (void)doTimerTask
{
    NSLog(@"do timer task: %d", CFRunLoopThreadTimerIndex);
    CFRunLoopThreadTimerIndex++;
    if (CFRunLoopThreadTimerIndex > 5)
    {
        CFRunLoopStop(CFRunLoopGetCurrent());
        
        //Try call run loop recursively
        //        SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2, YES);
        //        if (result == kCFRunLoopRunTimedOut)
        //        {
        //            [self cancel];
        //        }
    }
}


- (void)doOtherTask
{
    NSLog(@"do other task");
}

- (void)doPerformTask
{
    NSLog(@"do perform task");
}

@end

//
//  ASERunLoopThread.h
//  GCDDemo
//
//  Created by 王钱钧 on 14/12/2.
//  Copyright (c) 2014年 王钱钧. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 static NSString *const ThreadShouldExitNow = @"ThreadShouldExitNow";
- (void)threadRuntine {
    //必须创建一个NSAutoreleasePool，因为子线程不会自动创建
    @autoreleasepool {
        BOOL moreWorkToDo = YES;
        BOOL exitNow = NO;
        
        //(可选)设置Run Loop，如果子线程只是做个一次性的操作，那么无需设置Run Loop；如果子线程进入一个循环需要不断处理一些事件，那么设置一个Run Loop是最好的处理方式，如果需要Timer，那么Run Loop就是必须的
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        
        NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
        [threadDict setValue:[NSNumber numberWithBool:exitNow] forKey:ThreadShouldExitNow];
        
        // 添加事件源
        [self myInstallCustomInputSource];
        
        while (moreWorkToDo && !exitNow) {
            [runLoop runUntilDate:[NSDate date]];
            exitNow = [[threadDict valueForKey:ThreadShouldExitNow] boolValue];
        }
    }
}

- (void)myInstallCustomInputSource {
    
}
*/

@interface ASERunLoopThread : NSThread

@end

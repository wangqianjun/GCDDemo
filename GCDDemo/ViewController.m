//
//  ViewController.m
//  GCDDemo
//
//  Created by 王钱钧 on 14-10-17.
//  Copyright (c) 2014年 王钱钧. All rights reserved.
//  http://www.cnblogs.com/Quains/archive/2013/07/10/3182823.html

/*
  队列的类型只决定任务是并发还是串行执行，不影响同步还是异步；
 */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self serialQueue];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)serialQueue
{

    dispatch_queue_t serialQueue = dispatch_queue_create("cn.yoho.show.log", NULL);
    NSDate *startTime = [NSDate date];
    __block UIImage *image = nil;
    
    // download image first
    dispatch_async(serialQueue, ^{
        NSString *urlAsString = @"http://avatar.csdn.net/B/2/2/1_u010013695.jpg";
        NSURL *url = [NSURL URLWithString:urlAsString];
        NSError *downloadError = nil;
        NSData *imageData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:nil error:&downloadError];
        
        if (downloadError == nil && imageData != nil) {
            image = [UIImage imageWithData:imageData];
        }
        else if(downloadError != nil){
            NSLog(@"error happened = %@", downloadError);
        }
        else{
            NSLog(@"No data download");
        }
    });
    
    
    // show in the main thread
    //提交到串行队列可以用同步方式,也可以用异步方式
    dispatch_async(serialQueue, ^{
        /*
         提交到主线程队列的时候,慎用同步dispatch_sync方法,有可能造成死锁. 因为主线程队列是串行队列,要等队列里的任务一个一个执行.所以提交一个任务到队列,如果用同步方法就会阻塞住主线程,而主线程又要等主线程队列里的任务都执行完才能执行那个刚提交的,所以主线程队列里还有其他的任务的话,但他已经被阻塞住了,没法先完成队列里的其他任务,即,最后一个任务也没机会执行到,于是造成死锁.
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image != nil) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
                [imageView setImage:image];
                [self.view addSubview:imageView];
                NSDate *endTime = [NSDate date];
                NSLog(@"串行异步 completed in %f time", [endTime timeIntervalSinceDate:startTime]);
            }
            else{
                NSLog(@"image isn't downloaded, nothing to display");
            }
        });
        
    });

    
}

- (void)concurrentQueue
{
    
}

- (void)useSemaphore
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
//    dispatch_queue_t queue =
}

@end

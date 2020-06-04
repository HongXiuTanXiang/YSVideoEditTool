//
//  WAViewController.m
//  WAVideoBox
//
//  Created by 464429017@qq.com on 03/24/2020.
//  Copyright (c) 2020 464429017@qq.com. All rights reserved.
//

#import "WAViewController.h"
#import <WAVideoBox/WAVideoBox.h>
#import "PlayViewController.h"

@interface WAViewController ()

@property (nonatomic , copy) NSString *videoPath;

@property (nonatomic , copy) NSString *testOnePath;

@property (nonatomic , copy) NSString *testTwoPath;

@property (nonatomic , copy) NSString *testThreePath;

@property (nonatomic , strong) WAVideoBox *videoBox;


@end

@implementation WAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _videoBox = [WAVideoBox new];
    
      _videoPath = [[NSBundle mainBundle] pathForResource:@"recordVideo.mp4" ofType:nil];
    
      _testOnePath = [[NSBundle mainBundle] pathForResource:@"second_video.MOV" ofType:nil];
      _testTwoPath = [[NSBundle mainBundle] pathForResource:@"test2.mp4" ofType:nil];
      _testThreePath = [[NSBundle mainBundle] pathForResource:@"test3.mp4" ofType:nil];
    
    [self magicEdit:nil];
    
}

- (NSString *)buildFilePath{
    
    return [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%f.mp4", [[NSDate date] timeIntervalSinceReferenceDate]]];
}

- (void)goToPlayVideoByFilePath:(NSString *)filePath{
    PlayViewController *playVc = [PlayViewController new];
    [playVc loadWithFilePath:filePath];
    [self.navigationController pushViewController:playVc animated:YES];
}

#pragma mark 骚操作
- (void)magicEdit:(id)sender {
    
    [_videoBox clean];
    NSString *filePath = [self buildFilePath];
    __weak typeof(self) wself = self;
    
    // 放入原视频，换成1号的音，再把3号视频放入混音,剪其中8秒
    // 拼1号视频，给1号水印,剪其中8秒
    // 拼2号视频，给2号变速
    // 拼3号视频，旋转180,剪其中8秒
    // 把最后的视频再做一个变速
    [_videoBox appendVideoByPath:_videoPath];
//    [_videoBox appendWaterMark:[UIImage imageNamed:@"gifTest"] relativeRect:CGRectMake(0.1, 0.2, 0.2, 0)];
//    [_videoBox appendWaterMark:[UIImage imageNamed:@"waterImage"] absoluteRect:CGRectMake(100, 100, 0.3, 0)];
//    [_videoBox replaceSoundBySoundPath:_testOnePath];
//    [_videoBox dubbedSoundBySoundPath:_testThreePath];
//    [_videoBox rangeVideoByTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(3600, 600))];
    
    [_videoBox appendVideoByPath:_testOnePath];
//    [_videoBox appendWaterMark:[UIImage imageNamed:@"waterLog"] relativeRect:CGRectMake(0.7, 0.2, 0.2, 0)];
//    [_videoBox rangeVideoByTimeRange:CMTimeRangeMake(CMTimeMake(3600, 600), CMTimeMake(3600, 600))];
    
//    [_videoBox appendVideoByPath:_testTwoPath];
//    [_videoBox gearBoxWithScale:2];
//
//    [_videoBox appendVideoByPath:_testThreePath];
//    [_videoBox rotateVideoByDegress:180];
//    [_videoBox rangeVideoByTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMake(3600, 600))];
    
    [_videoBox commit];
//    [_videoBox gearBoxWithScale:2];
    
    [_videoBox asyncFinishEditByFilePath:filePath progress:^(float progress) {
        NSLog(@"progress --- %f",progress);
    }  complete:^(NSError * error) {
        if (!error) {
            [wself goToPlayVideoByFilePath:filePath];
            NSLog(@"filePath= %@",filePath);
        }
    }];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

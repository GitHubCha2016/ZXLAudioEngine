//
//  ViewController.m
//  AudioEngine
//
//  Created by Apple on 2017/8/24.
//  Copyright © 2017年 dandan. All rights reserved.
//

#import "ViewController.h"
#import <AEPlaythroughChannel.h>
#import <AEHighPassFilter.h>

@interface ViewController ()

/** AEPlaythroughChannel */
@property (nonatomic, strong) AEPlaythroughChannel * channel;

/** AEAudioController */
@property (nonatomic, strong) AEAudioController * audioController;

/** AEHighPassFilter */
@property (nonatomic, strong) AEHighPassFilter * highPassFilter;

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建 AEAudioController
    [self setAEAudioController];
    
    // 边录边播
    [self setupChannel];
    
    // 实现高通音效
    [self setFilter];
}

- (void)setAEAudioController{

    // This class contains the main audio engine, and manages your audio session for you.
    self.audioController = [[AEAudioController alloc]initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleaved16BitStereo inputEnabled:YES];
    
    // start the audio engine running
    NSError *error = nil;
    BOOL result = [self.audioController start:&error];
    if (!result) {
        NSLog(@"开启错误");
    }
}

- (AEHighPassFilter *)highPassFilter{
    if (!_highPassFilter) {
        _highPassFilter = [[AEHighPassFilter alloc]init];
    }
    return _highPassFilter;
}
- (IBAction)addHightPassFilter:(id)sender {
    if (![_audioController.filters containsObject:self.highPassFilter]) {
        [self.audioController addFilter:self.highPassFilter];
    }
}
- (IBAction)removeFilter:(id)sender {
    if ([_audioController.filters containsObject:self.highPassFilter]) {
        [self.audioController removeFilter:self.highPassFilter];
    }
}

- (void)setupChannel{
    
    // 实例化 AEPlaythroughChannel 对象
    self.channel = [[AEPlaythroughChannel alloc]init];
    self.channel.volume = 0.6;// 设置音量
    
    // 添加到 AEAudioController 对象中 -- 录播
    [self.audioController addInputReceiver:_channel];
    
    // 添加到 AEAudioController 对象中 -- 播放
    [self.audioController addChannels:@[self.channel]];
    
}

- (void)setFilter{
    if (![_audioController.filters containsObject:self.highPassFilter]) {
        [self.audioController addFilter:self.highPassFilter];
    }
}

- (IBAction)playAndRecorder:(id)sender {
    

    
}

- (IBAction)stopAction:(id)sender {
    
    if (self.channel) {
        [self.audioController removeInputReceiver:self.channel];
        [self.audioController removeChannels:@[self.channel]];
        self.channel = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
}


@end

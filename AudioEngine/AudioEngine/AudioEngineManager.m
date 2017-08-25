//
//  AudioEngineManager.m
//  AudioEngine
//
//  Created by Apple on 2017/8/24.
//  Copyright © 2017年 dandan. All rights reserved.
//

#import "AudioEngineManager.h"
#import <AEAudioController.h>
#import <AEAudioFilePlayer.h>

#if DEBUG
#define customLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define customLog(format, ...)
#endif

@interface  AudioEngineManager()

/** AEAudioController */
@property (nonatomic, strong) AEAudioController * audioController;

/** player */
@property (nonatomic, strong) AEAudioFilePlayer * player;

@end

@implementation AudioEngineManager

/**
 * Create a new player instance.
 */
- (void)playWithUrl:(NSString *)url{
    NSURL *file = [[NSBundle mainBundle] URLForResource:@"Loop" withExtension:@"m4a"];
    
    NSError * error = nil;
    self.player = [AEAudioFilePlayer audioFilePlayerWithURL:file
                                                    error:&error];
    
    if (!error) {
        customLog(@"%@",error);
    }
    else{
        customLog(@"播放时间 %f",self.player.duration);
    }
    // 循环
    self.player.loop = YES;
    self.player.removeUponFinish = YES;
    self.player.completionBlock = ^(){
        customLog(@"播放结束");
    };
}

- (void)playAtTime:(uint64_t)time{
    // 特定时间播放
    [self.player playAtTime:time];
}

- (UInt32)getPlayheadPosition{
    // 获取播放头的位置
    return AEAudioFilePlayerGetPlayhead(self.player);
}

@end

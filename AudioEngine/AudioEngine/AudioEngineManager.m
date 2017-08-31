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


@interface  AudioEngineManager()

/** AEAudioController */
@property (nonatomic, strong) AEAudioController * audioController;

/** player */
@property (nonatomic, strong) AEAudioFilePlayer * player;

/** AERecorder */
@property (nonatomic, strong) AERecorder * recorder;

/** AVAudioPlayer */
@property (nonatomic, strong) AVAudioPlayer * audioPalyer;

@end

@implementation AudioEngineManager


static AudioEngineManager * manager = nil;
+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AudioEngineManager alloc]init];
    });
    return manager;
}

- (void)initAudioController{
    // 设备是否支持 AAC 编码
    if ([AERecorder AACEncodingAvailable]) {
        customLog(@"设备支持AAC 编码");
        
        // 创建 AEAudioController
        // AEAudioStreamBasicDescriptionNonInterleaved16BitStereo 16位立体声PCM音频描述，非交错，44.1khz
        // 是否允许音频输入
        self.audioController = [[AEAudioController alloc]initWithAudioDescription:AEAudioStreamBasicDescriptionNonInterleaved16BitStereo inputEnabled:YES];
        // 缓冲区长度
        self.audioController.preferredBufferDuration = 0.005;
        // 音频会话模式 提高音频质量 和 低音响应
        self.audioController.useMeasurementMode = YES;
        // 启动音频引擎
        NSError *error = NULL;
        BOOL result = [_audioController start:&error];
        if ( !result ) {
            // Report error
        }
    }
}

/**
 * Create a new player instance.
 */
- (void)playWithUrl:(NSString *)url{
    NSError * error = nil;

    if ( _player ) {
        [self.audioController removeChannels:@[_player]];
        self.player = nil;
    } else {
        if ( ![[NSFileManager defaultManager] fileExistsAtPath:url] ) return;
        
        self.player = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:url] error:&error];
        
        if ( !_player ) {
            customLog(@"创建失败");
            return;
        }
        customLog(@"播放时间 %f",self.player.duration);
        
        // 循环
        self.player.loop = NO;
        self.player.removeUponFinish = YES;
        self.player.volume = 0.8;
        __weak typeof(self) weakSelf = self;
        _player.completionBlock = ^{
            customLog(@"播放结束");
            //__strong typeof(self) strongSelf = weakSelf;
            weakSelf.player = nil;
        };
        [self.audioController addChannels:@[_player]];
    }
}
- (void)playAtTime:(uint64_t)time{
    // 特定时间播放
    [self.player playAtTime:time];
}

- (UInt32)getPlayheadPosition{
    // 获取播放头的位置
    return AEAudioFilePlayerGetPlayhead(self.player);
}


- (void)recorderWithFilePath:(NSString *)filePath{
    if (!_recorder) {
        NSError * error = nil;
        // 准备录音 设置  路径 输出格式
        //    kAudioFileAIFFType				= 'AIFF',
        //    kAudioFileAIFCType				= 'AIFC',
        //    kAudioFileWAVEType				= 'WAVE',
        //    kAudioFileSoundDesigner2Type	= 'Sd2f',
        //    kAudioFileNextType				= 'NeXT',
        //    kAudioFileMP3Type				= 'MPG3',	// mpeg layer 3
        //    kAudioFileMP2Type				= 'MPG2',	// mpeg layer 2
        //    kAudioFileMP1Type				= 'MPG1',	// mpeg layer 1
        //    kAudioFileAC3Type				= 'ac-3',
        //    kAudioFileAAC_ADTSType			= 'adts',
        //    kAudioFileMPEG4Type             = 'mp4f',
        //    kAudioFileM4AType               = 'm4af',
        //    kAudioFileM4BType               = 'm4bf',
        //    kAudioFileCAFType				= 'caff',
        //    kAudioFile3GPType				= '3gpp',
        //    kAudioFile3GP2Type				= '3gp2',
        //    kAudioFileAMRType				= 'amrf'
        _recorder = [[AERecorder alloc] initWithAudioController:_audioController];
        if (![_recorder beginRecordingToFileAtPath:filePath fileType:kAudioFileM4AType error:&error] ) {
            customLog(@"录音失败");
            self.recorder = nil;
        }
        
        [_audioController addOutputReceiver:_recorder];
        [_audioController addInputReceiver:_recorder];
        
    }
    // 开始录音
    AERecorderStartRecording(self.recorder);
}
- (void)startRecorder{
    if (self.recorder && ![self.recorder recording]) {
        AERecorderStartRecording(self.recorder);
    }
}
- (void)stopRecorder{
    // 暂停录音
    if (self.recorder && [self.recorder recording]) {
        AERecorderStopRecording(self.recorder);
    }
}

- (void)finishRecorder{
    customLog(@"%@",self.recorder.path);
    [self.recorder finishRecording];
}


- (BOOL)recording{
    if (_recorder && [_recorder recording]) {
        return YES;
    }
    return NO;
}


#pragma mark AVFoundation
- (void)playAudio:(NSURL *)url{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSError * error;
    self.audioPalyer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    //self.audioPalyer.delegate = self;
    BOOL success = [self.audioPalyer play];
    if (success) {
        NSLog(@"播放成功");
    }else{
        NSLog(@"播放失败");
    }
    
}

@end

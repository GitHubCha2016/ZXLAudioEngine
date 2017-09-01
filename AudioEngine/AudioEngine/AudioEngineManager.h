//
//  AudioEngineManager.h
//  AudioEngine
//
//  Created by Apple on 2017/8/24.
//  Copyright © 2017年 dandan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

// http://www.cnblogs.com/kenshincui/p/4186022.html
// http://www.cnblogs.com/goodboy-heyang/p/5374322.html
// 音频编码 https://baike.baidu.com/item/%E9%9F%B3%E9%A2%91%E7%BC%96%E7%A0%81?fr=aladdin
// 码农人生 http://msching.github.io/blog/2014/07/07/audio-in-ios/

@interface AudioEngineManager : NSObject

/** AERecorder */
@property (nonatomic, strong) AERecorder * recorder;

/** player */
@property (nonatomic, strong) AEAudioFilePlayer * player;

+ (instancetype)share;

- (void)playWithUrl:(NSString *)url;

- (void)playAtTime:(uint64_t)time;



- (void)recorderWithFilePath:(NSString *)filePath;
- (void)startRecorder;
- (void)stopRecorder;
- (void)finishRecorder;
@property (nonatomic, assign) BOOL recording;


/** 检测音频变化 */
@property (nonatomic, copy) void(^AudioPowerChangeBlock)(CGFloat inputAvg,CGFloat inputPeak);

@end

//
//  AudioEngineManager.h
//  AudioEngine
//
//  Created by Apple on 2017/8/24.
//  Copyright © 2017年 dandan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioEngineManager : NSObject

+ (instancetype)share;

- (void)playWithUrl:(NSString *)url;

- (void)playAtTime:(uint64_t)time;



- (void)recorderWithFilePath:(NSString *)filePath;
- (void)startRecorder;
- (void)stopRecorder;
- (void)finishRecorder;
@property (nonatomic, assign) BOOL recording;


@end

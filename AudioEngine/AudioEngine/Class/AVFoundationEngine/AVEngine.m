//
//  AVEngine.m
//  AudioEngine
//
//  Created by Apple on 2017/9/1.
//  Copyright © 2017年 dandan. All rights reserved.
//

#import "AVEngine.h"
#import <AVFoundation/AVFoundation.h>

@interface AVEngine ()


/** AVAudioPlayer */
@property (nonatomic, strong) AVAudioPlayer * audioPalyer;

@end

@implementation AVEngine

- (instancetype)init
{
    self = [super init];
    if (self) {
        //_audioPalyer = [[AVAudioPlayer alloc]init];
    }
    return self;
}

- (void)playWithUrlString:(NSString *)urlString{
    NSURL * url = [NSURL fileURLWithPath:urlString];
    customLog(@"%@",url.absoluteString);
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSError * error;
    self.audioPalyer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    //self.audioPalyer.delegate = self;
    [self.audioPalyer prepareToPlay];
    BOOL success = [self.audioPalyer play];
    if (success) {
        NSLog(@"播放成功");
    }else{
        NSLog(@"播放失败");
    }
}

@end

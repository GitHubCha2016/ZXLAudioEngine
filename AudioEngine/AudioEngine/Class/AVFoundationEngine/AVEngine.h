//
//  AVEngine.h
//  AudioEngine
//
//  Created by Apple on 2017/9/1.
//  Copyright © 2017年 dandan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVEngine : NSObject

- (void)playWithUrlString:(NSString *)urlString;

/** AVAudioPlayer */
@property (nonatomic, strong) AVAudioPlayer * audioPalyer;

/** 播放是否成功、失败 */
@property (nonatomic, strong)  void(^PlayResultBlock)(BOOL result);

@end

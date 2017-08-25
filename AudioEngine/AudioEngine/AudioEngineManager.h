//
//  AudioEngineManager.h
//  AudioEngine
//
//  Created by Apple on 2017/8/24.
//  Copyright © 2017年 dandan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioEngineManager : NSObject

- (void)playWithUrl:(NSString *)url;

- (void)playAtTime:(uint64_t)time;

@end

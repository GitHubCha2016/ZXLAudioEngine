//
//  Macro.h
//  AudioEngine
//
//  Created by Apple on 2017/8/25.
//  Copyright © 2017年 dandan. All rights reserved.
//

#ifndef Macro_h
#define Macro_h


#endif /* Macro_h */

#if DEBUG
#define customLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define customLog(format, ...)
#endif

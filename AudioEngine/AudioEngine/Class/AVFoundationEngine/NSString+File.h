//
//  NSString+File.h
//  AudioEngine
//
//  Created by Apple on 2017/9/5.
//  Copyright © 2017年 zxl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (File)

- (BOOL)isFileExistsAtPath;
- (BOOL)removeFileAtPath;

@end

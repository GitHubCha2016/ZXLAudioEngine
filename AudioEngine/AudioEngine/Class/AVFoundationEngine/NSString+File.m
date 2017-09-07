//
//  NSString+File.m
//  AudioEngine
//
//  Created by Apple on 2017/9/5.
//  Copyright © 2017年 zxl. All rights reserved.
//

#import "NSString+File.h"

@implementation NSString (File)

- (BOOL)isFileExistsAtPath{
    return [[NSFileManager defaultManager]fileExistsAtPath:self];
}

- (BOOL)removeFileAtPath {
    if ([[NSFileManager defaultManager]fileExistsAtPath:self]) {
        // 移除存在文件
        return [[NSFileManager defaultManager]removeItemAtPath:self error:nil];
    }
    return YES;
}

@end

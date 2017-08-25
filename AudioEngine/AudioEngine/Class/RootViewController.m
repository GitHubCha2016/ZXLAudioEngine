//
//  RootViewController.m
//  AudioEngine
//
//  Created by Apple on 2017/8/25.
//  Copyright © 2017年 dandan. All rights reserved.
//

#import "RootViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // AVURLAsset是一个资源的抽象类，由此可以分离出资源的音频和视频
    NSURL * url = [[NSBundle mainBundle]URLForResource:@"frozen" withExtension:@"m4a"];
    AVURLAsset * videoAsset = [[AVURLAsset alloc]initWithURL:url options:nil];
    
    NSURL * bgUrl = [[NSBundle mainBundle]URLForResource:@"fun" withExtension:@"m4a"];
    AVURLAsset * backgroundAudio = [[AVURLAsset alloc]initWithURL:bgUrl options:nil];
    
    // AVMutableComposition顾名思义是一个用来接收不同轨道的类，无论是音频还是视频
    AVMutableComposition * mixComposition = [AVMutableComposition composition];
    
    
    // 合成
    AVMutableCompositionTrack *backgroundTrack =
    [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                preferredTrackID:kCMPersistentTrackID_Invalid];
    NSArray *audioTracks = [backgroundAudio tracksWithMediaType:AVMediaTypeAudio];
    [backgroundTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, backgroundAudio.duration)
                             ofTrack:[audioTracks firstObject]
                              atTime:kCMTimeZero error:nil];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    NSArray *videoTracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:[videoTracks firstObject]
                                    atTime:kCMTimeZero error:nil];
    
    // 是否可以导出
    BOOL isExportable = [mixComposition isExportable];
    AVAssetExportSession * exportSession = [AVAssetExportSession exportSessionWithAsset:mixComposition presetName:@"123"];
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString * filePath = [path stringByAppendingPathComponent:@"story.m4a"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSError * error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            return;
        }
    }
    
    for (NSString *supportFileType in assetExport.supportedFileTypes) {
        NSLog(@"%@",supportFileType);
    }
    
    assetExport.outputFileType = @"public.mpeg-4";
    NSLog(@"file type %@",assetExport.outputFileType);
    assetExport.outputURL = location;
    assetExport.shouldOptimizeForNetworkUse = YES;
    
    [assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         // your completion code here
         NSLog(@"%@",assetExport.outputURL);
         
     }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

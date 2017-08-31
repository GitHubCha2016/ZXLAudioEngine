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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // AVURLAsset是一个资源的抽象类，由此可以分离出资源的音频和视频
    NSURL * url = [[NSBundle mainBundle]URLForResource:@"frozen" withExtension:@"m4a"];
    NSURL * bgUrl = [[NSBundle mainBundle]URLForResource:@"video" withExtension:@"mov"];
    
    AVURLAsset * audioAsset = [[AVURLAsset alloc]initWithURL:url options:nil];
    AVURLAsset * videoAsset = [[AVURLAsset alloc]initWithURL:bgUrl options:nil];
    
    // AVMutableComposition顾名思义是一个用来接收不同轨道的类，无论是音频还是视频
    AVMutableComposition * mixComposition = [AVMutableComposition composition];
    
    
    // 合成
    AVMutableCompositionTrack *backgroundTrack =
    [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                preferredTrackID:kCMPersistentTrackID_Invalid];
    NSArray *audioTracks = [audioAsset tracksWithMediaType:AVMediaTypeAudio];
    [backgroundTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
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
    AVAssetExportSession * exportSession = [AVAssetExportSession exportSessionWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString * filePath = [path stringByAppendingPathComponent:@"story.mov"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSError * error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            return;
        }
    }
    
    for (NSString *supportFileType in exportSession.supportedFileTypes) {
        NSLog(@"%@",supportFileType);
    }
    
    // AVFileTypeAppleM4A AVFileTypeMPEG4 .mp4
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    NSLog(@"file type %@",exportSession.outputFileType);
    exportSession.outputURL = [NSURL fileURLWithPath:filePath];
    exportSession.shouldOptimizeForNetworkUse = YES;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         // your completion code here
         NSLog(@"%@",exportSession.outputURL);
         [self playWithUrl:exportSession.outputURL];
     }
     ];
}
- (IBAction)beginRecorder:(id)sender {
}

- (void)playWithUrl:(NSURL *)url{
//    NSData * data = [NSData dataWithContentsOfURL:url];
//    AVAudioPlayer * player = [[AVAudioPlayer alloc]initWithData:data error:nil];
//    [player prepareToPlay];
//    [player play];
    // 传入地址
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    // 播放器
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    // 播放器layer
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.imageView.frame;
    // 视频填充模式
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    // 添加到imageview的layer上
    [self.imageView.layer addSublayer:playerLayer];
    // 播放
    [player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

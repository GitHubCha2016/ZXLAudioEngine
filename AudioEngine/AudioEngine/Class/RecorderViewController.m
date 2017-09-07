//
//  RecorderViewController.m
//  AudioEngine
//
//  Created by Apple on 2017/8/31.
//  Copyright © 2017年 dandan. All rights reserved.
//

#import "RecorderViewController.h"
#import "AudioEngineManager.h"
#import "AnimationView.h"
#import "AudioTableView.h"
#import "AVEngine.h"


@interface RecorderViewController ()

@property (weak, nonatomic) IBOutlet UIButton *recorderButton;
@property (weak, nonatomic) IBOutlet UILabel *recorderTime;
/** AEAudioController */
@property (nonatomic, strong) AudioEngineManager * audioEngine;
/** 是否开始录音 */
@property (nonatomic, assign) BOOL isRecording;

// 音量
@property (weak, nonatomic) IBOutlet AnimationView *audioVolumeView;
// 所有音量
@property (weak, nonatomic) IBOutlet AudioTableView *audioTableView;

/** filePath1 */
@property (nonatomic, strong) NSString * filePath;
/** filePath2 */
@property (nonatomic, strong) NSString * filePath2;
/** 合成filePath */
@property (nonatomic, strong) NSString * compositionPath;
/** 剪辑filePath */
@property (nonatomic, strong) NSString * clipPath;
/** 是否剪辑 */
@property (nonatomic, assign) BOOL isNeedClip;
/** 是否已经合成 YES 需要合成 */
@property (nonatomic, assign) BOOL isComposition;
/** 录音时间 */
@property (nonatomic, strong) NSTimer * timer;

/** 当前录音时间 */
@property (nonatomic, assign) NSTimeInterval currentAudioTime;
/** 播放音频的截至时间 */
@property (nonatomic, assign) NSTimeInterval endAudioTime;

/** AVEngine*/
@property (nonatomic, strong) AVEngine * engine;
@property (weak, nonatomic) IBOutlet UIProgressView *audioPowerProgress;

/** 录音时间 */
@property (nonatomic, strong) AVMutableComposition * composition;



@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.audioEngine = [AudioEngineManager share];
    self.engine = [[AVEngine alloc]init];
    self.isRecording = NO;
    self.isNeedClip = NO;
    self.isComposition = NO;
    self.currentAudioTime = -1;
    [self getAudioFilePath];
    
    // 计时器
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        weakSelf.recorderTime.text = [NSString stringWithFormat:@"%.f",weakSelf.audioEngine.recorder.currentTime];
    }];
    
    // 显示音量
    self.audioEngine.AudioPowerChangeBlock = ^(CGFloat inputAvg, CGFloat inputPeak) {
        // 基准 -160 —— 0
        [weakSelf powerChange:inputAvg andInputPeak:inputPeak];
    };
}



- (IBAction)recorderAudio:(id)sender {
    
    [self beginRecorder];
}

// 播放背景 音乐
- (IBAction)playAction:(id)sender {
    if (self.engine.audioPalyer.isPlaying) {
        // 截一段 音频
        self.endAudioTime = self.engine.audioPalyer.currentTime;
        [self.engine.audioPalyer stop];
    }else{
        [self playBGFile];
        // 记住开始播的时间
    }
    
}

// 结束一段录音 保存 把所有录音合成一段录音
- (IBAction)finishAction:(id)sender {
    
    
}

// 剪辑
- (IBAction)clipAudioAction:(id)sender {
    
    self.isNeedClip = YES;
    // 每次剪辑前先合成
    [self compostionAduios];
}

// 先结束再 播放这段录音
- (IBAction)shitingAction:(id)sender {
    
    [self finishRecorder];
    
    // 合成 这是一个异步操作
    [self compostionAduios];
}

- (void)beginRecorder{
    // 按钮改变
    if (self.isRecording) {
        [self.recorderButton setTitle:@"继续录音" forState:UIControlStateNormal];
        
        [self stopRecorder];
    }else{
        [self.recorderButton setTitle:@"暂停录音" forState:UIControlStateNormal];
        
        // 录音
        self.isComposition = YES;
        [self.audioEngine recorderWithFilePath:[self getAudioFilePath]];
        self.currentAudioTime = self.audioEngine.recorder.currentTime;
    }
    self.isRecording = !self.isRecording;
}

- (void)stopRecorder{
    // 暂停音乐播放
    [self.engine.audioPalyer stop];
    // 暂停录音
    [self.audioEngine finishRecorder];
    // 如果有两个文件 把两个文件合成
    [self compostionAduios];
}

- (void)finishRecorder{
    // 暂停音乐播放
    [self.engine.audioPalyer stop];
    [self.audioEngine finishRecorder];
}

- (void)playRecorderFile:(NSString *)path{
    [self.audioEngine playWithUrl:path];
    
    
    customLog(@"%@",path);
}

- (void)playBGFile{
    NSString * url = [[NSBundle mainBundle]pathForResource:@"吴亦凡-时间煮雨" ofType:@"mp3"];
    
    __weak typeof(self) weakSelf = self;
    self.engine.PlayResultBlock = ^(BOOL result) {
        if (result && !self.isRecording) {
            // 播放背景音乐  开启录音
            [weakSelf beginRecorder];
        }
        else{
            customLog(@"播放文件错误");
        }
    };
    [self.engine playWithUrlString:url];
    
    customLog(@"%@",url);
}

- (NSString *)compositionPath{
    if (!_compositionPath) {
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString * filePath = [path stringByAppendingPathComponent:@"composition.m4a"];
        _compositionPath = filePath;
    }
    return _compositionPath;
}

- (NSString *)clipPath{
    if (!_clipPath) {
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString * filePath = [path stringByAppendingPathComponent:@"clip.m4a"];
        _clipPath = filePath;
    }
    return _clipPath;
}

- (void)compostionAduios{
    if (!self.isComposition) {
        customLog(@"不需要合成");
        [self compositionSuccess];
        return;
    }
    //AVMutableComposition用来合成视频或音频
    AVMutableComposition *composition = [AVMutableComposition composition];
    //self.composition = composition;
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    if (![self isFileExistsAtPath:self.filePath] && ![self isFileExistsAtPath:self.filePath2]) {
        customLog(@"没有录音");
        return;
    }
    else if ([self isFileExistsAtPath:self.filePath] && ![self isFileExistsAtPath:self.filePath2]){
        // 有一个录音
        
        AVURLAsset *videoAsset1 = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:self.filePath] options:nil];
        AVAssetTrack *assetTrack1 = [[videoAsset1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset1.duration) ofTrack:assetTrack1 atTime:kCMTimeZero error:nil];
        [self exportAudioWithComposition:composition];
    }
    else if ([self isFileExistsAtPath:self.filePath] && [self isFileExistsAtPath:self.filePath2]){
        if ([self isFileExistsAtPath:self.compositionPath]) {
            // 使用已经合成的音频
        }
        //AVURLAsset子类的作用则是根据NSURL来初始化AVAsset对象.
        AVURLAsset *videoAsset1 = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:self.filePath] options:nil];
        AVURLAsset *videoAsset2 = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:self.filePath2] options:nil];
        //音频轨迹(一般视频至少有2个轨道,一个播放声音,一个播放画面.音频有一个)
        AVAssetTrack *assetTrack1 = [[videoAsset1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        AVAssetTrack *assetTrack2 = [[videoAsset2 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        
        // 把第二段录音添加到第一段后面
        [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset1.duration) ofTrack:assetTrack1 atTime:kCMTimeZero error:nil];
        [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset2.duration) ofTrack:assetTrack2 atTime:videoAsset1.duration error:nil];
        //[compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset2.duration) ofTrack:assetTrack2 atTime:CMTimeAdd(videoAsset1.duration, videoAsset2.duration) error:nil];
        [self exportAudioWithComposition:composition];
    }
    else{
        customLog(@"文件路径选错了");
    }

}

- (void)exportAudioWithComposition:(AVMutableComposition *)composition{
    //输出
    AVAssetExportSession *exporeSession = [AVAssetExportSession exportSessionWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    exporeSession.outputFileType = AVFileTypeAppleM4A;
    exporeSession.outputURL = [NSURL fileURLWithPath:self.compositionPath];
    [exporeSession exportAsynchronouslyWithCompletionHandler:^{
        //exporeSession.status
        customLog(@"合成完成");
        [self removeFileAtPath:self.filePath];
        [self moveFileFromPath:self.compositionPath toPath:self.filePath];
        // 合成完成后开始播放
        [self compositionSuccess];
        //dispatch_async(dispatch_get_main_queue(), ^{
        
        //});
        
    }];
}

- (void)compositionSuccess{
    // 是否是剪辑操作
    self.isComposition = NO;
    if (self.isNeedClip) {
        [self clipAudio];
    }else{
        [self playRecorderFile:self.filePath];
        if ([[NSFileManager defaultManager]fileExistsAtPath:self.filePath]) {
            customLog(@"路径下有文件");
        }
    }
}

- (void)clipAudio{
    
    
    //AVURLAsset是AVAsset的子类,AVAsset类专门用于获取多媒体的相关信息,包括获取多媒体的画面、声音等信息.而AVURLAsset子类的作用则是根据NSURL来初始化AVAsset对象.
    AVURLAsset *audioAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:self.clipPath]];
    //音频输出会话
    //AVAssetExportPresetAppleM4A: This export option will produce an audio-only .m4a file with appropriate iTunes gapless playback data(输出音频,并且是.m4a格式)
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:audioAsset presetName:AVAssetExportPresetAppleM4A];
    //设置输出路径 / 文件类型 / 截取时间段
    exportSession.outputURL = [NSURL fileURLWithPath:self.clipPath];
    exportSession.outputFileType = AVFileTypeAppleM4A;
    exportSession.timeRange = CMTimeRangeFromTimeToTime(kCMTimeZero, CMTimeMake(3, 1));
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        //exporeSession.status
        if ([self isFileExistsAtPath:self.clipPath]) {
            customLog(@"剪辑成功");
        }
        self.isNeedClip = NO;
        [self removeFileAtPath:self.filePath];
        [self moveFileFromPath:self.clipPath toPath:self.filePath];
        
        [self playRecorderFile:self.filePath];
        if ([[NSFileManager defaultManager]fileExistsAtPath:self.filePath]) {
            // 移除存在文件
            customLog(@"路径下有文件");
        }
        
    }];
}


- (NSString *)getAudioFilePath{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString * filePath = [path stringByAppendingPathComponent:@"filePath.m4a"];
    self.filePath2 = [path stringByAppendingPathComponent:@"filePath2.m4a"];
    self.filePath = filePath;
    if (![[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        customLog(@"获取录音 --- %@",filePath);
        return filePath;
    }else{
        customLog(@"获取录音 --- %@",self.filePath2);
        return self.filePath2;
    }
    
    
}

- (void)powerChange:(CGFloat)inputAvg andInputPeak:(CGFloat)inputPeak{
    // 平均值和峰值
    //customLog(@"平均值 - %f 峰值 - %f",inputAvg,inputPeak);
    inputAvg += 40;
    self.audioPowerProgress.progress = (inputAvg) / 40;
    
    
    //customLog(@" ---- %f",(inputAvg + 10) / 40);
    CGFloat num = (inputAvg) / 40;
    if (num >= 0) {
        self.audioVolumeView.volume = num;
    }
    
}

- (BOOL)isFileExistsAtPath:(NSString *)path{
    return [[NSFileManager defaultManager]fileExistsAtPath:path];
}

- (BOOL)removeFileAtPath:(NSString *)path {
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        // 移除存在文件
        return [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
    }
    return YES;
}
- (BOOL)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath{
    NSError * error = nil;
    [[NSFileManager defaultManager]moveItemAtURL:[NSURL fileURLWithPath:fromPath] toURL:[NSURL fileURLWithPath:toPath] error:&error];
    if (error) {
        customLog(@"移动文件出错");
        return NO;
    }
    return YES;
}


@end

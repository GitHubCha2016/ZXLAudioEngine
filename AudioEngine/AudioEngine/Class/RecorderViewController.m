//
//  RecorderViewController.m
//  AudioEngine
//
//  Created by Apple on 2017/8/31.
//  Copyright © 2017年 dandan. All rights reserved.
//

#import "RecorderViewController.h"
#import "AudioEngineManager.h"
#import "AVEngine.h"

@interface RecorderViewController ()

@property (weak, nonatomic) IBOutlet UIButton *recorderButton;
@property (weak, nonatomic) IBOutlet UILabel *recorderTime;
/** AEAudioController */
@property (nonatomic, strong) AudioEngineManager * audioEngine;
/** 是否开始录音 */
@property (nonatomic, assign) BOOL isRecording;


/** filePath */
@property (nonatomic, strong) NSString * filePath;

/** 录音时间 */
@property (nonatomic, strong) NSTimer * timer;

/** AVEngine*/
@property (nonatomic, strong) AVEngine * engine;
@property (weak, nonatomic) IBOutlet UIProgressView *audioPowerProgress;

@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.audioEngine = [AudioEngineManager share];
    self.engine = [[AVEngine alloc]init];
    self.isRecording = NO;
    
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
    
    if (self.isRecording) {
        [self.recorderButton setTitle:@"开始录音" forState:UIControlStateNormal];
        
        [self stopRecorder];
    }else{
        [self.recorderButton setTitle:@"暂停录音" forState:UIControlStateNormal];
        [self beginRecorder];
    }
    self.isRecording = !self.isRecording;
    
}
- (IBAction)playAction:(id)sender {
    
    [self playBGFile];
}
- (IBAction)finishAction:(id)sender {
    
    [self finishRecorder];
}
- (IBAction)shitingAction:(id)sender {
    
    [self playRecorderFile];
}

- (void)beginRecorder{
    [self.audioEngine recorderWithFilePath:self.filePath];
}

- (void)stopRecorder{
    [self.audioEngine stopRecorder];
}

- (void)finishRecorder{
    [self.audioEngine finishRecorder];
    
//    self.audioEngine.player
}

- (void)playRecorderFile{
    NSString * url = [[NSBundle mainBundle]pathForResource:@"Recording" ofType:@"m4a"];
    [self.audioEngine playWithUrl:self.filePath];
    
    //[self.engine playWithUrlString:url];
    
    customLog(@"%@",url);
}

- (void)playBGFile{
    NSString * url = [[NSBundle mainBundle]pathForResource:@"吴亦凡-时间煮雨" ofType:@"mp3"];
    
    [self.engine playWithUrlString:url];
    
    customLog(@"%@",url);
}

- (NSString *)filePath{
    if (!_filePath) {
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString * filePath = [path stringByAppendingPathComponent:@"Recording.m4a"];
        _filePath = filePath;
    }
    return _filePath;
}

- (void)powerChange:(CGFloat)inputAvg andInputPeak:(CGFloat)inputPeak{
    // 平均值和峰值
    customLog(@"平均值 - %f 峰值 - %f",inputAvg,inputPeak);
    self.audioPowerProgress.progress = (inputAvg + 40) / 20;
    inputAvg += 40;
}

@end

//
//  RecorderViewController.m
//  AudioEngine
//
//  Created by Apple on 2017/8/31.
//  Copyright © 2017年 dandan. All rights reserved.
//

#import "RecorderViewController.h"
#import "AudioEngineManager.h"

@interface RecorderViewController ()

@property (weak, nonatomic) IBOutlet UIButton *recorderButton;
/** AEAudioController */
@property (nonatomic, strong) AudioEngineManager * audioEngine;



/** filePath */
@property (nonatomic, strong) NSString * filePath;

@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.audioEngine = [AudioEngineManager share];
}
- (IBAction)recorderAudio:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        [self.recorderButton setTitle:@"开始录音" forState:UIControlStateNormal];
        
        [self stopRecorder];
    }else{
        [self.recorderButton setTitle:@"结束录音" forState:UIControlStateSelected];
        [self beginRecorder];
    }
    btn.selected = !btn.selected;
    
}
- (IBAction)playAction:(id)sender {
    
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
}

- (void)playRecorderFile{
    NSString * url = [[NSBundle mainBundle]pathForResource:@"fun" ofType:@"m4a"];
    AudioEngineManager * manager = [[AudioEngineManager alloc]init];
    [manager playWithUrl:url];
    
    customLog(@"%@",self.filePath);
}

- (NSString *)filePath{
    if (!_filePath) {
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString * filePath = [path stringByAppendingPathComponent:@"Recording.m4a"];
        _filePath = filePath;
    }
    return _filePath;
}

@end

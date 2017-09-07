//
//  AudioTableViewCell.m
//  AudioEngine
//
//  Created by Apple on 2017/9/4.
//  Copyright © 2017年 dandan. All rights reserved.
//

#import "AudioTableViewCell.h"

@interface AudioTableViewCell ()

/** 声音音量 */
@property (nonatomic, strong) UIView * volumeView;

@end

@implementation AudioTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        //self.contentView.backgroundColor = [UIColor grayColor];
        
        //
        _volumeView = [[UIView alloc]initWithFrame:CGRectZero];
        _volumeView.backgroundColor = [UIColor blackColor];
        _volumeView.alpha = 0.6;
        [self.contentView addSubview:self.volumeView];
        
    }
    return self;
}

- (void)layoutSubviews{
    [self updateConstraints];
    
    // 设置frame
    CGFloat X = self.volume * self.frame.size.width;
    _volumeView.frame = CGRectMake(0, 0, X, self.frame.size.height);
}

- (void)setVolume:(CGFloat)volume{
    // 设置  0 - 1之间
    _volume = volume < 0 ? 0 : volume;
    _volume = volume > 1 ? 1 : volume;
    
    //CGFloat X = self.volume * self.frame.size.width;
    //_volumeView.frame = CGRectMake(0, 0, X, self.frame.size.height);
}

@end

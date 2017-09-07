//
//  AnimationView.m
//  AudioEngine
//
//  Created by Apple on 2017/9/4.
//  Copyright © 2017年 dandan. All rights reserved.
//

#import "AnimationView.h"

@interface AnimationView ()

/** 计时器 */
@property (nonatomic, strong) CADisplayLink * displayLink;

/** 计时器 */
@property (nonatomic, strong) CALayer * subLayer;

@end

@implementation AnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(volumeChange)];
        self.displayLink.paused = NO;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        self.subLayer = [CALayer layer];
        self.subLayer.backgroundColor = [UIColor blueColor].CGColor;
        self.subLayer.opacity = 0.8;
        self.subLayer.frame = CGRectMake(0, 0, 50, self.frame.size.height);
        [self.layer addSublayer:self.subLayer];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.subLayer = [CALayer layer];
    self.subLayer.backgroundColor = [UIColor blueColor].CGColor;
    self.subLayer.opacity = 0.8;
    self.subLayer.frame = CGRectMake(0, 0, 50, self.frame.size.height);
    [self.layer addSublayer:self.subLayer];
    
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(volumeChange)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0,1};
    NSArray *colors = @[(id)[UIColor redColor].CGColor,
                        (id)[UIColor greenColor].CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint startPoint = (CGPoint){self.frame.size.width * 0, self.frame.size.height * 1};
    CGPoint endPoint = (CGPoint){self.frame.size.width * 1, self.frame.size.height * 1};
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGGradientRelease(gradient);
    UIGraphicsPopContext();
}

- (void)setVolume:(CGFloat)volume{
    // 设置  0 - 1之间
    _volume = volume < 0 ? 0 : volume;
    _volume = volume > 1 ? 1 : volume;
}

- (void)volumeChange{
    CGFloat X = self.volume * self.frame.size.width;
    CGFloat W = self.frame.size.width - X;
    self.subLayer.frame = CGRectMake(X, 0, W, self.frame.size.height);
}


@end

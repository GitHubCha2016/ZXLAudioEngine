//
//  AudioTableView.m
//  AudioEngine
//
//  Created by Apple on 2017/9/4.
//  Copyright © 2017年 dandan. All rights reserved.
//

#import "AudioTableView.h"
#import "AudioTableViewCell.h"

static NSString * cellID = @"cellID";

@interface AudioTableView ()<UITableViewDataSource,UITableViewDelegate>

/** tableView */
@property (nonatomic, strong) UITableView * tableView;



@end

@implementation AudioTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat H = self.frame.size.height;
        CGFloat W = self.frame.size.width;
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(-(H - W)* 0.5, -H - 8, H, W)];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [self.tableView registerClass:[AudioTableViewCell class] forCellReuseIdentifier:cellID];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 5;
        self.tableView.allowsSelection = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.userInteractionEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    CGFloat H = self.frame.size.height;
    CGFloat W = self.frame.size.width;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(-(H - W)* 0.5, -H - 8, H, W)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self.tableView registerClass:[AudioTableViewCell class] forCellReuseIdentifier:cellID];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 5;
    self.tableView.allowsSelection = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.userInteractionEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    self.dataSource = [NSMutableArray array];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
//        [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            CGPoint point = self.tableView.contentOffset;
//            point.y += 5;
//            [self.tableView setContentOffset:point animated:YES];
//        }];
    }
    return self;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AudioTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    float volume = (float)(1+arc4random()%99)/100;
    cell.volume = volume;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}


@end

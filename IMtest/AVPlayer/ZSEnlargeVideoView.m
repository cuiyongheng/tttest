//
//  ZSEnlargeVideoView.m
//  VideoTest
//
//  Created by 牧仁者 on 2017/3/13.
//  Copyright © 2017年 牧仁者. All rights reserved.
//

#import "ZSEnlargeVideoView.h"

@interface ZSEnlargeVideoView ()
@property (nonatomic ,strong ,readwrite) UIProgressView *progressView;
@property (nonatomic ,strong ,readwrite) UIButton *controlButton;
@property (nonatomic ,strong ,readwrite) UIView *bottomView;
@property (nonatomic ,strong ,readwrite) UISlider *sliderView;
@property (nonatomic ,strong ,readwrite) UILabel *currentTimeLabel;
@property (nonatomic ,strong ,readwrite) UILabel *endTimeLabel;
@property (nonatomic ,strong ,readwrite) UIButton *reduceButton;

@property (nonatomic ,strong ,readwrite) UIView *topView;
@property (nonatomic ,strong ,readwrite) UIButton *backButton;
@property (nonatomic ,strong ,readwrite) UILabel *titleLabel;

@property (nonatomic ,strong ,readwrite) UILabel *systemTimeLabel;

@property (nonatomic ,assign ,readwrite) BOOL statusBarHidden;
@end

@implementation ZSEnlargeVideoView

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        [_topView addSubview:self.backButton];
        [_topView addSubview:self.titleLabel];
        _topView.backgroundColor = UICOLOR(0, 0, 0, 0.3);
        [self addSubview:_topView];
    }
    return _topView;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, UNITWIDTH * 60, 44);
        [_backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30 * UNITWIDTH, 0, 0);
        [_backButton addTarget:self action:@selector(reduceVideo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.backButton.frame), 0, HEIGHT - CGRectGetMaxX(self.backButton.frame), 44)];
        _titleLabel.font = font(15);
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

//- (UILabel *)systemTimeLabel{
//    if (!_systemTimeLabel) {
//        _systemTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake((HEIGHT - 100 * UNITWIDTH)*0.5, 0, 100 * UNITWIDTH, 44)];
//        [UIDevice currentDevice]
//    }
//    return _systemTimeLabel;
//}

- (UIButton *)controlButton{
    if (!_controlButton) {
        _controlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_controlButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        [_controlButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateSelected];
        [_controlButton addTarget:self action:@selector(controlPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_controlButton];
    }
    return _controlButton;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView.progress = 0.0;
        _progressView.progressTintColor = [UIColor blackColor];
        _progressView.trackTintColor = UICOLOR(194, 194, 194, 1);
        [self addSubview:_progressView];
    }
    return _progressView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        [_bottomView addSubview:self.currentTimeLabel];
        [_bottomView addSubview:self.sliderView];
        [_bottomView addSubview:self.endTimeLabel];
        [_bottomView addSubview:self.reduceButton];
        _bottomView.backgroundColor = UICOLOR(0, 0, 0, 0.3);
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

- (UILabel *)currentTimeLabel{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc]init];
        _currentTimeLabel.textColor = UICOLOR(194, 194, 194, 1);
        _currentTimeLabel.font = font(17);
        _currentTimeLabel.text = @"00:00";
        _currentTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _currentTimeLabel;
}

- (UISlider *)sliderView{
    if (!_sliderView) {
        _sliderView = [[UISlider alloc]init];
        _sliderView.minimumTrackTintColor = [UIColor blackColor];
        _sliderView.maximumTrackTintColor = UICOLOR(194, 194, 194, 1);
        _sliderView.minimumValue = 0;
        _sliderView.maximumValue = 1.0;
        
        [_sliderView addTarget:self action:@selector(sliderValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _sliderView;
}

- (UILabel *)endTimeLabel{
    if (!_endTimeLabel) {
        _endTimeLabel = [[UILabel alloc]init];
        _endTimeLabel.textColor = UICOLOR(194, 194, 194, 1);
        _endTimeLabel.font = font(17);
        _endTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _endTimeLabel;
}

- (UIButton *)reduceButton{
    if (!_reduceButton) {
        _reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reduceButton setBackgroundImage:[UIImage imageNamed:@"缩小"] forState:UIControlStateNormal];
        ;
        [_reduceButton addTarget:self action:@selector(reduceVideo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceButton;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.controlButton.frame = CGRectMake((self.frame.size.width - 72)*0.5, (self.frame.size.height - 72)*0.5, 72, 72);
    self.progressView.frame = CGRectMake(0, HEIGHT - 4, WIDTH, 3);
    
    self.bottomView.frame = CGRectMake(0, HEIGHT-50, WIDTH, 50);
    _currentTimeLabel.frame = CGRectMake(0, (self.bottomView.frame.size.height - 12) * 0.5, 50, 12);
    _sliderView.frame = CGRectMake(CGRectGetMaxX(self.currentTimeLabel.frame) + 10, (self.bottomView.frame.size.height -  12) * 0.5, WIDTH - 180,  12);
    _endTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.sliderView.frame) + 10, (self.bottomView.frame.size.height - 12) * 0.5, 50, 12);
    _reduceButton.frame = CGRectMake(CGRectGetMaxX(self.endTimeLabel.frame) + 5, (self.bottomView.frame.size.height - 30) * 0.5, 30, 30);
    self.topView.frame = CGRectMake(0, 0, WIDTH, 44);
}

- (void)reduceVideo:(UIButton *)sender{
    // 全屏
    if ([self.delegate respondsToSelector:@selector(reduceVideo)]) {
        [self.delegate reduceVideo];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_playStatus == 1 || _playStatus == 3) {
        
        if (!_controlButton.hidden) {
            return ;
        }
        _progressView.hidden = YES;
        _controlButton.hidden = NO;
        _bottomView.hidden = NO;
        _topView.hidden = NO;
        _statusBarHidden = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ((_playStatus == 1 || _playStatus == 3)) {
                _controlButton.hidden = YES;
                _progressView.hidden = NO;
                _bottomView.hidden = YES;
                _topView.hidden = YES;
                _statusBarHidden = YES;
            }
        });
    }
}

- (void)controlPlayOrPause:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(playOrPause:)]) {
        [self.delegate playOrPause:sender];
    }
    
}

- (void)sliderValue:(UISlider *)slider{
    
    if ([self.delegate respondsToSelector:@selector(slider:)]) {
        [self.delegate slider:slider];
    }
}

@end

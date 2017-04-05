//
//  ZSVideoManager.m
//  JadeKing
//
//  Created by 牧仁者 on 2017/3/3.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "ZSVideoManager.h"
#import "ZSViewController.h"
#import "AppDelegate.h"

@interface ZSVideoManager ()<ZSEnlargeVideoViewDelegate>

@property (nonatomic ,strong ,readwrite) UIProgressView *progressView;
@property (nonatomic ,strong ,readwrite) UIButton *controlButton;
@property (nonatomic ,strong ,readwrite) UIView *bottomView;
@property (nonatomic ,strong ,readwrite) UISlider *sliderView;
@property (nonatomic ,strong ,readwrite) UILabel *currentTimeLabel;
@property (nonatomic ,strong ,readwrite) UILabel *endTimeLabel;
@property (nonatomic ,strong ,readwrite) UIButton *enlargeButton;

@property (nonatomic ,strong) ZSEnlargeVideoView *bigVideoView;
@property (nonatomic ,strong) ZSViewController *controller;

@property (nonatomic ,strong) UIImageView *imageView;

@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic ,strong) AVPlayerLayer *playerLayer;
@property (nonatomic ,strong) AVPlayerItem *playerItem;

@property (nonatomic ,strong) id timeObser;
@property (nonatomic ,assign) float videoLength;
@property (nonatomic ,assign) videoType videoType;
@property (nonatomic ,assign) videoStatus videoStatus;
//@property (nonatomic ,assign) playStatus playStatus;
@property (nonatomic ,assign) float currentTimeValue;
@end

@implementation ZSVideoManager
- (ZSEnlargeVideoView *)bigVideoView{
    if (!_bigVideoView) {
        _bigVideoView = [[ZSEnlargeVideoView alloc]initWithFrame:CGRectMake(0, 0, HEIGHT, WIDTH)];
        _bigVideoView.delegate = self;
        
    }
    return _bigVideoView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView.clipsToBounds = YES;
        [self insertSubview:_imageView atIndex:0];
    }
    return _imageView;
}

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
        _bottomView.hidden = YES;
        _bottomView.backgroundColor = UICOLOR(0, 0, 0, 0.3);
        [self addSubview:_bottomView];
        [_bottomView addSubview:self.currentTimeLabel];
        [_bottomView addSubview:self.sliderView];
        [_bottomView addSubview:self.endTimeLabel];
        [_bottomView addSubview:self.enlargeButton];
    }
    return _bottomView;
}

- (UILabel *)currentTimeLabel{
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc]init];
        _currentTimeLabel.textColor = UICOLOR(194, 194, 194, 1);
        _currentTimeLabel.font = font(12);
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
        _endTimeLabel.font = font(12);
        _endTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _endTimeLabel;
}

- (UIButton *)enlargeButton{
    if (!_enlargeButton) {
        _enlargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enlargeButton setBackgroundImage:[UIImage imageNamed:@"全屏"] forState:UIControlStateNormal];
        [_enlargeButton addTarget:self action:@selector(enlargeVideo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enlargeButton;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.controlButton.frame = CGRectMake((self.frame.size.width - UNITWIDTH * 72)*0.5, (self.frame.size.height - UNITWIDTH * 72)*0.5, UNITWIDTH * 72, UNITWIDTH * 72);
    self.progressView.frame = CGRectMake(0, self.frame.size.height - 2, self.frame.size.width, 2);
    self.bottomView.frame = CGRectMake(UNITWIDTH * 10, (self.frame.size.height - UNITHEIGHT * 30), UNITWIDTH * 345, UNITHEIGHT * 30);
    self.currentTimeLabel.frame = CGRectMake(0, (self.bottomView.frame.size.height - UNITHEIGHT * 12) * 0.5, UNITWIDTH * 50, UNITHEIGHT * 12);
    
    CGFloat sliderViewWidth = UNITWIDTH * 180;
    CGFloat enlargeButtonSize = UNITWIDTH * 20;
    
    if (self.enlargeButton.hidden) {
        sliderViewWidth = UNITWIDTH * 210;
        enlargeButtonSize = 0;
    }
    
    self.sliderView.frame = CGRectMake(CGRectGetMaxX(self.currentTimeLabel.frame) + UNITWIDTH * 10, (self.bottomView.frame.size.height - UNITHEIGHT * 30) * 0.5, sliderViewWidth, UNITHEIGHT * 30);
    
    self.endTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.sliderView.frame) + UNITWIDTH * 10, (self.bottomView.frame.size.height - UNITHEIGHT * 12) * 0.5, UNITWIDTH * 50, UNITHEIGHT * 12);
    self.enlargeButton.frame = CGRectMake(CGRectGetMaxX(self.endTimeLabel.frame) + UNITWIDTH * 5, (self.bottomView.frame.size.height - UNITWIDTH * 20) * 0.5, enlargeButtonSize, enlargeButtonSize);
}

#pragma mark event

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_playStatus == 1 || _playStatus == 3) {
        
        if (!_controlButton.hidden) {
            return ;
        }
        
        _progressView.hidden = YES;
        _controlButton.hidden = NO;
        _bottomView.hidden = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ((_playStatus == 1 || _playStatus == 3)) {
                _controlButton.hidden = YES;
                _progressView.hidden = NO;
                _bottomView.hidden = YES;
            }
        });
    }
}

- (void)controlPlayOrPause:(UIButton *)sender{
    
    switch (_playStatus) {
        case 0:{
            [self play];
        }
            break;
        case 1:{
            [self pasue];
        }
            break;
        case 2:{
            [self play];
        }
            break;
        case 3:{
            [self pasue];
        }
            break;
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(playOrPauseCurrentVideo:indexRow:)]) {
        [self.delegate playOrPauseCurrentVideo:self indexRow:sender.tag];
    }
}

- (void)sliderValue:(UISlider *)slider{
    [self pasue];
    _playStatus = playStatusPause;
    _bigVideoView.playStatus = _playStatus;
    [self seekToTime:slider.value * [self videoTimeLengthValue]];
}

- (void)getStringFromCurrentCMTime:(NSString *)currentTime valueFromCurrentCMTime:(float)value{
    
    _currentTimeLabel.text = currentTime;
    _progressView.progress = value;
    _sliderView.value = value;
    
    _bigVideoView.currentTimeLabel.text = currentTime;
    _bigVideoView.progressView.progress = value;
    _bigVideoView.sliderView.value = value;
    
    _endTimeLabel.text = [self videoTimeLength];
    _bigVideoView.endTimeLabel.text = [self videoTimeLength];
}

- (void)enlargeVideo:(UIButton *)sender{
    // 全屏
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.bigVideoView.frame = CGRectMake(0, 0, HEIGHT, WIDTH);
    _playerLayer.frame = _bigVideoView.bounds;
    [_bigVideoView.layer insertSublayer:_playerLayer atIndex:0];
    _bigVideoView.playStatus = _playStatus;
    _bigVideoView.titleLabel.text = _title;
    [delegate.window addSubview:_bigVideoView];
    _controller = [[ZSViewController alloc]init];
    //    [_bigVideoView addObserver:_controller forKeyPath:statusBarHidden options:NSKeyValueObservingOptionNew context:nil];
    __weak typeof (self)weak_self = self;
    [[UIApplication sharedApplication].keyWindow.rootViewController
     presentViewController:_controller animated:NO completion:^{
         [weak_self play];
     }];
}

#pragma mark ---- delegate

- (void)reduceVideo{
    __weak typeof (self)weak_self = self;
    
    CGRect rect = [[self superview] convertRect:self.frame toView:_bigVideoView];
    _bigVideoView.frame = rect;
    
    _playerLayer.frame = _bigVideoView.bounds;

    [_controller dismissViewControllerAnimated:NO completion:^{

        [weak_self.layer insertSublayer:weak_self.playerLayer atIndex:0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weak_self.bigVideoView removeFromSuperview];
        });
    }];
    
    
}

- (void)playOrPause:(UIButton *)sender{
    [self controlPlayOrPause:sender];
}

- (void)slider:(UISlider *)slider{
    [self sliderValue:slider];
}

#pragma mark ------ customer

- (void)setImageUrl:(NSString *)imageUrl{
    
    if (_imageUrl != imageUrl) {
        _imageUrl = imageUrl;
        
        [self.imageView sd_setImageWithURL:NSSTRINGTOURL(imageUrl) placeholderImage:PLACEHOLDERVIDEOIMAGE];
    }
}

- (void)beginPlay{
    //    @"https://sslydjimg.jaadee.com/uploads/videos/2016/06/5760eecccef.mp4"
    [self stopPlay];
    _playStatus = playStatusPlay;
    _bigVideoView.playStatus = _playStatus;
    
    NSURL *playerUrl = [NSURL URLWithString:_videoUrl];
    _playerItem = [AVPlayerItem playerItemWithURL:playerUrl];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _playerLayer.frame = self.bounds;
    [self.layer insertSublayer:_playerLayer atIndex:0];
    
    [self addVideoKVO];
    [self addVideoTimerObserver];
    [self addVideoNotic];
}

- (void)stopPlay{
    
    [_player pause];
    
    @autoreleasepool {
        [self removeVideoKVO];
        [self removeVideoNotic];
        [self removeVideoTimerObserver];
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
        _player = nil;
        _playerItem = nil;
    }
    
    _videoType = videoDefualt;
    _playStatus = playStatusStop;
    _bigVideoView.playStatus = _playStatus;
    
    _imageView.hidden = NO;
    _progressView.progress = 0;
    _sliderView.value = 0;
    _controlButton.selected = NO;
    _progressView.hidden = NO;
    _controlButton.hidden = NO;
    _bottomView.hidden = YES;
    
    _bigVideoView.progressView.progress = 0;
    _bigVideoView.sliderView.value = 0;
    _bigVideoView.controlButton.selected = NO;
    _bigVideoView.progressView.hidden = NO;
    _bigVideoView.controlButton.hidden = NO;
    _bigVideoView.bottomView.hidden = YES;
    _bigVideoView.topView.hidden = YES;
}

- (void)replays{
    [_player seekToTime:kCMTimeZero];
}

- (void)reload{
    //    [self beginPlay:<#(NSString *)#>]
}

- (void)pasue{
    
    if (_playStatus == playStatusPlay) {
        _playStatus = playStatusPause;
        _bigVideoView.playStatus = _playStatus;
        [_player pause];
        
        _controlButton.selected = NO;
        _progressView.hidden = YES;
        _controlButton.hidden = NO;
        _bottomView.hidden = NO;
        
        _bigVideoView.controlButton.selected = NO;
        _bigVideoView.progressView.hidden = YES;
        _bigVideoView.controlButton.hidden = NO;
        _bigVideoView.bottomView.hidden = NO;
        _bigVideoView.topView.hidden = NO;
    }
}

- (void)play{
    
    if (_playStatus == playStatusStop) {
        [self beginPlay];
    }else if(_playStatus == playStatusPause){
        [_player play];
    }
    
    _imageView.hidden = YES;
    _controlButton.selected = YES;
    _controlButton.hidden = YES;
    _progressView.hidden = NO;
    _bottomView.hidden = YES;
    
    _bigVideoView.controlButton.selected = YES;
    _bigVideoView.controlButton.hidden = YES;
    _bigVideoView.progressView.hidden = NO;
    _bigVideoView.bottomView.hidden = YES;
    _bigVideoView.topView.hidden = YES;
    
    _videoType = videoPlay;
    _playStatus = playStatusPlay;
    _bigVideoView.playStatus = _playStatus;
}

- (void)seekToTime:(int64_t)time{
    [_player seekToTime:CMTimeMake(time, 1)];
}

- (videoType)videoPlayStatus{
    return _videoType;
}

- (videoStatus)videoLoadStatus{
    return _videoStatus;
}

- (NSString *)videoTimeLength{
    return [self getVideoLengthFromTimeLength:_videoLength];
}

- (float)videoTimeLengthValue{
    return _videoLength;
}

- (void)dealloc{
    [self stopPlay];
}

#pragma mark - KVO
- (void)addVideoKVO
{
    //KVO
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeVideoKVO {
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = _playerItem.status;
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
            {
                NSLog(@"AVPlayerItemStatusReadyToPlay");
                _videoStatus = videoStatusReadyToPlay;
                _videoLength = floor(_playerItem.asset.duration.value * 1.0/ _playerItem.asset.duration.timescale);
                if (_videoType != videoBackGroundPause) {
                    [_player play];
                }
            }
                break;
            case AVPlayerItemStatusUnknown:
            {
                NSLog(@"AVPlayerItemStatusUnknown");
                _videoStatus = videoStatusUnknown;
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"AVPlayerItemStatusFailed");
                NSLog(@"%@",_playerItem.error);
                _videoStatus = videoStatusFailed;
            }
                break;
                
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        //        [_player play];
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        
        NSLog(@"playbackBufferEmpty");
        
    }
}

#pragma mark - Notic
- (void)addVideoNotic {
    
    //Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieJumped:) name:AVPlayerItemTimeJumpedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieStalle:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backGroundPauseMoive) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

- (void)removeVideoNotic {
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemTimeJumpedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)movieToEnd:(NSNotification *)notic {
    [self seekToTime:0];
    [self pasue];
    _videoType = videoEnd;
    
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)movieJumped:(NSNotification *)notic {
    if (_videoType != videoBackGroundPause) {
        _videoType = videoPlay;
    }
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)movieStalle:(NSNotification *)notic {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)backGroundPauseMoive {
    [self pasue];
    _videoType = videoBackGroundPause;
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

#pragma mark - TimerObserver
- (void)addVideoTimerObserver {
    __weak typeof (self)weak_self = self;
    _timeObser = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        weak_self.currentTimeValue = time.value*1.0/time.timescale/weak_self.videoLength;
        
        [weak_self getStringFromCurrentCMTime:[weak_self getStringFromCMTime:time] valueFromCurrentCMTime:weak_self.currentTimeValue];
    }];
}

- (void)removeVideoTimerObserver {
    //    NSLog(@"%@",NSStringFromSelector(_cmd));
    [_player removeTimeObserver:_timeObser];
}

- (NSString *)getStringFromCMTime:(CMTime)time
{
    float currentTimeValue = (CGFloat)time.value/time.timescale;//得到当前的播放时
    
    NSDate * currentDate = [NSDate dateWithTimeIntervalSince1970:currentTimeValue];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    NSDateComponents *components = [calendar components:unitFlags fromDate:currentDate];
    
    if (currentTimeValue >= 3600 )
    {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",components.hour,components.minute,components.second];
    }
    else
    {
        return [NSString stringWithFormat:@"%02ld:%02ld",components.minute,components.second];
    }
}

- (NSString *)getVideoLengthFromTimeLength:(float)timeLength
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeLength];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    if (timeLength >= 3600 )
    {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",components.hour,components.minute,components.second];
    }
    else
    {
        return [NSString stringWithFormat:@"%02ld:%02ld",components.minute,components.second];
    }
}

@end

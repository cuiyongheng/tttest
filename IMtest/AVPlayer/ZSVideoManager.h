//
//  ZSVideoManager.h
//  JadeKing
//
//  Created by 牧仁者 on 2017/3/3.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSEnlargeVideoView.h"

@class ZSVideoManager;
@protocol ZSVideoManagerDelegate <NSObject>

- (void)playOrPauseCurrentVideo:(ZSVideoManager *)manager indexRow:(NSInteger)buttonTag;

- (void)enlargeVideo;

@end

@interface ZSVideoManager : UIView

@property (nonatomic ,strong ,readonly) UIProgressView *progressView;
@property (nonatomic ,strong ,readonly) UIButton *controlButton;
@property (nonatomic ,strong ,readonly) UIView *bottomView;
@property (nonatomic ,strong ,readonly) UISlider *sliderView;
@property (nonatomic ,strong ,readonly) UILabel *currentTimeLabel;
@property (nonatomic ,strong ,readonly) UILabel *endTimeLabel;
@property (nonatomic ,strong ,readonly) UIButton *enlargeButton;

@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *videoUrl;
@property (nonatomic ,copy) NSString *imageUrl;

@property (nonatomic ,weak) id delegate;
@property (nonatomic ,assign) playStatus playStatus;

- (void)seekToTime:(int64_t)time;

- (videoType)videoPlayStatus;

- (videoStatus)videoLoadStatus;

- (NSString *)videoTimeLength;

- (float)videoTimeLengthValue;

- (void)stopPlay;

- (void)pasue;

- (void)replays;

- (void)reload;

- (void)play;

@end

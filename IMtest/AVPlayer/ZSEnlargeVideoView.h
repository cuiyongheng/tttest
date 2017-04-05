//
//  ZSEnlargeVideoView.h
//  VideoTest
//
//  Created by 牧仁者 on 2017/3/13.
//  Copyright © 2017年 牧仁者. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *const statusBarHidden = @"statusBarHidden";

typedef NS_ENUM(NSInteger ,videoType) {
    videoDefualt,
    videoPlay,
    videoEnd,
    videoBackGroundPause
};

typedef NS_ENUM(NSInteger ,videoStatus) {
    videoStatusDefualt,
    videoStatusReadyToPlay,
    videoStatusUnknown,
    videoStatusFailed
};

typedef NS_ENUM(NSInteger ,playStatus) {
    playStatusStop,
    playStatusBegin,
    playStatusPause,
    playStatusPlay
};

@protocol ZSEnlargeVideoViewDelegate <NSObject>

- (void)reduceVideo;
- (void)playOrPause:(UIButton *)sender;
- (void)slider:(UISlider *)slider;

@end

@interface ZSEnlargeVideoView : UIView
@property (nonatomic ,strong ,readonly) UIProgressView *progressView;
@property (nonatomic ,strong ,readonly) UIButton *controlButton;
@property (nonatomic ,strong ,readonly) UIView *bottomView;
@property (nonatomic ,strong ,readonly) UISlider *sliderView;
@property (nonatomic ,strong ,readonly) UILabel *currentTimeLabel;
@property (nonatomic ,strong ,readonly) UILabel *endTimeLabel;
@property (nonatomic ,strong ,readonly) UIView *topView;
@property (nonatomic ,strong ,readonly) UIButton *backButton;
@property (nonatomic ,strong ,readonly) UILabel *titleLabel;
@property (nonatomic ,assign) playStatus playStatus;

@property (nonatomic ,assign ,readonly) BOOL statusBarHidden;

@property (nonatomic ,weak) id delegate;
@end

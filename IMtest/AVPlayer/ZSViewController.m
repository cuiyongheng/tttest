//
//  ZSViewController.m
//  JadeKing
//
//  Created by 牧仁者 on 2017/3/14.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "ZSViewController.h"

@interface ZSViewController ()
@property (nonatomic ,assign) BOOL isHidden;
@end

@implementation ZSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    _isHidden = [change[@"new"] boolValue];
    
    NSLog(@"%zd",_isHidden);
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    
    NSLog(@"----------");
    
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

- (BOOL)shouldAutorotate{

    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

@end

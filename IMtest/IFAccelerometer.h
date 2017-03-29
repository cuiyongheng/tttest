//
//  IFAccelerometer.h
//  IMtest
//
//  Created by MAC on 2017/3/13.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
@protocol  IFAccelerometerDelegate<NSObject>
- (void)accelerateWithX:(NSNumber*)x withY:(NSNumber*)y withZ:(NSNumber*)z withTimeInterval:(NSTimeInterval)timeInterval;
@end
@interface IFAccelerometer : NSObject<UIAccelerometerDelegate>
{
    UIAccelerometer *_accelerometer;
    CMMotionManager *_motionManager;
    id<IFAccelerometerDelegate>  _delegate;
}
+ (id)shareAccelerometer;
- (void)addOberser:(id)oberserer;
- (void)removeObserver;

@end

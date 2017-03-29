//
//  IFAccelerometer.m
//  IMtest
//
//  Created by MAC on 2017/3/13.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "IFAccelerometer.h"
static IFAccelerometer *accelerometerInstance = nil;
@implementation IFAccelerometer
+ (id)shareAccelerometer
{
    if (!accelerometerInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            accelerometerInstance = [[[self class]alloc]init];
        });
    }
    return accelerometerInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
#ifdef __IPHONE_5_0
        _motionManager = [[CMMotionManager alloc]init];
        if (_motionManager.accelerometerAvailable) {
            [_motionManager setAccelerometerUpdateInterval:1/60.f];
            NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];
            [_motionManager startAccelerometerUpdatesToQueue:operationQueue withHandler:^(CMAccelerometerData *data,NSError *error)
             {
                 if ([_delegate respondsToSelector:@selector(accelerateWithX:withY:withZ:withTimeInterval:)])
                 {
                     NSNumber *x  = [NSNumber numberWithDouble:data.acceleration.x];
                     NSNumber *y  = [NSNumber numberWithDouble:data.acceleration.y];
                     NSNumber *z  = [NSNumber numberWithDouble:data.acceleration.z];
                     [_delegate accelerateWithX:x withY:y withZ:z withTimeInterval:data.timestamp];
                 }
             }
             ];
            
        }
#else
#ifdef __IPHONE_4_0
        _accelerometer = [UIAccelerometer sharedAccelerometer];
        [_accelerometer setUpdateInterval:(1/60.0f)];
        _accelerometer.delegate = self;
#endif
#endif
        
    }
    return self;
}

- (void)addOberser:(id)oberserer
{
    _delegate = oberserer;
}

- (void)removeObserver
{
    _delegate = nil;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    if ([_delegate respondsToSelector:@selector(accelerateWithX:withY:withZ:withTimeInterval:)])
    {
        NSNumber *x  = [NSNumber numberWithDouble:acceleration.x];
        NSNumber *y  = [NSNumber numberWithDouble:acceleration.y];
        NSNumber *z  = [NSNumber numberWithDouble:acceleration.z];
        [_delegate accelerateWithX:x withY:y withZ:z withTimeInterval:acceleration.timestamp];
    }
}

@end

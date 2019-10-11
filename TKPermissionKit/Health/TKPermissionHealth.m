//
//  TKPermissionHealth.m
//  TKPermissionKitDemo
//
//  Created by mac on 2019/10/11.
//  Copyright © 2019 mac. All rights reserved.
//

#import "TKPermissionHealth.h"
#import "TKPermissionPublic.h"
#import <HealthKit/HealthKit.h>


@interface TKPermissionHealth ()
@property (nonatomic, strong) HKHealthStore             *healthStore;           // 健康
@property (nonatomic, copy  ) TKPermissionBlock block;
@property (nonatomic, assign) BOOL isAlert;
@property (nonatomic, strong) HKQuantityType *stepCountType;
@end

@implementation TKPermissionHealth

+ (id)shared
{
    static dispatch_once_t onceToken;
    static TKPermissionHealth *obj = nil;
    dispatch_once(&onceToken, ^{
        obj = [TKPermissionHealth new];
    });
    return obj;
}

- (void)jumpSetting
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [TKPermissionPublic alertTitle:@"权限提示" msg:@"访问HealthKit时需要您提供权限，请设置！"];
    });
}

- (void)alertAction
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [TKPermissionPublic alertActionTitle:@"提示" msg:@"当前设备不支持HealthKit！"];
    });
}

/**
 查询是否获取了HealthKit权限
 PS:只有选择了"始终"，才会返回YES
 **/
- (BOOL)checkAuth
{
    BOOL isAuth = NO;
    if ([HKHealthStore isHealthDataAvailable]) {
        HKAuthorizationStatus status = [self.healthStore authorizationStatusForType:self.stepCountType];
        if (HKAuthorizationStatusSharingAuthorized == status) {
            isAuth = YES;
        }
    }else{
        NSLog(@"⚠️⚠️⚠️当前设备不支持HealthKit！");
    }
    return isAuth;
}


/**
 请求HealthKit权限
 isAlert: 请求权限时，用户拒绝授予权限时。是否弹出alert进行手动设置权限 YES:弹出alert
 isAuth:  回调，用户是否申请权限成功！
 **/
- (void)authWithAlert:(BOOL)isAlert completion:(void(^)(BOOL isAuth))completion
{
    self.block = completion;
    self.isAlert = isAlert;
    if ([HKHealthStore isHealthDataAvailable]) {

////        HKQuantityType *stepCountType   = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
//        HKQuantityType *heightType      = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
//        HKQuantityType *weightType      = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
//        HKQuantityType *temperatureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
//        HKQuantityType *distance        = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
//        HKQuantityType *activeEnergyType= [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
////        NSSet *write = [NSSet setWithObjects:stepCountType,nil];
//        HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
//        HKCharacteristicType *sexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
////        NSSet *read  = [NSSet setWithObjects:stepCountType,nil];


        HKQuantityType *stepCountType = self.stepCountType;
        NSSet *write = [NSSet setWithObjects:stepCountType,nil];
        NSSet *read  = [NSSet setWithObjects:stepCountType,nil];
        [self.healthStore requestAuthorizationToShareTypes:write readTypes:read completion:^(BOOL success, NSError * _Nullable error) {
            HKAuthorizationStatus status = [self.healthStore authorizationStatusForType:stepCountType];
            if (HKAuthorizationStatusSharingAuthorized == status) {
                completion(YES);
            }else{
                if (self.isAlert) {
                    [self jumpSetting];
                }
                completion(NO);
            }
        }];
    }else{
        [self alertAction];
        completion(NO);
    }
}

//以步数为例子
- (HKQuantityType *)stepCountType
{
    if (!_stepCountType) {
        _stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    }
    return _stepCountType;
}

- (HKHealthStore *)healthStore
{
    if (!_healthStore) {
        _healthStore = [[HKHealthStore alloc] init];
    }
    return _healthStore;
}

@end
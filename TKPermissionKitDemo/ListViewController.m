//
//  ListViewController.m
//  TKPermissionKitDemo
//
//  Created by mac on 2019/8/19.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ListViewController.h"
#import "TKPermission.h"
#import <CoreTelephony/CTCellularData.h>
#import <CoreLocation/CoreLocation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "TKPermissionPublic.h"
#import "TKPermissionPhoto.h"
#import "TKPermissionCamera.h"
#import "TKPermissionMedia.h"
#import "TKPermissionMicrophone.h"
#import "TKPermissionLocationAlways.h"
#import "TKPermissionLocationWhen.h"
#import "TKPermissionBluetooth.h"
#import "TKPermissionSpeech.h"
#import "TKPermissionCalendar.h"
#import "TKPermissionReminder.h"
#import "TKPermissionContact.h"
#import "TKPermissionNetWork.h"
#import "TKPermissionHealth.h"






@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (copy  , nonatomic) NSArray *aryType;
@property (copy  , nonatomic) NSArray *aryTitle;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self instanceSubView];


//    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

//    [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [self get];
//    }];

    [self get];


//    [TKPermissionNetWork authWithAlert:YES completion:^(BOOL isAuth) {
//        if (isAuth) {
//            NSLog(@"权限获取成功！");
//        }else{
//            NSLog(@"权限获取失败");
//        }
//    }];
//
//    if ([TKPermissionContact checkAuth]) {
//        NSLog(@"查询到了权限");
//    }else{
//        NSLog(@"没有查询到权限");
//    }

//    [[TKPermissionHealth shared] authWithAlert:YES completion:^(BOOL isAuth) {
//        if (isAuth) {
//            NSLog(@"权限获取成功！");
//        }else{
//            NSLog(@"权限获取失败");
//        }
//    }];
//
//    if ([[TKPermissionHealth shared] checkAuth]) {
//        NSLog(@"查询到了权限");
//    }else{
//        NSLog(@"没有查询到权限");
//    }

}

- (void)instanceSubView
{
    self.aryTitle= @[@"打开相册权限",
                     @"打开相机权限",
                     @"打开媒体资料库权限",
                     @"打开麦克风权限",
                     @"打开位置权限-使用期间",
                     @"打开位置权限-始终使用",
                     @"打开推送权限",
                     @"打开语音识别权限",
                     @"打开日历权限",
                     @"打开通讯录权限",
                     @"打开提醒事项权限",
                     @"打开移动网络权限",
                     @"打开健康Health权限",
                     @"打开运动与健身权限",
                     @"打开HomeKit权限"
                     ];
    self.aryType = @[@(PermissionAuthTypePhoto),
                     @(PermissionAuthTypeCamera),
                     @(PermissionAuthTypeMedia),
                     @(PermissionAuthTypeMicrophone),
                     @(PrivacyPermissionTypeLocationWhen),
                     @(PrivacyPermissionTypeLocationAlways),
                     @(PermissionAuthTypePushNotification),
                     @(PermissionAuthTypeSpeech),
                     @(PermissionAuthTypeCalendar),
                     @(PermissionAuthTypeContact),
                     @(PermissionAuthTypeReminder),
                     @(PermissionAuthTypeNetWork),
                     @(PermissionAuthTypeHealth),
                     @(PermissionAuthTypeSportsAndFitness),
                     @(PermissionAuthTypeHomeKit)
                     ];

    self.tableView.rowHeight = 55;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aryType.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.aryTitle[row];
    return cell;
}

- (void)tableView1:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSNumber *number = self.aryType[row];
//    PrivacyPermissionType type = number.integerValue;
//    [[TKPermission shared] authorizeWithType:type completion:^(BOOL response, PrivacyPermissionAuthorizationStatus status) {
//        NSLog(@"认证状态:%ld",status);
//    }];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSNumber *number = self.aryType[row];
    PermissionAuthType type = number.integerValue;
    [[TKPermission shared] authPermissionWithType:type completion:^(BOOL isAuth) {
        if (isAuth) {
            NSLog(@"权限获取成功！");
        }else{
            NSLog(@"权限获取失败！");
        }
    }];
}





- (void)get
{
    NSURL *url = [NSURL URLWithString:@"http://www.cocoachina.com/cms/wap.php?action=article&id=24389"];
    NSURLSession *setion = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [setion dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"data");
    }];
    [task resume];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

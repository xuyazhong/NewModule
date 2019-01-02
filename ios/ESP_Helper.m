//
//  ESP_Helper.m
//  fxmy
//
//  Created by xuyazhong on 2018/4/17.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "ESP_Helper.h"
#import "ESPTouchResult.h"
#import "ESP_NetUtil.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation ESP_Helper

static NSCondition *_condition;
static ESPTouchTask *_esptouchTask;

+ (NSString *)fetchSsid {
  NSDictionary *ssidInfo = [ESP_Helper fetchNetInfo];
  return [ssidInfo objectForKey:@"SSID"];
}

+ (NSString *)fetchBssid {
  NSDictionary *bssidInfo = [ESP_Helper fetchNetInfo];
  return [bssidInfo objectForKey:@"BSSID"];
}

+ (NSDictionary *)fetchNetInfo {
  
  NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
  NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
  NSDictionary *SSIDInfo;
  for (NSString *interfaceName in interfaceNames) {
    SSIDInfo = CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
    NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
    BOOL isNotEmpty = (SSIDInfo.count > 0);
    if (isNotEmpty) {
      break;
    }
  }
  
  return SSIDInfo;
  
}

+ (void)start:(NSString *)password callback:(ESPResultBlock)block {
  
  NSLog(@"start connect action...");
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_async(queue, ^{
    NSLog(@"ESP do the execute work...");
    // execute the task
    NSArray *esptouchResultArray = [ESP_Helper executeForResults:password];
    // show the result to the user in UI Main Thread
    dispatch_async(dispatch_get_main_queue(), ^{
      
      ESPTouchResult *firstResult = [esptouchResultArray objectAtIndex:0];
      
      block(firstResult);
      
    });
  });
}

#pragma mark - the example of how to use executeForResults
+ (NSArray *)executeForResults:(NSString *)pwd {
  [_condition lock];
  NSString *apSsid = [ESP_Helper fetchSsid];
  NSString *apPwd = pwd;
  NSString *apBssid = [ESP_Helper fetchBssid];
  _esptouchTask = [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd];
  // set delegate
//  [_esptouchTask setEsptouchDelegate:[[ESP_Helper alloc]init] ];
  [_condition unlock];
  NSArray *esptouchResults = [_esptouchTask executeForResults:1];
  NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResults);
  
  return esptouchResults;
  
}

+ (void)cancel {
  
  NSLog(@"ESPViewController do cancel action...");
  [_condition lock];
  if (_esptouchTask != nil) {
    [_esptouchTask interrupt];
  }
  [_condition unlock];
  
}

@end

//
//  ESP.m
//  fxmy
//
//  Created by xuyazhong on 2018/3/30.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "BLEModule.h"
#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>

@implementation BLEModule

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(getBluetoothState:(RCTResponseSenderBlock)callback) {
  [[BLETools Single] start];
//  [[BLETools Single] ];
//  centralManagerDidUpdateState
//  NSString *ssid = [ESP_Helper fetchSsid];
//  callback(@[[NSNull null], ssid]);
  
}

RCT_EXPORT_METHOD(Connect:(NSString *)passwd :(RCTResponseSenderBlock)callback) {
//  NSString *apSsid = [ESP_Helper fetchSsid];
//  NSString *apBssid = [ESP_Helper fetchBssid];
//  if (apBssid == nil || apSsid == nil) {
//    callback(@[@"network error", [NSNull null]]);
//    return;
//  }
}

@end

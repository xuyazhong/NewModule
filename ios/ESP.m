//
//  ESP.m
//  fxmy
//
//  Created by xuyazhong on 2018/3/30.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "ESP.h"
#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>
#import "ESP_Helper.h"
#import "ESP_NetUtil.h"

@implementation ESP

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(getSSID:(RCTResponseSenderBlock)callback) {
  
  NSString *ssid = [ESP_Helper fetchSsid];
  callback(@[[NSNull null], ssid]);
  
}

RCT_EXPORT_METHOD(Connect:(NSString *)passwd :(RCTResponseSenderBlock)callback) {
  NSString *apSsid = [ESP_Helper fetchSsid];
  NSString *apBssid = [ESP_Helper fetchBssid];
  if (apBssid == nil || apSsid == nil) {
    callback(@[@"network error", [NSNull null]]);
    return;
  }
  
  [ESP_Helper start:passwd callback:^(ESPTouchResult *result) {
    
    if (!result.isCancelled) {
      
      if (result.isSuc) {
        NSString *ipAddrDataStr = [ESP_NetUtil descriptionInetAddr4ByData:result.ipAddrData];
        if (ipAddrDataStr==nil) {
          ipAddrDataStr = [ESP_NetUtil descriptionInetAddr6ByData:result.ipAddrData];
        }
        NSLog(@"ip :%@ description:%@", ipAddrDataStr, result);
        callback(@[[NSNull null], ipAddrDataStr]);
      } else {
        callback(@[@"error", [NSNull null]]);
      }
      
    } else {
      callback(@[@"cancel", [NSNull null]]);
    }
    
  }];
}

@end

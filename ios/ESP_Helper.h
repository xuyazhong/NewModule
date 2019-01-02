//
//  ESP_Helper.h
//  fxmy
//
//  Created by xuyazhong on 2018/4/17.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESPTouchTask.h"
#import "ESPTouchResult.h"
#import "ESPTouchDelegate.h"

typedef void(^ESPResultBlock)(ESPTouchResult *);
@interface ESP_Helper : NSObject

//@property (nonatomic, assign) EspTouchDelegateImpl *_esptouchDelegate;

+ (NSString *)fetchSsid;

+ (NSString *)fetchBssid;

+ (void)start:(NSString *)password callback:(ESPResultBlock)block;

+ (void)cancel;

@end

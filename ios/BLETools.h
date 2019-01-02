//
//  BLETools.h
//  BLE
//
//  Created by xuyazhong on 2018/11/29.
//  Copyright © 2018年 BLE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
//805005B9-543D-4018-A9A9-C5C46AB9300B
#define kServiceUUID @"6E40FFF0-B5A3-F393-E0A9-E50E24DCCA9E" //服务的UUID
#define kCharacteristicUUID @"00001530-1212-EFDE-1523-785FEABCD123" //特征的UUID
typedef void(^BroadcastBlock)(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI);
typedef void(^successConnectBlock)(CBPeripheral *peripheral);
typedef void(^failureConnectBlock)(CBPeripheral *peripheral);
typedef void(^serviceBlock)(CBPeripheral *peripheral);
typedef void(^cbsBlock)(CBService *service);
typedef void(^cbcharBlock)(CBCharacteristic *characteristic);
@interface BLETools : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager; //中心设备管理器
@property (nonatomic, copy) BroadcastBlock block;

@property (nonatomic, copy) successConnectBlock ConnectedBlock;
@property (nonatomic, copy) failureConnectBlock failureConnectBlock;

@property (nonatomic, copy) serviceBlock serviceBlock;

@property (nonatomic, copy) cbsBlock services;
@property (nonatomic, copy) cbcharBlock characteristic;

+ (instancetype)Single;

- (void)stop;
- (void)start;
- (void)connectPeripheral:(CBPeripheral *)peripheral;
- (void)discoverCharacteristics:(CBPeripheral *)peripheral :(nullable NSArray<CBUUID *> *)array forService:(nonnull CBService *)cbs;
- (void)disConnect:(nonnull CBPeripheral *)peripheral;

@end

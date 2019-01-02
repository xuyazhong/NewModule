//
//  BLETools.m
//  BLE
//
//  Created by xuyazhong on 2018/11/29.
//  Copyright © 2018年 BLE. All rights reserved.
//

#import "BLETools.h"

static BLETools *_sign = nil;

@implementation BLETools {
    BOOL isStop;
}

+ (instancetype)Single {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sign = [[BLETools alloc] init];
    });
    return _sign;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
    return self;
}

- (void)connectPeripheral:(CBPeripheral *)peripheral {
    [_centralManager connectPeripheral:peripheral options:nil];
}

- (void)disConnect:(CBPeripheral *)peripheral {
    [_centralManager cancelPeripheralConnection:peripheral];
}

- (void)discoverCharacteristics:(CBPeripheral *)peripheral :(nullable NSArray<CBUUID *> *)cbuuid forService:(nonnull CBService *)cbs {
    [peripheral discoverCharacteristics:cbuuid forService:cbs];
//    [peripheral discoverCharacteristics]
//    [_peripheral discoverCharacteristics:nil forService:item];
//    [self.peripheral discoverCharacteristics:characteristicUUIDs forService:service.service];
}

- (void)start {
    isStop = NO;
}

-(void)stop {
    isStop = YES;
}

- (void)broadcast:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    if (!isStop) {
        _block(peripheral, advertisementData, RSSI);
    }
}

#pragma mark - CBCentralManager代理方法
//中心服务器状态更新后
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBManagerStatePoweredOn:
            [self log:@"BLE已打开."];
            //扫描外围设备
            //            [central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:kServiceUUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
            [central scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
            break;
        case CBManagerStateUnknown:
            [self log:@">>>CBCentralManagerStateUnknown"];
            break;
        case CBManagerStateResetting:
            [self log:@">>>CBCentralManagerStateResetting"];
            break;
        case CBManagerStateUnsupported:
            [self log:@">>>CBCentralManagerStateUnsupported"];
            break;
        case CBManagerStateUnauthorized:
            [self log:@">>>CBCentralManagerStateUnauthorized"];
            break;
        case CBManagerStatePoweredOff:
            [self log:@">>>CBCentralManagerStatePoweredOff"];
            break;
        default:
            [self log:@"此设备不支持BLE或未打开蓝牙功能，无法作为外围设备."];
            break;
    }
    
}
/**
 *  发现外围设备
 *
 *  @param central           中心设备
 *  @param peripheral        外围设备
 *  @param advertisementData 特征数据
 *  @param RSSI              信号质量（信号强度）
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    [self broadcast:peripheral advertisementData:advertisementData RSSI:RSSI];
    
}

//连接到外围设备
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSString *result = [NSString stringWithFormat:@"%@====>连接成功", peripheral.name];
    [self log:result];
    //设置外围设备的代理为当前视图控制器
    peripheral.delegate=self;
    [self stop];
    _ConnectedBlock(peripheral);
    //外围设备开始寻找服务
//    [peripheral discoverServices:@[[CBUUID UUIDWithString:@"180A"]]];

//    [peripheral discoverServices:@[[CBUUID UUIDWithString:kServiceUUID]]];
}

//连接外围设备失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self log:@"连接外围设备失败!"];
    _failureConnectBlock(peripheral);
    
}

#pragma mark - CBPeripheral 代理方法
//外围设备寻找到服务后
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    [self log:@"已发现可用服务..."];
    _serviceBlock(peripheral);
    if (error) {
        NSLog(@"外围设备寻找服务过程中发生错误，错误信息：%@", error.localizedDescription);
    }
    //遍历查找到的服务
    //    CBUUID *serviceUUID=[CBUUID UUIDWithString:kServiceUUID];
    //    CBUUID *characteristicUUID=[CBUUID UUIDWithString:kCharacteristicUUID];
//    NSLog(@"name=>[%@]\n services => [%@]\n dict => [%@]", peripheral.name, peripheral.services, peripheral);
    
//    if([peripheral.identifier isEqual:serviceUUID]){
//        //外围设备查找指定服务中的特征
//        NSLog(@"=======>外围设备查找指定服务中的特征");
    
//    [peripheral discoverCharacteristics:nil forService:peripheral.services.firstObject];
//    }
//        for (CBService *service in peripheral.services) {
//            NSLog(@"UUID => %@", service.UUID);
//            if([service.UUID isEqual:serviceUUID]){
                //外围设备查找指定服务中的特征
//                NSLog(@"=======>外围设备查找指定服务中的特征");
//                [peripheral discoverCharacteristics:@[peripheral.services.firstObject] forService:service];
//            }
//        }
    //    NSLog(@"=======> 遍历结束");
}

//外围设备寻找到特征后
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    [self log:@"已发现可用特征..."];
    if (error) {
        NSLog(@"外围设备寻找特征过程中发生错误，错误信息：%@",error.localizedDescription);
    }
    NSLog(@"did discover => [%@]", service);
    _services(service);
    for (CBCharacteristic *characteristic in service.characteristics) {
        [peripheral readValueForCharacteristic:characteristic];
        [peripheral discoverDescriptorsForCharacteristic:characteristic];
//        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
    /*
    //遍历服务中的特征
    CBUUID *serviceUUID=[CBUUID UUIDWithString:kServiceUUID];
    CBUUID *characteristicUUID=[CBUUID UUIDWithString:kCharacteristicUUID];
    if ([service.UUID isEqual:serviceUUID]) {
//        NSLog(@"service => [%@]", service);
        for (CBCharacteristic *characteristic in service.characteristics) {
//            NSLog(@"characteristic.UUID: [%@]", characteristic.UUID);
            [self getMac:characteristic];
            if ([characteristic.UUID isEqual:characteristicUUID]) {
                //情景一：通知
                找到特征后设置外围设备为已通知状态（订阅特征）：
                 *1.调用此方法会触发代理方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
                 *2.调用此方法会触发外围设备的订阅代理方法
//                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                //情景二：读取
                [peripheral readValueForCharacteristic:characteristic];
                if (characteristic.value) {
                    NSString *value=[[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
                    NSLog(@"读取到特征值：%@",value);
                }
            }
        }
    }
    */
}

//特征值被更新后
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"delegate => didUpdateNotificationStateForCharacteristic");
    _characteristic(characteristic);
    if (error) {
        NSLog(@"更新通知状态时发生错误，错误信息：%@",error.localizedDescription);
    }
    //给特征值设置新的值
//    CBUUID *characteristicUUID=[CBUUID UUIDWithString:kCharacteristicUUID];
//    if ([characteristic.UUID isEqual:characteristicUUID]) {
//        if (characteristic.isNotifying) {
//            if (characteristic.properties==CBCharacteristicPropertyNotify) {
//                NSLog(@"已订阅特征通知.");
//                return;
//            } else if (characteristic.properties ==CBCharacteristicPropertyRead) {
//                //从外围设备读取新值,调用此方法会触发代理方法：-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
//                [peripheral readValueForCharacteristic:characteristic];
//            }
//
//        }else{
//            NSLog(@"停止已停止.");
//            //取消连接
//            [self.centralManager cancelPeripheralConnection:peripheral];
//        }
//    }
}

//更新特征值后（调用readValueForCharacteristic:方法或者外围设备在订阅后更新特征值都会调用此代理方法）
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"delegate => didUpdateValueForCharacteristic");
    _characteristic(characteristic);
    // mac address
    [self getMac:characteristic];
    
    if (error) {
        NSLog(@"更新特征值时发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    if (characteristic.value) {
        NSString *value=[[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"读取到特征值：[%@]",value);
    } else {
        NSLog(@"未发现特征值.");
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"delegate => didDiscoverDescriptorsForCharacteristic");
    _characteristic(characteristic);
    if (error) {
        NSLog(@"更新通知状态时发生错误，错误信息：%@",error.localizedDescription);
    }
}

- (void)getMac:(CBCharacteristic *)characteristic {
    //专门处理Mac地址的值
    NSString *macValue = [NSString stringWithFormat:@"%@", characteristic.value];
    NSLog(@"macValue:%@", macValue);
    //Mac地址数据
    NSMutableString *_macString;
    if([characteristic.UUID.UUIDString isEqualToString:@"2A23"]){
        _macString = [[NSMutableString alloc] init];
        [_macString appendString:[[macValue substringWithRange:NSMakeRange(16, 2)] uppercaseString]];
        [_macString appendString:@":"];
        [_macString appendString:[[macValue substringWithRange:NSMakeRange(14, 2)] uppercaseString]];
        [_macString appendString:@":"];
        [_macString appendString:[[macValue substringWithRange:NSMakeRange(12, 2)] uppercaseString]];
        [_macString appendString:@":"];
        [_macString appendString:[[macValue substringWithRange:NSMakeRange(5, 2)] uppercaseString]];
        [_macString appendString:@":"];
        [_macString appendString:[[macValue substringWithRange:NSMakeRange(3, 2)] uppercaseString]];
        [_macString appendString:@":"];
        [_macString appendString:[[macValue substringWithRange:NSMakeRange(1, 2)] uppercaseString]];
    }
    NSString *result = [NSString stringWithFormat:@"MAC ======> %@", _macString];
    [self log:result];
}

- (void)log:(NSString *)res {
    NSLog(@"BLETools => %@", res);
}

@end

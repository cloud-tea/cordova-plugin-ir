//
//  IRSender.m
//  tiqiaasdkTest
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 tiqiaa.com. All rights reserved.
//

#import "IRSender.h"

@implementation IRSender

+ (instancetype)sender {
	static dispatch_once_t onceToken;
	static IRSender *sender = nil;
	dispatch_once(&onceToken, ^{
		sender = [IRSender new];
	});
	return sender;
}

- (void)sendRemote:(TJRemote *)remote key:(TJIrKey *)key {
	NSArray<TJInfrared *> *irList = nil;
	if (remote.type == MachineType_AirCond) {
		// 处理空调按键
		TJAirRemoteState *state = [[TJAirRemoteStateManager sharedManager] getAirRemoteState:remote._id];
		if (key.type == IRKeyType_AirTimer) {
			// 处理空调定时按键
			int sampleTimerValue = 60; // 1 hour
			irList = [[TJRemoteHelper sharedInstance] fetchAirTimerInfrared:key state:state time:sampleTimerValue];
		} else {
			// 处理其他空调按键
			irList = [[TJRemoteHelper sharedInstance] fetchAirRemoteInfrared:remote key:key state:state];
		}
	} else {
		// 处理非空调按键
		irList = [[TJRemoteHelper sharedInstance] fetchRemoteInfrared:remote key:key];
	}

	if (irList.count) {
		for (TJInfrared *ir in irList) {
			// 红外信号
			NSData *data = [TJRemoteHelper getIrCode:ir.freq data:ir.data];
			// 发送/传输此信号的数据，频率等相关信息
			NSLog(@"key %d, %@, ir freq=%d, data=%@", key.type, key.localeName, ir.freq, data);
			// 设备调用 send_ir_code() 或其他对应的信号发送函数
		}
	}
}

- (void)sendRemote:(TJRemote *)remote testKey:(TJIrKey *)key {
	NSArray<TJInfrared *> *irList = [[TJRemoteHelper sharedInstance] fetchRemoteTestInfrared:remote key:key];

	if (irList.count) {
		for (TJInfrared *ir in irList) {
			// 红外信号
			NSData *data = [TJRemoteHelper getIrCode:ir.freq data:ir.data];
			// 发送/传输此信号的数据，频率等相关信息
			NSLog(@"key %d, %@, ir freq=%d, data=%@", key.type, key.localeName, ir.freq, data);
			// 设备调用 send_ir_code() 或其他对应的信号发送函数
		}
	}
}

@end

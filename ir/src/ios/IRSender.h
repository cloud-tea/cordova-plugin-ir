//
//  IRSender.h
//  tiqiaasdkTest
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 tiqiaa.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tiqiaasdk/tiqiaasdk.h"

/**
 发送红外信号
 */
@interface IRSender : NSObject

+ (instancetype)sender;

/// 9. 发送信号
- (void)sendRemote:(TJRemote *)remote key:(TJIrKey *)key;

/// 9.3.2 发送测试信息：搜索、匹配
- (void)sendRemote:(TJRemote *)remote testKey:(TJIrKey *)key;

@end

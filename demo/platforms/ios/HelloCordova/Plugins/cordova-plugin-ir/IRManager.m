#import <Cordova/CDV.h>
#import "tiqiaasdk/tiqiaasdk.h"
#import "AFNetworking/AFNetworking.h"
#import <objC/runtime.h>
#import <objc/message.h>

static const uint8_t appKey[] = {243, 249, 51, 188, 227, 62, 233, 176, 152, 8, 52, 66, 226, 188, 174, 255,181, 248, 12, 219, 222, 231, 246, 190, 137, 77, 69, 141, 76, 195, 152, 151,185, 134, 109, 154, 174, 164, 241, 24, 159, 143, 25, 51, 210, 64, 209, 91,23, 37, 197, 176, 143, 58, 65, 175, 10, 206, 0, 7, 111, 13, 253, 9,123, 178, 57, 115, 207, 97, 112, 70, 58, 236, 63, 191, 49, 239, 171, 77,88, 185, 40, 254, 122, 77, 32, 85, 19, 73, 112, 15, 174, 10, 115, 5,129, 153, 67, 147, 63, 207, 178, 34, 52, 190, 248, 250, 0, 133, 245, 88,169, 14, 188, 83, 231, 229, 178, 122, 156, 60, 161, 39, 190, 19, 184, 235,119, 79, 95, 41, 52, 49, 49, 158, 114, 192, 94, 193, 16, 147, 255, 166};

@interface IRManager : CDVPlugin {
    // Member variables go here.
    BOOL isconnecting;
}

- (void) SEARCH_REMOTE:(CDVInvokedUrlCommand*)command;
- (void) ADD_REMOTE:(CDVInvokedUrlCommand*)command;
- (void) SEND_IR_CODE:(CDVInvokedUrlCommand*)command;
- (void) GET_BRAND:(CDVInvokedUrlCommand*)command;
- (void) GET_ALL_APPLICANCE:(CDVInvokedUrlCommand*)command;

/// 当前遥控器
@property (nonatomic, strong) TJRemote *currentRemote;
@property (nonatomic) NSUInteger currentKeyIndex;
@property(nonatomic, strong) TJRemotePage *page;
/// 当前空调状态
@property (nonatomic, strong) TJAirRemoteState *currentAirState;
@property(nonatomic, strong) NSMutableArray<TJRemote *> *remoteList;
/// 测试遥控器
@property (nonatomic, strong) TJRemote *remote;

@end

@implementation IRManager

#pragma mark "Private methods"

- (void) pluginInitialize
{
    
    [TJRemoteClient setAppKey:appKey length:sizeof(appKey)];

    [self setup];
}


- (void)setup {
    self.remoteList = [NSMutableArray array];
    self.remote = nil;
    TJRemotePage *page = [TJRemotePage new];
    page.appliance_type = MachineType_AirCond;
    page.brand_id = 1103806845734LL; // 海尔
    page.lang = [TJRemoteHelper fetchCurrentLang];
    self.page = page;
}


- (NSMutableDictionary *) searializeJSON: (char *) className withInstance:(NSObject *) classInstance {
    NSMutableDictionary *muteDictionary = [NSMutableDictionary dictionary];
    
    id YourClass = objc_getClass(className);
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(YourClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        SEL propertySelector = NSSelectorFromString(propertyName);
        if (classInstance && [classInstance respondsToSelector:propertySelector]) {
            [muteDictionary setValue: objc_msgSend(classInstance, propertySelector) forKey:propertyName];
        }
    }
    
    return muteDictionary;
}

- (NSString *) toJSONStr: (NSObject *) object {
    
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&jsonError];
    
    
    NSString *JSONString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSLog(@"%@", JSONString);
    
    return JSONString;
}

- (NSArray<TJInfrared *> *)getIRListByKey: (TJIrKey *) key  byRemote: (TJRemote *) remote {
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
            
            [ir setValue:data forKey:@"code"];
        }
    }
    
    return irList;
}


// 在遥控器中查找特定按键
/// !!!DEMO ONLY: 只适用于非自定义按键（keyType>=0）
- (TJIrKey *)findIrKeyByType:(IRKeyType)keyType {
    for (TJIrKey *key in _currentRemote.keys) {
        if (key.type == keyType) {
            return key;
        }
    }
    return nil;
}


/*
   搜索遥控器完成
 */
- (void) onSearchRemoteDone:(NSMutableArray *) remoteList withCommand: (CDVInvokedUrlCommand*) command
{
    NSMutableArray* remotesArray = [[NSMutableArray alloc] init];
    
    id weak = self;
    
    if (remoteList.count) {
        [self.remoteList addObjectsFromArray:remoteList];
        
        [remoteList enumerateObjectsUsingBlock:^(TJRemote * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *json = [obj toJsonObject];
            [remotesArray addObject:json];
        }];
    } else {
        NSLog(@"No remotes!");
    }
    
    [self successWithCallbackID:command.callbackId withMessage: [self toJSONStr:remotesArray]];
}


/*
    添加远程遥控器
 */
- (void) ADD_REMOTE:(CDVInvokedUrlCommand *)command
{
    self.page.keyword = [command argumentAtIndex:0];
    BOOL isOffical = [[command argumentAtIndex:1] boolValue];
    
    id weak = self;
    
    if(isOffical) {
        [[TJRemoteClient sharedClient] searchOfficial:self.page callback:^(TJWebErrorCode errcode, NSMutableArray<TJRemote *> *remoteList) {
            NSLog(@"searchOfficial: %d, %d", errcode, (int)remoteList.count);
            
            [weak onSearchRemoteDone:remoteList withCommand:command];
        }];
    } else {
        [[TJRemoteClient sharedClient] searchDiy:self.page callback:^(TJWebErrorCode errcode, NSMutableArray<TJRemote *> *remoteList) {
            NSLog(@"searchDiy: %d, %d", errcode, (int)remoteList.count);
            
            [weak onSearchRemoteDone:remoteList withCommand:command];
        }];
    }
    
}


/*
    根据关键字搜索远程遥控器
 */
- (void) SEARCH_REMOTE:(CDVInvokedUrlCommand *)command
{
    self.page.keyword = [command argumentAtIndex:0];
    BOOL isOffical = [[command argumentAtIndex:1] boolValue];
    
    id weak = self;
    
    if(isOffical) {
        [[TJRemoteClient sharedClient] searchOfficial:self.page callback:^(TJWebErrorCode errcode, NSMutableArray<TJRemote *> *remoteList) {
            NSLog(@"searchOfficial: %d, %d", errcode, (int)remoteList.count);
            
            [weak onSearchRemoteDone:remoteList withCommand:command];
        }];
    } else {
        [[TJRemoteClient sharedClient] searchDiy:self.page callback:^(TJWebErrorCode errcode, NSMutableArray<TJRemote *> *remoteList) {
            NSLog(@"searchDiy: %d, %d", errcode, (int)remoteList.count);
            
            [weak onSearchRemoteDone:remoteList withCommand:command];
        }];
    }
    
}

// 加载更多的遥控器
- (void) LOAD_MORE_REMOTE:(CDVInvokedUrlCommand *)command
{
    NSLog(@"Load More: %d", self.page.page);
    BOOL isOffical = [[command argumentAtIndex:0] boolValue];

    id weak = self;
    NSMutableArray* remotesArray = [[NSMutableArray alloc] init];
    
    if (self.remoteList.count >= SearchDefaultPageSize) {
        self.page.page += 1;
        
        if(isOffical) {
            [[TJRemoteClient sharedClient] searchOfficial:self.page callback:^(TJWebErrorCode errcode, NSMutableArray<TJRemote *> *remoteList) {
                NSLog(@"searchOfficial: %d, %d", errcode, (int)remoteList.count);
                
                [weak onSearchRemoteDone:remoteList withCommand:command];
            }];
        } else {
            [[TJRemoteClient sharedClient] searchDiy:self.page callback:^(TJWebErrorCode errcode, NSMutableArray<TJRemote *> *remoteList) {
                NSLog(@"searchDiy: %d, %d", errcode, (int)remoteList.count);
                
                [weak onSearchRemoteDone:remoteList withCommand:command];
            }];
        }

    } else {
        [self successWithCallbackID:command.callbackId withMessage: [self toJSONStr:remotesArray]];
    }
}


/*
    获取所有的遥控器型号
 */
- (void) GET_REMOTES_BY_BRAND: (CDVInvokedUrlCommand *) command
{
    id weak = self;
    NSMutableArray* remotesArray = [[NSMutableArray alloc] init];
    self.page.brand_id = [[command argumentAtIndex:0] intValue];
    
    [[TJRemoteClient sharedClient] autoMatchRemote:self.page callback:^(TJWebErrorCode errcode, NSMutableArray<TJRemote *> *remotes) {
        if (remotes.count) {
            [self.remoteList addObjectsFromArray:remotes];
            
            [remotes enumerateObjectsUsingBlock:^(TJRemote * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                NSDictionary *remoteJSON = [weak searializeJSON:"TJRemote" withInstance:obj];
                NSDictionary *remoteJSON = [obj toJsonObject];
                [remotesArray addObject:remoteJSON];
            }];
        } else {
            // 没有可用遥控器
            // 方案1：按电器类型和品牌ID自动匹配
            // 方案2：按电器类型和品牌ID搜索
            // 方案3：提示找不到遥控器，反馈缺失遥控器型号
            //		[[TJRemoteClient sharedClient] missModel:page.appliance_type brandId:page.brand_id model:model];
            NSLog(@"No remotes!");
        }
        
        [weak successWithCallbackID:command.callbackId withMessage: [self toJSONStr:remotesArray]];
    }];
}

// 下载遥控器并返回遥控器所有按键信息和红外码
- (void) DOWNLOAD_REMOTE:(CDVInvokedUrlCommand *)command
{
    NSString *remoteId = [command argumentAtIndex:0];
    id weak = self;
    
    [[TJRemoteClient sharedClient] downloadRemote:remoteId callback:^(TJWebErrorCode errcode, TJRemote * _Nonnull remote) {
        [remote.keys enumerateObjectsUsingBlock:^(TJIrKey * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray<TJInfrared *> *irList = [weak getIRListByKey:obj byRemote:remote];
            
            [remote setValue:irList forKey:@"irList"];
            
            [weak successWithCallbackID:command.callbackId withMessage: [self toJSONStr:remote]];
        }];
    }];
}



- (void) GET_IR_CODE:(CDVInvokedUrlCommand *)command
{
    int freq = [[command argumentAtIndex:0] intValue];
    NSData *data = [command argumentAtIndex:1];
    
    NSData *irCode = [TJRemoteHelper getIrCode:freq data:data];
    
    [self successWithCallbackID:command.callbackId withMessage: [self toJSONStr:irCode]];
}

// note: send id code could be done by web side
- (void) SEND_IR_CODE:(CDVInvokedUrlCommand *)command
{
    
}

- (void) GET_AIR_BRANDS:(CDVInvokedUrlCommand *)command
{
    NSString *keyword = [command argumentAtIndex:0];
    id weak = self;
    
    NSMutableArray* brandsArray = [[NSMutableArray alloc] init];
    
    [[TJRemoteClient sharedClient] fetchBrandList:MachineType_AirCond flag:TJFetchRemoteBrandFlag_OnlyBrandHasRemoteModel keyword:keyword callback:^(NSMutableArray<TJBrand *> *brands) {
        
        
        [brands enumerateObjectsUsingBlock:^(TJBrand * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSDictionary *brandJSON = [weak searializeJSON:"TJBrand" withInstance:obj];
            NSDictionary *brandJSON = [obj toJsonObject];
            [brandsArray addObject:brandJSON];
        }];
        
        [weak successWithCallbackID:command.callbackId withMessage: [self toJSONStr:brandsArray]];
    }];

}

- (void) GET_BRANDS:(CDVInvokedUrlCommand *)command
{
    id weak = self;
    NSMutableArray* brandsArray = [[NSMutableArray alloc] init];
    

    [[TJRemoteClient sharedClient] loadBrand:^(TJWebErrorCode errcode, NSMutableArray<TJBrand *> * _Nonnull brands) {
        
        
        [brands enumerateObjectsUsingBlock:^(TJBrand * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSDictionary *brandJSON = [weak searializeJSON:"TJBrand" withInstance:obj];
            NSDictionary *brandJSON = [obj toJsonObject];
            [brandsArray addObject:brandJSON];
        }];
        
        
        [weak successWithCallbackID:command.callbackId withMessage: [self toJSONStr:brandsArray]];
    }];
}

- (void) GET_ALL_APPLICANCE:(CDVInvokedUrlCommand *)command
{
    
}


- (void)successWithCallbackID:(NSString *)callbackID withMessage:(NSString *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}

- (void)failWithCallbackID:(NSString *)callbackID withError:(NSError *)error
{
    [self failWithCallbackID:callbackID withMessage:[error localizedDescription]];
}

- (void)failWithCallbackID:(NSString *)callbackID withMessage:(NSString *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}


@end

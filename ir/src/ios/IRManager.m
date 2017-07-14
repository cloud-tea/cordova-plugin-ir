#import <Cordova/CDV.h>
#import "tiqiaasdk/tiqiaasdk.h"
#import "AFNetworking/AFNetworking.h"


static const uint8_t appKey[] = {235, 39, 171, 141, 224, 110, 212, 247, 73, 166, 80, 112, 123, 22, 232, 153,199, 108, 106, 146, 10, 21, 140, 192, 62, 240, 249, 51, 50, 38, 35, 114,165, 211, 131, 133, 73, 94, 69, 78, 40, 62, 92, 92, 187, 128, 26, 78,199, 236, 174, 75, 142, 184, 253, 208, 26, 115, 176, 122, 60, 143, 103, 165,57, 83, 176, 60, 12, 241, 215, 26, 127, 93, 127, 117, 156, 71, 253, 94,148, 84, 117, 142, 129, 155, 224, 152, 38, 248, 198, 135, 113, 129, 109, 212,148, 15, 100, 155, 106, 171, 53, 227, 243, 122, 171, 43, 113, 66, 241, 248,158, 140, 59, 119, 213, 108, 27, 212, 144, 156, 49, 193, 115, 58, 77, 196,87, 227, 203, 75, 77, 171, 92, 195, 59, 87, 252, 88, 46, 57, 217, 106};

@interface IRManager : CDVPlugin {
    // Member variables go here.
    BOOL isconnecting;
}

- (void) SEARCH_REMOTE:(CDVInvokedUrlCommand*)command;
- (void) ADD_REMOTE:(CDVInvokedUrlCommand*)command;
- (void) SEND_IR_CODE:(CDVInvokedUrlCommand*)command;
- (void) GET_BRAND:(CDVInvokedUrlCommand*)command;
- (void) GET_ALL_APPLICANCE:(CDVInvokedUrlCommand*)command;

@end

@implementation IRManager

#pragma mark "Private methods"

- (void) pluginInitialize
{
    [TJRemoteClient setAppKey:appKey length:sizeof(appKey)];
}

- (void) SEARCH_REMOTE:(CDVInvokedUrlCommand *)command
{
    
}

- (void) ADD_REMOTE:(CDVInvokedUrlCommand *)command
{
    
}

- (void) SEND_IR_CODE:(CDVInvokedUrlCommand *)command
{
    
}

- (void) GET_BRAND:(CDVInvokedUrlCommand *)command
{
    id weak = self;

    [[TJRemoteClient sharedClient] loadBrand:^(TJWebErrorCode errcode, NSMutableArray<TJBrand *> * _Nonnull brands) {
        
        NSLog(@"%@", brands.firstObject.description);
        
        
        NSError* error = nil;
        NSString *brandsJSONString = @"";
        
        NSData *brandsJSONData = [NSJSONSerialization dataWithJSONObject:brands options:NSJSONWritingPrettyPrinted error:&error];

        brandsJSONString = [[NSString alloc] initWithData:brandsJSONData encoding:NSUTF8StringEncoding] ;

        [weak successWithCallbackID:command.callbackId withMessage: brandsJSONString];
        
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

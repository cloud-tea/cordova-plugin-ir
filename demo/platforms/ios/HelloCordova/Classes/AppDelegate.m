/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  HelloCordova
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "../Plugins/cordova-plugin-ir/tiqiaasdk/tiqiaasdk.h"

static const uint8_t appKey[] = {243, 249, 51, 188, 227, 62, 233, 176, 152, 8, 52, 66, 226, 188, 174, 255,181, 248, 12, 219, 222, 231, 246, 190, 137, 77, 69, 141, 76, 195, 152, 151,185, 134, 109, 154, 174, 164, 241, 24, 159, 143, 25, 51, 210, 64, 209, 91,23, 37, 197, 176, 143, 58, 65, 175, 10, 206, 0, 7, 111, 13, 253, 9,123, 178, 57, 115, 207, 97, 112, 70, 58, 236, 63, 191, 49, 239, 171, 77,88, 185, 40, 254, 122, 77, 32, 85, 19, 73, 112, 15, 174, 10, 115, 5,129, 153, 67, 147, 63, 207, 178, 34, 52, 190, 248, 250, 0, 133, 245, 88,169, 14, 188, 83, 231, 229, 178, 122, 156, 60, 161, 39, 190, 19, 184, 235,119, 79, 95, 41, 52, 49, 49, 158, 114, 192, 94, 193, 16, 147, 255, 166};


@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    [TJRemoteClient setAppKey:appKey length:sizeof(appKey)];

    self.viewController = [[MainViewController alloc] init];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

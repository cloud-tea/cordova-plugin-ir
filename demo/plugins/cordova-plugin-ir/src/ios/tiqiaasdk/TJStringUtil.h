//
//  TJStringUtil.h
//  TiqiaaSDK
//
//  Created by apple on 14-5-16.
//  Copyright (c) 2014年 TianJia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TJStringUtil)

/// self
- (NSString *)stringValue;

/// contains substring, like containsString: in iOS8+
- (BOOL)contains:(NSString *)str;
- (BOOL)containsAnyChar:(NSString *)chars;

/// concatenate items by self
- (NSString *)join:(NSArray *)items;

/// trim/strip whitespace and newline from both end
- (NSString *)trim;

/// remove entries with zero length
+ (NSArray<NSString *> *)removeEmptyEntries:(NSArray<NSString *> *)items;

/// split self by separator
- (NSArray<NSString *> *)split:(NSString *)separator;

/// split self by every char
- (NSArray<NSString *> *)splitByChars:(NSString *)chars;

/// split self by whitespace and newline
- (NSArray<NSString *> *)split;

- (NSArray<NSString *> *)arrayWithWordTokenize;
- (NSString *)separatedStringWithSeparator:(NSString *)separator;

- (NSString *)toPinyin;

@end

NS_ASSUME_NONNULL_END

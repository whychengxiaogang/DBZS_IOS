//
//  NSDictionary+JSON.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/9.
//  Copyright © 2016年 jianyi. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)

- (NSString*)jsonString;

+ (NSDictionary*)initWithJsonString:(NSString*)json;

@end

//
//  NSArray+JSON.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/9.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JSON)

- (NSString*)jsonString;

+ (NSArray*)initWithJsonString:(NSString*)json;

@end

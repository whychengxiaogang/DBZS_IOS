//
//  NSArray+JSON.m
//  dbzs_IOS
//
//  Created by jianyi on 16/9/9.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "NSArray+JSON.h"

@implementation NSArray (JSON)

- (NSString*)jsonString
{
    NSData* infoJsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    NSString* json = [[NSString alloc] initWithData:infoJsonData encoding:NSUTF8StringEncoding];
    return json;
}

+ (NSArray*)initWithJsonString:(NSString*)json
{
    NSData* infoData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSArray* info = [NSJSONSerialization JSONObjectWithData:infoData options:0 error:nil];
    return info;
}

@end

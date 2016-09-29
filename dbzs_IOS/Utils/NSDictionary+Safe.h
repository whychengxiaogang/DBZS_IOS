//
//  LifeCircleControl.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/9.
//  Copyright © 2016年 jianyi. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSDictionary(Safe)

- (id)safeObjectForKey:(id)key;
- (int)intValueForKey:(id)key;
- (double)doubleValueForKey:(id)key;
- (float)floatValueForKey:(id)key;
- (NSString*)stringValueForKey:(id)key;
- (NSString*)unescapeStringForKey:(id)key;
- (NSDecimalNumber *)decimalValueForKey:(id)key;
@end


@interface NSMutableDictionary(Safe)

- (void)safeSetObject:(id)anObject forKey:(id)aKey;
- (void)setIntValue:(int)value forKey:(id)aKey;
- (void)setDoubleValue:(double)value forKey:(id)aKey;
- (void)setStringValueForKey:(NSString*)string forKey:(id)aKey;

@end

@interface NSArray (Exception)

- (id)objectForKey:(id)key;

@end

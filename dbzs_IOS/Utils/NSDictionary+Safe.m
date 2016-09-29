//
//  LifeCircleControl.h
//  dbzs_IOS
//
//  Created by jianyi on 16/9/9.
//  Copyright © 2016年 jianyi. All rights reserved.
//

#import "NSDictionary+Safe.h"
#import "NSString+Additions.h"

//#define isValidKey(x) (!x || [x isKindOfClass:[NSNull class]])

#define isValidKey(key) ((key) != nil && ![key isKindOfClass:[NSNull class]])
#define isValidValue(value) (((value) != nil) && ![value isKindOfClass:[NSNull class]])

@implementation NSDictionary (Safe)


- (id)safeObjectForKey:(id)key{
    if (!isValidKey(key)) {
        return nil;
    }
    id obj = [self objectForKey:key];
    if(!isValidValue(obj))
        return nil;
    return obj;
}
- (int)intValueForKey:(id)key{
    id obj = [self safeObjectForKey:key];
    return [obj intValue];
}
- (double)doubleValueForKey:(id)key{
    id obj = [self safeObjectForKey:key];
    return [obj doubleValue];
}
- (float)floatValueForKey:(id)key{
    id obj = [self safeObjectForKey:key];
    return [obj floatValue];
}
- (NSString *)stringValueForKey:(id)key{
    if (!isValidKey(key)) {
        return [NSString stringWithFormat:@"%@",@""];// 去除(null) <null>
    }
    id obj = [self objectForKey:key];
    if(!isValidValue([self objectForKey:key]))
        return [NSString stringWithFormat:@"%@",@""];//去除(null) <null>


    if ([obj respondsToSelector:@selector(stringValue)]) {
        return [obj stringValue];
    }
   
    obj = [NSString stringWithFormat:@"%@",obj];
    return obj;
}
- (NSDecimalNumber *)decimalValueForKey:(id)key{
    NSString *obj = [self stringValueForKey:key];
    if (obj == nil||obj.length==0) {
        return [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    return [NSDecimalNumber decimalNumberWithString:obj];
}

- (NSString *)unescapeStringForKey:(id)key{
    NSString *string = [self safeObjectForKey:key];
    if ([string isKindOfClass:[NSString class]]) {
        return [string unescapeHTML];
    }
    return nil;
}

@end






@implementation NSMutableDictionary(Safe)

- (void)safeSetObject:(id)anObject forKey:(id)aKey{
    if (!isValidKey(aKey)) {
        return;
    }
    if ([aKey isKindOfClass:[NSString class]]) {
        [self setValue:anObject forKey:aKey];
    }
    else{
        if (anObject != nil) {
            [self setObject:anObject forKey:aKey];
        }
        else{
            [self removeObjectForKey:aKey];
        }
    }
}
- (void)setIntValue:(int)value forKey:(id)aKey{
    [self safeSetObject:[[NSNumber numberWithInt:value] stringValue] forKey:aKey];
}
- (void)setDoubleValue:(double)value forKey:(id)aKey{
    [self safeSetObject:[[NSNumber numberWithDouble:value] stringValue] forKey:aKey];

}
- (void)setStringValueForKey:(NSString*)string forKey:(id)aKey{
    [self safeSetObject:string forKey:aKey];
}


@end


@implementation NSArray(Exception)

- (id)objectForKey:(id)key{
#ifdef DEBUG

    NSAssert(NO, @"NSArray should not call objectForKey, you should check your code!");

    return nil;
#else
 
    return nil;
#endif
}

@end

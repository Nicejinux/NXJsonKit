//
//  NSMutableDictionary+SafeSet.m
//  NXJsonKit
//
//  Created by Nicejinux on 01/02/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import "NSMutableDictionary+SafeSet.h"

@implementation NSMutableDictionary (SafeSet)

- (void)nx_safeSetObject:(id)object forKey:(NSString *)key
{
    if (object && key) {
        [self setObject:object forKey:key];
    }
}

@end

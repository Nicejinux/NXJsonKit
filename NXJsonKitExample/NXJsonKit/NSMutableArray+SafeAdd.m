//
//  NSMutableArray+SafeAdd.m
//  NXJsonKit
//
//  Created by Nicejinux on 01/02/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import "NSMutableArray+SafeAdd.h"

@implementation NSMutableArray (SafeAdd)

- (void)safeAddObject:(id)object
{
    if (object) {
        [self addObject:object];
    }
}

@end

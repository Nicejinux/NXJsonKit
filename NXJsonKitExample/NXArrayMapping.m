//
//  NXArrayMapping.m
//  NXJsonKit
//
//  Created by Nicejinux on 30/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import "NXArrayMapping.h"

@interface NXArrayMapping ()

@property (nonatomic, strong) Class onClass;
@property (nonatomic, strong) Class itemClass;
@property (nonatomic, strong) NSString *itemKey;

@end


@implementation NXArrayMapping

+ (instancetype)mapForArrayItemClass:(Class)itemClass itemKey:(NSString *)itemKey onClass:(Class)onClass
{
    return [[self alloc] initWithArrayItemClass:itemClass itemKey:itemKey onClass:onClass];
}


- (instancetype)initWithArrayItemClass:(Class)itemClass itemKey:(NSString *)itemKey onClass:(Class)onClass
{
    self = [super init];
    if (self) {
        _onClass = onClass;
        _itemClass = itemClass;
        _itemKey = itemKey;
    }
    
    return self;
}

@end

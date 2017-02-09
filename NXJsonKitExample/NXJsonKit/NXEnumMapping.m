//
//  NXEnumMapping.m
//  NXJsonKit
//
//  Created by Nicejinux on 09/02/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import "NXEnumMapping.h"

@interface NXEnumMapping ()

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSArray *enumKeyList;
@property (nonatomic, strong) Class onClass;

@end


@implementation NXEnumMapping

+ (instancetype)mapForEnumKey:(NSString *)key enumKeyList:(NSArray *)keyList onClass:(Class)onClass
{
    return [[self alloc] initWithEnumKey:key enumKeyList:keyList onClass:onClass];
}

- (instancetype)initWithEnumKey:(NSString *)key enumKeyList:(NSArray *)keyList onClass:(Class)onClass
{
    self = [super init];
    if (self) {
        _key = key;
        _enumKeyList = keyList;
        _onClass = onClass;
    }
    
    return self;
}

@end

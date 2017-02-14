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
@property (nonatomic, strong) NSArray *enumTypeList;
@property (nonatomic, strong) Class onClass;

@end


@implementation NXEnumMapping

+ (instancetype)mapForEnumKey:(NSString *)key enumTypeList:(NSArray *)typeList onClass:(Class)onClass
{
    return [[self alloc] initWithEnumKey:key enumTypeList:typeList onClass:onClass];
}

- (instancetype)initWithEnumKey:(NSString *)key enumTypeList:(NSArray *)typeList onClass:(Class)onClass
{
    self = [super init];
    if (self) {
        _key = key;
        _enumTypeList = typeList;
        _onClass = onClass;
    }
    
    return self;
}

@end

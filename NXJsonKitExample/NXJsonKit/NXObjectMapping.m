//
//  NXObjectMapping.m
//  NXJsonKit
//
//  Created by Nicejinux on 30/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import "NXObjectMapping.h"

@interface NXObjectMapping ()

@property (nonatomic, strong) NSString *jsonKey;
@property (nonatomic, strong) NSString *modelKey;
@property (nonatomic, strong) Class onClass;

@end

@implementation NXObjectMapping

+ (instancetype)mapForJsonKey:(NSString *)jsonKey toModelKey:(NSString *)modelKey onClass:(Class)onClass
{
    return [[self alloc] initWithJsonKey:jsonKey toModelKey:modelKey onClass:onClass];
}


- (instancetype)initWithJsonKey:(NSString *)jsonKey toModelKey:(NSString *)modelKey onClass:(Class)onClass
{
    self = [super init];
    if (self) {
        _jsonKey = jsonKey;
        _modelKey = modelKey;
        _onClass = onClass;
    }
    
    return self;
}

@end

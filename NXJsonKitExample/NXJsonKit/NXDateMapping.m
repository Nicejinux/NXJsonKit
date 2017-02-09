//
//  NXDateMapping.m
//  NXJsonKit
//
//  Created by Nicejinux on 09/02/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import "NXDateMapping.h"

@interface NXDateMapping ()

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *formatter;
@property (nonatomic, strong) Class onClass;

@end

@implementation NXDateMapping

+ (instancetype)mapForDateKey:(NSString *)key formatter:(NSString *)formatter onClass:(Class)onClass
{
    return [[self alloc] initWithDateKey:key formatter:formatter onClass:onClass];
}


- (instancetype)initWithDateKey:(NSString *)key formatter:(NSString *)formatter onClass:(Class)onClass
{
    self = [super init];
    if (self) {
        _key = key;
        _formatter = formatter;
        _onClass = onClass;
    }
    
    return self;
}

@end

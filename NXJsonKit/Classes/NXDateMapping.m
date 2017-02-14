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
@property (nonatomic, strong) NSString *format;
@property (nonatomic, strong) Class onClass;

@end

@implementation NXDateMapping

+ (instancetype)mapForDateKey:(NSString *)key format:(NSString *)format onClass:(Class)onClass
{
    return [[self alloc] initWithDateKey:key format:format onClass:onClass];
}


- (instancetype)initWithDateKey:(NSString *)key format:(NSString *)format onClass:(Class)onClass
{
    self = [super init];
    if (self) {
        _key = key;
        _format = format;
        _onClass = onClass;
    }
    
    return self;
}

@end

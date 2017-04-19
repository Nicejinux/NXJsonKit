//
//  NXJsonKit.m
//  NXJsonKit
//
//  Created by Nicejinux on 22/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//


#import <objc/runtime.h>
#import "NXJsonKit.h"
#import "NXPropertyExtractor.h"
#import "NXObjectMapping.h"
#import "NXArrayMapping.h"
#import "NXClassAttribute.h"
#import "NXNotNull.h"

#import "NSMutableArray+SafeAdd.h"
#import "NSMutableDictionary+SafeSet.h"

@interface NXJsonKit ()

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NXMapper *mapper;
@property (nonatomic, weak) id <NXNotNull> delegate;

@end


@implementation NXJsonKit

- (instancetype)initWithJsonData:(NSDictionary *)data
{
    return [self initWithJsonData:data mapper:[NXMapper new]];
}


- (instancetype)initWithJsonData:(NSDictionary *)data mapper:(NXMapper *)mapper
{
    self = [super init];
    if (self) {
        _data = data;
        _mapper = mapper;
    }
    
    return self;
}


- (id)mappedObjectForClass:(Class)klass
{
    if (!klass) {
        return nil;
    }
    
    id mappedObject = [[klass alloc] init];
    if ([mappedObject conformsToProtocol:@protocol(NXNotNull)]) {
        _delegate = mappedObject;
    }

    [self mapForClass:(klass) instance:mappedObject];
    
    return mappedObject;
}


- (void)mapForClass:(Class)class instance:(id)instance
{
    NXPropertyExtractor *extractor = [[NXPropertyExtractor alloc] initWithClass:class];
    NSArray *attributeList = [extractor attributeList];
    for (NXClassAttribute *attribute in attributeList) {
        [self setValueForClassProperties:attribute instance:instance parentClass:class];
    }
}


- (BOOL)isUserDefinedClass:(Class)class
{
    if (!class) {
        return NO;
    }
    
    if ([class isSubclassOfClass:[NSString class]]) {
        return NO;
    } else if ([class isSubclassOfClass:[NSNumber class]]) {
        return NO;
    } else if ([class isSubclassOfClass:[NSArray class]]) {
        return NO;
    } else if ([class isSubclassOfClass:[NSDictionary class]]) {
        return NO;
    } else if ([class isSubclassOfClass:[NSDate class]]) {
        return NO;
    }
    
    return YES;
}


- (id)objectForPropertyName:(NXClassAttribute *)attribute onClass:(Class)onClass
{
    // check custom mapping key
    NSString *key = [_mapper objectKeyWithPropertyName:attribute.propertyName onClass:onClass];
    if (!key) {
        key = attribute.propertyName;
    }
    
    id data = _data[key];
    if ([data isKindOfClass:[NSString class]]) {
        // NSString type date string to NSDate
        BOOL hasDateMapping = [_mapper hasDateMappingWithPropertyName:attribute.propertyName onClass:onClass];
        if (hasDateMapping) {
            return [_mapper dateWithPropertyName:attribute.propertyName dateString:data onClass:onClass];
        }
        
        // NSString type enum string to enum
        BOOL hasEnumMapping = [_mapper hasEnumMappingWithPropertyName:attribute.propertyName onClass:onClass];
        if (hasEnumMapping) {
            return [NSNumber numberWithInteger:[_mapper enumWithPropertyName:attribute.propertyName enumString:data onClass:onClass]];
        }
    }
    
    if (!data) {
        if (attribute.hasNotNullProtocol) {
            if ([_delegate respondsToSelector:@selector(propertyWillSetNil:propertyClass:)]) {
                [_delegate propertyWillSetNil:attribute.propertyName propertyClass:attribute.classOfProperty];
            }
        }
    }
    
    return data;
}


- (void)setValueForClassProperties:(NXClassAttribute *)attribute instance:(id)instance parentClass:(Class)parentClass
{
    // parameter validation
    if (!attribute.classOfProperty || !attribute.propertyName || !instance || !parentClass) {
        return;
    }
    
    // check custom mapping key
    id object = [self objectForPropertyName:attribute onClass:parentClass];
    if (!object) {
        return;
    }
    
    // if object is NSDictionary, should check whether object is custom class or not.
    if (![object isKindOfClass:attribute.classOfProperty]) {
        if ([object isKindOfClass:[NSDictionary class]] && ![self isUserDefinedClass:attribute.classOfProperty]) {
            return;
        }
    }
    
    if ([self isUserDefinedClass:attribute.classOfProperty]) {
        id mappedObject = [self userDefinedObjectFromObject:object class:attribute.classOfProperty];
        [instance setValue:mappedObject forKey:attribute.propertyName];
    } else if ([object isKindOfClass:[NSString class]]) {
        [instance setValue:[[NSString alloc] initWithString:object] forKey:attribute.propertyName];
    } else if ([object isKindOfClass:[NSDate class]]) {
        [instance setValue:object forKey:attribute.propertyName];
    } else if ([object isKindOfClass:[NSNumber class]]) {
        [instance setValue:object forKey:attribute.propertyName];
    } else if ([object isKindOfClass:[NSArray class]]) {
        Class itemClass = [_mapper arrayItemClassWithPropertyName:attribute.propertyName onClass:parentClass defaultClass:attribute.classOfProperty];
        NSMutableArray *mappedObject = [self arrayValueFromObject:object itemClass:itemClass propertyName:attribute.propertyName];
        [instance setValue:mappedObject forKey:attribute.propertyName];
    }
}


- (NSMutableDictionary *)dictionaryValueFromObject:(NSDictionary *)objectDic class:(Class)class key:(NSString *)keyForObjectDic
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    for (NSString *key in objectDic.allKeys) {
        id object = objectDic[key];
        
        if ([self isUserDefinedClass:class]) {
            [dic safeSetObject:[self userDefinedObjectFromObject:object class:class] forKey:key];
        } else if ([object isKindOfClass:[NSString class]]) {
            [dic safeSetObject:[[NSString alloc] initWithString:object] forKey:key];
        } else if ([object isKindOfClass:[NSNumber class]]) {
            [dic setObject:object forKey:key];
        } else if ([object isKindOfClass:[NSArray class]]) {
            [dic safeSetObject:[self arrayValueFromObject:object itemClass:class propertyName:key] forKey:key];
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            [dic safeSetObject:[self dictionaryValueFromObject:object class:class key:key] forKey:key];
        }
    }
    
    return dic;
}


- (NSMutableArray *)arrayValueFromObject:(NSArray *)objectList itemClass:(Class)itemClass propertyName:(NSString *)name
{
    NSMutableArray *array = [NSMutableArray new];
    
    for (id object in objectList) {
        if ([self isUserDefinedClass:itemClass]) {
            [array safeAddObject:[self userDefinedObjectFromObject:object class:itemClass]];
        } else if ([object isKindOfClass:[NSString class]]) {
            [array safeAddObject:[[NSString alloc] initWithString:object]];
        } else if ([object isKindOfClass:[NSNumber class]]) {
            [array addObject:object];
        } else if ([object isKindOfClass:[NSArray class]]) {
            [array safeAddObject:[self arrayValueFromObject:object itemClass:itemClass propertyName:name]];
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            [array safeAddObject:[self dictionaryValueFromObject:object class:itemClass key:name]];
        }
    }
    
    return array;
}


- (id)userDefinedObjectFromObject:(id)object class:(Class)class
{
    NXJsonKit *jsonKit = [[NXJsonKit alloc] initWithJsonData:object mapper:_mapper];
    
    id mappedObject = [jsonKit mappedObjectForClass:class];
    
    return mappedObject;
}


@end

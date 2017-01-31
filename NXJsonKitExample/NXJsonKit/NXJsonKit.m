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

#import "NSMutableArray+SafeAdd.h"
#import "NSMutableDictionary+SafeSet.h"

@interface NXJsonKit ()

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSMutableDictionary *arrayItemMap;
@property (nonatomic, strong) NSMutableDictionary *objectMap;

@end

@implementation NXJsonKit

- (instancetype)initWithJsonData:(NSDictionary *)data
{
    return [self initWithJsonData:data arrayItemMap:[NSMutableDictionary new] objectMap:[NSMutableDictionary new]];
}


- (instancetype)initWithJsonData:(NSDictionary *)data arrayItemMap:(NSMutableDictionary *)arrayDic objectMap:(NSMutableDictionary *)dictionaryDic
{
    self = [super init];
    if (self) {
        _data = data;
        _arrayItemMap = arrayDic;
        _objectMap = dictionaryDic;
    }
    
    return self;
}


- (void)addMappingForArrayItem:(NXArrayMapping *)mapping
{
    if (!mapping.itemKey || !mapping.itemClass || !mapping.onClass) {
        return;
    }
    
    NSMutableDictionary *dic = _arrayItemMap[NSStringFromClass(mapping.onClass)];
    if (!dic) {
        dic = [NSMutableDictionary new];
        _arrayItemMap[NSStringFromClass(mapping.onClass)] = dic;
    }
    
    dic[mapping.itemKey] = NSStringFromClass(mapping.itemClass);
}


- (void)addMappingForObject:(NXObjectMapping *)mapping
{
    if (!mapping.jsonKey || !mapping.modelKey || !mapping.onClass) {
        return;
    }
    
    NSMutableDictionary *dic = _objectMap[NSStringFromClass(mapping.onClass)];
    if (!dic) {
        dic = [NSMutableDictionary new];
        _objectMap[NSStringFromClass(mapping.onClass)] = dic;
    }
    
    dic[mapping.modelKey] = mapping.jsonKey;
}


- (id)mappedObjectForClass:(Class)class
{
    if (!class) {
        return nil;
    }
    
    id mappedObject = [[class alloc] init];

    [self mapForClass:(class) instance:mappedObject];
    
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
    if ([class isSubclassOfClass:[NSString class]]) {
        return NO;
    } else if ([class isSubclassOfClass:[NSNumber class]]) {
        return NO;
    } else if ([class isSubclassOfClass:[NSArray class]]) {
        return NO;
    } else if ([class isSubclassOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    return YES;
}


- (id)objectForPropertyName:(NSString *)name onClass:(Class)onClass
{
    // check custom mapping key
    NSString *key = [self objectKeyWithPropertyName:name onClass:onClass];
    if (!key) {
        key = name;
    }
    
    return _data[key];
}


- (void)setValueForClassProperties:(NXClassAttribute *)attribute instance:(id)instance parentClass:(Class)parentClass
{
    // parameter validation
    if (!attribute.classOfProperty || !attribute.propertyName || !instance || !parentClass) {
        return;
    }
    
    // check custom mapping key
    id object = [self objectForPropertyName:attribute.propertyName onClass:parentClass];
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
    } else if ([object isKindOfClass:[NSNumber class]]) {
        [instance setValue:object forKey:attribute.propertyName];
    } else if ([object isKindOfClass:[NSArray class]]) {
        Class itemClass = [self arrayItemClassWithPropertyName:attribute.propertyName onClass:parentClass defaultClass:attribute.classOfProperty];
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
    NXJsonKit *jsonKit = [[NXJsonKit alloc] initWithJsonData:object arrayItemMap:_arrayItemMap objectMap:_objectMap];
    
    id mappedObject = [jsonKit mappedObjectForClass:class];
    
    return mappedObject;
}


- (Class)arrayItemClassWithPropertyName:(NSString *)name onClass:(Class)onClass defaultClass:(Class)defaultClass
{
    if (!name || !onClass) {
        return defaultClass;
    }
    
    NSString *classKey = NSStringFromClass(onClass);
    if (!classKey) {
        return defaultClass;
    }
    
    NSDictionary *dic = _arrayItemMap[classKey];
    NSString *className = dic[name];
    Class targetClass = defaultClass;
    if (className) {
        targetClass = NSClassFromString(className);
    }
    
    return targetClass;
}


- (NSString *)objectKeyWithPropertyName:(NSString *)name onClass:(Class)onClass
{
    if (!name || !onClass) {
        return nil;
    }
    
    NSString *classKey = NSStringFromClass(onClass);
    if (!classKey) {
        return nil;
    }

    NSDictionary *dic = _objectMap[classKey];
    return dic[name];
}


@end

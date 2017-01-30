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
    NSArray *propertyNames = [extractor propertyNames];
    for (NSString *name in propertyNames) {
        Class classOfProperty = [extractor classOfProperty:name];
        [self setValueForClass:classOfProperty propertyName:name instance:instance parentClass:class];
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


- (void)setValueForClass:(Class)class propertyName:(NSString *)name instance:(id)instance parentClass:(Class)parentClass
{
    // parameter validation
    if (!class || !name || !instance || !parentClass) {
        return;
    }
    
    // check custom mapping key
    NSString *key = [self objectKeyWithPropertyName:name onClass:parentClass];
    if (!key) {
        key = name;
    }
    
    id object = _data[key];
    if (!object) {
        return;
    }
    
    if (![object isKindOfClass:class]) {
        if ([object isKindOfClass:[NSDictionary class]] && ![self isUserDefinedClass:class]) {
            return;
        }
    }
    
    if ([self isUserDefinedClass:class]) {
        id copiedObject = [self userDefinedObjectFromObject:object class:class];
        [instance setValue:copiedObject forKey:name];
    } else if ([object isKindOfClass:[NSString class]]) {
        NSString *copiedObject = [[NSString alloc] initWithString:object];
        [instance setValue:copiedObject forKey:name];
    } else if ([object isKindOfClass:[NSNumber class]]) {
            [instance setValue:object forKey:name];
    } else if ([object isKindOfClass:[NSArray class]]) {
        Class itemClass = [self arrayItemClassWithPropertyName:name onClass:parentClass];
        if (!itemClass) {
            itemClass = class;
        }
        NSMutableArray *copiedObject = [self arrayValueFromObject:object itemClass:itemClass propertyName:name];
        [instance setValue:copiedObject forKey:name];
    }
}


- (NSMutableDictionary *)dictionaryValueFromObject:(NSDictionary *)objectDic class:(Class)class key:(NSString *)keyForObjectDic
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    for (NSString *key in objectDic.allKeys) {
        id object = objectDic[key];
        
        if ([self isUserDefinedClass:class]) {
            dic[key] = [self userDefinedObjectFromObject:object class:class];
        } else if ([object isKindOfClass:[NSString class]]) {
            dic[key] = [[NSString alloc] initWithString:object];
        } else if ([object isKindOfClass:[NSNumber class]]) {
            dic[key] = object;
        } else if ([object isKindOfClass:[NSArray class]]) {
            dic[key] = [self arrayValueFromObject:object itemClass:class propertyName:key];
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            dic[key] = [self dictionaryValueFromObject:object class:class key:key];
        }
    }
    
    return dic;
}


- (NSMutableArray *)arrayValueFromObject:(NSArray *)objectList itemClass:(Class)itemClass propertyName:(NSString *)name
{
    NSMutableArray *array = [NSMutableArray new];
    
    for (id object in objectList) {
        if ([self isUserDefinedClass:itemClass]) {
            [array addObject:[self userDefinedObjectFromObject:object class:itemClass]];
        } else if ([object isKindOfClass:[NSString class]]) {
            [array addObject:[[NSString alloc] initWithString:object]];
        } else if ([object isKindOfClass:[NSNumber class]]) {
            [array addObject:object];
        } else if ([object isKindOfClass:[NSArray class]]) {
            [array addObject:[self arrayValueFromObject:object itemClass:itemClass propertyName:name]];
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            [array addObject:[self dictionaryValueFromObject:object class:itemClass key:name]];
        }
    }
    
    return array;
}


- (id)userDefinedObjectFromObject:(id)object class:(Class)class
{
    NXJsonKit *jsonKit = [[NXJsonKit alloc] initWithJsonData:object arrayItemMap:_arrayItemMap objectMap:_objectMap];
    typeof(class) mappedObject = (typeof(class))[jsonKit mappedObjectForClass:class];
    
    return mappedObject;
}


- (Class)arrayItemClassWithPropertyName:(NSString *)name onClass:(Class)onClass
{
    if (!name || !onClass) {
        return nil;
    }
    
    NSString *classKey = NSStringFromClass(onClass);
    if (!classKey) {
        return nil;
    }
    
    NSDictionary *dic = _arrayItemMap[classKey];
    NSString *className = dic[name];
    Class targetClass = nil;
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

//
//  NXJsonKit.m
//  NXJsonKit
//
//  Created by Nicejinux on 22/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//


#import <objc/runtime.h>
#import "NXJsonKit.h"
#import "NXPropertyMapConfig.h"
#import "NXPropertyExtractor.h"


@interface NXJsonKit ()

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSMutableDictionary *arrayItemTargetConfig;
@property (nonatomic, strong) NSMutableDictionary *dictionaryValueTargetConfig;

@end

@implementation NXJsonKit

- (instancetype)initWithJsonData:(NSDictionary *)data
{
    return [self initWithJsonData:data arrayConfig:[NSMutableDictionary new] dictionaryConfig:[NSMutableDictionary new]];
}


- (instancetype)initWithJsonData:(NSDictionary *)data arrayConfig:(NSMutableDictionary *)arrayDic dictionaryConfig:(NSMutableDictionary *)dictionaryDic
{
    self = [super init];
    if (self) {
        _data = data;
        _arrayItemTargetConfig = arrayDic;
        _dictionaryValueTargetConfig = dictionaryDic;
    }
    
    return self;
}


- (void)addConfigForArrayItem:(NXPropertyMapConfig *)config
{
    if (!config.propertyName || !config.targetClass || !config.parentClass) {
        return;
    }
    
    NSMutableDictionary *dic = _arrayItemTargetConfig[NSStringFromClass(config.parentClass)];
    if (!dic) {
        dic = [NSMutableDictionary new];
        _arrayItemTargetConfig[NSStringFromClass(config.parentClass)] = dic;
    }
    
    dic[config.propertyName] = NSStringFromClass(config.targetClass);
}


- (void)addConfigForDictionaryValue:(NXPropertyMapConfig *)config
{
    if (!config.propertyName || !config.targetClass || !config.parentClass) {
        return;
    }
    
    NSMutableDictionary *dic = _dictionaryValueTargetConfig[NSStringFromClass(config.parentClass)];
    if (!dic) {
        dic = [NSMutableDictionary new];
        _dictionaryValueTargetConfig[NSStringFromClass(config.parentClass)] = dic;
    }
    
    dic[config.propertyName] = NSStringFromClass(config.targetClass);
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
    id object = _data[name];
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
        Class itemClass = [self arrayItemClassWithParentClass:parentClass propertyName:name];
        if (!itemClass) {
            itemClass = class;
        }
        NSMutableArray *copiedObject = [self arrayValueFromObject:object class:itemClass propertyName:name];
        [instance setValue:copiedObject forKey:name];
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        Class valueClass = [self dictionaryValueClassWithParentClass:parentClass key:name];
        if (!valueClass) {
            valueClass = class;
        }
        NSMutableDictionary *copiedObject = [self dictionaryValueFromObject:object class:valueClass key:name];
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
            dic[key] = [self arrayValueFromObject:object class:class propertyName:key];
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            dic[key] = [self dictionaryValueFromObject:object class:class key:key];
        }
    }
    
    return dic;
}


- (NSMutableArray *)arrayValueFromObject:(NSArray *)objectList class:(Class)class propertyName:(NSString *)name
{
    NSMutableArray *array = [NSMutableArray new];
    
    for (id object in objectList) {
        if ([self isUserDefinedClass:class]) {
            [array addObject:[self userDefinedObjectFromObject:object class:class]];
        } else if ([object isKindOfClass:[NSString class]]) {
            [array addObject:[[NSString alloc] initWithString:object]];
        } else if ([object isKindOfClass:[NSNumber class]]) {
            [array addObject:object];
        } else if ([object isKindOfClass:[NSArray class]]) {
            [array addObject:[self arrayValueFromObject:object class:class propertyName:name]];
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            [array addObject:[self dictionaryValueFromObject:object class:class key:name]];
        }
    }
    
    return array;
}


- (id)userDefinedObjectFromObject:(id)object class:(Class)class
{
    NXJsonKit *jsonKit = [[NXJsonKit alloc] initWithJsonData:object arrayConfig:_arrayItemTargetConfig dictionaryConfig:_dictionaryValueTargetConfig];
    typeof(class) mappedObject = (typeof(class))[jsonKit mappedObjectForClass:class];
    
    return mappedObject;
}


- (Class)arrayItemClassWithParentClass:(Class)parentClass propertyName:(NSString *)name
{
    NSString *classKey = NSStringFromClass(parentClass);
    if (!classKey) {
        return nil;
    }
    
    NSDictionary *dic = _arrayItemTargetConfig[classKey];
    NSString *className = dic[name];
    Class targetClass = nil;
    if (className) {
        targetClass = NSClassFromString(className);
    }
    
    return targetClass;
}


- (Class)dictionaryValueClassWithParentClass:(Class)parentClass key:(NSString *)key
{
    NSString *classKey = NSStringFromClass(parentClass);
    if (!classKey) {
        return nil;
    }

    NSDictionary *dic = _dictionaryValueTargetConfig[classKey];
    NSString *className = dic[key];
    Class targetClass = nil;
    if (className) {
        targetClass = NSClassFromString(className);
    }
    
    return targetClass;
}

@end

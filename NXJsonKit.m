//
//  NXJsonKit.m
//  test
//
//  Created by Nicejinux on 22/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//


#import <objc/runtime.h>
#import "NXJsonKit.h"

@implementation NXJsonKitConfig

@end


@interface NXJsonKit ()

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSMutableDictionary *arrayItemTargetConfig;
@property (nonatomic, strong) NSMutableDictionary *dictionaryValueTargetConfig;

@end

@implementation NXJsonKit

- (instancetype)initWithJsonData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        _data = data;
        _arrayItemTargetConfig = [NSMutableDictionary new];
        _dictionaryValueTargetConfig = [NSMutableDictionary new];
    }
    
    return self;
}


- (void)appendConfigForArrayItemTargetClass:(Class)class propertyName:(NSString *)name containerClass:(Class)containerClass
{
    if (!name || !class) {
        return;
    }
    
    NSMutableDictionary *dic = _arrayItemTargetConfig[NSStringFromClass(containerClass)];
    if (!dic) {
        dic = [NSMutableDictionary new];
        _arrayItemTargetConfig[NSStringFromClass(containerClass)] = dic;
    }
    
    dic[name] = NSStringFromClass(class);
}


- (void)appendConfigForDictionaryValueTargetClass:(Class)class key:(NSString *)key containerClass:(Class)containerClass
{
    if (!key || !class) {
        return;
    }
    
    NSMutableDictionary *dic = _dictionaryValueTargetConfig[NSStringFromClass(containerClass)];
    if (!dic) {
        dic = [NSMutableDictionary new];
        _dictionaryValueTargetConfig[NSStringFromClass(containerClass)] = dic;
    }
    
    dic[key] = NSStringFromClass(class);
}



- (id)mappedObjectForClass:(Class)class
{
    id mappedObject = [[class alloc] init];

    [self mapForClass:(class) instance:mappedObject];
    
    return mappedObject;
}


- (void)mapForClass:(Class)class instance:(id)instance
{
    NSArray *allPropertyNames = [self allPropertyNamesForClass:class];
    for (NSString *name in allPropertyNames) {
        Class classOfProperty = [self classOfProperty:class named:name];
        [self setValueForClass:classOfProperty propertyName:name instance:instance containerClass:class];
    }
}


- (Class)classOfProperty:(Class)class named:(NSString *)name
{
    // Get Class of property to be populated.
    Class propertyClass = nil;
    objc_property_t property = class_getProperty(class, [name UTF8String]);
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
    
    if (splitPropertyAttributes.count > 0) {
        NSString *encodeType = splitPropertyAttributes[0];
        NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
        NSString *className = splitEncodeType[1];
        propertyClass = NSClassFromString(className);
    }
    
    return propertyClass;
}


- (NSMutableArray *)propertyNamesOfClass:(Class)klass
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(klass, &count);
    
    NSMutableArray *nameList = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        if (name) {
            [nameList addObject:name];
        }
    }
    
    free(properties);
    
    return nameList;
}


- (NSArray *)allPropertyNamesForClass:(Class)class
{
    NSMutableArray *classes = [NSMutableArray array];
    Class targetClass = class;
    while (targetClass != nil && targetClass != [NSObject class]) {
        [classes addObject:targetClass];
        targetClass = class_getSuperclass(targetClass);
    }
    
    NSMutableArray *names = [NSMutableArray array];
    [classes enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(Class targetClass, NSUInteger idx, BOOL *stop) {
        [names addObjectsFromArray:[self propertyNamesOfClass:targetClass]];
    }];
    
    return names;
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


- (void)setValueForClass:(Class)class propertyName:(NSString *)name instance:(id)instance containerClass:(Class)containerClass
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
        Class itemClass = [self arrayItemClassWithContainerClass:containerClass propertyName:name];
        if (!itemClass) {
            itemClass = class;
        }
        NSMutableArray *copiedObject = [self arrayValueFromObject:object class:itemClass propertyName:name];
        [instance setValue:copiedObject forKey:name];
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        Class valueClass = [self dictionaryValueClassWithContainerClass:containerClass key:name];
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
    NXJsonKit *jsonKit = [[NXJsonKit alloc] initWithJsonData:object];
    typeof(class) mappedObject = (typeof(class))[jsonKit mappedObjectForClass:class];
    
    return mappedObject;
}


- (Class)arrayItemClassWithContainerClass:(Class)containerClass propertyName:(NSString *)name
{
    NSDictionary *dic = _arrayItemTargetConfig[NSStringFromClass(containerClass)];
    NSString *className = dic[name];
    Class targetClass = nil;
    if (className) {
        targetClass = NSClassFromString(className);
    }
    return targetClass;
}


- (Class)dictionaryValueClassWithContainerClass:(Class)containerClass key:(NSString *)key
{
    NSDictionary *dic = _dictionaryValueTargetConfig[NSStringFromClass(containerClass)];
    
    NSString *className = dic[key];
    Class targetClass = nil;
    if (className) {
        targetClass = NSClassFromString(className);
    }
    return targetClass;
}

@end

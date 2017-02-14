//
//  NXMapper.m
//  NXJsonKitExample
//
//  Created by Nicejinux on 09/02/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import "NXMapper.h"

@interface NXMapper ()

@property (nonatomic, strong) NSMutableDictionary *arrayItemMap;
@property (nonatomic, strong) NSMutableDictionary *objectMap;
@property (nonatomic, strong) NSMutableDictionary *dateMap;
@property (nonatomic, strong) NSMutableDictionary *enumMap;

@end


@implementation NXMapper

- (instancetype)init
{
    self = [super init];
    if (self) {
        _arrayItemMap = [NSMutableDictionary new];
        _objectMap = [NSMutableDictionary new];
        _dateMap = [NSMutableDictionary new];
        _enumMap = [NSMutableDictionary new];
    }
    
    return self;
}


- (void)addDateMapping:(NXDateMapping *)mapping
{
    if (!mapping.key || !mapping.format || !mapping.onClass) {
        return;
    }
    
    NSMutableDictionary *dic = _dateMap[NSStringFromClass(mapping.onClass)];
    if (!dic) {
        dic = [NSMutableDictionary new];
        _dateMap[NSStringFromClass(mapping.onClass)] = dic;
    }
    
    dic[mapping.key] = mapping.format;
}


- (void)addEnumMapping:(NXEnumMapping *)mapping
{
    if (!mapping.key || mapping.enumTypeList.count == 0 || !mapping.onClass) {
        return;
    }
    
    NSMutableDictionary *dic = _enumMap[NSStringFromClass(mapping.onClass)];
    if (!dic) {
        dic = [NSMutableDictionary new];
        _enumMap[NSStringFromClass(mapping.onClass)] = dic;
    }
    
    dic[mapping.key] = mapping.enumTypeList;
}


- (void)addArrayMapping:(NXArrayMapping *)mapping
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


- (void)addObjectMapping:(NXObjectMapping *)mapping
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


- (NSDate *)dateWithPropertyName:(NSString *)name dateString:(NSString *)dateString onClass:(Class)onClass
{
    if (!dateString || ![dateString isKindOfClass:[NSString class]]) {
        return nil;
    }

    NSString *format = [self dateFormatWithPropertyName:name onClass:onClass];
    if (!format) {
        return nil;
    }
    
    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
    dateFormmater.dateFormat = format;
    dateFormmater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    
    NSDate *date = [dateFormmater dateFromString:dateString];
    return date;
}


- (NSInteger)enumWithPropertyName:(NSString *)name enumString:(NSString *)enumString onClass:(Class)onClass
{
    if (!enumString || ![enumString isKindOfClass:[NSString class]]) {
        return 0;
    }
    
    NSArray *enumList = [self enumTypeListWithPropertyName:name onClass:onClass];
    if (!enumList || enumList.count == 0) {
        return 0;
    }

    NSUInteger index = [enumList indexOfObject:enumString];
    if (index == NSNotFound) {
        return 0;
    }
    
    return index;
}


- (BOOL)hasDateMappingWithPropertyName:(NSString *)name onClass:(Class)onClass
{
    if ([self dateFormatWithPropertyName:name onClass:onClass]) {
        return YES;
    }
    
    return NO;
}


- (BOOL)hasEnumMappingWithPropertyName:(NSString *)name onClass:(Class)onClass
{
    if ([self enumTypeListWithPropertyName:name onClass:onClass]) {
        return YES;
    }
    
    return NO;
}



- (NSString *)dateFormatWithPropertyName:(NSString *)name onClass:(Class)onClass
{
    if (!name || !onClass) {
        return nil;
    }
    
    NSString *classKey = NSStringFromClass(onClass);
    if (!classKey) {
        return nil;
    }

    NSDictionary *dic = _dateMap[classKey];

    return dic[name];
}


- (NSArray *)enumTypeListWithPropertyName:(NSString *)name onClass:(Class)onClass
{
    if (!name || !onClass) {
        return nil;
    }
    
    NSString *classKey = NSStringFromClass(onClass);
    if (!classKey) {
        return nil;
    }
    
    NSDictionary *dic = _enumMap[classKey];
    
    return dic[name];
}

@end

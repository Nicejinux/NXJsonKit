//
//  NXPropertyExtractor.m
//  NXJsonKit
//
//  Created by Nicejinux on 25/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <objc/runtime.h>
#import "NXPropertyExtractor.h"

@interface NXPropertyExtractor ()

@property (nonatomic, strong) Class class;
@property (nonatomic, strong) NSArray *propertyNames;

@end

@implementation NXPropertyExtractor

- (instancetype)initWithClass:(Class)class
{
    self = [super init];
    if (self) {
        _class = class;
        _propertyNames = [self allPropertyNames];
    }
    
    return self;
}


- (NSArray *)propertyNames
{
    return _propertyNames;
}


- (Class)classOfProperty:(NSString *)propertyName
{
    return [self classOfProperty:_class named:propertyName];
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


- (NSArray *)allPropertyNames
{
    if (!_class) {
        return nil;
    }
    
    NSMutableArray *classes = [NSMutableArray array];
    Class targetClass = _class;
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



@end

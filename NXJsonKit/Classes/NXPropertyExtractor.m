//
//  NXPropertyExtractor.m
//  NXJsonKit
//
//  Created by Nicejinux on 25/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <objc/runtime.h>
#import "NXPropertyExtractor.h"
#import "NXClassAttribute.h"

static NSString * const NotNullProtocolName = @"<NXNotNull>";

@interface NXPropertyExtractor ()

@property (nonatomic, strong) Class class;
@property (nonatomic, strong) NSMutableArray <NSString *> *propertyNames;
@property (nonatomic, strong) NSMutableArray <NXClassAttribute *> *attributeList;

@end

@implementation NXPropertyExtractor

- (instancetype)initWithClass:(Class)klass
{
    self = [super init];
    if (self) {
        _class = klass;
        _propertyNames = [self allPropertyNames];
        _attributeList = [self allProperties];
    }
    
    return self;
}


# pragma mark - Public methods

- (NSArray <NXClassAttribute *> *)attributeList
{
    return _attributeList;
}


# pragma mark - Private methods

- (NSMutableArray <NXClassAttribute *> *)allProperties
{
    NSMutableArray *properties = [NSMutableArray new];
    if (!_propertyNames || _propertyNames.count == 0) {
        return properties;
    }
    
    for (NSString *propertyName in _propertyNames) {
        NSString *classNameOfProperty = [self classNameOfProperty:_class named:propertyName];
        Class classOfProperty = nil;
        BOOL hasNotNullProtocol = NO;
        
        // If you set <NXNotNull>, class name will be returned like this ("NSString<NSNotNull>")
        // so, have to remove protocol name.
        if ([classNameOfProperty containsString:NotNullProtocolName]) {
            classNameOfProperty = [classNameOfProperty stringByReplacingOccurrencesOfString:NotNullProtocolName withString:@""];
            hasNotNullProtocol = YES;
        }
        
        classOfProperty = NSClassFromString(classNameOfProperty);
        if (classOfProperty) {
            NXClassAttribute *attribute = [[NXClassAttribute alloc] init];
            attribute.classOfProperty = classOfProperty;
            attribute.propertyName = propertyName;
            attribute.hasNotNullProtocol = hasNotNullProtocol;
            [properties addObject:attribute];
        }
    }
    
    return properties;
}


- (NSMutableArray *)propertyNamesOfClass:(Class)klass
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(klass, &count);
    NSArray *builtInProperties = @[@"hash", @"superclass", @"description", @"debugDescription"];
    NSMutableArray *nameList = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        
        if ([builtInProperties containsObject:name]) {
            continue;
        }
    
        if (name) {
            [nameList addObject:name];
        }
    }
    
    free(properties);
    
    return nameList;
}


- (NSMutableArray *)allPropertyNames
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


- (NSString *)classNameOfProperty:(Class)class named:(NSString *)name
{
    // Get Class of property to be populated.
    NSString *classNameOfProperty = nil;
    objc_property_t property = class_getProperty(class, [name UTF8String]);
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
    
    if (splitPropertyAttributes.count > 0) {
        NSString *encodeType = splitPropertyAttributes[0];
        if ([encodeType isEqualToString:@"TB"] ||   // BOOL
            [encodeType isEqualToString:@"Tf"] ||   // float
            [encodeType isEqualToString:@"Td"] ||   // CGFloat, double
            [encodeType isEqualToString:@"Tq"] ||   // NSInteger
            [encodeType isEqualToString:@"Ti"] ||   // int, enum
            [encodeType isEqualToString:@"Tl"]) {   // long
            classNameOfProperty = @"NSNumber";
        } else if ([encodeType hasPrefix:@"T@"]) {
            NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
            if (splitEncodeType.count > 0) {
                classNameOfProperty = splitEncodeType[1];
            }
        }
    }
    
    return classNameOfProperty;
}



@end

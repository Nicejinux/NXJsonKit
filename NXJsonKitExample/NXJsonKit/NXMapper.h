//
//  NXMapper.h
//  NXJsonKitExample
//
//  Created by Nicejinux on 09/02/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXDateMapping.h"
#import "NXEnumMapping.h"
#import "NXArrayMapping.h"
#import "NXObjectMapping.h"

@interface NXMapper : NSObject

- (void)addDateMapping:(NXDateMapping *)mapping;
- (void)addEnumMapping:(NXEnumMapping *)mapping;
- (void)addArrayMapping:(NXArrayMapping *)mapping;
- (void)addObjectMapping:(NXObjectMapping *)mapping;

- (BOOL)hasDateMappingWithPropertyName:(NSString *)name onClass:(Class)onClass;
- (BOOL)hasEnumMappingWithPropertyName:(NSString *)name onClass:(Class)onClass;

- (Class)arrayItemClassWithPropertyName:(NSString *)name onClass:(Class)onClass defaultClass:(Class)defaultClass;
- (NSString *)objectKeyWithPropertyName:(NSString *)name onClass:(Class)onClass;
- (NSDate *)dateWithPropertyName:(NSString *)name dateString:(NSString *)dateString onClass:(Class)onClass;
- (NSInteger)enumWithPropertyName:(NSString *)name enumString:(NSString *)enumString onClass:(Class)onClass;

@end

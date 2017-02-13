//
//  NXEnumMapping.h
//  NXJsonKit
//
//  Created by Nicejinux on 09/02/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXEnumMapping : NSObject

@property (nonatomic, strong, readonly) NSString *key;
@property (nonatomic, strong, readonly) NSArray *enumTypeList;
@property (nonatomic, strong, readonly) Class onClass;

+ (instancetype)mapForEnumKey:(NSString *)key enumTypeList:(NSArray <NSString *> *)typeList onClass:(Class)onClass;

- (instancetype)initWithEnumKey:(NSString *)key enumTypeList:(NSArray <NSString *> *)typeList onClass:(Class)onClass;

@end

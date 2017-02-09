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
@property (nonatomic, strong, readonly) NSArray *enumKeyList;
@property (nonatomic, strong, readonly) Class onClass;

+ (instancetype)mapForEnumKey:(NSString *)key enumKeyList:(NSArray *)keyList onClass:(Class)onClass;

- (instancetype)initWithEnumKey:(NSString *)key enumKeyList:(NSArray *)keyList onClass:(Class)onClass;

@end

//
//  NXObjectMapping.h
//  NXJsonKit
//
//  Created by Nicejinux on 30/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXObjectMapping : NSObject

@property (nonatomic, strong, readonly) NSString *jsonKey;
@property (nonatomic, strong, readonly) NSString *modelKey;
@property (nonatomic, strong, readonly) Class onClass;

// convenient initializer
+ (instancetype)mapForJsonKey:(NSString *)jsonKey toModelKey:(NSString *)modelKey onClass:(Class)onClass;

- (instancetype)initWithJsonKey:(NSString *)jsonKey toModelKey:(NSString *)modelKey onClass:(Class)onClass;

@end

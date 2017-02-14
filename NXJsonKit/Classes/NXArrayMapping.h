//
//  NXArrayMapping.h
//  NXJsonKit
//
//  Created by Nicejinux on 30/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXArrayMapping : NSObject

@property (nonatomic, strong, readonly) Class onClass;
@property (nonatomic, strong, readonly) Class itemClass;
@property (nonatomic, strong, readonly) NSString *itemKey;

// convenient initializer
+ (instancetype)mapForArrayItemClass:(Class)itemClass itemKey:(NSString *)itemKey onClass:(Class)onClass;

- (instancetype)initWithArrayItemClass:(Class)itemClass itemKey:(NSString *)itemKey onClass:(Class)onClass;

@end

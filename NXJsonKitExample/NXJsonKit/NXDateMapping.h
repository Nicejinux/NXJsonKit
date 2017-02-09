//
//  NXDateMapping.h
//  NXJsonKit
//
//  Created by Nicejinux on 09/02/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXDateMapping : NSObject

@property (nonatomic, strong, readonly) NSString *key;
@property (nonatomic, strong, readonly) NSString *formatter;
@property (nonatomic, strong, readonly) Class onClass;

+ (instancetype)mapForDateKey:(NSString *)key formatter:(NSString *)formatter onClass:(Class)onClass;

- (instancetype)initWithDateKey:(NSString *)key formatter:(NSString *)formatter onClass:(Class)onClass;

@end

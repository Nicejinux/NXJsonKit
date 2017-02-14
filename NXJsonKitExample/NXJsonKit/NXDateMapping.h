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
@property (nonatomic, strong, readonly) NSString *format;
@property (nonatomic, strong, readonly) Class onClass;

+ (instancetype)mapForDateKey:(NSString *)key format:(NSString *)format onClass:(Class)onClass;

- (instancetype)initWithDateKey:(NSString *)key format:(NSString *)format onClass:(Class)onClass;

@end

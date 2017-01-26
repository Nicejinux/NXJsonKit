//
//  NXJsonKit.h
//  NXJsonKit
//
//  Created by Nicejinux on 22/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NXPropertyMapConfig;

@interface NXJsonKit : NSObject

- (instancetype)initWithJsonData:(NSDictionary *)data;

- (void)addConfigForArrayItem:(NXPropertyMapConfig *)config;
- (void)addConfigForDictionaryValue:(NXPropertyMapConfig *)config;

- (id)mappedObjectForClass:(Class)class;

@end


//
//  NXJsonKit.h
//  NXJsonKit
//
//  Created by Nicejinux on 22/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NXArrayMapping;
@class NXObjectMapping;

@interface NXJsonKit : NSObject

- (instancetype)initWithJsonData:(NSDictionary *)data;

- (void)addMappingForObject:(NXObjectMapping *)mapping;
- (void)addMappingForArrayItem:(NXArrayMapping *)mapping;

- (id)mappedObjectForClass:(Class)class;

@end


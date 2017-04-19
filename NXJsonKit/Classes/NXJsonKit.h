//
//  NXJsonKit.h
//  NXJsonKit
//
//  Created by Nicejinux on 22/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXMapper.h"

@interface NXJsonKit : NSObject

- (instancetype)initWithJsonData:(NSDictionary *)data;
- (instancetype)initWithJsonData:(NSDictionary *)data mapper:(NXMapper *)mapper;

- (id)mappedObjectForClass:(Class)klass;

@end


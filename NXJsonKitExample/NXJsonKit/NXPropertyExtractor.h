//
//  NXPropertyExtractor.h
//  NXJsonKit
//
//  Created by Nicejinux on 25/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NXClassAttribute;

@interface NXPropertyExtractor : NSObject

- (instancetype)initWithClass:(Class)class;

- (NSArray <NSString *> *)propertyNames;
- (Class)classOfProperty:(NSString *)propertyName;

- (NSArray <NXClassAttribute *> *)attributeList;

@end

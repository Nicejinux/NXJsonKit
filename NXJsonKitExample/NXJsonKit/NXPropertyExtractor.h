//
//  NXPropertyExtractor.h
//  NXJsonKit
//
//  Created by Nicejinux on 25/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXPropertyExtractor : NSObject

- (instancetype)initWithClass:(Class)class;

- (NSArray *)propertyNames;
- (Class)classOfProperty:(NSString *)propertyName;

@end

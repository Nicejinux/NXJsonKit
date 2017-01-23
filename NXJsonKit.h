//
//  NXJsonKit.h
//  test
//
//  Created by Nicejinux on 22/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXJsonKit : NSObject

- (instancetype)initWithJsonData:(NSDictionary *)data;

- (id)mappedObjectForClass:(Class)class;

@end

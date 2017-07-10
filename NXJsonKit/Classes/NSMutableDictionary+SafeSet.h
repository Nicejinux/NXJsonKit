//
//  NSMutableDictionary+SafeSet.h
//  NXJsonKit
//
//  Created by Nicejinux on 01/02/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SafeSet)

- (void)nx_safeSetObject:(id)object forKey:(NSString *)key;

@end

//
//  NXNotNull.h
//  NXJsonKit
//
//  Created by Nicejinux on 14/02/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NXNotNull <NSObject>
@optional

- (void)propertyWillSetNil:(NSString *)propertyName propertyClass:(Class)propertyClass;

@end

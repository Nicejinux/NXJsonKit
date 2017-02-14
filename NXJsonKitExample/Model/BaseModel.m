//
//  BaseModel.m
//  NXJsonKitExample
//
//  Created by Nicejinux on 14/02/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)propertyWillSetNil:(NSString *)propertyName propertyClass:(Class)propertyClass
{
    NSLog(@"%@ (%@) property should not be null", propertyName, propertyClass);
}

@end

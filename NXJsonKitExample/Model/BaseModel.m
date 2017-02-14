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
    // you can assert or do something else here.
    NSLog(@"%@ (%@) property should not be nil", propertyName, propertyClass);
}

@end

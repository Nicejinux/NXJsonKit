//
//  NXPropertyMapConfig.h
//  NXJsonKit
//
//  Created by Nicejinux on 26/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXPropertyMapConfig : NSObject

@property (nonatomic, strong) Class parentClass;
@property (nonatomic, strong) Class targetClass;
@property (nonatomic, strong) NSString *propertyName;

@end

//
//  NXClassAttribute.h
//  NXJsonKit
//
//  Created by Nicejinux on 31/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXClassAttribute : NSObject

@property (nonatomic, strong) Class classOfProperty;
@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic, strong) NSString *propertyType;
@property (nonatomic, assign) BOOL hasNotNullProtocol;

@end

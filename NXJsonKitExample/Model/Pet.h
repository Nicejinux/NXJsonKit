//
//  Pet.h
//  NXJsonKitExample
//
//  Created by Nicejinux on 23/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import "BaseModel.h"

@interface Pet : BaseModel

@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *age;

@end

//
//  Peoples.h
//  NXJsonKitExample
//
//  Created by Nicejinux on 01/02/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import "BaseModel.h"

@class People;

@interface Peoples : BaseModel

@property (nonatomic, strong) NSArray <People *> *peopleList;

@end

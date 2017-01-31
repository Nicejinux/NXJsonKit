//
//  Friend.h
//  NXJsonKitExample
//
//  Created by Nicejinux on 25/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Pet;

@interface Friend : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Pet *pet;

@end

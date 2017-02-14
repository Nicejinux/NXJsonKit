//
//  People.h
//  NXJsonKitExample
//
//  Created by Nicejinux on 23/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "BaseModel.h"

@class Pet;
@class Friend;

typedef NS_ENUM(NSInteger, NXJobType) {
    NXJobTypeNone = 0,
    NXJobTypeDoctor,
    NXJobTypeDeveloper,
    NXJobTypeDesigner,
};

@interface People : BaseModel

@property (nonatomic, strong) NSString <NXNotNullDelegate> *name;
@property (nonatomic, strong) NSNumber <NXNotNullDelegate> *age;
@property (nonatomic, strong) Friend *myfriend;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, assign) NXJobType jobType;
@property (nonatomic, strong) NSArray <Pet *> *pets;
@property (nonatomic, strong) NSArray <People *> *otherFriends;
@property (nonatomic, assign) NSInteger numberOfFriends;
@property (nonatomic, assign) BOOL hasGirlFriend;
@property (nonatomic, assign) CGFloat height;

@end

//
//  People.h
//  NXJsonKitExample
//
//  Created by Nicejinux on 23/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

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

@property (nonatomic, strong) NSString <NXNotNull> *name;
@property (nonatomic, strong) NSNumber <NXNotNull> *age;
@property (nonatomic, strong) Friend *myfriend;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, assign) NXJobType jobType;
@property (nonatomic, strong) NSArray <Pet *> *pets;
@property (nonatomic, strong) NSArray <People *> *otherFriends;
@property (nonatomic, assign) NSInteger numberOfFriends;
@property (nonatomic, assign) BOOL hasGirlFriend;
@property (nonatomic, assign) CGFloat height;

@end

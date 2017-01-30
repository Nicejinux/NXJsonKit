//
//  People.h
//  test
//
//  Created by Nicejinux on 23/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class Pet;
@class Friend;

@interface People : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) Friend *myfriend;
@property (nonatomic, strong) NSArray <Pet *> *pets;
@property (nonatomic, strong) NSArray <People *> *otherFriends;
@property (nonatomic, assign) NSInteger numberOfFriends;
@property (nonatomic, assign) BOOL hasGirlFriend;
@property (nonatomic, assign) CGFloat height;

@end

//
//  NXViewController.m
//  NXJsonKit
//
//  Created by nicejinux on 02/15/2017.
//  Copyright (c) 2017 nicejinux. All rights reserved.
//

#import "NXViewController.h"
#import <NXJsonKit/NXJsonKit.h>
#import "People.h"
#import "Pet.h"

@interface NXViewController ()

@end

@implementation NXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableDictionary *dic = [self createMock];
    
    NXMapper *mapper = [[NXMapper alloc] init];
    
    // add array mapping with element class
    // pets (NSArray) element will map as a Pet class in the People class
    NXArrayMapping *arrayMapping = [NXArrayMapping mapForArrayItemClass:Pet.class itemKey:@"pets" onClass:People.class];
    [mapper addArrayMapping:arrayMapping];
    
    // otherFriends (NSArray) element will map as a People class in the People class
    arrayMapping = [NXArrayMapping mapForArrayItemClass:People.class itemKey:@"otherFriends" onClass:People.class];
    [mapper addArrayMapping:arrayMapping];
    
    // add object mapping with field name (different object name)
    // "others" which is from Json data will map to "otherFriends" property in the People class
    NXObjectMapping *objectMapping = [NXObjectMapping mapForJsonKey:@"others" toModelKey:@"otherFriends" onClass:People.class];
    [mapper addObjectMapping:objectMapping];
    
    // "user_name" which is from Json data will map to "name" property in the People class
    objectMapping = [NXObjectMapping mapForJsonKey:@"user_name" toModelKey:@"name" onClass:People.class];
    [mapper addObjectMapping:objectMapping];
    
    // "job" which is from Json data will map to "jobType" in the People class
    objectMapping = [NXObjectMapping mapForJsonKey:@"job" toModelKey:@"jobType" onClass:People.class];
    [mapper addObjectMapping:objectMapping];
    
    // add date mapping with format
    // birthday will map as a NSDate with format (yyyyMMdd)
    NXDateMapping *dateMapping = [NXDateMapping mapForDateKey:@"birthday" format:@"yyyyMMdd" onClass:People.class];
    [mapper addDateMapping:dateMapping];
    
    // enum mapping with enum type list
    // "jobType" which is from Json data "job" field will map as JobType in the People class
    NXEnumMapping *enumMapping = [NXEnumMapping mapForEnumKey:@"jobType" enumTypeList:@[@"NONE", @"DOCTOR", @"DEVELOPER", @"DESIGNER"] onClass:People.class];
    [mapper addEnumMapping:enumMapping];
    
    // parse
    NXJsonKit *jsonKit = [[NXJsonKit alloc] initWithJsonData:dic mapper:mapper];
    
    People *people = [jsonKit mappedObjectForClass:[People class]];
    NSLog(@"%@", people);
}


- (NSMutableDictionary *)createMock
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    //    dic[@"user_name"] = @"Nicejinux";
    dic[@"age"] = @40;
    dic[@"numberOfFriends"] = @3;
    dic[@"hasGirlFriend"] = @(false);
    dic[@"height"] = @178.5;
    dic[@"birthday"] = @"19781227";
    dic[@"job"] = @"DEVELOPER";
    dic[@"pets"] = @[
                     @{
                         @"kind":@"dog",
                         @"name":@"doggy",
                         @"age":@"2 years"
                         }, @{
                         @"kind":@"cat",
                         @"name":@"kitty",
                         @"age":@"1 year"
                         }
                     ];
    
    dic[@"myfriend"] = @{
                         @"name":@"tom",
                         @"pet":
                             @{
                                 @"kind":@"cat",
                                 @"name":@"catty",
                                 @"age":@"3 years"
                                 }
                         };
    
    dic[@"others"] = @[
                       @{
                           @"user_name" : @"Qneek",
                           @"age"  : @40,
                           @"pets" : @[
                                   @{
                                       @"kind":@"dog",
                                       @"name":@"doggy",
                                       @"age":@"2 years"
                                       }, @{
                                       @"kind":@"cat",
                                       @"name":@"eitty",
                                       @"age":@"4 monthes"
                                       }, @{
                                       @"kind":@"cat",
                                       @"name":@"kitty",
                                       @"age":@"1 year"
                                       }
                                   ]
                           },
                       @{
                           @"user_name" : @"Max",
                           @"age"  : @40
                           }, @{
                           @"user_name" : @"Kim",
                           @"age"  : @40,
                           @"pets" : @[
                                   @{
                                       @"kind":@"dog",
                                       @"name":@"doggy",
                                       @"age":@"2 years"
                                       }
                                   ]
                           }
                       ];
    
    return dic;
}


@end

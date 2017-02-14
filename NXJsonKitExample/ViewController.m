//
//  ViewController.m
//  NXJsonKitExample
//
//  Created by Nicejinux on 26/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import "ViewController.h"
#import "NXJsonKit.h"

#import "People.h"
#import "Pet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSMutableDictionary *dic = [self createMock];
    
    NXMapper *mapper = [[NXMapper alloc] init];
    
    // array mapping
    NXArrayMapping *arrayMapping = [NXArrayMapping mapForArrayItemClass:Pet.class itemKey:@"pets" onClass:People.class];
    [mapper addArrayMapping:arrayMapping];
    
    arrayMapping = [NXArrayMapping mapForArrayItemClass:People.class itemKey:@"otherFriends" onClass:People.class];
    [mapper addArrayMapping:arrayMapping];
    
    // object mapping (rename object)
    NXObjectMapping *objectMapping = [NXObjectMapping mapForJsonKey:@"others" toModelKey:@"otherFriends" onClass:People.class];
    [mapper addObjectMapping:objectMapping];
    
    objectMapping = [NXObjectMapping mapForJsonKey:@"user_name" toModelKey:@"name" onClass:People.class];
    [mapper addObjectMapping:objectMapping];
    
    objectMapping = [NXObjectMapping mapForJsonKey:@"job" toModelKey:@"jobType" onClass:People.class];
    [mapper addObjectMapping:objectMapping];
    
    // date mapping with formatter
    NXDateMapping *dateMapping = [NXDateMapping mapForDateKey:@"birthday" formatter:@"yyyyMMdd" onClass:People.class];
    [mapper addDateMapping:dateMapping];
    
    // enum mapping with enum type list
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

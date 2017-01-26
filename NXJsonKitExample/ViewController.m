//
//  ViewController.m
//  NXJsonKitExample
//
//  Created by Nicejinux on 26/01/2017.
//  Copyright © 2017 Nicejinux. All rights reserved.
//

#import "ViewController.h"
#import "NXJsonKit.h"
#import "NXPropertyMapConfig.h"
#import "People.h"
#import "Pet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSMutableDictionary *dic = [self createMock];
    NXJsonKit *jsonKit = [[NXJsonKit alloc] initWithJsonData:dic];
    NXPropertyMapConfig *config = [NXPropertyMapConfig new];
    config.parentClass = People.class;
    config.targetClass = Pet.class;
    config.propertyName = @"pets";
    [jsonKit addConfigForArrayItem:config];
    
    config = [NXPropertyMapConfig new];
    config.parentClass = People.class;
    config.targetClass = People.class;
    config.propertyName = @"otherFriends";
    [jsonKit addConfigForArrayItem:config];

    People *people = [jsonKit mappedObjectForClass:[People class]];
    NSLog(@"%@", people);
}


- (NSMutableDictionary *)createMock
{
    NSMutableDictionary *dic = [NSMutableDictionary new];

    dic[@"name"] = @"Nicejinux";
    dic[@"age"] = @40;
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
    
    dic[@"otherFriends"] = @[
                             @{
                                 @"name" : @"Qneek",
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
                                 @"name" : @"Max",
                                 @"age"  : @40
                             }, @{
                                 @"name" : @"Kim",
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

# NXJsonKit

[![CI Status](http://img.shields.io/travis/nicejinux/NXJsonKit.svg?style=flat)](https://travis-ci.org/nicejinux/NXJsonKit)
[![Version](https://img.shields.io/cocoapods/v/NXJsonKit.svg?style=flat)](http://cocoapods.org/pods/NXJsonKit)
[![License](https://img.shields.io/cocoapods/l/NXJsonKit.svg?style=flat)](http://cocoapods.org/pods/NXJsonKit)
[![Platform](https://img.shields.io/cocoapods/p/NXJsonKit.svg?style=flat)](http://cocoapods.org/pods/NXJsonKit)   

**NXJsonKit** can set JSON dictionary values to object type values or user defined data model easily.    

    
# Why did I make it?

I was looking for simple JSON mapper for the project, and I found so many open sources for JSON mapping in GitHub. But Those were not easy to customize and there were so many features.  
We just needed ***simple*** and ***easy*** JSON mapper.   
   

# Features

1. Set values to Model class from **JSON** data automatically.
2. Add mapping conditions for *`NSArray`* elements.
3. Override key for Model **property**.
4. Convert *`NSNumber`* type to primitive type (*`NSInteger`*, *`CGFloat`*, *`enum`*...) automatically.  
5. Convert string type value to *`enum`*.  
6. Convert string type date to *`NSDate`*.  
7. Check value which should not be *`nil`*.  

# Requirements
Tested on iOS 8.0 or higher   

# Installation

NXJsonKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NXJsonKit"
```

# Usage

### JSON Data

```objc
    {
        "user_name":"Nicejinux",
        "age":39,
        "numberOfFriends":3,
        "hasGirlFriend":false,
        "height":178.5,
        "birthday":"20000101"
        "job":"DEVELOPER"
        "pets":[
            {
                "kind":"dog",
                "name":"doggy",
                "age":"2 years",
            }, {
                "kind":"cat",
                "name":"kitty",
                "age":"1 year"
            }
        ]
    }
```



### Data Model

```objc
    // People.h

    // enum type
    typedef NS_ENUM (NSInteger, JobType) {
        JobTypeNone = 0,
        JobTypeDoctor,
        JobTypeDeveloper,
        JobTypeDesigner,
    };

    // People Model
    @interface People : NSObject

    @property (nonatomic, strong) NSString <NXNotNullProtocol> *name;
    @property (nonatomic, strong) NSNumber *age;
    @property (nonatomic, strong) NSArray <Pet *> *pets;
    @property (nonatomic, strong) NSDate *birthday;
    @property (nonatomic, assign) JobType jobType;
    @property (nonatomic, assign) NSInteger numberOfFriends;
    @property (nonatomic, assign) BOOL hasGirlFriend;
    @property (nonatomic, assign) CGFloat height;

    @end

    // Pet Model
    @interface Pet : NSObject

    @property (nonatomic, strong) NSString *kind;
    @property (nonatomic, strong) NSString *name;
    @property (nonatomic, strong) NSNumber *age;

    @end


    // People.m

    // optional method for NXNotNullProtocol
    - (void)propertyWillSetNil:(NSString *)propertyName propertyClass:(Class)propertyClass
    {
        NSLog(@"%@ (%@) property should not be null", propertyName, propertyClass);
    }


```



### Get object from JSON

```objc
    - (People *)mapJsonToPeopleModelWithData:(NSDictionary *)dic 
    {	
        // create mapper for each mappings.
        NXMapper *mapper = [[NXMapper alloc] init];

        // add array mapping with element class
        // pets (NSArray) element will map as a Pet class in the People class
        NXArrayMapping *arrayMapping = [NXArrayMapping mapForArrayItemClass:Pet.class itemKey:@"pets" onClass:People.class];
        [mapper addArrayMapping:arrayMapping];

        // add object mapping with field name (different object name)
        // "user_name" which is from Json data will map to "name" property in the People class 
        NXObjectMapping *objectMapping = [NXObjectMapping mapForJsonKey:@"user_name" toModelKey:@"name" onClass:People.class];
        [mapper addObjectMapping:objectMapping];

        // "job" which is from Json data will map to "jobType" in the People class
        objectMapping = [NXObjectMapping mapForJsonKey:@"job" toModelKey:@"jobType" onClass:People.class];
        [mapper addObjectMapping:objectMapping];

        // add date mapping with formatter
        // birthday will map as a NSDate with formatter (yyyyMMdd)
        NXDateMapping *dateMapping = [NXDateMapping mapForDateKey:@"birthday" formatter:@"yyyyMMdd" onClass:People.class];
        [mapper addDateMapping:dateMapping];

        // add enum mapping with enum type list
        // "jobType" which is from Json data "job" will map as JobType in the People class
        NXEnumMapping *enumMapping = [NXEnumMapping mapForEnumKey:@"jobType" enumTypeList:@[@"NONE", @"DOCTOR", @"DEVELOPER", @"DESIGNER"] onClass:People.class];
        [mapper addEnumMapping:enumMapping];

        // initialize jsonkit with Json data and Mapper
        NXJsonKit *jsonKit = [[NXJsonKit alloc] initWithJsonData:dic mapper:mapper];

        // get mapped object that you specified class
        People *people = [jsonKit mappedObjectForClass:[People class]];

        return people;
    }
```

# Logic

1. get all properties from class that you specified.
2. check custom mapping conditions.
3. get the data by property name or custom mapping condition.
4. if you set **`<NXNotNullProtocol>`** to property which you want to check, **`propertyWillSetNil:propertyClass:`** method will be called if the JSON value is ***nil***.
5. if the class of data is a collection class (**`NSArray`**, **`NSDictionary`**) or user defined class, alloc new **`NXJsonKit`** and call recursively.
6. set value to Model.


# Author

This is [Jinwook Jeon](http://Nicejinux.NET) (nicejinux@gmail.com)   
I've been working as an iOS developer in Korea.  
I'm waiting for your comments, suggestions, fixes, everything what you want to say. 
Feel free to contact me. 


# License

Copyright (c) 2017 Jinwook Jeon. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

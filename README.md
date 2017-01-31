# NXJsonKit

**NXJsonKit** can set values to object type values or user defined data model without coding from Json data.  



# Why did I make it?

I was looking for simple Json mapper for my company project, and I found so many open sources for Json mapping in GitHub. But Those were not easy to customize and there were so many features.  

We just needed ***simple*** and ***easy*** Json mapper.  



# Features

1. Set values to Model class from Json data automatically.
2. Add mapping conditions for Array elements.
3. Override key for Model property.
4. Convert **`NSNumber`** type to primitive type (`NSInteger`, `CGFloat`, `enum`...) automatically.  


# Usage

### JSON Data

```objc
    {
        "user_name":"Nicejinux",
        "age":40,
        "numberOfFriends":3,
        "hasGirlFriend":false,
        "height":178.5,
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
    // People Model
    @interface People : NSObject
    
    @property (nonatomic, strong) NSString *name;
    @property (nonatomic, strong) NSNumber *age;
    @property (nonatomic, strong) NSArray <Pet *> *pets;
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

```



### Get object from JSON

```objc
	// add mapping for array element
	// pets (NSArray) element will map as a Pet class in the People class
	NXArrayMapping *arrayMapping = [NXArrayMapping mapForArrayItemClass:Pet.class itemKey:@"pets" onClass:People.class];

	// add mapping for object (different object name)
	// "user_name" which is from Json data will map to "name" property in the People class 
    NXObjectMapping *objectMapping = [NXObjectMapping mapForJsonKey:@"user_name" toModelKey:@"name" onClass:People.class];

	// initialize jsonkit with Json data
    NXJsonKit *jsonKit = [[NXJsonKit alloc] initWithJsonData:dic];

	// add mapping conditions
    [jsonKit addMappingForArrayItem:arrayMapping];
    [jsonKit addMappingForObject:objectMapping];

	// get mapped object that you specified class
	People *people = [jsonKit mappedObjectForClass:[People class]];
```



# Author

This is [Jinwook Jeon](http://Nicejinux.NET).  
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

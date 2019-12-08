# NSArray Functional

An Objective-C category that adds functional programming methods to NSArray.

### Generate

Returns a new array by calling the block a given number of times and returning the results.

`+ (NSArray *) generate:(id(^)(void))block count:(int)count;`

```
__block int i = 0;
NSArray *numbers = [NSArray generate:^id{
    return [NSNumber numberWithInt: ++i];
} count:10];
````
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
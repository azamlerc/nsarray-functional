# NSArray Functional

An Objective-C category that adds functional programming methods to NSArray.

## Contents

- [Generate](#generate)
- [Numbers in Range](#numbers-in-range)
- [Each](#each)
- [Every](#every)
- [Any](#any)
- [Contains Objects](#contains-objects)
- [Find](#find)
- [Map](#map)
- [Indexed Map](#indexed-map)
- [Matrix Map](#matrix-map)
- [Square Map](#square-map)
- [Nested Map](#nested-map)
- [Multi Map](#multi-map)
- [Replace](#replace)
- [Filter](#filter)
- [Remove](#remove)
- [Filter Objects](#filter-objects)
- [Remove Objects](#remove-objects)
- [Reduce](#reduce)
- [Sort](#sort)
- [Sort By](#sort-by)
- [Reverse](#reverse)
- [Unique](#unique)
- [Limit](#limit)
- [Join](#join)
- [Random Object](#random-object)
- [Shuffle](#shuffle)
- [Zip](#zip)
- [Flatten](#flatten)
- [Concat](#concat)
- [Four Fours](#four-fours)

## Generate

`+ (NSArray *) generate:(id(^)(void))block count:(int)count;`

Returns a new array by calling the block a given number of times and returning the results.

```
NSArray *randomNumbers = [NSArray generate:^id{
    int value = arc4random_uniform(100) + 1;
    return [NSNumber numberWithInt: value];
} count:10];
```
[14, 84, 2, 78, 100, 95, 54, 4, 100, 32]

## Numbers in Range

`+ (NSArray *) numbersInRange:(NSRange)range;`

Generates an array of numbers in the given range.

```
NSArray *numbers = [NSArray numbersInRange:NSMakeRange(1, 100)];
```
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

## Each

`- (void) each:(void(^)(id object))block;`

Performs the block on each object in the array.

```
NSArray *colors = @[@"red", @"orange", @"yellow", @"green", @"blue", @"purple"];
[colors each:^(id value) {
    NSLog(@"%@", value);
}];
```
red  
orange  
yellow  
green  
blue  
purple  

## Every

`- (BOOL) every:(BOOL(^)(id object))block;`

Returns true if the block returns true for every object in the array.

```
[colors every:^BOOL(id value) {
    return [value contains:@"e"];
}]
```
YES

## Any

`- (BOOL) any:(BOOL(^)(id object))block;`

Returns true if the block returns true for any object in the array.

```
[colors any:^BOOL(id value) {
    return [value length] > 6;
}]
```
NO

## Contains Objects

`- (BOOL) containsObjects:(NSArray *)objects;`

Returns true if the array contains all of the objects.

```
[colors containsObjects:@[@"blue", @"purple"]]
```
YES

## Find

`- (id) find:(BOOL(^)(id object))block;`

Returns the first object in the array for which the block returns true.

```
[colors find:^BOOL(id value) {
    return [value length] == 4;
}]
```
blue

## Map

`- (NSArray *) map:(id(^)(id object))block;`

Calls the block on every object in the array and returns an array of the results.

```
[colors map:^id(id value) {
    return [NSNumber numberWithLong: [value length]];
}]
```
[3, 6, 6, 5, 4, 6]

## Indexed Map

`- (NSArray *) indexedMap:(id(^)(NSUInteger index, id object))block;`

Calls the block on every object in the array along with the index and returns an array of the results.

```
[colors indexedMap:^id(NSUInteger i, id value) {
    return [NSString stringWithFormat: @"%lu %@", i, value];
}]
```
[0 red, 1 orange, 2 yellow, 3 green, 4 blue, 5 purple]

## Matrix Map

`- (NSArray *) matrixMap:(id(^)(id object1, id object2))block objects:(NSArray *)objects;`

Creates a marrix that is the result of calling the block on every combination of objects from this and the other array.

```
[numbers matrixMap:^id(id number, id color) {
    return [NSString stringWithFormat: @"%@ %@", number, color];
} objects:colors]
```
[1 red, 1 orange, 1 yellow, 1 green, 1 blue, 1 purple]  
[2 red, 2 orange, 2 yellow, 2 green, 2 blue, 2 purple]  
[3 red, 3 orange, 3 yellow, 3 green, 3 blue, 3 purple]  
[4 red, 4 orange, 4 yellow, 4 green, 4 blue, 4 purple]  
[5 red, 5 orange, 5 yellow, 5 green, 5 blue, 5 purple]  
[6 red, 6 orange, 6 yellow, 6 green, 6 blue, 6 purple]  
[7 red, 7 orange, 7 yellow, 7 green, 7 blue, 7 purple]  
[8 red, 8 orange, 8 yellow, 8 green, 8 blue, 8 purple]  
[9 red, 9 orange, 9 yellow, 9 green, 9 blue, 9 purple]  
[10 red, 10 orange, 10 yellow, 10 green, 10 blue, 10 purple]  

## Square Map

`- (NSArray *) squareMap:(id(^)(id object1, id object2))block;`

Returns a matrix that is the result of calling the block with every combination of two objects from the array. Equivalent to passing self to `matrix:objects:`.

```
NSArray *multiplicationTable = [numbers squareMap:^id(id object1, id object2) {
    return [NSNumber numberWithInt: [object1 intValue] * [object2 intValue]];
}]
```
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]  
[2, 4, 6, 8, 10, 12, 14, 16, 18, 20]  
[3, 6, 9, 12, 15, 18, 21, 24, 27, 30]  
[4, 8, 12, 16, 20, 24, 28, 32, 36, 40]  
[5, 10, 15, 20, 25, 30, 35, 40, 45, 50]  
[6, 12, 18, 24, 30, 36, 42, 48, 54, 60]  
[7, 14, 21, 28, 35, 42, 49, 56, 63, 70]  
[8, 16, 24, 32, 40, 48, 56, 64, 72, 80]  
[9, 18, 27, 36, 45, 54, 63, 72, 81, 90]  
[10, 20, 30, 40, 50, 60, 70, 80, 90, 100]

## Nested Map

`- (NSArray *) nestedMap:(id(^)(id object))block;`

Given a nested array, returns a nested array of the results of calling the block on each item.

```
[multiplicationTable nestedMap:twice]
```
[2, 4, 6, 8, 10, 12, 14, 16, 18, 20]  
[4, 8, 12, 16, 20, 24, 28, 32, 36, 40]  
[6, 12, 18, 24, 30, 36, 42, 48, 54, 60]  
[8, 16, 24, 32, 40, 48, 56, 64, 72, 80]  
[10, 20, 30, 40, 50, 60, 70, 80, 90, 100]  
[12, 24, 36, 48, 60, 72, 84, 96, 108, 120]  
[14, 28, 42, 56, 70, 84, 98, 112, 126, 140]  
[16, 32, 48, 64, 80, 96, 112, 128, 144, 160]  
[18, 36, 54, 72, 90, 108, 126, 144, 162, 180]  
[20, 40, 60, 80, 100, 120, 140, 160, 180, 200]


## Multi Map

`- (NSArray *) multiMap:(NSArray *)blocks;`

Given an array of blocks, returns an array of arrays generated by calling all of the blocks on each object.

```
[numbers multiMap: @[identity, square, squareRoot]]
```
[1, 1, 1]  
[2, 4, 1.414213562373095]  
[3, 9, 1.732050807568877]  
[4, 16, 2]  
[5, 25, 2.23606797749979]  
[6, 36, 2.449489742783178]  
[7, 49, 2.645751311064591]  
[8, 64, 2.82842712474619]  
[9, 81, 3]  
[10, 100, 3.16227766016838]

## Replace

`- (NSArray *) replace:(NSDictionary *)dict;`

Returns an array by looking up each object in the dictionary and replacing it with the corresponding value.

```
NSDictionary *frenchColors = @{
    @"red": @"rouge",
    // orange is the same
    @"yellow": @"jaune",
    @"green": @"vert",
    @"blue": @"bleu",
    @"purple": @"violet",
};
[colors replace:frenchColors]
```
[rouge, orange, jaune, vert, bleu, violet]

## Filter

`- (NSArray *) filter:(BOOL(^)(id object))block;`

Returns an array consisting of all the objects in the array for which the block returns true.

```
[colors filter:^BOOL(id value) {
  return [value length] == 6;
}]
```
[orange, yellow, purple]

```
[randomNumbers filter:^BOOL(id value) {
  return [value intValue] % 2 == 0;
}]
```
[14, 84, 2, 78, 100, 54, 4, 100, 32]

## Remove

`- (NSArray *) remove:(BOOL(^)(id object))block;`

Returns an array consisting of all the objects in the array for which the block returns false.

```
[colors remove:^BOOL(id value) {
  return [value hasPrefix:@"g"];
}]
```
[red, orange, yellow, blue, purple]

```
[randomNumbers remove:^BOOL(id value) {
  return [value intValue] > 50;
}]
```
[14, 2, 4, 32]

## Filter Objects

`- (NSArray *) filterObjectsIn:(NSArray *)objects;`

Returns just the objects that are in the other array.

```
[target filterObjectsIn:fours4]
```
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 74, 75, 76, 78, 79, 80, 82, 83, 84, 85, 86, 88, 89, 90, 91, 92, 94, 95, 96, 97, 98, 100]

## Remove Objects

`- (NSArray *) removeObjectsIn:(NSArray *)objects;`

Returns just the objects that are not in the other array.

```
[target removeObjectsIn:fours4]
```
[73, 77, 81, 87, 93, 99]

## Reduce

`- (id) reduce:(id(^)(id acc, id object))block;`  
`- (id) reduce:(id(^)(id acc, id object))block initial:(id)initial;`

Reduces the array using a block. Each time the block is called, it is passed the accumulator value and one object from the array, and returns a new accumulator value. The function takes an initial value and returns the final accumulator value. If the initial value is nil, uses the first value as the initial value.

```
[colors reduce:^id(id acc, id value) {
    return [value length] <= [acc length] ? value : acc;
}]
```
red

```
Operation sum = ^(NSNumber *value1, NSNumber *value2) {
    return [NSNumber numberWithDouble: [value1 doubleValue] + [value2 doubleValue]];
};
[numbers reduce:sum initial:0])
```
55

## Sort

`- (NSArray *) sort;`

Returns an array sorted using the `compare:` selector.

`- (NSArray *) sort:(NSComparator)block;`

Returns an array sorted using the comparator block. Alias for `sortedArrayUsingComparator:`.

```
[colors sort]
[colors sort:^(NSString *a, NSString *b) {
    return [a compare: b];
}]
```
[blue, green, orange, purple, red, yellow]

## Sort By

`- (NSArray *) sortBy:(NSUInteger(^)(id object))block;`

Returns an array sorted by calling the block on each object and comparing the resulting integers.

```
[colors sortBy:^NSUInteger(id value) {
  return [value length];
}]
```
[red, blue, green, orange, yellow, purple]

## Reverse

`- (NSArray *) reverse;`

Returns an array with the objects reversed.

```
[colors reverse]
```
[purple, blue, green, yellow, orange, red]

```
[colors reverse]
```
[10, 9, 8, 7, 6, 5, 4, 3, 2, 1]


## Unique

`- (NSArray *) unique;`

Returns an array with only the unique objects from the array. The order of the results is undefined.

```
NSArray *dupes = @[@1, @1, @1, @2, @2, @3];
[dupes unique]
```
[1, 2, 3]

## Limit

`- (NSArray *) limit:(int)limit;`

Returns an initial slice of the array with a length up to the limit.

```
[colors limit:3]
```
[red, orange, yellow]

```
[numbers limit:3]
```
[1, 2, 3]

## Join

`- (NSString *) join;`

Joins the items in the array using commas.

`- (NSString *) join:(NSString *)separator;`

Joins the items in the array using the separator. Alias for `componentsJoinedByString:`.

```
[colors join:" - "]
```
red - orange - yellow - green - blue - purple

## Random Object

`- (id) randomObject;`

Returns a random object from the array.

```
[colors randomObject]
```
purple

## Shuffle

`- (NSArray *) shuffle;`

Returns an array with the objects in a random order.

```
[colors shuffle]
```
[blue, orange, red, green, yellow, purple]

```
[numbers shuffle]
```
[1, 6, 7, 8, 2, 5, 9, 4, 3, 10]

## Zip

`- (NSArray *) zip:(NSArray *)objects;`

Interleaves items with objects from the other array. The length does not need to be the same.

```
[numbers zip:colors]
```
[1, red, 2, orange, 3, yellow, 4, green, 5, blue, 6, purple, 7, 8, 9, 10]

## Flatten

`- (NSArray *) flatten;`

Returns the items in the array, flattening any arrays.

```
NSArray *nested = @[@[@1, @2], @[@3, @[@4, @[@5, @[@6]]]]];
[nested flatten]
```
[1, 2, 3, 4, 5, 6]

## Concat

`- (NSArray *) concat:(NSArray *)objects;`

Alias for `arrayByAddingObjectsFromArray:`.

```
[colors concat:numbers]
```
[red, orange, yellow, green, blue, purple, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

## Four Fours

How many numbers between 1 and 100 can you make using the number four four times, and mathematical operations? 

Using functional programming, we can reduce the main function of the program to a one-liner!

```
NSArray *combineFours(NSArray *foursA, NSArray *foursB) {
    return [[[[[[[foursA matrixMap:[Tuple make] objects:foursB]
                 nestedMap:[Tuple bothWays]]
                flatten]
               multiMap: @[add, subtract, multiply, divide]]
              flatten]
             unique]
            sort];
}

void fourFours() {
    NSArray *target = [NSArray numbersInRange:NSMakeRange(1, 100)];
    NSArray *unaryOps = @[decimalPoint, squareRoot, identity, factorial];
    NSArray *fours1 = [[@[@4.0] multiMap: unaryOps] flatten];
    NSArray *fours2 = combineFours(fours1, fours1);
    NSArray *fours3 = combineFours(fours1, fours2);
    NSArray *fours4 = [combineFours(fours1, fours3) concat:
                       combineFours(fours2, fours2)];
    NSLog(@"One four: %@", fours1);
    NSLog(@"Two fours: %@", fours2);
    NSLog(@"Found: %@", [target filterObjectsIn:fours4]);
    NSLog(@"Missing: %@", [target removeObjectsIn:fours4]);
}
```
One four: 0.4, 2, 4, 24  
Two fours: -23.6, -22, -20, -3.6, -2, -1.6, 0, 0.016667, 0.083333, 0.1, 0.16, 0.166667, 0.2, 0.5, 0.8, 1, 1.6, 2, 2.4, 3.6, 4, 4.4, 5, 6, 8, 9.6, 10, 12, 16, 20, 22, 23.6, 24.4, 26, 28, 48, 60, 96, 576  
Found: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 74, 75, 76, 78, 79, 80, 82, 83, 84, 85, 86, 88, 89, 90, 91, 92, 94, 95, 96, 97, 98, 100  
Missing: 73, 77, 81, 87, 93, 99  

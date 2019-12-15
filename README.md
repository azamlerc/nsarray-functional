# NSArray Functional

An Objective-C category that adds functional programming methods to NSArray.

## Contents

- [Blocks](#blocks): typedefs for block types
- [Times](#times): call a block several times
- [Generate](#generate): call a block several times
- [Range](#range): array with range of numbers
- [Apply](#apply): call a block on an object
- [Apply All](#apply-all): call several blocks on an object
- [Call All](#call-all): call several blocks
- [Copies](#copies): array of copies of an object
- [Copies Of](#copies-of): array of copies of an object
- [Each](#each): call a block on each object
- [Every](#every): check if every object passes a test
- [Any](#any): check if any object passes a test
- [Contains Objects](#contains-objects): check if an array contains some objects
- [Find](#find): find an object in the array
- [Map](#map): transform each object in the array
- [Indexed Map](#indexed-map): transform each object with index
- [Zip Map](#zip-map): call a block on objects from two arrays
- [Matrix Map](#matrix-map): create a matrix using another array
- [Square Map](#square-map): transform all combinations of two values
- [Child Map](#child-map): transform all children in a 2D array
- [Nested Map](#nested-map): transform all objects in a nested array
- [Map All](#map-all): call several blocks on each object
- [Replace](#replace): replace all objects using a dictionary
- [Filter](#filter): objects that pass a test
- [Remove](#remove): objects that don't pass a test
- [Filter Objects](#filter-objects): objects that are in another array
- [Remove Objects](#remove-objects): objects that aren't in another array
- [Reduce](#reduce): iterate over the array using an accumulator block
- [Sort](#sort): sort using a comparator
- [Sort By](#sort-by): sort by performing a calculation on each object
- [Group By](#group-by): group by performing a calculation on each object
- [Reverse](#reverse): reverse the array
- [Unique](#unique): remove duplicates
- [Dedupe](#dedupe): remove consecutive duplicates
- [Limit](#limit): just a few objects
- [Take Nth](#take-nth): just every nth object
- [Join](#join): convert array to string
- [Nested Join](#nested-join): convert nested array to string
- [Random Object](#random-object): random object from the array
- [Random Sample](#random-sample): random objects from the array
- [Shuffle](#shuffle): random order
- [Zip](#zip): alternating objects from two arrays
- [Flatten](#flatten): nested array to flat array
- [Concat](#concat): concatenate two arrays
- [Four Fours](#four-fours): put it all together!
- [Selectors](#selectors): converts selectors to blocks
- [Lessons Learned](#lessons-learned)

## Blocks

The following type definitions make working with block types easier. 

`typedef id(^Generator)(void);`

A block that takes no arguments, generates an object and returns it.

`typedef id(^Transform)(id);`

A block that takes an object, transforms it in some way and returns another object.

`typedef id(^Operation)(id, id);`

A block that takes two objects, performs and operation on them and returns the result.

`typedef BOOL(^Test)(id);`

A block that takes an object, performs a test and returns a boolean.

## Times

*NSNumber*

`- (NSArray *) times:(Generator)block;`

Returns a new array by calling the block a given number of times and returning the results.

```
NSArray *randomNumbers = [@10 times:randomNumber];
```
[14, 84, 2, 78, 100, 95, 54, 4, 100, 32]

## Generate

`+ (NSArray *) generate:(Generator)block count:(int)count;`

Returns a new array by calling the block a given number of times and returning the results.

```
NSArray *randomNumbers = [NSArray generate:randomNumber count:10];
```
[14, 84, 2, 78, 100, 95, 54, 4, 100, 32]

## Numbers in Range

`+ (NSArray *) numbersInRange:(NSRange)range;`

Generates an array of numbers in the given range.

```
NSArray *numbers = [NSArray numbersInRange:NSMakeRange(1, 100)];
```
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

## Apply

*NSObject*

`- (id) apply:(Transform)block;`

Calls the block on the object and returns the result

```
[@25 apply:squareRoot]
```
5

## Apply All

*NSObject*

`- (NSArray *) applyAll:(NSArray *)blocks;`

Calls the blocks on the object and returns the results.

```
[@4 applyAll: @[decimalPoint, squareRoot, identity, factorial]]
```
[0.4, 2, 4, 24]

## Apply Transforms

*NSObject*

`- (id) applyTransforms:(NSArray *)blocks;`

Calls each of the blocks on the object, passing the result of each call as the input to the next.

```
[@2.0 applyTransforms: @[square, square, square, square, square]
```
4294967296

## Call All

`- (NSArray *) callAll;`

Calls each generator block in the array and returns the results.

```
NSDate *start = [NSDate date];
Generator timeInterval = ^{
    return [NSNumber numberWithDouble: [[NSDate date] timeIntervalSinceDate:start]];
};
[[@5 copiesOf:timeInterval] callAll]
```
2.598762512207031e-05  
3.302097320556641e-05  
3.397464752197266e-05  
3.492832183837891e-05  
3.600120544433594e-05

## Copies

*NSObject*

`- (NSArray *) copies:(NSUInteger)count;`

Returns an array with the recipient a given number of times.

```
[@"Yeah!" copies:3]
```
[Yeah!, Yeah!, Yeah!]

## Copies Of

*NSNumber*

`- (NSArray *) copiesOf:(id)value;`

Returns an array with the same object a given number of times.

```
[@3 copiesOf: @"Yeah!"]
```
[Yeah!, Yeah!, Yeah!]

## Each

`- (void) each:(void(^)(id))block;`

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

`- (BOOL) every:(Test)block;`

Returns true if the block returns true for every object in the array.

```
[colors every:^BOOL(id value) {
    return [value contains: @"e"];
}]
```
YES

## Any

`- (BOOL) any:(Test)block;`

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
[colors containsObjects: @[@"blue", @"purple"]]
```
YES

## Find

`- (id) find:(Test)block;`

Returns the first object in the array for which the block returns true.

```
[colors find:^BOOL(id value) {
    return [value length] == 4;
}]
```
blue

## Map

`- (NSArray *) map:(Transform)block;`

Calls the block on every object in the array and returns an array of the results.

```
[colors map:^(id value) {
    return [NSNumber numberWithLong: [value length]];
}]
```
[3, 6, 6, 5, 4, 6]

## Indexed Map

`- (NSArray *) indexedMap:(id(^)(NSUInteger, id))block;`

Calls the block on every object in the array along with the index and returns an array of the results.

```
[colors indexedMap:^(NSUInteger i, id value) {
    return [NSString stringWithFormat: @"%lu %@", i, value];
}]
```
[0 red, 1 orange, 2 yellow, 3 green, 4 blue, 5 purple]

## Zip Map

`- (NSArray *) zip:(NSArray *)objects map:(Operation)block;`

Given another array of the same length, iterates over both arrays and calls the block on one object from each array.

```
[numbers zip:colors map:^(id number, id color) {
    return [number copiesOf:color];
}]
```
[red]  
[orange, orange]  
[yellow, yellow, yellow]  
[green, green, green, green]  
[blue, blue, blue, blue, blue]  
[purple, purple, purple, purple, purple, purple]

## Matrix Map

`- (NSArray *) matrix:(NSArray *)objects map:(Operation)block;`

Creates a matrix that is the result of calling the block on every combination of objects from this and the other array.

```
[numbers matrix:colors map:^(id number, id color) {
    return [NSString stringWithFormat: @"%@ %@", number, color];
}]
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

`- (NSArray *) squareMap:(Operation)block;`

Returns a matrix that is the result of calling the block with every combination of two objects from the array. Equivalent to passing self to `matrix:map:`.

```
NSArray *multiplicationTable = [numbers squareMap:product];
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

## Child Map

`- (NSArray *) childMap:(Transform)block;`

Given an array of arrays, returns the result of mapping the block on every array in the array.

```
[multiplicationTable childMap:twice]
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

## Nested Map

`- (NSArray *) nestedMap:(Transform)block;`

Given a deeply nested array, returns a nested array of the results of calling the block on each item.

```
NSArray *nested = @[@[@1, @2], @[@3, @[@4, @[@5, @[@6]]]]];
[nested nestedMap:square]
```
[[1, 4], [9, [16, [25, [36]]]]]

## Map All

`- (NSArray *) mapAll:(NSArray *)blocks;`

Given an array of blocks, returns an array of arrays generated by calling all of the blocks on each object.

```
[numbers mapAll: @[identity, square, squareRoot]]
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

## Generators

`- (NSArray *) generators:(Transform)block;`

Returns an array of generator blocks that close over each value in the array and pass it to the transform block.

```
NSArray *greeters = [numbers generators:^(id number) {
    return [number copiesOf: @"hi"];
}];
[greeters callAll]
```
[hi]  
[hi, hi]  
[hi, hi, hi]  
[hi, hi, hi, hi]  
[hi, hi, hi, hi, hi]  
[hi, hi, hi, hi, hi, hi]  
[hi, hi, hi, hi, hi, hi, hi]  
[hi, hi, hi, hi, hi, hi, hi, hi]  
[hi, hi, hi, hi, hi, hi, hi, hi, hi]  
[hi, hi, hi, hi, hi, hi, hi, hi, hi, hi]

## Transforms

`- (NSArray *) transforms:(Operation)block;`

Returns an array of transform blocks that close over each value in the array and pass it to the operation block as the first value.

```
[@3 applyAll: [numbers transforms:product]]
```
[3, 6, 9, 12, 15, 18, 21, 24, 27, 30]

```
NSArray *repeaters = [[numbers limit:3] transforms:^(id number, id value) {
    return [number copiesOf: value];
}];
[colors mapAll:repeaters]
```
[[red], [red, red], [red, red, red]]  
[[orange], [orange, orange], [orange, orange, orange]]  
[[yellow], [yellow, yellow], [yellow, yellow, yellow]]  
[[green], [green, green], [green, green, green]]  
[[blue], [blue, blue], [blue, blue, blue]]  
[[purple], [purple, purple], [purple, purple, purple]]

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

`- (NSArray *) filter:(Test)block;`

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

`- (NSArray *) remove:(Test)block;`

Returns an array consisting of all the objects in the array for which the block returns false.

```
[colors remove:^BOOL(id value) {
  return [value hasPrefix: @"g"];
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
[colors reduce:^(id acc, id object) {
    return [object length] <= [acc length] ? object : acc;
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
[colors sortBy:^(id value) {
  return [value length];
}]
```
[red, blue, green, orange, yellow, purple]

## Group By

`- (NSDictionary *) groupBy:(Transform)block;`

Returns a dictionary where the key is the result of calling the block on each object in the array and the value is an array of objects with the same key.

```
[colors groupBy:^(id value) {
    return [NSNumber numberWithInt: [value length]];
}]
```
{3: [red], 6: [orange, yellow, purple], 4: [blue], 5: [green]}

```
[colors groupBy:^(id value) {
    return [value substringToIndex:1];
}]
```
{r: [red], y: [yellow], g: [green], b: [blue], p: [purple], o: [orange]}

```
[numbers groupBy:^(id value) {
    return [value intValue] % 2 == 0 ? @"even" : @"odd";
}]
```
{odd: [1, 3, 5, 7, 9], even: [2, 4, 6, 8, 10]}

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

## Dedupe

`- (NSArray *) dedupe;`

Returns an array with the consecutive duplicates removed.

```
NSArray *dupes = @[@1, @1, @1, @2, @2, @3, @1, @2, @3];
[dupes dedupe]
```
[1, 2, 3, 1, 2, 3]

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

## Take Nth

`- (NSArray *) takeNth:(int)n;`

Returns every nth object from the array, starting with the first.

```
[colors takeNth:2]
```
[red, yellow, blue]

```
[numbers takeNth:3]
```
[1, 4, 7, 10]

## Join

`- (NSString *) join;`

Joins the items in the array using commas, in square brackets.

```
[colors join:]
```
[red, orange, yellow, green, blue, purple]

`- (NSString *) join:(NSString *)separator;`

Joins the items in the array using the separator. Alias for `componentsJoinedByString:`.

```
[colors join: @" - "]
```
red - orange - yellow - green - blue - purple

## Nested Join

`- (NSString *) nestedJoin;`

Recursively joins the items in the array using commas, in square brackets.

```
[@[@[@1, @2], @[@3, @[@4, @[@5, @[@6]]]]] nestedJoin]
```
[[1, 2], [3, [4, [5, [6]]]]]

## Random Object

`- (id) randomObject;`

Returns a random object from the array.

```
[colors randomObject]
```
purple

## Random Sample

`- (NSArray *) randomSample:(double)probability;`

Returns a sample of objects from the array, included with the given probability.

```
[colors randomSample:0.5]
```
[orange, green, blue]

```
[[NSArray range:NSMakeRange(1,100)] randomSample:0.1]
```
[4, 6, 19, 24, 28, 32, 45, 46, 50, 88]

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
    return [[[[[[[foursA matrix:foursB map:[Tuple make]]
                 nestedMap:[Tuple bothWays]]
                flatten]
               mapAll: @[add, subtract, multiply, divide]]
              flatten]
             unique]
            sort];
}

void fourFours() {
    NSArray *target = [NSArray range:NSMakeRange(1, 100)];
    NSArray *fours1 = [@4 applyAll: @[decimalPoint, squareRoot, identity, factorial]];
    NSArray *fours2 = combineFours(fours1, fours1);
    NSArray *fours3 = combineFours(fours1, fours2);
    NSArray *fours4 = [combineFours(fours1, fours3) concat:
                       combineFours(fours2, fours2)];
    NSLog(@"Found: %@", [target filterObjectsIn:fours4]);
    NSLog(@"Missing: %@", [target removeObjectsIn:fours4]);
}
```
Found: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 74, 75, 76, 78, 79, 80, 82, 83, 84, 85, 86, 88, 89, 90, 91, 92, 94, 95, 96, 97, 98, 100  
Missing: 73, 77, 81, 87, 93, 99

## Selectors

Selectors describe the name of a method, but cannot be used like blocks. These functions transform selectors into blocks that are compatible with functional programming. 

`Transform transformFromSelector(SEL selector);`

Given a selector that takes no arguments, returns a transform block that will call the selector on an object and return the result.

`NSArray *transformsFromSelectors(SEL selectors[]);`

Given a NULL-terminated C array of selectors that take no arguments, returns an array of transform blocks that will call the selector on an object and return the result.

`Operation operationFromSelector(SEL selector);`

Given a selector that takes one argument, returns an operation block that will call the selector on the first object with the second object and return the result.

`NSArray *operationsFromSelectors(SEL selectors[]);`

Given a NULL-terminated C array of selectors that take one argument, returns an array of operation blocks that will call the selector on the first object with the second object and return the result.

```
SEL caseSelectors[] = {
    @selector(lowercaseString),
    @selector(capitalizedString),
    @selector(uppercaseString),
    NULL
};
[colors mapAll:transformsFromSelectors(caseSelectors)]
```
[red, Red, RED]  
[orange, Orange, ORANGE]  
[yellow, Yellow, YELLOW]  
[green, Green, GREEN]  
[blue, Blue, BLUE]  
[purple, Purple, PURPLE]

```
- (NSString *) ish: (NSString *) color {
    return [self isEqual: color] ? self : [NSString stringWithFormat: @"%@ish-%@", self, color];
}

[colors squareMap:operationFromSelector(@selector(ish:))]
```
[red, redish-orange, redish-yellow, redish-green, redish-blue, redish-purple]  
[orangeish-red, orange, orangeish-yellow, orangeish-green, orangeish-blue, orangeish-purple]  
[yellowish-red, yellowish-orange, yellow, yellowish-green, yellowish-blue, yellowish-purple]  
[greenish-red, greenish-orange, greenish-yellow, green, greenish-blue, greenish-purple]  
[blueish-red, blueish-orange, blueish-yellow, blueish-green, blue, blueish-purple]  
[purpleish-red, purpleish-orange, purpleish-yellow, purpleish-green, purpleish-blue, purple]  


## Background

`void background(id(^block)(void), void(^completion)(id));`

Performs the first block in the background, and then calls the second block in the foreground with the return value of the first block.

```
background(^{
    return @"It worked!";
}, ^(id result){
    NSLog(@"Result: %@", result);
});
```

## Lessons Learned

- Blocks were added in Objective-C 2.0, and relatively few functional methods are are built in. But new functionality can be added to base classes using categories. 
- Function names are verbose, like `sortedArrayUsingComparator:`. But it’s easy to add aliases like `sort:` that call existing functions. 
- The [block syntax](http://fuckingblocksyntax.com/) is attrocious, but typedefs can be used to make block type syntax manageable. Block return types can usually be inferred. 
- Methods, functions and operators cannot be used interchangably with blocks. If you want the functionality of a method, function or operator, you have to wrap it in a new block.
- Scalars cannot be added to an array, but must be wrapped in NSNumber objects. However you can’t do math with NSNumber objects, which must be unwrapped to perform calculations.
- Blocks are closures and can close over variables in the scope where they are defined.
- Blocks can be added to NSArrays and enumerated using for loops.

//
//  NSArray+Functional.h
//
//  Created by Andrew Zamler-Carhart on 12/7/19.
//

#import <Foundation/Foundation.h>

typedef id(^Generator)(void);
typedef id(^Transform)(id);
typedef id(^Operation)(id, id);
typedef BOOL(^Test)(id);

@interface NSNumber (Functional)

// Returns a new array by calling the block a
// given number of times and returning the results.
- (NSArray *) times:(Generator)block;

// Returns an array with the same object a given number of times.
- (NSArray *) copiesOf:(id)value;

@end

@interface NSArray (Functional)

// Returns a new array by calling the block a
// given number of times and returning the results.
+ (NSArray *) generate:(Generator)block
                 count:(int)count;

// Generates an array of numbers in the given range.
+ (NSArray *) range:(NSRange)range;

// Performs the block on each object in the array.
- (void) each:(void(^)(id))block;

// Returns true if the block returns true for every object in the array.
- (BOOL) every:(Test)block;

// Returns true if the block returns true for any object in the array.
- (BOOL) any:(Test)block;

// Returns true if the array contains all of the objects.
- (BOOL) containsObjects:(NSArray *)objects;

// Returns the first object in the array for which the block returns true.
- (id) find:(Test)block;

// Calls the block on every object in the array
// and returns an array of the results.
- (NSArray *) map:(Transform)block;

// Calls the block on every object in the array along
// with the index and returns an array of the results.
- (NSArray *) indexedMap:(id(^)(NSUInteger, id))block;

// Given another array of the same length, iterates over both arrays
// and calls the block on one object from each array.
- (NSArray *) zip:(NSArray *)objects map:(Operation)block;

// Creates a matrix that is the result of calling the block
// on every combination of objects from this and the other array.
- (NSArray *) matrix:(NSArray *)objects map:(Operation)block;

// Returns a matrix that is the result of calling the block
// with every combination of two objects from the array.
// Equivalent to passing self to matrix:objects:.
- (NSArray *) squareMap:(Operation)block;

// Given an array of arrays, returns the result of mapping
// the block on every array in the array.
- (NSArray *) childMap:(Transform)block;

// Given a deeply nested array, returns a nested array of
// the results of calling the block on each item.
- (NSArray *) nestedMap:(Transform)block;

// Given an array of blocks, returns an array of arrays
// generated by calling all of the blocks on each object.
- (NSArray *) mapAll:(NSArray *)blocks;

// Calls each generator block in the array and returns the results.
- (NSArray *) callAll;

// Returns an array of generator blocks that close over each
// value in the array and pass it to the transform block.
- (NSArray *) generators:(Transform)block;

// Returns an array of transform blocks that close over each
// value in the array and pass it to the operation block as
// the first value.
- (NSArray *) transforms:(Operation)block;

// Returns an array by looking up each object in the dictionary
// and replacing it with the corresponding value.
- (NSArray *) replace:(NSDictionary *)dict;

// Returns an array consisting of all the objects
// in the array for which the block returns true.
- (NSArray *) filter:(Test)block;

// Returns an array consisting of all the objects
// in the array for which the block returns false.
- (NSArray *) remove:(Test)block;

// Returns just the objects that are in the other array.
- (NSArray *) filterObjectsIn:(NSArray *)objects;

// Returns just the objects that are not in the other array.
- (NSArray *) removeObjectsIn:(NSArray *)objects;

// Reduces the array using a block. Each time the block is called,
// it is passed the accumulator value and one object from the array,
// and returns a new accumulator value. The function takes an initial
// value and returns the final accumulator value. If the initial value
// is nil, uses the first value as the initial value.
- (id) reduce:(id(^)(id acc, id object))block;
- (id) reduce:(id(^)(id acc, id object))block
      initial:(id)initial;

// Returns an array sorted using the compare: selector.
- (NSArray *) sort;

// Returns an array sorted using the comparator block.
// Just an alias for the sortedArrayUsingComparator: method.
- (NSArray *) sort:(NSComparator)block;

// Returns an array sorted by calling the block on
// each object and comparing the resulting integers.
- (NSArray *) sortBy:(NSUInteger(^)(id))block;

// Returns a dictionary where the key is the result of
// calling the block on each object in the array and
// the value is an array of objects with the same key.
- (NSDictionary *) groupBy:(Transform)block;

// Returns an array with the objects reversed.
- (NSArray *) reverse;

// Returns an array with only the unique objects from the array.
// The order of the results is undefined.
- (NSArray *) unique;

// Returns an initial slice of the array with a length up to the limit.
- (NSArray *) limit:(int)limit;

// Joins the items in the array using commas, in square brackets.
- (NSString *) join;

// Recursively joins the items in the array using commas, in square brackets.
- (NSString *) nestedJoin;

// Joins the items in the array using the separator.
// Just an alias for the componentsJoinedByString: method.
- (NSString *) join:(NSString *)separator;

// Returns a random object from the array.
- (id) randomObject;

// Returns an array with the objects in a random order.
- (NSArray *) shuffle;

// Interleaves items with objects from the other array.
// The length does not need to be the same.
- (NSArray *) zip:(NSArray *)objects;

// Returns the items in the array, flattening any arrays.
- (NSArray *) flatten;

// Alias for arrayByAddingObjectsFromArray:.
- (NSArray *) concat:(NSArray *)objects;

@end

@interface NSObject (Functional)

// Calls the block on the object and returns the result.
- (id) apply:(Transform)block;

// Calls the blocks on the object and returns the results.
- (NSArray *) applyAll:(NSArray *)blocks;

// Calls each of the blocks on the object, passing
// the result of each call as the input to the next.
- (id) applyTransforms:(NSArray *)blocks;

// Returns an array with the same object a given number of times.
- (NSArray *) copies:(NSUInteger)count;

// Returns a JSON string version of the object.
- (NSString *) jsonString;

- (NSComparisonResult) randomCompare: (NSObject *) object;

@end

@interface NSString (StringAdditions)

- (BOOL) contains: (NSString *) string;

- (NSString *) ish: (NSString *) color;

@end

// Given a selector that takes no arguments, returns a transform block
// that will call the selector on an object and return the result.
Transform transformFromSelector(SEL selector);

// Given a selector that takes one argument, returns an operation block
// that will call the selector on the first object with the second object
// and return the result.
Operation operationFromSelector(SEL selector);

// Given a NULL-terminated C array of selectors that take no arguments,
// returns an array of transform blocks that will call
// the selector on an object and return the result.
NSArray *transformsFromSelectors(SEL selectors[]);

// Given a NULL-terminated C array of selectors that take one argument,
// returns an array of operation blocks that will call
// the selector on the first object with the second object
// and return the result.
NSArray *operationsFromSelectors(SEL selectors[]);

// Performs the first block in the background, and then calls the second
// block in the foreground with the return value of the first block.
void background(id(^block)(void), void(^completion)(id));

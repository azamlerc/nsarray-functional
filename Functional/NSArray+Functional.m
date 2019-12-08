//
//  NSArray+Functional.m
//
//  Created by Andrew Zamler-Carhart on 12/7/19.
//

#import "NSArray+Functional.h"
#import <Foundation/Foundation.h>

@implementation NSNumber (Functional)

- (NSArray *) times:(Generator)block {
    return [NSArray generate:block count:[self intValue]];
}

- (NSArray *) copiesOf:(id)value {
    return [value copies:[self intValue]];
}

@end

@implementation NSArray (Functional)

+ (NSArray *) generate:(Generator)block
                 count:(int)count {
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; i++) {
        [result addObject:block()];
    }
    return result;
}

+ (NSArray *) range:(NSRange)range {
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = range.location; i < range.length + range.location; i++) {
        [result addObject:[NSNumber numberWithDouble: i]];
    }
    return result;
}

- (void) each:(void(^)(id))block {
    for (id object in self) {
        block(object);
    }
}

- (BOOL) every:(Test)block {
    for (id object in self) {
        if (!block(object)) {
            return NO;
        }
    }
    return YES;
}

- (BOOL) any:(Test)block {
    for (id object in self) {
        if (block(object)) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) containsObjects:(NSArray *)objects {
    NSSet *set = [NSSet setWithArray:self];
    for (id object in objects) {
        if (![set containsObject: object]) {
            return NO;
        }
    }
    return YES;
}

- (id) find:(Test)block {
    for (id object in self) {
        if (block(object)) {
            return object;
        }
    }
    return nil;
}

- (NSArray *) map:(Transform)block {
    NSMutableArray *result = [NSMutableArray array];
    for (id object in self) {
        [result addObject:block(object)];
    }
    return result;
}

- (NSArray *) indexedMap:(id(^)(NSUInteger, id))block {
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger index = 0; index < [self count]; index++) {
        id object = [self objectAtIndex:index];
        [result addObject:block(index, object)];
    }
    return result;
}

- (NSArray *) matrixMap:(Operation)block
                objects:(NSArray *)objects {
    NSMutableArray *result = [NSMutableArray array];
    for (id object1 in self) {
        NSMutableArray *line = [NSMutableArray array];
        for (id object2 in objects) {
            [line addObject:block(object1, object2)];
        }
        [result addObject: line];
    }
    return result;
}

- (NSArray *) squareMap:(Operation)block {
    return [self matrixMap:block objects:self];
}

- (NSArray *) childMap:(Transform)block {
    NSMutableArray *result = [NSMutableArray array];
    for (id array in self) {
        [result addObject: [array map:block]];
    }
    return result;
}

- (NSArray *) nestedMap:(Transform)block {
    NSMutableArray *result = [NSMutableArray array];
    for (id object in self) {
        if ([object isKindOfClass:[NSArray class]]) {
            [result addObject:[object nestedMap:block]];
        } else {
            [result addObject:block(object)];
        }
    }
    return result;
}

- (NSArray *) mapAll:(NSArray *)blocks {
    NSMutableArray *result = [NSMutableArray array];
    for (id object in self) {
        [result addObject: [object applyAll:blocks]];
    }
    return result;
}

- (NSArray *) generators:(Transform)block {
    NSMutableArray *result = [NSMutableArray array];
    for (id object in self) {
        [result addObject: ^{
            return block(object);
        }];
    }
    return result;
}

- (NSArray *) transforms:(Operation)block {
    NSMutableArray *result = [NSMutableArray array];
    for (id object in self) {
        [result addObject: ^(id value){
            return block(object, value);
        }];
    }
    return result;
}

- (NSArray *) replace:(NSDictionary *)dict {
    NSMutableArray *result = [NSMutableArray array];
    for (id object in self) {
        id value = [dict objectForKey:object];
        [result addObject: value != nil ? value : object];
    }
    return result;
}

- (NSArray *) filter:(Test)block {
    NSMutableArray *result = [NSMutableArray array];
    for (id object in self) {
        if (block(object)) {
            [result addObject:object];
        }
    }
    return result;
}

- (NSArray *) remove:(Test)block {
    NSMutableArray *result = [NSMutableArray array];
    for (id object in self) {
        if (!block(object)) {
            [result addObject:object];
        }
    }
    return result;
}

- (NSArray *) filterObjectsIn:(NSArray *)objects {
    NSSet *set = [NSSet setWithArray: objects];
    NSMutableArray *result = [NSMutableArray array];
    for (id object in self) {
        if ([set containsObject:object]) {
            [result addObject:object];
        }
    }
    return result;
}

- (NSArray *) removeObjectsIn:(NSArray *)objects {
    NSSet *set = [NSSet setWithArray: objects];
    NSMutableArray *result = [NSMutableArray array];
    for (id object in self) {
        if (![set containsObject:object]) {
            [result addObject:object];
        }
    }
    return result;
}

- (id) reduce:(id(^)(id acc, id object))block {
    return [self reduce:block initial:nil];
}

- (id) reduce:(id(^)(id acc, id object))block
      initial:(id)initial {
    for (id object in self) {
        initial = initial == nil ? object : block(initial, object);
    }
    return initial;
}

- (NSArray *) sort {
    return [self sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray *) sort:(NSComparator)block {
    return [self sortedArrayUsingComparator:block];
}

- (NSArray *) sortBy:(NSUInteger(^)(id))block {
    return [self sort:^(id a, id b) {
      return [[NSNumber numberWithLong:block(a)] compare:
              [NSNumber numberWithLong:block(b)]];
    }];
}

- (NSArray *) reverse {
    return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *) unique {
    return [[NSSet setWithArray:self] allObjects];
}

- (NSArray *) limit:(int)limit {
    return [self subarrayWithRange:NSMakeRange(0, limit)];
}

- (NSString *) join {
    return [NSString stringWithFormat: @"[%@]", [self join: @", "]];
}

- (NSString *) nestedJoin {
    NSMutableArray *result = [NSMutableArray array];
    for (id object in self) {
        if ([object isKindOfClass:[NSArray class]]) {
            [result addObject: [object nestedJoin]];
        } else {
            [result addObject: object];
        }
    }
    return [result join];
}

- (NSString *) join:(NSString *)separator {
    return [self componentsJoinedByString:separator];
}

- (id) randomObject {
    if ([self count] == 0) return nil;
    NSUInteger randomIndex = arc4random_uniform((unsigned int)[self count]);
    return [self objectAtIndex: randomIndex];
}

- (NSArray *) shuffle {
    NSMutableArray *copy = [self mutableCopy];
    [copy sortUsingSelector: @selector(randomCompare:)];
    return copy;
}

- (NSArray *) zip:(NSArray *)objects {
    NSMutableArray *result = [NSMutableArray array];
    NSUInteger selfCount = [self count];
    NSUInteger objectsCount = [objects count];
    
    for (NSUInteger i = 0; i < selfCount || i < objectsCount; i++) {
        if (i < selfCount) {
            [result addObject: [self objectAtIndex:i]];
        }
        if (i < objectsCount) {
            [result addObject: [objects objectAtIndex:i]];
        }
    }
    return result;
}

- (NSArray *) flatten {
    NSMutableArray *result = [NSMutableArray array];
    for (id object in self) {
        if ([object isKindOfClass:[NSArray class]]) {
            [result addObjectsFromArray:[object flatten]];
        } else {
            [result addObject:object];
        }
    }
    return result;
}

- (NSArray *) concat:(NSArray *)objects {
    return [self arrayByAddingObjectsFromArray:objects];
}

@end

@implementation NSObject (Functional)

- (id) apply:(Transform)block {
    return block(self);
}

- (NSArray *) applyAll:(NSArray *)blocks {
    NSMutableArray *result = [NSMutableArray array];
    for (id(^block)(id) in blocks) {
        [result addObject:block(self)];
    }
    return result;
}

- (NSArray *) copies:(NSUInteger)count {
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; i++) {
        [result addObject:self];
    }
    return result;
}

- (NSComparisonResult) randomCompare: (NSObject *) object {
    return (arc4random_uniform(100) % 2 == 0) ? NSOrderedAscending : NSOrderedDescending;
}

@end

@implementation NSString (StringAdditions)

- (BOOL) contains: (NSString *) string {
    return [self rangeOfString: string].location != NSNotFound;
}

@end

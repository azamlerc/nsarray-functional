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

- (NSArray *) zip:(NSArray *)objects map:(Operation)block {
    NSMutableArray *result = [NSMutableArray array];
    NSUInteger selfCount = [self count];
    NSUInteger objectsCount = [objects count];
    
    for (NSUInteger i = 0; i < selfCount && i < objectsCount; i++) {
        [result addObject: block([self objectAtIndex:i], [objects objectAtIndex:i])];
    }
    return result;
}

- (NSArray *) matrix:(NSArray *)objects map:(Operation)block {
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
    return [self matrix:self map:block];
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

- (NSArray *) callAll {
    NSMutableArray *result = [NSMutableArray array];
    for (Generator generator in self) {
        [result addObject: generator()];
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

- (NSDictionary *) groupBy:(Transform)block {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (id object in self) {
        id key = block(object);
        NSMutableArray *array = [result objectForKey:key];
        if (array == nil) {
            array = [NSMutableArray array];
            [result setObject:array forKey:key];
        }
        [array addObject:object];
    }
    return result;
}

- (NSArray *) reverse {
    return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *) unique {
    return [[NSSet setWithArray:self] allObjects];
}

- (NSArray *) dedupe {
    NSMutableArray *result = [NSMutableArray array];
    id previous = nil;
    for (id object in self) {
        if (object != previous) {
            [result addObject: object];
        }
        previous = object;
    }
    return result;
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

- (NSArray *) randomSample:(double)probability {
    return [self filter:^BOOL(id value) {
        return arc4random_uniform(100.0 / probability) < 100;
    }];
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
    for (Transform block in blocks) {
        [result addObject:block(self)];
    }
    return result;
}

- (id) applyTransforms:(NSArray *)blocks {
    id result = self;
    for (Transform block in blocks) {
        result = block(result);
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

- (NSString *) jsonString {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
       options:0
       // options:(NSJSONWritingOptions) NSJSONWritingPrettyPrinted
       error:&error];
    return jsonData ? [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] : @"[]";
}

- (NSComparisonResult) randomCompare: (NSObject *) object {
    return (arc4random_uniform(100) % 2 == 0) ? NSOrderedAscending : NSOrderedDescending;
}

@end

@implementation NSString (StringAdditions)

- (BOOL) contains: (NSString *) string {
    return [self rangeOfString: string].location != NSNotFound;
}

- (NSString *) ish: (NSString *) color {
    return [self isEqual: color] ? self : [NSString stringWithFormat: @"%@ish-%@", self, color];
}

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

Transform transformFromSelector(SEL selector) {
    return ^(id target) {
        return [target performSelector:selector];
    };
}

Operation operationFromSelector(SEL selector) {
    return ^(id target, id argument) {
        return [target performSelector:selector withObject:argument];
    };
}

#pragma clang diagnostic pop

NSArray *transformsFromSelectors(SEL selectors[]) {
    NSMutableArray *result = [NSMutableArray array];
    int i = 0;
    SEL selector;
    while ((selector = selectors[i++])) {
        [result addObject: transformFromSelector(selector)];
    }
    return result;
}

NSArray *operationsFromSelectors(SEL selectors[]) {
    NSMutableArray *result = [NSMutableArray array];
    int i = 0;
    SEL selector;
    while ((selector = selectors[i++])) {
        [result addObject: operationFromSelector(selector)];
    }
    return result;
}

void background(id(^block)(void), void(^completion)(id)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id result = block();
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result);
        });
    });
}

//
//  Tuple.m
//  Functional
//
//  Created by Andrew Zamler-Carhart on 12/7/19.
//

#import <Foundation/Foundation.h>
#import "Tuple.h"

@implementation Tuple

static id(^makeBlock)(id, id) = ^id(id object1, id object2) {
    return [Tuple tupleWithFirst: [object1 doubleValue]
                          second: [object2 doubleValue]];
};

static id(^bothWaysBlock)(id) = ^id(id tuple) {
    return @[tuple, [tuple reverse]];
};

+ (Tuple *) tupleWithFirst: (double) first
                    second: (double) second
{
    Tuple *tuple = [[Tuple alloc] init];
    tuple.first = first;
    tuple.second = second;
    return tuple;
}

+ (id) make {
    return makeBlock;
}

+ (id) bothWays {
    return bothWaysBlock;
}

- (Tuple *) reverse {
    return [Tuple tupleWithFirst:self.second second:self.first];
}

- (NSString *) description {
    return [NSString stringWithFormat: @"(%g,%g)", self.first, self.second];
}

@end


//
//  main.m
//  Functional
//
//  Created by Andrew Zamler-Carhart on 12/7/19.
//

#import <Foundation/Foundation.h>
#import "NSArray+Functional.h"
#import "Tuple.h"

// get rid of NSLog annoying date strings
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

typedef NSNumber *(^UnaryNumberBlock)(NSNumber *);
typedef NSNumber *(^BinaryNumberBlock)(NSNumber *, NSNumber *);
typedef NSNumber *(^TupleBlock)(Tuple *);

double roundDouble(double value) {
    return round(1000000 * value) / 1000000;
}
int fact(int n) {
  return n > 0 ? n * fact(n - 1) : 1;
}

TupleBlock add = ^(Tuple *tuple) {
    return [NSNumber numberWithDouble: tuple.first + tuple.second];
};
TupleBlock subtract = ^(Tuple *tuple) {
    return [NSNumber numberWithDouble: tuple.first - tuple.second];
};
TupleBlock multiply = ^(Tuple *tuple) {
    return [NSNumber numberWithDouble: tuple.first * tuple.second];
};
TupleBlock divide = ^(Tuple *tuple) {
    return [NSNumber numberWithDouble: roundDouble(tuple.first / tuple.second)];
};
UnaryNumberBlock identity = ^(NSNumber *value) {
    return value;
};
UnaryNumberBlock decimalPoint = ^(NSNumber *value) {
    return [NSNumber numberWithDouble: [value doubleValue] / 10.0];
};
UnaryNumberBlock twice = ^(NSNumber *value) {
    return [NSNumber numberWithInt: [value intValue] * 2];
};
UnaryNumberBlock square = ^(NSNumber *value) {
    return [NSNumber numberWithInt: [value intValue] * [value intValue]];
};
UnaryNumberBlock squareRoot = ^(NSNumber *value) {
    return [NSNumber numberWithDouble: sqrt([value doubleValue])];
};
UnaryNumberBlock factorial = ^(NSNumber *value) {
    return [NSNumber numberWithDouble: fact([value intValue])];
};

BinaryNumberBlock sum = ^(NSNumber *value1, NSNumber *value2) {
    return [NSNumber numberWithDouble: [value1 doubleValue] + [value2 doubleValue]];
};

id (^join)(id) = ^id(id array) {
     return [NSString stringWithFormat: @"[%@]", [array join]];
};

NSArray *combineFours(NSArray *fa, NSArray *fb) {
    return [[[[[[[fa matrixMap:[Tuple make] objects:fb]
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
    NSArray *fours4 = [combineFours(fours1, fours3)
                concat:combineFours(fours2, fours2)];
    NSLog(@"One four: %@", [fours1 join]);
    NSLog(@"Two fours: %@", [fours2 join]);
    NSLog(@"Found: %@", [[target filterObjectsIn:fours4] join]);
    NSLog(@"Missing: %@", [[target removeObjectsIn:fours4] join]);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        

        NSArray *colors = @[@"red", @"orange", @"yellow", @"green", @"blue", @"purple"];
        
        NSLog(@"Generate");

        __block int i = 0;
        NSArray *numbers = [NSArray generate:^id{
            return [NSNumber numberWithInt: ++i];
        } count:10];

        NSArray *randomNumbers = [NSArray generate:^id{
            int value = arc4random_uniform(100) + 1;
            return [NSNumber numberWithInt: value];
        } count:10];

        NSLog(@"Random numbers: %@", [randomNumbers join]);

        NSLog(@"\nEach");
        [colors each:^(id value) {
            NSLog(@"  %@", value);
        }];
        
        NSLog(@"\nEvery");

        NSLog(@"All colors contain letter E: %@", [colors every:^BOOL(id value) {
            return [value contains:@"e"];
        }] ? @"yes" : @"no");

        NSLog(@"\nAny");

        NSLog(@"Any color longer than 6: %@", [colors any:^BOOL(id value) {
            return [value length] > 6;
        }] ? @"yes" : @"no");

        NSLog(@"\nContains Objects");
        
        NSLog(@"Colors contain blue and purple: %@", [colors containsObjects:@[@"blue", @"purple"]] ? @"yes" : @"no");

        NSLog(@"\nFind");
        
        NSLog(@"First color of length 4: %@", [colors find:^BOOL(id value) {
            return [value length] == 4;
        }]);

        NSLog(@"\nMap");
        
        NSLog(@"Length of each color: %@", [[colors map:^id(id value) {
            return [NSNumber numberWithLong: [value length]];
        }] join]);

        NSLog(@"\nIndexed Map");
        
        NSLog(@"Indexed colors: %@", [[colors indexedMap:^id(NSUInteger i, id value) {
            return [NSString stringWithFormat: @"%lu %@", i, value];
        }] join]);

        NSLog(@"\nSquare Map");
        
        NSArray *multiplicationTable = [numbers squareMap:^id(id object1, id object2) {
            return [NSNumber numberWithInt: [object1 intValue] * [object2 intValue]];
        }];
        NSLog(@"Multiplication table:\n%@",
            [[multiplicationTable map:join] join: @"\n"]);

        NSLog(@"\nNested Map");
        
        NSLog(@"Doubled multiplication table:\n%@",
            [[[multiplicationTable nestedMap:twice] map:join] join: @"\n"]);

        NSLog(@"\nMulti Map");

        NSLog(@"Squares and square roots:\n%@",
            [[[numbers multiMap: @[identity, square, squareRoot]]
                map:join] join: @"\n"]);

        NSLog(@"\nReplace");

        NSDictionary *frenchColors = @{
            @"red": @"rouge",
            @"yellow": @"jaune",
            @"green": @"vert",
            @"blue": @"bleu",
            @"purple": @"violet",
        };
        NSLog(@"French colors: %@", [[colors replace:frenchColors] join]);

        NSLog(@"\nFilter");

        NSLog(@"Colors of length 6: %@", [[colors filter:^BOOL(id value) {
          return [value length] == 6;
        }] join]);

        NSLog(@"Even numbers: %@", [[randomNumbers filter:^BOOL(id value) {
          return [value intValue] % 2 == 0;
        }] join]);

        NSLog(@"\nRemove");

        NSLog(@"Colors that don't start with G: %@", [[colors remove:^BOOL(id value) {
          return [value hasPrefix:@"g"];
        }] join]);

        NSLog(@"No numbers over 50: %@", [[randomNumbers remove:^BOOL(id value) {
          return [value intValue] > 50;
        }] join]);

        NSLog(@"\nReduce");

        NSLog(@"Shortest color: %@", [colors reduce:^id(id acc, id value) {
            return [value length] <= [acc length] ? value : acc;
        }]);
        NSLog(@"Sum of numbers: %@", [numbers reduce:sum initial:0]);

        NSLog(@"\nSort");

        NSLog(@"Colors sorted by default: %@", [[colors sort] join]);

        NSLog(@"Colors sorted using block: %@", [[colors sort:^(NSString *a, NSString *b) {
            return [a compare: b];
        }] join]);

        NSLog(@"Colors sorted by length: %@", [[colors sortBy:^NSUInteger(id value) {
          return [value length];
        }] join]);

        NSLog(@"\nReverse");

        NSLog(@"Reversed colors: %@", [[colors reverse] join]);
        NSLog(@"Reversed numbers: %@", [[numbers reverse] join]);

        NSLog(@"\nUnique");

        NSArray *dupes = @[@1, @1, @1, @2, @2, @3];
        NSLog(@"Unique numbers: %@", [[[dupes unique] sort] join]);
        
        NSLog(@"\nLimit");

        NSLog(@"First 3 colors: %@", [[colors limit:3] join]);
        NSLog(@"First 3 numbers: %@", [[numbers limit:3] join]);

        NSLog(@"\nRandom object");

        NSLog(@"Random color: %@", [colors randomObject]);
        NSLog(@"Random number: %@", [numbers randomObject]);

        NSLog(@"\nShuffle");

        NSLog(@"Shuffled colors: %@", [[colors shuffle] join]);
        NSLog(@"Shuffled numbers: %@", [[numbers shuffle] join]);


        
        NSLog(@"\nZip");

        NSLog(@"Numbers and colors: %@", [[numbers zip:colors] join]);
        
        NSLog(@"\nFlatten");

        NSArray *nested = @[@[@1, @2], @[@3, @[@4, @[@5, @[@6]]]]];
        NSLog(@"Nested array flattened: %@", [[nested flatten] join]);
        NSLog(@"Squared nested array: %@", [[[nested nestedMap:square] flatten] join]);

        NSLog(@"\nFour Fours");
        fourFours();
    }
    return 0;
}
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

double roundDouble(double value) {
    return round(1000000 * value) / 1000000;
}

int fact(int n) {
  return n > 0 ? n * fact(n - 1) : 1;
}

Transform identity = ^(id value) {
    return value;
};
Transform decimalPoint = ^(NSNumber *value) {
    return [NSNumber numberWithDouble: [value doubleValue] / 10.0];
};
Transform twice = ^(NSNumber *value) {
    return [NSNumber numberWithInt: [value intValue] * 2];
};
Transform square = ^(NSNumber *value) {
    return [NSNumber numberWithInt: [value intValue] * [value intValue]];
};
Transform squareRoot = ^(NSNumber *value) {
    return [NSNumber numberWithDouble: sqrt([value doubleValue])];
};
Transform factorial = ^(NSNumber *value) {
    return [NSNumber numberWithDouble: fact([value intValue])];
};
Operation sum = ^(NSNumber *value1, NSNumber *value2) {
    return [NSNumber numberWithDouble: [value1 doubleValue] + [value2 doubleValue]];
};
Operation product = ^(NSNumber *value1, NSNumber *value2) {
    return [NSNumber numberWithDouble: [value1 doubleValue] * [value2 doubleValue]];
};
Transform add = ^(Tuple *tuple) {
    return [NSNumber numberWithDouble: tuple.first + tuple.second];
};
Transform subtract = ^(Tuple *tuple) {
    return [NSNumber numberWithDouble: tuple.first - tuple.second];
};
Transform multiply = ^(Tuple *tuple) {
    return [NSNumber numberWithDouble: tuple.first * tuple.second];
};
Transform divide = ^(Tuple *tuple) {
    return [NSNumber numberWithDouble: roundDouble(tuple.first / tuple.second)];
};
Transform join = ^(id array) {
     return [array join];
};

NSArray *combineFours(NSArray *foursA, NSArray *foursB) {
    return [[[[[[[foursA matrixMap:[Tuple make] objects:foursB]
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
    NSLog(@"Found: %@", [[target filterObjectsIn:fours4] join]);
    NSLog(@"Missing: %@", [[target removeObjectsIn:fours4] join]);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSArray *colors = @[@"red", @"orange", @"yellow", @"green", @"blue", @"purple"];

        NSLog(@"Generate");

        __block int i = 0;
        NSArray *numbers = [NSArray generate:^{
            return [NSNumber numberWithInt: ++i];
        } count:10];

        NSArray *randomNumbers = [@10 times:^{
            return [NSNumber numberWithInt: arc4random_uniform(100) + 1];
        }];

        NSLog(@"Random numbers: %@", [randomNumbers join]);

        NSLog(@"\nApply");
        
        NSLog(@"Square root of 25: %@", [@25 apply:squareRoot]);

        NSLog(@"\nApply All");
        
        NSLog(@"1 Four: %@", [[@4.0 applyAll: @[decimalPoint, squareRoot, identity, factorial]] join]);
                           
        NSLog(@"\nCopies");
        
        NSLog(@"3 Yeahs: %@", [[@"Yeah!" copies:3] join: @" "]);
        NSLog(@"3 Yeahs: %@", [[@3 copiesOf: @"Yeah!"] join: @" "]);

        NSLog(@"\nEach");
        [colors each:^(id value) {
            NSLog(@"  %@", value);
        }];

        NSLog(@"\nEvery");

        NSLog(@"All colors contain letter E: %@", [colors every:^(id value) {
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

        NSLog(@"Length of each color: %@", [[colors map:^(id value) {
            return [NSNumber numberWithLong: [value length]];
        }] join]);

        NSLog(@"\nIndexed Map");

        NSLog(@"Indexed colors: %@", [[colors indexedMap:^(NSUInteger i, id value) {
            return [NSString stringWithFormat: @"%lu %@", i, value];
        }] join]);

        NSLog(@"\nMatrix Map");

        NSLog(@"All number color combinations:\n%@",
            [[[numbers matrixMap:^(id number, id color) {
                return [NSString stringWithFormat: @"%@ %@", number, color];
            } objects:colors] map:join] join: @"\n"]);

        NSLog(@"\nSquare Map");

        NSArray *multiplicationTable = [numbers squareMap:^(id object1, id object2) {
            return [NSNumber numberWithInt: [object1 intValue] * [object2 intValue]];
        }];
        NSLog(@"Multiplication table:\n%@",
            [[multiplicationTable map:join] join: @"\n"]);

        NSLog(@"\nChild Map");

        NSLog(@"Doubled multiplication table:\n%@",
            [[[multiplicationTable childMap:twice] map:join] join: @"\n"]);
        
        NSLog(@"\nNested Map");

        NSArray *nested = @[@[@1, @2], @[@3, @[@4, @[@5, @[@6]]]]];
        NSLog(@"Squared nested array: %@", [[nested nestedMap:square] nestedJoin]);

        NSLog(@"\nMap All");

        NSLog(@"Squares and square roots:\n%@",
            [[[numbers mapAll: @[identity, square, squareRoot]]
                map:join] join: @"\n"]);

        NSLog(@"\nGenerators");

        NSArray *greeters = [numbers generators:^(id number) {
            return [number copiesOf: @"hi"];
        }];
        for (Generator greeter in greeters) {
            NSLog(@"%@", [greeter() join]);
        }
        
        NSLog(@"\nTransforms");

        NSArray *multipliers = [numbers transforms:product];
        NSLog(@"Multiples of 3: %@", [[@3 applyAll: multipliers] join]);

        NSArray *repeaters = [[numbers limit:3] transforms:^(id number, id value) {
            return [number copiesOf: value];
        }];
        NSLog(@"%@", [[[[colors mapAll:repeaters] childMap:join] map:join] join:@"\n"]);
        
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

        NSLog(@"Colors that don't start with G: %@", [[colors remove:^(id value) {
          return [value hasPrefix:@"g"];
        }] join]);

        NSLog(@"No numbers over 50: %@", [[randomNumbers remove:^BOOL(id value) {
          return [value intValue] > 50;
        }] join]);

        NSLog(@"\nReduce");

        NSLog(@"Shortest color: %@", [colors reduce:^(id acc, id value) {
            return [value length] <= [acc length] ? value : acc;
        }]);
        NSLog(@"Sum of numbers: %@", [numbers reduce:sum initial:0]);

        NSLog(@"\nSort");

        NSLog(@"Colors sorted by default: %@", [[colors sort] join]);

        NSLog(@"Colors sorted using block: %@", [[colors sort:^(id a, id b) {
            return [a compare: b];
        }] join]);

        NSLog(@"Colors sorted by length: %@", [[colors sortBy:^(id value) {
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

        NSLog(@"Nested array flattened: %@", [[nested flatten] join]);

        NSLog(@"\nConcat");

        NSLog(@"Colors and numbers: %@", [[colors concat: numbers] join]);

        NSLog(@"\nFour Fours");
        fourFours();
    }
    return 0;
}

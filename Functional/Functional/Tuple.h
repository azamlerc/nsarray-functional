//
//  Tuple.h
//  Functional
//
//  Created by Andrew Zamler-Carhart on 12/7/19.
//

#ifndef Tuple_h
#define Tuple_h

@interface Tuple : NSObject

@property double first;
@property double second;

+ (Tuple *) tupleWithFirst: (double) first
                    second: (double) second;
+ (id) make;
+ (id) bothWays;
- (Tuple *) reverse;

@end

#endif

//
//  main.m
//  prog1
//
//  Created by lvsheng on 15/11/7.
//  Copyright © 2015年 lvsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fraction : NSObject

-(void) print;
-(void) setNumberator: (int) n;
-(void) setDenominator: (int) d;

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Fraction *f = [[Fraction alloc] init];
        [f setNumberator: 1];
        [f setDenominator: 3];
        [f print];
    }
    return 0;
}

@implementation Fraction
{
    int numberator;
    int denominator;
}

-(void) print
{
    NSLog(@"%i/%i", numberator, denominator);
}

-(void) setNumberator: (int) n
{
    numberator = n;
}

-(void) setDenominator: (int) d
{
    denominator = d;
}

@end
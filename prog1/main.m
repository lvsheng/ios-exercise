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
        Fraction *fraction = [[Fraction alloc] init];
        [fraction setNumberator: 1];
        [fraction setDenominator: 3];

        SEL sel = @selector(print);
        NSLog(@"SEL: %s", sel); //try log SEL as a char*, and will log the function name "print"
        [fraction print];
        [fraction performSelector:sel]; //equal to [fraction print], the performSelector will transform SEL to id
    }
    return 0;
}

@implementation Fraction
{
    int numberator;
    int denominator;
}

static Fraction* sInstance = 0; //define a static member

-(void) print
{
    NSLog(@"%i/%i", numberator, denominator);
    NSLog(@"sInstance: %@", sInstance); //%@ will log the object, on this is null
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
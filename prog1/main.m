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
        //指针
        int *nP = alloca(sizeof(int));
        *nP = 3;
        NSLog(@"nP: %p, *nP: %d", nP, *nP);

        //NSNumber
        NSNumber *n = @3;
        NSLog(@"hello, %@", n);

        //class
        Fraction *fraction = [[Fraction alloc] init];
        [fraction setNumberator: 1];
        [fraction setDenominator: 3];

        //sel
        NSLog(@"sel");
        SEL sel = NSSelectorFromString(@"print");
        [fraction print];
        if (!fraction) {
            [NSException raise:@"fraction has no value" format:@"fraction is %@", fraction];
        }
        if (![fraction respondsToSelector: sel]) {
            [NSException raise:@"not existed sel" format:@"sel %s is not exist", sel_getName(sel)];
        }
        [fraction performSelector: sel]; //equal to [fraction print], the performSelector will call the method that sel select
        
        //imp
        NSLog(@"imp");
        IMP imp = [fraction methodForSelector: sel];
        void (*func)(id, SEL) = (void *)imp;
        func(fraction, sel);
        //TODO: 为什么methodForSelector都需要sel参数呢？而且试验里就算给methodForSelector传一个不存在的sel也可以得到一个可调用的func，在执行func时才抛出错误（即便func调用时传入正确的sel也仍抛错）
        //而如下面调用func时传入一个错误的sel却可以正常调用
        func(fraction, NSSelectorFromString(@"testasdlfkajsdf"));

        SEL sel2 = NSSelectorFromString(@"getResult");
        float (*func2)(id, SEL) = (void *)[fraction methodForSelector:sel2];
        NSLog(@"getResult: %f", func2(fraction, sel2));
        
        //SEL sel3 = NSSelectorFromString(@"setNumberatorWithNSNumber");
        //void (*func3)(id, SEL, int) = (void *)[fraction methodForSelector:sel3];
        //func3(fraction, sel3, 3); //调用会报错。。。说unrecognized selector。。。。 不知道为什么。。。
        //NSNumber *n3 = @3;
        //[fraction performSelector:sel3 withObject:n3];
        [fraction print];
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
    NSLog(@"sInstance: %g", [self getResult]);
    SEL sel = NSSelectorFromString(@"getResult");
        NSLog(@"result: %d", [self performSelector:sel]);
}

-(void) setNumberator: (int) n
{
    numberator = n;
}

-(void) setNumberatorWithNSNumber:(NSNumber*)n
{
    [self setNumberator:[n intValue]];
}

-(void) setDenominator: (int) d
{
    denominator = d;
}

-(float) getResult
{
    return (float)numberator / denominator;
}

@end
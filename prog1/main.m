//
//  main.m
//  prog1
//
//  Created by lvsheng on 15/11/7.
//  Copyright © 2015年 lvsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Test: NSObject
-(void) print;
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (0) {
            NSLog(@"1 is true");
        } else {
            NSLog(@"0 is not true");
        }
        if (1) {
            NSLog(@"1 is true");
        } else {
            NSLog(@"1 is not true");
        }
        if (2) {
            NSLog(@"2 is true");
        } else {
            NSLog(@"2 is not true");
        }
        if ("hello") {
            NSLog(@"cstring is true");
        } else {
            NSLog(@"cstring is not true");
        }
        if (@"sd") {
            NSLog(@"NSString is true");
        } else {
            NSLog(@"NSString is not true");
        }
        if (@3) {
            NSLog(@"@3 is true");
        } else {
            NSLog(@"@3 is not true");
        }
        if (FALSE) {
            NSLog(@"FALSE is true");
        } else {
            NSLog(@"FALSE is not true");
        }
        if (TRUE) {
            NSLog(@"TRUE is true");
        } else {
            NSLog(@"TRUE is not true");
        }

        NSLog(@"\n\n---------------------------");
        if (nil) {
            NSLog(@"nil is true");
        } else {
            NSLog(@"nil is not true");
            NSLog(@"nil - 1: %d", nil - 1);
            NSLog(@"nil == 0: %d", (nil == 0));
        }
        if (Nil) {
            NSLog(@"Nil is true");
        } else {
            NSLog(@"Nil is not true");
            NSLog(@"Nil - 1: %d", Nil - 1);
            NSLog(@"Nil == 0: %d", (Nil == 0));
        }
        
        NSLog(@"\n\n---------------------------");
        if (NAN) {
            NSLog(@"NAN is true, NAN: %d, NAN-1: %d", NAN, NAN - 1);
        } else {
            NSLog(@"NAN is not true");
        }
        
        NSLog(@"\n\n---------------------------");
        int a;
        if (a) {
            NSLog(@"a is true");
        } else {
            NSLog(@"a is not true");
            NSLog(@"default value of int a: %d", a);
        }

        NSLog(@"\n\n---------------------------");
        int* aP;
        if (aP) {
            NSLog(@"aP is true");
        } else {
            NSLog(@"aP is not true");
            NSLog(@"default value of int* aP: %p", aP);
        }

        NSString *s;
        if (s) {
            NSLog(@"s is true");
        } else {
            NSLog(@"s is not true, default value of NSString *s: %p", s);
        }
        Test *test;
        if (test) {
            NSLog(@"test is true");
        } else {
            NSLog(@"test is not true");
            NSLog(@"test is not true, default value of Test *test: %p", test);
        }

        test = [[Test alloc] init];
        NSLog(@"after alloc and init");
        if (test) {
            NSLog(@"test is true");
            NSLog(@"test %p", test);
        } else {
            NSLog(@"test is not true");
        }
        
        
        NSLog(@"\n\n--------------------------- %s");
        BOOL bo = 3;
        if (bo && @"hello") {
            NSLog(@"value of bo && @\"hello\": , %d", bo && @"hello");
        }
        
        int n = 3;
        n = n ?: -1;
        NSLog(@"n: %d", n);
    }
    return 0;
}

@implementation Test

-(void) print
{
    NSLog(@"hello");
}

@end

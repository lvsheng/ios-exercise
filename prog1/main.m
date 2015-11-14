//
//  main.m
//  prog1
//
//  Created by lvsheng on 15/11/7.
//  Copyright © 2015年 lvsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "./MyPoint.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MyPoint *p = [MyPoint new];
        NSLog(@"直接调用");
        [p setX:@5 andY:@5];
        [p print];

        //SEL sel = NSSelectorFromString(@"someNonExistSelector");
        SEL sel = NSSelectorFromString(@"setX:andY:");

        //use sel (use pragma to disable compiler warning):
        NSLog(@"sel调用");
        if ([p respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [p performSelector:sel withObject:@50 withObject:@50];
#pragma clang diagnostic pop
        } else {
            NSLog(@"non existed selector: %s", sel_getName(sel));
        }
        [p print];

        //use imp (no compiler warning):
        NSLog(@"imp调用");
        IMP imp = [p methodForSelector:sel];
        void(*func)(id, SEL, NSNumber *, NSNumber *) = (void*) imp;
        if ([p respondsToSelector:sel]) {
            //TODO: 实际调用imp时传入的sel其实无效。。。？那干嘛还都要传呀？
            func(p, NSSelectorFromString(@"h123f&*$#_asfda"), @100, @100);
        } else {
            NSLog(@"non existed selector: %s, and the func still can got: %p, %d", sel_getName(sel), func, (int)func);
        }
        [p print];
    }
    return 0;
}

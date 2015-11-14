//
//  main.m
//  prog1
//
//  Created by lvsheng on 15/11/7.
//  Copyright © 2015年 lvsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "./MyPoint.h"
#import "react/MethodRouter.h"

void testMethodRouter ();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MyPoint *p = [MyPoint new];
        NSLog(@"直接调用");
        [p setX:@5 andY:@5];
        [p print];

        //SEL sel = NSSelectorFromString(@"someNonExistSelector");
        //TODO: 尝试不写参数名，还能找到相应方法么？
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
        NSLog(@"OBJC_OLD_DISPATCH_PROTOTYPES: %d", OBJC_OLD_DISPATCH_PROTOTYPES);
        // OBJC_OLD_DISPATCH_PROTOTYPES为0，故IMP在objc.h中被定义为无参数函数指针，故需再进一步强制转换（同时试验发现可以自己改objc.h来改动。。。好可怕）
        void(*func)(id, SEL, NSNumber *, NSNumber *) = (void*) imp;
        if ([p respondsToSelector:sel]) {
            //这里需要重复传入SEL的原因可参考：http://stackoverflow.com/questions/14305191/what-was-the-second-parameter-in-id-impid-sel-used-for
            //但某些情况，不传入也能“碰巧”(?)运行成功
            func(p, NSSelectorFromString(@"h123f&*$#_asfda"), @100, @100);
        } else {
            NSLog(@"non existed selector: %s, and the func still can got: %p, %d", sel_getName(sel), func, (int)func);
        }
        [p print];

        testMethodRouter();
    }
    return 0;
}

@interface A: NSObject
@property char name;

-(void)test0;
-(void)test1;
-(void)test2;
@end

@interface B: NSObject
@property char name;

-(void)test0;
-(void)test1;
-(void)test2;
@end

@interface C: A
-(void)test0;
-(void)test1;
-(void)test2;
@end


void testMethodRouter () {
    NSLog(@"\n\n--------------------------------------------");

    //TODO: place to map
    A *a = [A new];
    a.name = 'a';
    B *b = [B new];
    b.name = 'b';
    C *c = [C new];
    c.name = 'c';
    A *d = [C new];
    d.name = 'd';

    NSLog(@"\n\n--------------");
    [MethodRouter invokeMethod:0 of:a];
    [MethodRouter invokeMethod:1 of:a];
    [MethodRouter invokeMethod:2 of:a];

    NSLog(@"\n\n--------------");
    [MethodRouter invokeMethod:0 of:b];
    [MethodRouter invokeMethod:1 of:b];
    [MethodRouter invokeMethod:2 of:b];

    NSLog(@"\n\n--------------");
    [MethodRouter invokeMethod:0 of:c];
    [MethodRouter invokeMethod:1 of:c];
    [MethodRouter invokeMethod:2 of:c];

    NSLog(@"\n\n--------------");
    [MethodRouter invokeMethod:0 of:d];
    [MethodRouter invokeMethod:1 of:d];
    [MethodRouter invokeMethod:2 of:d];
}

@implementation A
-(void)test0 {
    NSLog(@"test0 in A, name: %c", self.name);
}
-(void)test1 {
    NSLog(@"test1 in A, name: %c", self.name);
}
-(void)test2 {
    NSLog(@"test2 in A, name: %c", self.name);
}
@end

@implementation B
-(void)test0 {
    NSLog(@"test0 in B, name: %c", self.name);
}
-(void)test1 {
    NSLog(@"test1 in B, name: %c", self.name);
}
-(void)test2 {
    NSLog(@"test2 in B, name: %c", self.name);
}
@end

@implementation C
-(void)test0 {
    NSLog(@"test0 in C, name: %c", self.name);
    NSLog(@"call super in C:");
    [super test0];
}
-(void)test1 {
    NSLog(@"test1 in C, name: %c", self.name);
    NSLog(@"call super in C:");
    [super test1];
}
-(void)test2 {
    NSLog(@"test2 in C, name: %c", self.name);
    NSLog(@"call super in C:");
    [super test2];
}
@end

//
//  main.m
//  prog1
//
//  Created by lvsheng on 15/11/7.
//  Copyright © 2015年 lvsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "./MyPoint.h"
#import "test/MethodRouterTest.h"

void testSEL ();
void testPolymorphism();
void testSelTime(int);
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        testSelTime((int) 1e2);
        testSelTime((int) 184);
        testSelTime((int) 1e3);
//        testSEL();
//        testPolymorphism();
//        [MethodRouterTest test];
    }
    return 0;
}

//TODO: 试现在o2o条件下的性能（两种方式）
void testSelTime(int amount) {
    MyPoint *point = [MyPoint new];
    NSLog(@"【start】, amount: %d", amount);

    int i;

    NSLog(@"---------------------直接调用---------------------");
    for (i = 0; i < amount; ++i) {
        [point test];
    }
    NSLog(@"done\n\n");

    NSString *methodName = @"test";

    NSLog(@"---------------------SEL调用---------------------");
    for (i = 0; i < amount; ++i) {
        SEL sel = NSSelectorFromString(methodName);
        [point performSelector:sel];
    }
    NSLog(@"done\n\n");

    NSLog(@"---------------------imp调用---------------------");
    for (i = 0; i < amount; ++i) {
        SEL sel = NSSelectorFromString(methodName);
        IMP imp = [point methodForSelector:sel];
        void(*func)(id, SEL) = (void*) imp;
        func(point, sel);
    }
    NSLog(@"done\n\n");

    NSLog(@"---------------------string append---------------------");
    for (i = 0; i < amount; ++i) {
        methodName = [methodName stringByAppendingString:@"a"];
    }
    NSLog(@"done\n\n");

    NSLog(@"---------------------string append + NSSelectorFromString---------------------");
    for (i = 0; i < amount; ++i) {
        methodName = [methodName stringByAppendingString:@"a"];
        SEL sel = NSSelectorFromString(methodName);
    }
    NSLog(@"done\n\n");
}

void testSEL () {
    NSLog(@"\n\n---------------------testSEL---------------------");

    MyPoint *p = [MyPoint new];
    NSLog(@"直接调用");
    [p setX:@5 andY:@5];
    [p print];

    SEL sel = NSSelectorFromString(@"setX:andY:");
    //[p performSelector:NSSelectorFromString(@"setX::") withObject:@52 withObject:@52]; //will throw: unrecognized selector

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
}

@interface SubMyPoint: MyPoint
-(void)print;
@end
@implementation SubMyPoint
-(void)print {
    NSLog(@"print in SubMyPoint, and i'll call super:");
    [super print];
}
@end
void testPolymorphism () {
    NSLog(@"\n\n----------------testPolymorphism----------------");

    //调用到的方法只与实际是哪个类有关，与声明为哪个类无关
    // 如objc_object结构体中所定义，每个对象中仅有isa指向一个由子类到父类的objc_class的链表
    // 而每个objc_class中保存了对应在这个类中的属性与方法
    // 调用时，是从实例的isa也就是最底层类开始向上找
    // 也即，调用到哪个方法，完全是看对象而定，而不论其类型。甚至其实是支持动态改变方法的吧
    id pIdParent = [MyPoint new];
    ((SubMyPoint *)pIdParent).x = @1;
    ((SubMyPoint *)pIdParent).y = @1;
    [pIdParent print];

    id pIdSub = [SubMyPoint new];
    ((SubMyPoint *)pIdSub).x = @2;
    ((SubMyPoint *)pIdSub).y = @2;
    [pIdSub print];

    MyPoint *pParentSub = [SubMyPoint new];
    pParentSub.x = @3;
    pParentSub.y = @3;
    [pParentSub print];

    SubMyPoint *pSubSub = [SubMyPoint new];
    pSubSub.x = @4;
    pSubSub.y = @4;
    [pSubSub print];
}
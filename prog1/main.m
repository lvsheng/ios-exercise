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

void testException () {
    id i = [MyPoint new];
    SEL sel = @selector(add:);
    @try {
        @try {
            [i performSelector:sel];
        }
        @catch (NSException *exception) {
            NSLog(@"catched exce: %@", exception);
            @throw;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }

    @try {
        [NSException raise:@"Invalid foo value" format:@"foo of %d is invalid", 3];
    }
    @catch (NSException *exception) {
        NSLog(@"my exception: %@", exception);
    }

    @try {
        @throw [NSException exceptionWithName:@"some" reason:@"some reason" userInfo:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"my exception: %@", exception);
    }
    @finally {
        NSLog(@"finally");
    }
    NSLog(@"after try");
}

@interface ClassA: NSObject
-(int) add:(int)n;
//oc仅通过selector定位方法，而参数类型并不能在定位方法上起到作用。故：
//-(int) add:(double)n; //不允许存在同名但参数类型不同的方法
//-(double) add:(int)a; //返回值不同也不行
-(int) add:(int)a with:(int)b; //但参数描述也算在选择器中，故可以
@end
@implementation ClassA
-(int) add: (int)n {
    return n + 1;
}
@end
@interface ClassB: NSObject
-(float) add:(float)n;
@end
@implementation ClassB
-(float) add:(float)n {
    return n + (float)0.5;
}
@end
void testIsMemberOf () {
    ClassA *ca = [ClassA new];

    NSLog(@"%p", [ClassA class]);
    NSLog(@"%d", [ClassA class] == [[ClassA class] class]);
    NSLog(@"%d", [ca isMemberOfClass:[ClassA class]]); //true
    NSLog(@"%d", [ca isMemberOfClass:[NSObject class]]); //false
    NSLog(@"%d", [ca isKindOfClass:[NSObject class]]); //true
}
void testCallSameNameMethod () {
    id i;
    ClassA *ca = [ClassA new];
    NSLog(@"%d", [ca add:2]);
    i = ca;
    //因为ClassB存在，故编译器不知道通过选择器获取到的imp该转换为怎样的函数签名，于是下面两行报错
//    NSLog(@"%d", [i add:2]);
//    NSLog(@"%d", [i add:@2]);
    //但自己转是ok的：
    SEL sel = @selector(add:);
    IMP imp = [i methodForSelector:sel];
    int(*func)(id, SEL, int) = (void*)imp;
    NSLog(@"%d", func(i, sel, 3));
    NSLog(@"%d", [i performSelector:sel withObject: @3]); //performSelector只能带object参数，这里调用不正常，只做示例
}

void testMessage () {
    id p = [MyPoint new];
    SEL sel = @selector(test1:);
    IMP imp = [MyPoint instanceMethodForSelector:sel];

    //函数调用时没有进行任何参数/返回值类型检查
    //拿到imp之后，下面可以把它强转为任何签名的函数并进行调用。。。
    long(*func)(id, SEL, long) = (void*)imp; //正常调用
    NSLog(@"%ld", func(p, sel, (int)'a'));

    char(*func2)(id, SEL, int) = (void*)imp; //返回值做不同类型来处理
    NSLog(@"%c", func2(p, sel, (int)'a'));

    int(*func3)(id, SEL, void *) = (void*)imp; //传入不同类型参数
    NSLog(@"%d, %d", func3(p, sel, (void *)imp), (int)imp);

    char*(*func4)(id, SEL, void *) = (void*)imp;
    char b[2];
    b[1] = '$';
    NSLog(@"%c", *func4(p, sel, b));

    int(*func5)(id, SEL, NSNumber *) = (void*)imp;
    NSLog(@"%d", func5(p, sel, @1));

    char(*func6)(id, SEL, int, int) = (void*)imp;
    NSLog(@"%c", func6(p, sel, 64, 2)); //多余的参数被忽略

    int(*func7)(id, SEL) = (void*)imp;
    NSLog(@"%d", func7(p, sel)); //缺少参数也可以执行。。。

    int *n = malloc(sizeof(int));
    *n = 97;
    int*(*func8)(id, SEL, int*) = (void*)imp;
    NSLog(@"%d", *func8(p, sel, (n + 90))); //使用指针访问非法内存空间。。。

    void*(*func9)(id, SEL, id) = (void*)imp;
    void *r = func9(p, sel, @2);
    NSLog(@"%p", r); //操作NSNumber指针
    NSLog(@"%c", *(char*)r); //但NSNumber内部空间貌似不允许直接进入访问，此行会导致程序以139异常中止
}

void testCallMethodError () {
    id i = [MyPoint new];
    [i print];
    i = @3;
    //运行时才会报错，但编译时并不会。再次验证了真地是动态“发消息”，而不是提前编译时找到方法地址然后进行调用
    //并且与比如java、c++的多态应该也不一样，如果是c++或java，应该是父类上有相应的方法，才允许调用，运行时再根据具体类找到要调用的函数地址
    [i print];
}

void testNSNumber () {
    NSNumber *a = [NSNumber new]; //TODO 除了@，不能new或者alloc,init方式来创建一个NSNumber么？打印出来地址都是0呢~
    NSNumber *b = @3;
    [a initWithFloat:3.2];
    NSLog(@"a: %@, initRes: %@, %p", a, [a initWithFloat:3.2], a);
    NSLog(@"b: %@, %p", b, b);
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
//可重载父类同名方法，但参数必需一致
//但selector也算在方法名中，故setX:与setX:withY与setX:withY:andPrint是三个不同的方法
//但貌似父类方法、子类方法、甚至@interface与@implementation中、声明与调用中参数类型不同也只是警告
-(void)print;
-(void) setX: (NSString *)str;
-(void) setX: (NSNumber *)x andY: (NSNumber *)y;
-(void) setX: (NSNumber *)x andY: (NSNumber *)y andPrint: (NSString *) str;
@end
@implementation SubMyPoint
-(void)print {
    NSLog(@"print in SubMyPoint, and i'll call super:");
    [super print];
}
-(void) setX: (NSNumber *)str {
    NSLog(@"setX(int) SubMyPoing, i'll call super, %@", str);
    [super setX:@101];
}
-(void) setX: (NSNumber *)xx andY: (NSNumber *)y {
    NSLog(@"setX andY in SubMyPoing, i'll call super");
    [super setX:xx andY:y];
}
-(void) setX: (NSNumber *)x andY: (NSNumber *)y andPrint: (NSString *) str {
    NSLog(@"setX:andY:andPrint in SubMyPoing, i'll call super setX and y, and then print");
    [super setX:x andY:y];
    NSLog(@"print: %@", str);
    [self print];
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

    [pSubSub setX:@1 andY:@1 andPrint:@"hello"];

    [pSubSub setX:@"3"];
    [pSubSub print];

    [pSubSub setX:[NSNumber numberWithDouble:12]];
    [pSubSub print];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        testSelTime((int) 1e2);
//        testSelTime((int) 184);
//        testSelTime((int) 1e3);
//        testSEL();
//        testPolymorphism();
//        [MethodRouterTest test];
//        testNSNumber();
//        testCallMethodError();
//        testMessage();
//        testCallSameNameMethod();
//        testIsMemberOf();
        testException();
    }
    return 0;
}


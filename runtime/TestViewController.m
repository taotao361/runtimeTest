//
//  TestViewController.m
//  runtime
//
//  Created by yangxutao on 17/3/20.
//  Copyright © 2017年 yangxutao. All rights reserved.
//

#import "TestViewController.h"
#import <objc/runtime.h>
#import "UIView+associate.h"
#import "albumInfo.h"
#import "albumInfo+category.h"
#import "TestView.h"


@interface TestViewController ()

@end

@implementation TestViewController

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSNumber *num1 = @(22);
    NSNumber *num2 = @(33);
    NSNumber *num3 = @(11);
    NSString *key1 = @"key1";
    NSString *key2 = @"key2";
    
    NSMutableArray *array1 = [NSMutableArray array];
    [array1 addObject:num1];
    NSMutableArray *array2 = [NSMutableArray array];
    [array2 addObject:num2];
    [array1 addObject:num2];
    NSLog(@"array end -------------------------------");
    
    NSMutableSet *set1 = [NSMutableSet set];
    [set1 addObject:num1];
    NSMutableSet *set2 = [NSMutableSet set];
    [set2 addObject:num2];
    NSMutableSet *set3 = [NSMutableSet set];
    [set3 addObject:num3];
    NSLog(@"set end -------------------------------");
    
    NSMutableDictionary *dictionaryValue1 = [NSMutableDictionary dictionary];
    [dictionaryValue1 setObject:num1 forKey:key1];
    NSMutableDictionary *dictionaryValue2 = [NSMutableDictionary dictionary];
    [dictionaryValue2 setObject:num2 forKey:key2];
    NSLog(@"dictionary value end -------------------------------");
    
    NSMutableDictionary *dictionaryKey1 = [NSMutableDictionary dictionary];
    [dictionaryKey1 setObject:num1 forKey:@"wq"];
    NSMutableDictionary *dictionaryKey2 = [NSMutableDictionary dictionary];
    [dictionaryKey2 setObject:num2 forKey:@"ewew"];
    NSLog(@"dictionary key end -------------------------------");
    
    
    UIColor *color1 = [UIColor redColor];
    UIColor *color2 = [UIColor redColor];
    NSLog(@"------- %p     %p",color1,color2);
    
    
    
    
    
    
    
    
}


- (NSUInteger)hash {
    NSUInteger hash =  [super hash];
    NSLog(@"hash = %lu",hash);
    return hash;
}




- (void)test {
    /*
     类：首先一个类是结构体，objc_class 别名为 *Class  --->  typedef struct objc_class *Class;
     看看结构体里边有什么东西：
     struct objc_class {
     Class isa  OBJC_ISA_AVAILABILITY; //isa指针，指向父类；
     
     #if !__OBJC2__
     Class super_class                                        父类
     const char *name                                         类名
     long version
     long info
     long instance_size                                       类实例大小;
     struct objc_ivar_list *ivars                             变量、属性列表
     struct objc_method_list **methodLists                    类方法、实例方法列表;
     struct objc_cache *cache                                 缓存（最近使用的方法名，变量等，节约资源）
     struct objc_protocol_list *protocols                     遵守的协议列表
     #endif
     
     } OBJC2_UNAVAILABLE; OC版本为2开始有的；
     
     
     [receiver message];
     // 底层运行时会被编译器转化为：发送消息，向receiver发送message消息；
     objc_msgSend(receiver, selector)
     OC被设计为万物皆对象，但是底层会转为C语言的代码；
     
     
     1、获取所有的成员变量；
     class_copyPropertyList
     根据每一个objc_property_t获取对应的属性名：property_getName （const char）
     2、获取一个类的所有方法
     class_copyMethodList
     根据每一个Method获取方法名：method_getName
     
     3、获取成员列表 class_copyIvarList
     根据每一个Ivar 获取 成员名称；ivar_getName
     
     
     4、获取一个类所遵守的所有协议 class_copyProtocolList
     根据每个协议Protocol 获取协议名：protocol_getName
     
     */
    
    
    //    objc_getClass("TestViewController");
    //    object_isClass(self);
    //    Class class = object_getClass(self);//获取类名
    //    const char *aaa = object_getClassName(self);
    //    NSLog(@"--------%s",aaa);
    
    
    
    //    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    //    vv.backgroundColor = [UIColor redColor];
    //    NSDictionary *dic = [vv associateDictionary];
    //    [self.view addSubview:vv];
    //    NSLog(@"======= %@",dic);
    
    
    //    TestView *vv = [[TestView alloc] init];
    //    unsigned int count;
    //    Class class = object_getClass(vv);
    //    objc_property_t *propertys = class_copyPropertyList(class, &count);
    //    for (int i = 0; i<count; i++) {
    //        const char *name = property_getName(propertys[i]);
    //        NSLog(@"---------- name = %s",name);
    //    }
    //
    //    Method *methods = class_copyMethodList(class, &count);
    //    for (int i = 0; i<count; i++) {
    //        Method method = methods[i];
    //        NSString *methodName = NSStringFromSelector(method_getName(method));
    //        NSLog(@"-------- method = %@",methodName);
    //    }
    //
    //    Ivar *ivarList = class_copyIvarList(class, &count);
    //    for (int i = 0; i<count; i++) {
    //        Ivar ivar = ivarList[i];
    //        const char *ivarName = ivar_getName(ivar);
    //        NSLog(@"------- ivarName = %s",ivarName);
    //    }
    //
    //    __unsafe_unretained Protocol **protocols = class_copyProtocolList(class, &count);
    //    for (int i = 0; i<count; i++) {
    //        Protocol *protocol = protocols[i];
    //        const char *protocolName = protocol_getName(protocol);
    //        NSLog(@"--------- protocol = %s",protocolName);
    //    }
    //
    //
    //    NSArray *arr = [vv performSelector:@selector(getArray)];
    //    NSLog(@"arr = %@",arr);
    
    //- (BOOL)isProxy; 判断一个实例是否继承自NSObject
    //    BOOL isProxy = [self isProxy];

}










@end

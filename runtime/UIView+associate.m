//
//  UIView+associate.m
//  runtime
//
//  Created by yangxutao on 17/3/20.
//  Copyright © 2017年 yangxutao. All rights reserved.
//

#import "UIView+associate.h"
#import <objc/runtime.h>

static char associatekey;

@implementation UIView (associate)

//给对象绑定一个属性
- (NSDictionary *)associateDictionary {
    NSDictionary *dic = objc_getAssociatedObject(self, &associatekey);
    if (dic) {
        return dic;
    }
    
    dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"22",@"11", nil];
    objc_setAssociatedObject(self, &associatekey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dic;
}

@end

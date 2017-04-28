//
//  People.h
//  runtime
//
//  Created by yangxutao on 16/8/23.
//  Copyright © 2016年 yangxutao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Car;
@interface People : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, strong) Car *car;
@end

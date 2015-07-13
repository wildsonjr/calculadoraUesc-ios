//
//  UIColor+Additions.m
//  Calculadora UESC
//
//  Created by Wildson Jr. on 7/11/15.
//  Copyright (c) 2015 Wildson Jr. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (UIColor *)darkGrayColor
{
    return [UIColor colorWithRed:67.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
}

+ (UIColor *)greenColor
{
    return [UIColor colorWithRed:47.0/255.0 green:83.0/255.0 blue:30.0/255.0 alpha:1.0];
}

+ (UIColor *)lightGrayColor
{
    return [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0];
}

+ (UIColor *)maroonColor
{
    return [UIColor colorWithRed:128.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
}

+ (UIColor *)orangeColor
{
    return [UIColor colorWithRed:248.0/255.0 green:156.0/255.0 blue:50.0/255.0 alpha:1.0];
}

+ (UIColor *)redColor
{
    return [UIColor colorWithRed:80.0/255.0 green:45.0/255.0 blue:30.0/255.0 alpha:1.0];
}

#pragma clang diagnostic pop

@end

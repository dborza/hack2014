//
//  UIStoryboard+Main.m
//  IntelSmartCityBiker
//
//  Created by Iustina Gligor on 4/5/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import "UIStoryboard+Main.h"

UIStoryboard *_mainStoryboard = nil;

@implementation UIStoryboard (Main)

+ (instancetype)ICBMainStoryboard {
    if (!_mainStoryboard) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *storyboardName = [bundle objectForInfoDictionaryKey:@"UIMainStoryboardFile"];
        _mainStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:bundle];
    }
    return _mainStoryboard;
}
@end

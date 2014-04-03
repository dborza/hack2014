//
//  BikeAnnotation.m
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import "BikeAnnotation.h"

@implementation BikeAnnotation

- (BikeAnnotation *)initWithLocation:(CLLocationCoordinate2D) coord
{
    self = [super init];
    if (self) {
        _coordinate = coord;
    }
    return self;
}
@end
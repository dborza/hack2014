//
//  BikeAnnotation.m
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import "BikeAnnotation.h"
#import "Bike.h"

@implementation BikeAnnotation

- (BikeAnnotation *)initWithLocation:(CLLocationCoordinate2D) coord bikeID:(int)bikeId;
{
    self = [super init];
    if (self) {
        _coordinate = coord;
        _bikeID = bikeId;
    }
    return self;
}
- (id)initBike:(Bike*) bike
{
    self = [super init];
    if (self) {
        _coordinate = bike.coord;
        _bikeID = bike.bikeID;
    }
    return self;
    
}
@end
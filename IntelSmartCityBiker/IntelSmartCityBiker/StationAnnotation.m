//
//  StationAnnotation.m
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//


#import "StationAnnotation.h"
#import "Station.h"


@implementation StationAnnotation

- (id) initWithStation: (Station *) station
{
    self = [super init];
    if (self) {
        _coordinate = station.coord;
        _stationID = station.stationId;
        _availableBikes = station.availableBikes;

    }
    return self;
}


@end

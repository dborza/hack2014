//
//  BikeAnnotation.h
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class Bike;

@interface BikeAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) int bikeID;
@property (nonatomic, assign) NSString *color;

- (BikeAnnotation *)initWithLocation:(CLLocationCoordinate2D) coord bikeID:(int)bikeId;

- (id)initBike:(Bike*) bike;

@end

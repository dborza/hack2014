//
//  Station.h
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Station : NSObject

@property (nonatomic,strong) NSString *city;
@property (nonatomic,assign) CLLocationCoordinate2D coord;
@property (nonatomic,assign) int availableBikes;
@property (nonatomic,assign) int stationId;

- (id) initWithDict: (NSDictionary *)dict;

@end

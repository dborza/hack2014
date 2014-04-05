//
//  BikeSearchCriteria.h
//  IntelSmartCityBiker
//
//  Created by Iustina Gligor on 4/5/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BikeSearchCriteria : NSObject

@property (nonatomic, strong) NSString * color;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, assign) BOOL shoppingBasket;
@property (nonatomic, assign) BOOL childrenSeat;
@property (nonatomic, assign) CLLocationCoordinate2D coord;

@end


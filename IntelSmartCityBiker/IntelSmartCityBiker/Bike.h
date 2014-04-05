//
//  Bike.h
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Bike : NSObject

@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * color;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, assign) BOOL shoppingBasket;
@property (nonatomic, assign) BOOL childrenSeat;
@property (nonatomic, assign) CLLocationCoordinate2D coord;
@property (nonatomic, assign)  int bikeID;


- (id) initWithLatitude:(NSString *)latitude longitude:(NSString *) longitude city:(NSString *) city status:(NSString *) status;
- (id) initWithDict: (NSDictionary *)dict;
@end

//
//  Bike.m
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import "Bike.h"

@implementation Bike

- (id) initWithLatitude:(NSString *)latitude longitude:(NSString *) longitude city:(NSString *) city status:(NSString *) status
{
    self = [super init];
    if (self)
    {
        _coord = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        _status = status;
        _city = city;
    }
    return self;
}

- (id) initWithDict: (NSDictionary *)dict
{
    if (dict)
    {
        self = [super init];
        if (self)
        {
            double lat = [[dict objectForKey:@"lat"] doubleValue];
            double  lon = [[dict objectForKey:@"lon"] doubleValue];
            
            _bikeID = [[dict objectForKey:@"bikeId"] integerValue];
            _coord = CLLocationCoordinate2DMake(lat,lon);
            _city = [dict objectForKey:@"city"];
            _status = [dict objectForKey:@"status"];
            _color = [dict objectForKey:@"color"];
            _type = [dict objectForKey:@"type"];
        }
    }
    return self;

    
}
@end

//
//  Station.m
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import "Station.h"

@implementation Station

- (id) initWithDict: (NSDictionary *)dict
{
    self = [super init];
    if(self)
    {
        if (dict)
        {
            _stationId = [[dict objectForKey:@"stationId"]integerValue];
            _city = [dict objectForKey:@"city"];
            _availableBikes = [[dict objectForKey:@"availableBikes"] integerValue];
            double lat =[[dict objectForKey:@"lat"] doubleValue];
            double lon = [[dict objectForKey:@"lon"] doubleValue];
            _coord = CLLocationCoordinate2DMake(lat, lon);
            
        }
        
    }
    return self;
}
@end

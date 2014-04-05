//
//  BikeWSRequest.m
//  IntelSmartCityBiker
//
//  Created by Iustina Gligor on 4/5/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import "BikeWSRequest.h"

@implementation BikeWSRequest
- (id) initWithRequest: (NSURLRequest *) request type:(WSType) type
{
    self =[super init];
    if (self)
    {
        _request = request;
        _type = type;
    }
    return self;
}

@end

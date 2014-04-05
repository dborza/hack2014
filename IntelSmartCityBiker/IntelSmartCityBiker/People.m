//
//  People.m
//  IntelSmartCityBiker
//
//  Created by Iustina Gligor on 4/5/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import "People.h"

@implementation People

- (id) initWithDict: (NSDictionary *)dict
{
    if (dict)
    {
        self = [super init];
        if (self)
        {
            _firstName = [dict objectForKey:@"firstName"];
            _lastName = [dict objectForKey:@"lastName"];
            _email = [dict objectForKey:@"email"];
            _persID =[[dict objectForKey:@"personId"] integerValue];
        }
    }
    return self;
    
    
}

- (NSString *) fullName
{
    return [NSString stringWithFormat:@"%@ %@",_firstName, _lastName];
}
@end

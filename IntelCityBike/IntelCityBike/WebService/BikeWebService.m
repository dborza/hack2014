//
//  BikeWebService.m
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import "BikeWebService.h"

NSString *const DanIP = @"http://54.72.167.121:8080";
NSString *const MihaiIP = @"http://10.41.0.136:8080";
@interface BikeWebService()


@property (nonatomic, strong) NSURLConnection * urlConnection;

@end

@implementation BikeWebService



- (BikeWebService *) init
{

    self = [super init];
    
    if(self)
    {
    }
    return self;
}

+ (id) sharedBikeWebService{
    static BikeWebService *sharedBikeService =nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBikeService = [[self alloc] init];
    });
    
    return sharedBikeService;
    
}

- (void) getAllBikes
{
    
    if (!_urlConnection)
    {
        NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"%@/bikes",DanIP] ];
        NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
        _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    }
    
}

#pragma mark - nsurlconnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}
@end

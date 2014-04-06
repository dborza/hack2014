//
//  BikeWebService.m
//  IntelCityBike
//
//  Created by Iustina Gligor on 4/3/14.
//  Copyright (c) 2014 Intel. All rights reserved.
//

#import "BikeWebService.h"
#import "JSONKit.h"
#import "Bike.h"
#import "Station.h"


NSString *const DanIP = @"http://54.72.175.223:8080";
NSString *const MihaiIP = @"http://10.41.0.136:8080";

#define PoolTime  2


@interface BikeWebService()


@property (nonatomic, strong) NSURLConnection * urlConnection;
@property (nonatomic, strong) NSMutableData * data;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *stationTimer;
@property (nonatomic, strong) JSONDecoder *decoder;
@property (nonatomic, assign) int x;
@end

@implementation BikeWebService



- (BikeWebService *) init
{

    self = [super init];
    
    if(self)
    {
         _decoder = [[JSONDecoder alloc] init];
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

- (void) getAllStations
{
    
    if (!_urlConnection)
    {
        NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"%@/stations",DanIP] ];
        NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
        _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    }
    
}
#pragma  mark - other methods
- (NSDictionary *) decodeBikes:(NSData *) bikes
{
    
    NSDictionary * dict = [_decoder objectWithData:bikes];
    
    NSDictionary * bikesDict = [dict objectForKey:@"_embedded"];
    NSArray *bikesArray = [bikesDict objectForKey:@"bikes"];
    
    for (NSDictionary *oneBikeDict in bikesArray ) {
        
        Bike * oneBike = [[Bike alloc] initWithDict:oneBikeDict];
        if (_delegate && [_delegate respondsToSelector:@selector(showBike:)])
        {
            [_delegate showBike:oneBike];
        }
    }
    return dict;
}
- (NSDictionary *) decodeStations:(NSData *) bikes
{
    
    NSDictionary * dict = [_decoder objectWithData:bikes];
    
    NSDictionary * stationsDict = [dict objectForKey:@"_embedded"];
    NSArray *stationsArray = [stationsDict objectForKey:@"stations"];
    
    for (NSDictionary *oneStationDict in stationsArray ) {
        
        Station * oneStation = [[Station alloc] initWithDict:oneStationDict];
        if (_delegate && [_delegate respondsToSelector:@selector(showStation:)])
        {

            
            oneStation.availableBikes +=_x;
            [_delegate showStation:oneStation];
        }
    }
    return dict;
}

#pragma mark - nsurlconnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_urlConnection cancel];
    _urlConnection = nil;
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc] init];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *s = [[NSString alloc] initWithBytes:_data.bytes length:[_data length] encoding:NSUTF8StringEncoding];
    //[self decodeBikes:_data];
    [self decodeStations:_data];
    
    [_urlConnection cancel];
    _urlConnection = nil;
}

- (void) stationsPool{
    
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"%@/stations",DanIP] ];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy  timeoutInterval:5 ];
    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (!error)
    {
        //_x+=1;
        [self performSelectorOnMainThread:@selector(decodeStations:) withObject:responseData waitUntilDone:YES];
    }
    
    //   [self performSelector:@selector(longBikesPool) withObject:nil];
    //  NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
    if (_stationTimer == nil)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _stationTimer = [NSTimer scheduledTimerWithTimeInterval:PoolTime target:self selector:@selector(stationsTimerFired:) userInfo:nil repeats:NO];
        });
    }
    //    [self performSelector:@selector(longBikesPool) withObject:nil afterDelay:PoolTime];
    
}


- (void) longBikesPool{
    
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    
    NSURL *url = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"%@/bikes/?page=0&size=10000",DanIP] ];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy  timeoutInterval:5 ];
    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (!error)
    {
        [self performSelectorOnMainThread:@selector(decodeBikes:) withObject:responseData waitUntilDone:YES];
    }
    
 //   [self performSelector:@selector(longBikesPool) withObject:nil];
  //  NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
    if (_timer == nil)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
        });
    }
//    [self performSelector:@selector(longBikesPool) withObject:nil afterDelay:PoolTime];
   
}

-(void) stationsTimerFired:(NSTimer *)timer{
    
    _stationTimer = nil;
    [self performSelectorInBackground:@selector(stationsPool) withObject:nil];
}

-(void) timerFired:(NSTimer *)timer{

    _timer = nil;
    [self performSelectorInBackground:@selector(longBikesPool) withObject:nil];
}

- (void) startStationsPooling
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self performSelectorInBackground:@selector(stationsPool) withObject:nil];
    });
    
}

- (void) startPooling
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self performSelectorInBackground:@selector(longBikesPool) withObject:nil];
    });

}
@end

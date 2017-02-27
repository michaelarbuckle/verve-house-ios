//
//  DevicesHTTPClient.m
//  Devices
//
//  Created by App-Order on 1/17/14.
//  Copyright (c) 2014 Scott Sherwood. All rights reserved.
//

#import "DevicesHTTPClient.h"


#warning PASTE YOUR API KEY HERE
static NSString* const WorldDevicesOnlineAPIKey = @"PASTE YOUR API KEY HERE";

//static NSString* const rest_verve_houseURLString = @"http://localhost:8080/";
static NSString* const rest_verve_houseURLString = @"http://rest.verve.house:8080/";

@implementation DevicesHTTPClient

+ (DevicesHTTPClient *)sharedDevicesHTTPClient
{
    static DevicesHTTPClient *_sharedDevicesHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDevicesHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:rest_verve_houseURLString]];
    });
    
    return _sharedDevicesHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (void)updateDevicesAtLocation:(CLLocation *)location forNumberOfDays:(NSUInteger)number
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"num_of_days"] = @(number);
    parameters[@"q"] = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
    parameters[@"format"] = @"json";
    parameters[@"key"] = WorldDevicesOnlineAPIKey;
    
    [self GET:@"Devices.ashx" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(DevicesHTTPClient:didUpdateWithDevices:)]) {
            [self.delegate DevicesHTTPClient:self didUpdateWithDevices:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(DevicesHTTPClient:didFailWithError:)]) {
            [self.delegate DevicesHTTPClient:self didFailWithError:error];
        }
    }];
}

@end

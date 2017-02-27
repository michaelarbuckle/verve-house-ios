//
//  DevicesHTTPClient.h
//  Devices
//
//  Created by App-Order on 1/17/14.
//  Copyright (c) 2014 Scott Sherwood. All rights reserved.
//


#import "AFHTTPSessionManager.h"
#import <CoreLocation/CoreLocation.h>


static NSString * const BaseURLString = @"http://localhost:8080/";
//static NSString * const BaseURLString = @"http://rest.verve.house:8080/";

@protocol DevicesHTTPClientDelegate;

@interface DevicesHTTPClient : AFHTTPSessionManager
@property (nonatomic, weak) id<DevicesHTTPClientDelegate>delegate;

+ (DevicesHTTPClient *)sharedDevicesHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)updateDevicesAtLocation:(CLLocation *)location forNumberOfDays:(NSUInteger)number;

@end

@protocol DevicesHTTPClientDelegate <NSObject>
@optional
-(void)DevicesHTTPClient:(DevicesHTTPClient *)client didUpdateWithDevices:(id)Devices;
-(void)DevicesHTTPClient:(DevicesHTTPClient *)client didFailWithError:(NSError *)error;
@end

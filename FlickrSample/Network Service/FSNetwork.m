//
//  FSNetwork.m
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FSNetwork.h"
#import "NetworkHeader.h"

@interface FSNetwork()

@property(nonatomic, strong) NSURLSession *defaultSession;
@property(nonatomic, strong) NSOperationQueue *netOperationQueue;
@end

@implementation FSNetwork

+ (id)defaultNetwork {
    static FSNetwork *defaltNet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaltNet = [[self alloc] init];
    });
    return defaltNet;
}

- (id)init
{
    self = [super init];
    if (self) {
        _netOperationQueue = [[NSOperationQueue alloc] init];
        _netOperationQueue.maxConcurrentOperationCount = 3;
        _netOperationQueue.name = @"Net Operations";
        
        NSURLSessionConfiguration *sessionImageConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionImageConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        
        _defaultSession = [NSURLSession sessionWithConfiguration:sessionImageConfiguration delegate:nil delegateQueue:_netOperationQueue];
    }
    return self;
}

+ (void)getImagesDictionarySuccess:(void (^)(NSData *data))success
                           failure:(void (^)(NSError *error))failure {

    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:URL_TAG];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: @"TEST IOS", @"name",
                             @"IOS TYPE", @"typemap",
                             nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        (error) ? failure (error) : success (data);
    }];
    
    [postDataTask resume];
}

- (void)getImageWithFarmID:(NSString *)farmID
                  serverID:(NSString *)serverID
                        ID:(NSString *)ID
                  secretID:(NSString *)secretID
               success:(void (^)(NSData *data))success
               failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farmID, serverID, ID, secretID];
    NSURLSessionTask *task = [_defaultSession dataTaskWithURL:[NSURL URLWithString:path] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
            return failure(error);
        if (response) {
            success(data);

//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                //useless optimization as it seems to be decoded while UIImageView is displayed
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (data) {
//                        success(data);
//                    }
//                });
//            });
        }
    }];
    
    [task resume];


}

@end

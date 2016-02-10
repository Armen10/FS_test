//
//  FSNetwork.h
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSNetwork : NSObject <NSURLSessionDelegate>

+ (id)defaultNetwork;

+ (void)getImagesDictionarySuccess:(void (^)(NSData *data))success
                           failure:(void (^)(NSError *error))failure;

- (void)getImageWithFarmID:(NSString *)farmID
                  serverID:(NSString *)serverID
                        ID:(NSString *)ID
                  secretID:(NSString *)secret
                   success:(void (^)(NSData *data))success
                   failure:(void (^)(NSError *error))failure;

@end

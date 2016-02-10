//
//  FSImageCD.m
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FSImageCD.h"

@implementation FSImageCD

- (instancetype)updateObjectWithDictonary:(NSDictionary*)dict {
    self.id     = @([[dict valueForKeyPath:@"key.path"] intValue]);
    self.title  = [dict objectForKey:@"title"];
    self.path   = [dict objectForKey:@"path"];

    return self;
}

@end

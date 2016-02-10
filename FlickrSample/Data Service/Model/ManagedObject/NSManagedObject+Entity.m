//
//  NSManagedObject+Entity.h
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "NSManagedObject+Entity.h"

@implementation NSManagedObject (Entity)

+ (NSString*)entityName {
    return NSStringFromClass([self class]);
}

@end

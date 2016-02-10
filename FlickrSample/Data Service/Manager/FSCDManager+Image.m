//
//  FSCDManager+Image.m
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FSCDManager+Image.h"
#import "NSManagedObject+Creation.h"

@implementation FSCDManager (Image)
- (FSImageCD*)insertOrUpdateCategoryWithDictionary:(NSDictionary*)dict inManagedObjectContext:(NSManagedObjectContext*)context {
    FSImageCD *imageCD = [FSImageCD insertObjectWithDictonary:dict inManagedObjectContext:context];
    
    
    return imageCD;
}

@end

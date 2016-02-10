//
//  FSCDManager+Image.h
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FSCDManager.h"
#import "FSImageCD.h"

@interface FSCDManager (Image)

- (FSImageCD*)insertOrUpdateCategoryWithDictionary:(NSDictionary*)dict inManagedObjectContext:(NSManagedObjectContext*)context;

@end

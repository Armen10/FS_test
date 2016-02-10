//
//  NSManagedObject+Entity.h
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Entity)

+ (NSString*)entityName;

@end

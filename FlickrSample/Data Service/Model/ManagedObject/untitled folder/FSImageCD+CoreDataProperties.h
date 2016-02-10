//
//  FSImageCD+CoreDataProperties.h
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FSImageCD.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSImageCD (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *path;
@property (nullable, nonatomic, retain) NSString *desc;

@end

NS_ASSUME_NONNULL_END

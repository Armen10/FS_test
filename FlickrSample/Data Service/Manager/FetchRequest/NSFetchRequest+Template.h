//
//  NSFetchRequest+Template.h
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchRequest (Template)

+ (NSFetchRequest*)requestWithTemplate:(NSString*)templateName;

+ (NSArray*)fs_allPhotosWithMOC:(NSManagedObjectContext*)moc;

@end

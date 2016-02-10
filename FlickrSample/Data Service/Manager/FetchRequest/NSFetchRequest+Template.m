//
//  NSFetchRequest+Template.h
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//
#import "NSFetchRequest+Template.h"
#import "FSCDService.h"

@implementation NSFetchRequest (Template)

+ (NSArray*)fs_allPhotosWithMOC:(NSManagedObjectContext*)moc {
    [self privateMOCIfNeeded:&moc];
    NSFetchRequest *request = [self requestWithTemplate:@"AllPhotos"];
    return [moc executeFetchRequest:request error:nil];
}

+ (void)privateMOCIfNeeded:(NSManagedObjectContext**)moc {
    if (!*moc) {
        *moc = [FSCDService defaultService].privateMOC;
    }
}

+ (NSFetchRequest*)requestWithTemplate:(NSString*)templateName {
    return [[FSCDService defaultService].managedObjectModel fetchRequestTemplateForName:templateName];
}


@end


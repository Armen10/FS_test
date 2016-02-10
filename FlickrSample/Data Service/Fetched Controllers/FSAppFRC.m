//
//  FSAppFRC.m
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FSAppFRC.h"
#import "NSManagedObject+Creation.h"

#define kCache NSStringFromSelector(_cmd)

@implementation FSAppFRC

+ (NSFetchedResultsController*)fs_photosFRC {
    [NSFetchedResultsController deleteCacheWithName:kCache];
    NSEntityDescription *entity = [FSImageCD entityDescriptionIntoManagedObjectContext:[self mainMOC]];
    NSFetchRequest *fetchRequest = [self fetchRequestWithEntity:entity sortKey:@"id" ascending:YES];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:[self mainMOC]
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:kCache];
    [self performFetchWithFRC:aFetchedResultsController];
    
    return aFetchedResultsController;
}

#pragma mark - private helper
+ (NSManagedObjectContext*)mainMOC {
    return [FSCDService defaultService].managedObjectContext;;
}

+ (NSFetchRequest*)fetchRequestWithEntity:(NSEntityDescription*)entity sortKey:(NSString*)sortKey ascending:(BOOL)ascending {
    NSFetchRequest *fetchRequest = [self defaultFetchRequestWithEntity:entity];
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    return fetchRequest;
}

+ (NSFetchRequest*)fetchRequestWithEntity:(NSEntityDescription*)entity sortKeys:(NSArray*)sortKeys ascendings:(NSArray*)ascendings {
    NSFetchRequest *fetchRequest = [self defaultFetchRequestWithEntity:entity];
    // Edit the sort key as appropriate.
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < sortKeys.count; i++) {
        NSString *sortKey = sortKeys[i];
        NSNumber *ascending;
        if (i < ascendings.count) {
            ascending = ascendings[i];
        }else {
            ascending = ascendings.lastObject;
        }
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending.boolValue];
        [sortDescriptors addObject:sortDescriptor];
    }
    [fetchRequest setSortDescriptors:sortDescriptors];
    return fetchRequest;
}

+ (NSFetchRequest*)defaultFetchRequestWithEntity:(NSEntityDescription*)entity {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    return fetchRequest;
}


+ (void)performFetchWithFRC:(NSFetchedResultsController*)frc {
    NSError *error = nil;
    if (![frc performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end
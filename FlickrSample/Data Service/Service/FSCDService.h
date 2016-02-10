//
//  FSCDService.h
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FSCDService : NSObject

+ (instancetype)defaultService;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext; //main context
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSPersistentStore *sqLiteStore;

- (NSManagedObjectContext*)privateMOC;

- (void)saveWithBlock:(void (^)(NSManagedObjectContext *context))block;
- (void)saveWithContext:(NSManagedObjectContext*)context;

- (void)flushStores;

@end


typedef void (^privateMOC_block)(NSManagedObjectContext *context);
void saveContext(privateMOC_block block);
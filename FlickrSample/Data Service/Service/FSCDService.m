//
//  FSCDService.m
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FSCDService.h"
#import "FSFileManager.h"

#define CD_MODEL_NAME @"FSModel"

@implementation FSCDService

static FSCDService *defaultService = nil;
static dispatch_once_t onceToken = 0;
+ (instancetype)defaultService {
    dispatch_once(&onceToken, ^{
        defaultService = [[self alloc] init];
    });
    return defaultService;
}

#pragma mark - Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize sqLiteStore = _sqLiteStore;

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:CD_MODEL_NAME withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStore*)sqLiteStore {
    if (!_sqLiteStore) {
        static NSURL *documentsDirectory = nil;
        if (!documentsDirectory) {
            documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        }
        
        NSURL *storeURL = [documentsDirectory URLByAppendingPathComponent:[CD_MODEL_NAME stringByAppendingString:@".sqlite"]];
        NSError *error = nil;
        _sqLiteStore = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                 configuration:nil
                                                                           URL:storeURL
                                                                       options:nil
                                                                         error:&error];
    }
    return _sqLiteStore;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    NSError *error = nil;
    
    if (!self.sqLiteStore) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:NSStringFromClass([self class]) code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//       abort();
    }
    
    return _persistentStoreCoordinator;
}

/*
 * Main Context
 * Use only for updates View
 */
- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    NSManagedObjectContext *backgroundSaveContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [backgroundSaveContext setPersistentStoreCoordinator:coordinator];
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setParentContext:backgroundSaveContext];
    return _managedObjectContext;
}

/*
 * Private Context
 * Use for add, edit, delete ...
 */
- (NSManagedObjectContext*)privateMOC {
    __autoreleasing NSManagedObjectContext *privateMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [privateMOC setParentContext:self.managedObjectContext];
    return privateMOC;
}

#pragma mark - Core Data Saving support - 3 level
- (void)saveWithBlock:(void (^)(NSManagedObjectContext *context))block {
    NSManagedObjectContext *context = [self privateMOC];
    void (^performBlock)(void) = ^{
        if (block) {
            block(context);
        }
        NSError *error = nil;
        if ([context hasChanges] && ![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self saveMainContext];
        [self saveBackgroundContext];
    };
    
    if ([NSThread isMainThread]) {
        [context performBlock:^{
            performBlock();
        }];
    }else {
        [context performBlockAndWait:^{
            performBlock();
        }];
    }
}

- (void)saveWithContext:(NSManagedObjectContext*)context {
    if (context != nil) {
        void (^performBlock)(void) = ^{
            NSError *error = nil;
            if ([context hasChanges] && ![context save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            [self saveMainContext];
            [self saveBackgroundContext];
        };
        
        if ([NSThread isMainThread]) {
            [context performBlock:^{
                performBlock();
            }];
        }else {
            [context performBlockAndWait:^{
                performBlock();
            }];
        }
    }
}

- (void)saveMainContext {
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error: %@, User Info: %@", error, [error userInfo]);
            abort();
        }
    }];
}

- (void)saveBackgroundContext {
    [self.managedObjectContext.parentContext performBlock:^{
        NSError *error = nil;
        NSManagedObjectContext *context = self.managedObjectContext.parentContext;
        if ([context hasChanges] && ![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }];
}

- (void)flushStores {
    void (^performBlock)(void) = ^{
        NSArray *stores = [_persistentStoreCoordinator persistentStores];
        for(NSPersistentStore *store in stores) {
            [_persistentStoreCoordinator removePersistentStore:store error:nil];
            if ([[NSFileManager defaultManager] fileExistsAtPath:store.URL.path]) {
                [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
            }
        }
        _managedObjectModel    = nil;
        _managedObjectContext  = nil;
        _persistentStoreCoordinator = nil;
    };

    if (_managedObjectContext) {
        [_managedObjectContext performBlockAndWait:^{
            performBlock();
        }];
    }else {
        performBlock();
    }
    
    
}

@end


void saveContext(privateMOC_block block) {
    [[FSCDService defaultService] saveWithBlock:^(NSManagedObjectContext *context) {
        if (block) {
            block(context);
        }
    }];
}


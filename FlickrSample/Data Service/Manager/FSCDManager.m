//
//  FSCDManager.m
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FSCDManager.h"

@implementation FSCDManager

+ (instancetype)defaultManager {
    static FSCDManager *defaultManager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        defaultManager = [[self alloc] initWithStoreType:FSCDStoreTypeSQLite];
    });
    return defaultManager;
}

- (instancetype)initWithStoreType:(FSCDStoreType)storeType {
    self = [super init];
    if (self) {
        _storeType = storeType;
    }
    return self;
}

#pragma mark - Fetch Request
- (NSFetchRequest*)requestWithEntityName:(NSString*)entityName predicate:(NSPredicate*)predicate sortDescriptor:(NSArray*)sortDescriptors {
    NSFetchRequest *requset = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [requset setPredicate:predicate];
    [requset setSortDescriptors:sortDescriptors];
    return requset;
}

- (NSArray*)objectsWithMOC:(NSManagedObjectContext*)moc entityName:(NSString*)entityName predicate:(NSPredicate*)predicate sortDescriptor:(NSArray*)sortDescriptors {
    NSFetchRequest *request = [self requestWithEntityName:entityName predicate:predicate sortDescriptor:sortDescriptors];
    NSError *error = nil;
    NSArray *list = [moc executeFetchRequest:request error:&error];
//    kAPPLogError(error);
    return list;
}

- (NSManagedObject*)anyObjectWithMOC:(NSManagedObjectContext*)moc entityName:(NSString*)entityName predicate:(NSPredicate*)predicate sortDescriptor:(NSArray*)sortDescriptors {
    NSArray *list = [self objectsWithMOC:moc entityName:entityName predicate:predicate sortDescriptor:sortDescriptors];
    return [list firstObject];
}

- (NSUInteger)countWithMOC:(NSManagedObjectContext*)moc entityName:(NSString*)entityName predicate:(NSPredicate*)predicate sortDescriptor:(NSArray*)sortDescriptors {
    NSFetchRequest *request = [self requestWithEntityName:entityName predicate:predicate sortDescriptor:sortDescriptors];
    NSError *error = nil;
    NSUInteger count = [moc countForFetchRequest:request error:&error];
//    kAPPLogError(error);
    return count;
}

- (void)deleteObject:(NSManagedObject*)object autoSave:(BOOL)autoSave {
    NSManagedObjectContext *context = object.managedObjectContext;
    [context deleteObject:object];
    if (autoSave) {
        [[FSCDService defaultService] saveWithContext:context];
    }
}

- (void)deleteObjects:(NSArray*)objects inManagedObjectContext:(NSManagedObjectContext*)moc autoSave:(BOOL)autoSave {
    for (NSManagedObject *mo in objects) {
        [moc deleteObject:mo];
    }
    if (autoSave) {
        [[FSCDService defaultService] saveWithContext:moc];
    }
}

- (void)deleteObjectWithManagedObjectID:(NSManagedObjectID *)objectID autoSave:(BOOL)autoSave {
    NSManagedObjectContext *context = [FSCDService defaultService].privateMOC;
    [self deleteObjectWithManagedObjectID:objectID inManagedObjectContext:context autoSave:autoSave];
}

- (void)deleteObjectWithManagedObjectID:(NSManagedObjectID *)objectID inManagedObjectContext:(NSManagedObjectContext*)context autoSave:(BOOL)autoSave {
    NSManagedObject *object = [context objectWithID:objectID];
    [context deleteObject:object];
    if (autoSave) {
        [[FSCDService defaultService] saveWithContext:context];
    }
}

- (void)deleteEntityWithEntityName:(NSString*)entityName autoSave:(BOOL)autoSave {
    NSManagedObjectContext *context = [FSCDService defaultService].privateMOC;
    [self deleteEntityWithEntityName:entityName inManagedObjectContext:context autoSave:autoSave];
}

- (void)deleteEntityWithEntityName:(NSString*)entityName inManagedObjectContext:(NSManagedObjectContext*)moc autoSave:(BOOL)autoSave {
    NSArray *list = [self objectsWithMOC:moc entityName:entityName predicate:nil sortDescriptor:nil];
    [self deleteObjects:list inManagedObjectContext:moc autoSave:autoSave];
}

@end

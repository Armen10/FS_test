//
//  FSCDManager.h
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FSCDService.h"

typedef void (^saveReturn_block)(id returnObject);
typedef NS_ENUM(NSUInteger, FSCDStoreType) {
    FSCDStoreTypeSQLite,
};

@interface FSCDManager : NSObject

@property (readonly) FSCDStoreType storeType;

+ (instancetype)defaultManager; //SQLite

- (NSFetchRequest*)requestWithEntityName:(NSString*)entityName predicate:(NSPredicate*)predicate sortDescriptor:(NSArray*)sortDescriptors;

- (NSArray*)objectsWithMOC:(NSManagedObjectContext*)moc entityName:(NSString*)entityName predicate:(NSPredicate*)predicate sortDescriptor:(NSArray*)sortDescriptors;
- (NSManagedObject*)anyObjectWithMOC:(NSManagedObjectContext*)moc entityName:(NSString*)entityName predicate:(NSPredicate*)predicate sortDescriptor:(NSArray*)sortDescriptors;

- (NSUInteger)countWithMOC:(NSManagedObjectContext*)moc entityName:(NSString*)entityName predicate:(NSPredicate*)predicate sortDescriptor:(NSArray*)sortDescriptors;

- (void)deleteObject:(NSManagedObject*)object autoSave:(BOOL)autoSave;
- (void)deleteObjects:(NSArray*)objects inManagedObjectContext:(NSManagedObjectContext*)moc autoSave:(BOOL)autoSave;

- (void)deleteObjectWithManagedObjectID:(NSManagedObjectID *)objectID autoSave:(BOOL)autoSave;
- (void)deleteObjectWithManagedObjectID:(NSManagedObjectID *)objectID inManagedObjectContext:(NSManagedObjectContext*)context autoSave:(BOOL)autoSave;

- (void)deleteEntityWithEntityName:(NSString*)entityName autoSave:(BOOL)autoSave;
- (void)deleteEntityWithEntityName:(NSString*)entityName inManagedObjectContext:(NSManagedObjectContext*)moc autoSave:(BOOL)autoSave;

@end

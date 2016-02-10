//
//  NSManagedObject+Creation.h
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#define kNotContactUserID LLONG_MAX

#import <CoreData/CoreData.h>


@interface NSManagedObject (Creation)

+ (instancetype)insertObjectWithDictonary:(NSDictionary*)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSEntityDescription*)entityDescriptionIntoManagedObjectContext:(NSManagedObjectContext *)context;

@end

@interface NSManagedObject (InsertOrUpdate)

+ (instancetype)insertOrUpdateObjectWithDictonary:(NSDictionary*)dict inManagedObjectContext:(NSManagedObjectContext *)context ID:(NSNumber*)ID;
+ (instancetype)insertOrUpdateObjectWithDictonary:(NSDictionary*)dict inManagedObjectContext:(NSManagedObjectContext *)context ID:(NSNumber*)ID idKey:(NSString*)key;
+ (instancetype)insertOrUpdateObjectWithDictonary:(NSDictionary*)dict inManagedObjectContext:(NSManagedObjectContext *)context predicate:(NSPredicate*)predicate;
+ (instancetype)updateObjectWithDictonary:(NSDictionary*)dict objectID:(NSNumber*)ID;

@end


@interface NSManagedObject (Get)

+ (instancetype)managedObjectWithObjectID:(NSManagedObjectID*)objectID;
+ (instancetype)managedObjectWithObjectID:(NSManagedObjectID*)objectID inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray*)objectsWithID:(NSNumber*)ID;
+ (instancetype)anyObjectWithID:(NSNumber*)ID;

+ (NSArray*)objectsWithPredicate:(NSPredicate*)predicate;
+ (instancetype)anyObjectWithPredicate:(NSPredicate*)predicate;

+ (NSArray*)objectsWithKey:(NSString*)key value:(id)value;
+ (instancetype)anyObjectWithKey:(NSString*)key value:(id)value;

+ (NSArray*)objectsWithID:(NSNumber*)ID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (instancetype)anyObjectWithID:(NSNumber*)ID inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray*)objectsWithPredicate:(NSPredicate*)predicate inManagedObjectContext:(NSManagedObjectContext *)context;
+ (instancetype)anyObjectWithPredicate:(NSPredicate*)predicate inManagedObjectContext:(NSManagedObjectContext *)context;

@end


@interface NSManagedObject (inFormal)
- (instancetype)updateObjectWithDictonary:(NSDictionary*)dict;
@end

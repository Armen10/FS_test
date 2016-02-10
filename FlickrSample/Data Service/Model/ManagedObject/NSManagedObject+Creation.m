//
//  NSManagedObject+Creation.m
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "NSManagedObject+Creation.h"
#import "NSManagedObject+Entity.h"
#import "FSCDManager.h"

@implementation NSManagedObject (Creation)

+ (instancetype)insertObjectWithDictonary:(NSDictionary*)dict inManagedObjectContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [self entityDescriptionIntoManagedObjectContext:context];
   __strong typeof(self) object = [[self alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    return [object updateObjectWithDictonary:dict];
}

+ (NSEntityDescription*)entityDescriptionIntoManagedObjectContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context];
    return entity;
}

@end

@implementation NSManagedObject (InsertOrUpdate)

+ (instancetype)insertOrUpdateObjectWithDictonary:(NSDictionary*)dict inManagedObjectContext:(NSManagedObjectContext *)context ID:(NSNumber*)ID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", ID];
    return [self insertOrUpdateObjectWithDictonary:dict inManagedObjectContext:context predicate:predicate];
}

+ (instancetype)insertOrUpdateObjectWithDictonary:(NSDictionary*)dict inManagedObjectContext:(NSManagedObjectContext *)context ID:(NSNumber*)ID idKey:(NSString*)key {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, ID];
    return [self insertOrUpdateObjectWithDictonary:dict inManagedObjectContext:context predicate:predicate];
}

+ (instancetype)insertOrUpdateObjectWithDictonary:(NSDictionary*)dict inManagedObjectContext:(NSManagedObjectContext *)context predicate:(NSPredicate*)predicate {
    if (!predicate) {
        predicate = [NSPredicate predicateWithFormat:@"id == %@", dict[@"id"]];
    }
    __strong typeof(self) object = (typeof(self))[[FSCDManager defaultManager] anyObjectWithMOC:context entityName:[self entityName] predicate:predicate sortDescriptor:nil];
    if (object) {
        return [object updateObjectWithDictonary:dict];
    }else {
        return [self insertObjectWithDictonary:dict inManagedObjectContext:context];
    }
    return nil;
}

+ (instancetype)updateObjectWithDictonary:(NSDictionary*)dict objectID:(NSNumber*)ID {
    NSManagedObject *obj = [self anyObjectWithID:ID];
    [obj updateObjectWithDictonary:dict];
    [[FSCDService defaultService] saveWithContext:obj.managedObjectContext];
    return obj;
}

@end

@implementation NSManagedObject (Get)

+ (instancetype)managedObjectWithObjectID:(NSManagedObjectID*)objectID {
    NSManagedObjectContext *context = [FSCDService defaultService].privateMOC;
    return [self managedObjectWithObjectID:objectID inManagedObjectContext:context];
}

+ (instancetype)managedObjectWithObjectID:(NSManagedObjectID*)objectID inManagedObjectContext:(NSManagedObjectContext *)context {
    if (context && objectID) {
        return [context objectWithID:objectID];
    }
    return nil;
}

+ (NSArray*)objectsWithID:(NSNumber*)ID {
    NSManagedObjectContext *context = [FSCDService defaultService].privateMOC;
    return [self objectsWithID:ID inManagedObjectContext:context];
}

+ (instancetype)anyObjectWithID:(NSNumber*)ID {
    NSManagedObjectContext *context = [FSCDService defaultService].privateMOC;
    return [self anyObjectWithID:ID inManagedObjectContext:context];
}

+ (NSArray*)objectsWithPredicate:(NSPredicate*)predicate {
    NSManagedObjectContext *context = [FSCDService defaultService].privateMOC;
    return [self objectsWithPredicate:predicate inManagedObjectContext:context];
}

+ (instancetype)anyObjectWithPredicate:(NSPredicate*)predicate {
    NSManagedObjectContext *context = [FSCDService defaultService].privateMOC;
    return [self anyObjectWithPredicate:predicate inManagedObjectContext:context];
}

+ (NSArray*)objectsWithKey:(NSString*)key value:(id)value {
    NSManagedObjectContext *context = [FSCDService defaultService].privateMOC;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
    return [self objectsWithPredicate:predicate inManagedObjectContext:context];
}

+ (instancetype)anyObjectWithKey:(NSString*)key value:(id)value {
    NSManagedObjectContext *context = [FSCDService defaultService].privateMOC;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
    return [self anyObjectWithPredicate:predicate inManagedObjectContext:context];
}

+ (NSArray*)objectsWithID:(NSNumber*)ID inManagedObjectContext:(NSManagedObjectContext *)context {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", ID];
    return [self objectsWithPredicate:predicate inManagedObjectContext:context];
}

+ (instancetype)anyObjectWithID:(NSNumber*)ID inManagedObjectContext:(NSManagedObjectContext *)context {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", ID];
    return [self anyObjectWithPredicate:predicate inManagedObjectContext:context];
}

+ (NSArray*)objectsWithPredicate:(NSPredicate*)predicate inManagedObjectContext:(NSManagedObjectContext *)context {
    return [[FSCDManager defaultManager] objectsWithMOC:context entityName:[self entityName] predicate:predicate sortDescriptor:nil];
}

+ (instancetype)anyObjectWithPredicate:(NSPredicate*)predicate inManagedObjectContext:(NSManagedObjectContext *)context {
    return [[FSCDManager defaultManager] anyObjectWithMOC:context entityName:[self entityName] predicate:predicate sortDescriptor:nil];
}

@end

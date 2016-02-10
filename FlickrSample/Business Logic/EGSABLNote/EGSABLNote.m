//
//  EGSABLNote.m
//  EGSArticles
//
//  Created by Armen Hakobyan on 13.11.15.
//  Copyright © 2015 EGS. All rights reserved.
//

#import "EGSABLNote.h"
#import "EGSACDManager+Note.h"
#import "NSManagedObject+Creation.h"

@implementation EGSABLNote

+ (void)addNote:(NSString *)string WithCategory:(EGSACategoryCD *)categoryCD {
    __block EGSACategoryCD *__categoryCD = categoryCD;
    NSNumber *_id = [self getLastNoteId];
    __block NSDictionary *dict = @{@"noteDate"  : [NSDate date],
                                   @"noteTitle" : string,
                                   @"noteDetail": string,
                                   @"id": _id
                                   };
    
    saveContext(^(NSManagedObjectContext *context) {
        [[EGSACDManager defaultManager] insertOrUpdateCategoryWithDictionary:dict inManagedObjectContext:context withCategory:__categoryCD];
    });
}

+ (void)deleteNoteWithMediaID:(NSNumber*)ID success:(EGSABLSuccessBlock)block {
    EGSANoteCD *_noteCD = [EGSANoteCD anyObjectWithID:ID inManagedObjectContext:[EGSACDService defaultService].managedObjectContext];
    [[EGSACDManager defaultManager] deleteObject:_noteCD autoSave:YES];
}

+ (NSNumber *)getLastNoteId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"EGSANoteCD"];
    
    fetchRequest.fetchLimit = 1;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO]];
    
    NSError *error = nil;
    
    EGSANoteCD *note = [[EGSACDService defaultService].managedObjectContext executeFetchRequest:fetchRequest error:&error].firstObject;
    NSNumber *number;
    if (note.id == nil) {
        number = @(0);
    } else {
        number = [NSNumber numberWithInt:(note.id.intValue + 1)];
    }
    return number;
}

@end

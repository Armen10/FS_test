//
//  EGSABLArticles.m
//  EGSArticles
//
//  Created by Armen Hakobyan on 13.11.15.
//  Copyright © 2015 EGS. All rights reserved.
//

#import "EGSABLArticles.h"
#import "EGSACDManager+Category.h"
#import "EGSACDManager+Note.h"
#import "NSManagedObject+Creation.h"

@implementation EGSABLArticles

+ (void)addArticleWithDict:(NSDictionary *)dict {
    saveContext(^(NSManagedObjectContext *context) {
        [[EGSACDManager defaultManager] insertOrUpdateCategoryWithDictionary:dict inManagedObjectContext:context];
    });
}

+ (void)deleteArtcileWithMediaID:(NSNumber*)ID success:(EGSABLSuccessBlock)block {
    EGSACategoryCD *_categoryCD = [EGSACategoryCD anyObjectWithID:ID inManagedObjectContext:[EGSACDService defaultService].managedObjectContext];
    for (EGSANoteCD *noteCD in _categoryCD.notes) {
        [[EGSACDManager defaultManager] deleteObject:noteCD autoSave:YES];
    }
    [[EGSACDManager defaultManager] deleteObject:_categoryCD autoSave:YES];
}

@end

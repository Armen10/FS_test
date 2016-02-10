//
//  FPBL.m
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "FSBL.h"
#import "FSNetwork.h"
#import "FSCDManager+Image.h"
#import "NSManagedObject+Creation.h"
#import "FSCDManager.h"
#import "FSFileManager.h"

@implementation FSBL

+ (void)startBL {
    [FSNetwork getImagesDictionarySuccess:^(NSData *data) {
        [self parsJsonData:data];
    } failure:^(NSError *error) {
        
    }];
}

+ (void)parsJsonData:(NSData *)data {
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            NSDictionary *dictPhotos = [dict objectForKey:@"photos"];
            NSArray *array = [dictPhotos objectForKey:@"photo"];
            
            for (NSDictionary *photoDict in array) {
                [self downloadImageWithDict:photoDict];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLOAD_FINISH" object:nil];
        }
}

+ (void)downloadImageWithDict:(NSDictionary *)dict {
    FSImageCD *imageCD = [FSImageCD anyObjectWithID:[dict objectForKey:@"id"] inManagedObjectContext:[FSCDService defaultService].managedObjectContext];
    if (!imageCD) {
        NSString *farmID = [dict objectForKey:@"farm"];
        NSString *serverID = [dict objectForKey:@"server"];
        NSString *ID = [dict objectForKey:@"id"];
        NSString *secretID = [dict objectForKey:@"secret"];
    
        [[FSNetwork defaultNetwork] getImageWithFarmID:farmID serverID:serverID ID:ID secretID:secretID success:^(NSData *data) {
            [self saveImageData:data atDictionary:dict];
        } failure:^(NSError *error) {
        
        }];
    }
}

+ (void)saveImageData:(NSData *)data atDictionary:(NSDictionary *)dict {
    NSError *error;
    NSString *basePath = [FSFileManager applicationDocumentsDirectory];
    basePath = [basePath stringByAppendingString:@"/Photos"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:basePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:basePath withIntermediateDirectories:NO attributes:nil error:&error];
    if (!error) {
        NSString* myDocumentPath= [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [dict objectForKey:@"id"]]];
    
        if([[NSFileManager defaultManager] fileExistsAtPath:myDocumentPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:myDocumentPath error:nil];
        }
    
        [data writeToFile:myDocumentPath atomically:YES];
        NSMutableDictionary *__dict = [[NSMutableDictionary alloc] initWithDictionary:dict];
        [__dict setObject:myDocumentPath forKey:@"path"];
        
        saveContext(^(NSManagedObjectContext *context) {
            [[FSCDManager defaultManager] insertOrUpdateCategoryWithDictionary:__dict inManagedObjectContext:context];
        });
    }
}

+ (void)addImageDataAtDictionary:(NSDictionary *)dict{
    saveContext(^(NSManagedObjectContext *context) {
        [[FSCDManager defaultManager] insertOrUpdateCategoryWithDictionary:dict inManagedObjectContext:context];
    });
}

+ (void)deleteImageWithImageID:(NSNumber*)ID success:(FSBLSuccessBlock)block {
    FSImageCD *_imageCD = [FSImageCD anyObjectWithID:ID inManagedObjectContext:[FSCDService defaultService].managedObjectContext];
    [[FSCDManager defaultManager] deleteObject:_imageCD autoSave:YES];
}

@end

//
//  EGSAFileManager.m
//  EGSArticles
//
//  Created by Armen Hakobyan on 10.11.15.
//  Copyright © 2015 EGS. All rights reserved.
//

#import "EGSAFileManager.h"
#import "AppLog.h"

@implementation EGSAFileManager

#pragma mark - Directories
+ (NSURL *)applicationDocumentsDirectory {
    static NSURL *documentsDirectory = nil;
    if (!documentsDirectory) {
        documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    }
    return documentsDirectory;
}

@end

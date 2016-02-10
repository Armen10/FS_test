//
//  EGSAFileManager.h
//  EGSArticles
//
//  Created by Armen Hakobyan on 10.11.15.
//  Copyright © 2015 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGSAFileManager : NSFileManager

+ (NSURL *)applicationDocumentsDirectory;

@end


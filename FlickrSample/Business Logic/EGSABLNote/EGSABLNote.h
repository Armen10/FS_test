//
//  EGSABLNote.h
//  EGSArticles
//
//  Created by Armen Hakobyan on 13.11.15.
//  Copyright © 2015 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGSABusinessLogicDefaines.h"
#import "EGSACategoryCD.h"

@interface EGSABLNote : NSObject

+ (void)addNote:(NSString *)string WithCategory:(EGSACategoryCD *)categoryCD;
+ (void)deleteNoteWithMediaID:(NSNumber*)ID success:(EGSABLSuccessBlock)block;

@end

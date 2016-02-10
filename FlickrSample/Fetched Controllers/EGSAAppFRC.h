//
//  EGSAAppFRC.h
//  EGSArticles
//
//  Created by Armen Hakobyan on 10.11.15.
//  Copyright © 2015 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGSACDManager.h"
#import "EGSACDManager+Note.h"
#import "EGSACDManager+Category.h"

@interface EGSAAppFRC : NSObject

+ (NSFetchedResultsController*)egsa_categoriesFRC;
+ (NSFetchedResultsController*)egsa_notesFRCWithCategory:(EGSACategoryCD *)category;

@end

//
//  EGSABLArticles.h
//  EGSArticles
//
//  Created by Armen Hakobyan on 13.11.15.
//  Copyright © 2015 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGSABusinessLogicDefaines.h"

@interface EGSABLArticles : NSObject

+ (void)addArticleWithDict:(NSDictionary *)dict;
+ (void)deleteArtcileWithMediaID:(NSNumber*)ID success:(EGSABLSuccessBlock)block;

@end

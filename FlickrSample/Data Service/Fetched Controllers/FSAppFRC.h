//
//  FSAppFRC.h
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSCDManager.h"
#import "FSCDManager+Image.h"

@interface FSAppFRC : NSObject

+ (NSFetchedResultsController*)fs_photosFRC;

@end

//
//  EGSAAppFRCDelegation.h
//  EGSArticles
//
//  Created by Armen Hakobyan on 10.11.15.
//  Copyright © 2015 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EGSAAppFRC.h"

typedef void(^EGSAAppFRCDidChangeObjectAtIndexPath)(NSFetchedResultsChangeType, NSIndexPath*);

@protocol EGSAAppFRCInvokeDelegate;

@interface EGSAAppFRCDelegation : NSObject
@property (nonatomic, weak) id<EGSAAppFRCInvokeDelegate> invokeDelegate;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) UITableViewRowAnimation tableViewRowAnimation; //default UITableViewRowAnimationFade
@property (nonatomic, assign) BOOL stopFetchedResultsControllerUpdating;
/*
 *Currently works only NSFetchedResultsChangeInsert
 */
@property (nonatomic, copy) EGSAAppFRCDidChangeObjectAtIndexPath changeObjectAtIndexPath;

@property (nonatomic, assign) BOOL resultsChangeMoveCells;

- (instancetype)initWithFRC:(NSFetchedResultsController*)frc;


- (BOOL)performFetchWithPredicate:(NSPredicate*)predicate;

@end

@protocol EGSAAppFRCInvokeDelegate <NSObject>
@optional
- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
- (void)controllerDidChangeAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void)controllerWillChangeContent;
- (void)controllerDidChangeContent;

@end

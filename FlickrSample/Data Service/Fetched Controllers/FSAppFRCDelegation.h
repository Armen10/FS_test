//
//  FSAppFRCDelegation.h
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FSAppFRC.h"

typedef void(^FSAppFRCDidChangeObjectAtIndexPath)(NSFetchedResultsChangeType, NSIndexPath*);

@protocol FSAppFRCInvokeDelegate;

@interface FSAppFRCDelegation : NSObject
@property (nonatomic, weak) id<FSAppFRCInvokeDelegate> invokeDelegate;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) UITableViewRowAnimation tableViewRowAnimation; //default UITableViewRowAnimationFade
@property (nonatomic, assign) BOOL stopFetchedResultsControllerUpdating;
/*
 *Currently works only NSFetchedResultsChangeInsert
 */
@property (nonatomic, copy) FSAppFRCDidChangeObjectAtIndexPath changeObjectAtIndexPath;

@property (nonatomic, assign) BOOL resultsChangeMoveCells;

- (instancetype)initWithFRC:(NSFetchedResultsController*)frc;


- (BOOL)performFetchWithPredicate:(NSPredicate*)predicate;

@end

@protocol FSAppFRCInvokeDelegate <NSObject>
@optional
- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
- (void)controllerDidChangeAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void)controllerWillChangeContent;
- (void)controllerDidChangeContent;

@end

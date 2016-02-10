//
//  EGSAAppFRCDelegation.m
//  EGSArticles
//
//  Created by Armen Hakobyan on 10.11.15.
//  Copyright © 2015 EGS. All rights reserved.
//

#import "EGSAAppFRCDelegation.h"

#define kProjectBlockAfter(timeSec, dispatch_queue, args...)\
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeSec * NSEC_PER_SEC)), dispatch_queue, ^{args;});

@interface EGSAAppFRCDelegation () <NSFetchedResultsControllerDelegate>
@property (nonatomic) BOOL reloadOnUpdate;
@property (nonatomic, strong) NSIndexPath *insertIndexPath;
@end

@implementation EGSAAppFRCDelegation

- (instancetype)initWithFRC:(NSFetchedResultsController *)frc{
    self = [super init];
    if (self) {
        _fetchedResultsController = frc;
        _fetchedResultsController.delegate = self;
        self.tableViewRowAnimation = UITableViewRowAnimationFade;
    }
    return self;
}

- (void)setStopFetchedResultsControllerUpdating:(BOOL)stopFetchedResultsControllerUpdating {
    _stopFetchedResultsControllerUpdating = stopFetchedResultsControllerUpdating;
    self.fetchedResultsController.delegate = _stopFetchedResultsControllerUpdating ? nil : self;
}

- (BOOL)performFetchWithPredicate:(NSPredicate*)predicate {
    [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    return [self.fetchedResultsController performFetch:nil];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
    if (self.invokeDelegate && [self.invokeDelegate respondsToSelector:@selector(controllerWillChangeContent)]) {
        [self.invokeDelegate controllerWillChangeContent];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:_tableViewRowAnimation];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:_tableViewRowAnimation];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:_tableViewRowAnimation];
            self.insertIndexPath = newIndexPath;
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:_tableViewRowAnimation];
            break;
            
        case NSFetchedResultsChangeUpdate:
            if (![self customConfigureAtIndexPath:indexPath]) {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:_tableViewRowAnimation];
            }
            break;
            
        case NSFetchedResultsChangeMove:
            if (self.resultsChangeMoveCells) {
                [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
                if (![self customConfigureAtIndexPath:indexPath]) {
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:_tableViewRowAnimation];
                }
                if (![self customConfigureAtIndexPath:newIndexPath]) {
                    [tableView reloadRowsAtIndexPaths:@[newIndexPath] withRowAnimation:_tableViewRowAnimation];
                }
            }else {
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:_tableViewRowAnimation];
                [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:_tableViewRowAnimation];
            }
            break;
    }
    if (self.invokeDelegate && [self.invokeDelegate respondsToSelector:@selector(controllerDidChangeAtIndexPath:forChangeType:newIndexPath:)]) {
        [self.invokeDelegate controllerDidChangeAtIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    if (self.insertIndexPath) {
        __block NSIndexPath *indexPath = [self.insertIndexPath copy];
        __weak typeof(self) __weakSelf = self;
        kProjectBlockAfter(0.25, dispatch_get_main_queue(),
                           if (self.changeObjectAtIndexPath) {
                               __weakSelf.changeObjectAtIndexPath(NSFetchedResultsChangeInsert, indexPath);
                           })
    }
    if (self.invokeDelegate && [self.invokeDelegate respondsToSelector:@selector(controllerDidChangeContent)]) {
        [self.invokeDelegate controllerDidChangeContent];
    }
}

- (BOOL)customConfigureAtIndexPath:(NSIndexPath*)indexPath {
    if (self.invokeDelegate && [self.invokeDelegate respondsToSelector:@selector(configureCell:atIndexPath:)]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self.invokeDelegate configureCell:cell atIndexPath:indexPath];
        return YES;
    }
    return NO;
}

@end

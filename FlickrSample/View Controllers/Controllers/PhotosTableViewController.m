//
//  PhotosTableViewController.m
//  FlickrSample
//
//  Created by Armen Hakobyan on 10.02.16.
//  Copyright © 2016 EGS. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "FSAppFRCDelegation.h"
#import "FSImageCD.h"

@interface PhotosTableViewController() <FSAppFRCInvokeDelegate>
{
    UIActivityIndicatorView *iv;
}
@property (nonatomic, strong) FSAppFRCDelegation *appFRCDelegation;
@property (nonatomic, weak) NSFetchedResultsController *fetchedResultsController;

@end

@implementation PhotosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addActivityIndicatorView];
    [self configureFRC];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadIsComplate:) name:@"DOWNLOAD_FINISH" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)downloadIsComplate:(NSNotification *)notification {
    [iv stopAnimating];
}

#pragma mark - UI
- (void)addActivityIndicatorView {
    iv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    iv.center = self.view.center;
    [self.view addSubview:iv];
    [iv startAnimating];
}

#pragma mark - FRC configuration

- (void)configureFRC {
    self.appFRCDelegation = [[FSAppFRCDelegation alloc] initWithFRC:[FSAppFRC fs_photosFRC]];
    self.appFRCDelegation.tableView = self.tableView;
    self.appFRCDelegation.invokeDelegate = self;
    self.fetchedResultsController = self.appFRCDelegation.fetchedResultsController;
}

#pragma mark - UITableViewDATASOURCE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = self.fetchedResultsController.sections.count;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> frc_section = [self.fetchedResultsController.sections objectAtIndex:section];
    NSUInteger numberOfObjects = [frc_section numberOfObjects];
    return numberOfObjects;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    FSImageCD *imageCD = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithContentsOfFile:imageCD.path];
    
    return cell;
}



@end

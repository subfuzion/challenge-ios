//
//  MasterViewController.m
//  ChallengeApp
//
//  Created by Tony on 3/10/13.
//  Copyright (c) 2013 Subfuzion. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ChallengeTableCell.h"
#import "ChallengeAPI.h"


@interface MasterViewController ()

- (IBAction)sortSegmentedControlTap:(UISegmentedControl *)sender;

@end

@implementation MasterViewController {
    NSOperationQueue *_backgroundOperationQueue;
    ChallengeAPI *_challengeAPI;
    NSArray *_challenges;
    ChallengeSort _challengeSortOrder;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!_backgroundOperationQueue) {
        _backgroundOperationQueue = [[NSOperationQueue alloc] init];
    }

    if (!_challengeAPI) {
        _challengeAPI = [[ChallengeAPI alloc] init];
    }

    UINib *tableCell = [UINib nibWithNibName:@"ChallengeTableCell" bundle:nil];
    [self.tableView registerNib:tableCell forCellReuseIdentifier:@"ChallengeTableCell"];

    [self fetchChallenges];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [_challengeAPI cancelFetchChallenges];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _challenges ? _challenges.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChallengeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChallengeTableCell" forIndexPath:indexPath];

    // if no data, just return empty cell
    if (_challenges == nil || [_challenges count] == 0) return cell;

    // get the challenge for the row and update the cell asynchronously
    Challenge *challenge = [_challenges objectAtIndex:indexPath.row];
    [cell updateCellData:challenge useOperationQueue:_backgroundOperationQueue];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    DetailViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];

    Challenge *challenge = [_challenges objectAtIndex:indexPath.row];
    viewController.title = @"Challenge Info"; //challenge.ID;
    viewController.challenge = challenge;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ChallengeTableCell *challengeCell = (ChallengeTableCell *) cell;
    [challengeCell cancelUpdate];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Implementation

- (void)fetchChallenges {
    [_challengeAPI fetchChallengesSorted:_challengeSortOrder withBlock:^(NSArray *challenges) {
        _challenges = challenges;
        [self.tableView reloadData];
    }];
}

- (IBAction)sortSegmentedControlTap:(UISegmentedControl *)sender {
    
    if([sender selectedSegmentIndex] == 0) {
        NSLog(@"Sort by Newest");
        _challengeSortOrder = SortByNewest;
    }
    else if ([sender selectedSegmentIndex] == 1){
        NSLog(@"Sort by Time Left");
        _challengeSortOrder = SortByTimeLeft;
    }
    else if ([sender selectedSegmentIndex] == 2){
        NSLog(@"Sort by Prize");
        _challengeSortOrder = SortByPrize;
    }
    
    [self fetchChallenges];
}

@end

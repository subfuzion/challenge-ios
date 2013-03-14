//
//  MasterViewController.m
//  ChallengeApp
//
//  Created by Tony on 3/10/13.
//  Copyright (c) 2013 Subfuzion. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ChallengeTableCell.h"
#import "Challenge.h"
#import "ChallengeAPI.h"


@interface MasterViewController () {
	NSOperationQueue *_backgroundOperationQueue;
	ChallengeAPI *_challengeAPI;
    NSArray *_challenges;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	if (!_backgroundOperationQueue) {
		_backgroundOperationQueue = [[NSOperationQueue alloc] init];
	}

	if (!_challengeAPI) {
		_challengeAPI = [[ChallengeAPI alloc] init];
	}

	[self fetchChallenges];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	[_challengeAPI cancelFetchChallenges];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _challenges.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChallengeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

	// if no data, just return empty cell
	if (_challenges == nil || [_challenges count] == 0) return cell;

	// get the challenge for the row and update the cell asynchronously
	Challenge *challenge = [_challenges objectAtIndex:indexPath.row];
	[cell updateCellData:challenge useOperationQueue:_backgroundOperationQueue];

    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	ChallengeTableCell *challengeCell = (ChallengeTableCell *)cell;
	[challengeCell cancelUpdate];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _challenges[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

- (void)fetchChallenges {
//	[_challengeAPI fetchChallenges:^(NSArray *challenges) {
//		_challenges = challenges;
//		[self.tableView reloadData];
//	}];


	// test bookmark support
	NSMutableArray *ids = [[NSMutableArray alloc] initWithObjects:
			@"513b2256a9d2fb325b000002",
			@"513b2256a9d2fb325b000003",
			@"513b2256a9d2fb325b000004",
			nil];

	[_challengeAPI fetchBookmarks:ids withBlock:^(NSArray *challenges) {
		_challenges = challenges;
		[self.tableView reloadData];
	}];
}

@end

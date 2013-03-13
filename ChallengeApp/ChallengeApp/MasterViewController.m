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
    NSMutableArray *_challenges;
}
@end

@implementation MasterViewController {
	NSOperationQueue *_fetchImageOperationQueue;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	if (!_fetchImageOperationQueue) {
		_fetchImageOperationQueue = [[NSOperationQueue alloc] init];
		_fetchImageOperationQueue.name = @"Fetch Image Operation Queue";
	}

	[self getChallengesAsync];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	[_fetchImageOperationQueue cancelAllOperations];
}

- (void)insertNewObject:(id)sender
{
    if (!_challenges) {
        _challenges = [[NSMutableArray alloc] init];
    }

	[_challenges addObject:[[Challenge alloc] init]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_challenges count] inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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

	if (_challenges == nil || [_challenges count] == 0) return cell;

	Challenge *challenge = [_challenges objectAtIndex:indexPath.row];

	[cell updateCellData:challenge useOperationQueue:_fetchImageOperationQueue];

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

- (void)getChallengesAsync {

	if (!_challenges) {
		_challenges = [[NSMutableArray alloc] init];
	}

	// TODO: fetch data using operation queue
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://challengeapi-7312.onmodulus.net/feed"]];
	[self parseData:data];
}

- (void)parseData:(NSData *)responseData {
	NSError *error;
	NSDictionary* json = [NSJSONSerialization
			JSONObjectWithData:responseData
					   options:(NSJSONReadingOptions)kNilOptions
						 error:&error];

	NSArray *challenges = [json objectForKey:@"challenges"];
	NSLog(@"challenges: %@", challenges);

	for (NSDictionary *item in challenges) {
		Challenge *challenge = [Challenge challengeWithData:item];
		[_challenges addObject:challenge];
	}
}

@end

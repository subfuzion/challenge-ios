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
#import "Challenge.h"
#import "ChallengeAPI.h"


@interface MasterViewController () {
    NSMutableArray *_challenges;
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

	// Do any additional setup after loading the view, typically from a nib.
	
	[self getChallengesAsync];

    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_challenges) {
        _challenges = [[NSMutableArray alloc] init];
    }
    [_challenges insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
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

    Challenge *challenge = _challenges[indexPath.row];
	[cell updateCellData:challenge];
    return cell;
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

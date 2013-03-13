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

- (IBAction)bookMarkClick:(id)sender;
- (IBAction)infoClick:(id)sender;

@end

@implementation MasterViewController {
	NSOperationQueue *_fetchImageOperationQueue;
	NSMutableDictionary *_imageUrlToFetchImageOperation;
}

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

	if (_challenges == nil || [_challenges count] == 0) return cell;

	Challenge *challenge = [_challenges objectAtIndex:indexPath.row];

	[cell updateCellData:challenge];

	[self fetchImageAsync:challenge.imageURL tableView:tableView cellForRowAtIndexPath:indexPath];

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
        
        //NSLog(@"%@", url);
        
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
	//NSLog(@"challenges: %@", challenges);

	for (NSDictionary *item in challenges) {
		Challenge *challenge = [Challenge challengeWithData:item];
		[_challenges addObject:challenge];
	}
}

- (void)fetchImageAsync:(NSString *)imageURL tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (!imageURL) return;

	if (!_fetchImageOperationQueue) {
		_fetchImageOperationQueue = [[NSOperationQueue alloc] init];
		_fetchImageOperationQueue.name = @"Fetch Image Operation Queue";
	}

	if (!_imageUrlToFetchImageOperation) {
		_imageUrlToFetchImageOperation = [[NSMutableDictionary alloc] init];
	}

	// Async solution inspired by Stav Ashuri's blog article:
	// http://stavash.wordpress.com/2012/12/14/advanced-issues-asynchronous-uitableviewcell-content-loading-done-right/
	NSBlockOperation *fetchImageOperation = [[NSBlockOperation alloc] init];
	__weak NSBlockOperation *weakOpRef = fetchImageOperation;
	[fetchImageOperation addExecutionBlock:^(void) {
		NSURL *url = [[NSURL alloc] initWithString:imageURL];
		UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
		[[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
			if (!weakOpRef.isCancelled) {
				ChallengeTableCell *cell = (ChallengeTableCell *) [tableView cellForRowAtIndexPath:indexPath];
				cell.imageView.image = image;
				[_imageUrlToFetchImageOperation removeObjectForKey:imageURL];
			}
		}];
	}];

	// save reference in case we want to cancel later
	[_imageUrlToFetchImageOperation setObject:fetchImageOperation forKey:imageURL];

	// queue the operation
	[_fetchImageOperationQueue addOperation:fetchImageOperation];

	// remove any previous images (from cell reuse) while image is downloading
	ChallengeTableCell *cell = (ChallengeTableCell *) [tableView cellForRowAtIndexPath:indexPath];
	cell.imageView.image = nil;
}

- (IBAction)bookMarkClick:(id)sender {
    
    
    //call Bookmarks view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                         bundle:nil];
    
    
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"BookmarksViewController"];
    
    [viewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:viewController animated:YES completion:NULL];
}

- (IBAction)infoClick:(id)sender {
    
    //call Bookmarks view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                         bundle:nil];
    
    
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"InfoViewController"];
    
    [viewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:viewController animated:YES completion:NULL];
}
@end

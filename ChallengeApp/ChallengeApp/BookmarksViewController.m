//
//  BookmarksViewController.m
//  ChallengeApp
//
//  Created by Tony on 3/14/13.
//  Copyright (c) 2013 Subfuzion. All rights reserved.
//

#import "BookmarksViewController.h"
#import "ChallengeTableCell.h"
#import "ChallengeAPI.h"
#import "DetailViewController.h"


@interface BookmarksViewController ()

- (IBAction)doneTap:(UIBarButtonItem *)sender;

@end

@implementation BookmarksViewController {
    NSOperationQueue *_backgroundOperationQueue;
    ChallengeAPI *_challengeAPI;
    NSMutableArray *_challenges;
    NSMutableArray *_bookmarks;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (!_backgroundOperationQueue) {
        _backgroundOperationQueue = [[NSOperationQueue alloc] init];
    }
    
    if (!_challengeAPI) {
        _challengeAPI = [[ChallengeAPI alloc] init];
    }

    UINib *tableCell = [UINib nibWithNibName:@"ChallengeTableCell" bundle:nil];
    [self.tableView registerNib:tableCell forCellReuseIdentifier:@"ChallengeTableCell"];
}

	
- (void)viewDidAppear:(BOOL)animated {
    // Refresh the bookmarks each time view appears
    
    _bookmarks = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"bookmarkArray"]];
    
    //NSLog(@"%@", bookmarks);
    
    [self fetchBookmarks];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_backgroundOperationQueue)
        [_backgroundOperationQueue cancelAllOperations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchBookmarks {
    
    // Get saved bookmarks from NSUserDefaults
    [_challengeAPI fetchBookmarks:_bookmarks withBlock:^(NSArray *challenges) {
        _challenges = [[NSMutableArray alloc] initWithArray:challenges];
        [self.tableView reloadData];
        // NSLog(@"%@", challenges);
    }];
}

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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Challenge *challenge = [_challenges objectAtIndex:indexPath.row];
    [_challenges removeObjectAtIndex:indexPath.row];
    
    NSString *oid = challenge.ID;
    
    [_bookmarks removeObject:oid];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:_bookmarks forKey:@"bookmarkArray"];
    
    [defaults synchronize];
    
    [self.tableView reloadData];
    
    // NSLog(@"%@", bookmarks);
    
}


- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ChallengeTableCell *challengeCell = (ChallengeTableCell *) cell;
    [challengeCell cancelUpdate];
}

- (IBAction)doneTap:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

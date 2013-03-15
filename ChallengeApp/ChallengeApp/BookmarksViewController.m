//
//  BookmarksViewController.m
//  ChallengeApp
//
//  Created by Tenny Susanto on 3/12/13.
//  Copyright (c) 2013 Subfuzion. All rights reserved.
//

#import "BookmarksViewController.h"
#import "ChallengeTableCell.h"
#import "ChallengeAPI.h"


@interface BookmarksViewController ()


- (IBAction)doneClick:(id)sender;
@end

@implementation BookmarksViewController
NSArray *_challenges;
ChallengeAPI *_challengeAPI;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if (!_challengeAPI) {
        _challengeAPI = [[ChallengeAPI alloc] init];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    // Refresh the bookmarks each time view appears
    [self fetchBookmarks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)fetchBookmarks {

    //read favids from NSUserDefaults
    NSMutableArray *favids = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteArray"]];
    NSLog(@"ids: %@", favids);

    [_challengeAPI fetchBookmarks:favids withBlock:^(NSArray *challenges) {
        _challenges = challenges;
///		[self.tableView reloadData];
        NSLog(@"%@", challenges);
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChallengeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    return cell;
}


- (IBAction)doneClick:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}
@end

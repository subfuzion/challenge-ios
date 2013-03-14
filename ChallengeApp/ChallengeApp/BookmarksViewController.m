//
//  BookmarksViewController.m
//  ChallengeApp
//
//  Created by Tenny Susanto on 3/12/13.
//  Copyright (c) 2013 Subfuzion. All rights reserved.
//

#import "BookmarksViewController.h"
#import "ChallengeTableCell.h"
#import "Challenge.h"
#import "ChallengeAPI.h"



@interface BookmarksViewController ()


- (IBAction)doneClick:(id)sender;
@end

@implementation BookmarksViewController
 NSArray *_challenges;
ChallengeAPI *_challengeAPI;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    NSMutableArray *testArray= [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteArray"]];
    
    NSLog(@"Favorites ids: %@", testArray);
    
    [self fetchBookmarks];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)fetchBookmarks {

     // test bookmark support
     NSMutableArray *ids = [[NSMutableArray alloc] initWithObjects:
     @"513b2256a9d2fb325b000001",
     @"513b2256a9d2fb325b000003",
     @"513b2256a9d2fb325b000004",
     nil];
     
    // NSArray *challenges = [json objectForKey:@"challenges"];
    
     
     [_challengeAPI fetchBookmarks:ids withBlock:^(NSArray *challenges) {
     _challenges = challenges;
     //[self.tableView reloadData];
         NSLog(@"%@", challenges);
     }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChallengeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
}


- (IBAction)doneClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end

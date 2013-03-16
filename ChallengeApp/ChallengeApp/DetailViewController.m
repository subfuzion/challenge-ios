//
//  DetailViewController.m
//  ChallengeApp
//
//  Created by Tony on 3/10/13.
//  Copyright (c) 2013 Subfuzion. All rights reserved.
//

#import "DetailViewController.h"
#import "ChallengeAPI.h"

@interface DetailViewController ()

- (IBAction)onSendAction:(id)sender;
- (IBAction)onBookmarkAction:(UIButton *)sender;
- (IBAction)GoToURLButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property(weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property(weak, nonatomic) IBOutlet UILabel *bookmarkLabel;

@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *posterLabel;

- (void)configureView;

@end

@implementation DetailViewController {
    NSOperationQueue *_backgroundOperationQueue;
    NSOperation *_fetchImageOperation;
    ChallengeAPI *_challengeAPI;
    Challenge *item;
    
}

#pragma mark - Managing the detail item



- (void)configureView {
    // Update the user interface for the challenge, which is passed by MasterViewController
    item = self.challenge;
    if (item) {
        self.titleLabel.text = item.title;
        self.detailDescriptionLabel.text = item.summary;
        self.posterLabel.text = [NSString stringWithFormat:@"By %@", item.poster];
        
  
        // load image asynchronously
        [self fetchImage:item.imageURL useOperationQueue:_backgroundOperationQueue];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.    
    
    _bookmarkLabel.hidden = YES;

    UIImage *buttonImage = [[UIImage imageNamed:@"blueButton.png"]
                            stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    
    [_websiteButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    
    if (!_backgroundOperationQueue) {
        _backgroundOperationQueue = [[NSOperationQueue alloc] init];
    }
    
    if (!_challengeAPI) {
        _challengeAPI = [[ChallengeAPI alloc] init];
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self configureView];
    

    self.scrollView.contentSize = CGSizeMake(320, 800);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSendAction:(id)sender {

    NSString *message = @"I want to share this challenge.gov posting with you.";

    item = self.challenge;
    
    NSArray *postItems = @[message,item.url];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
          initWithActivityItems:postItems
            applicationActivities:nil];

    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact];

    [self presentViewController:activityVC animated:YES completion:nil];

}

- (IBAction)onBookmarkAction:(UIButton *)sender {

    //add id to NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSMutableArray *bookmarks = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"bookmarkArray"]];

    //see if id already added before, don't store it if already there
    NSString *id = self.challenge.ID;
    if (![bookmarks containsObject:id]) {
        [bookmarks addObject:id];
    }

    [defaults setObject:bookmarks forKey:@"bookmarkArray"];

    [defaults synchronize];


    //fade in and out label that says "bookmarked"
    _bookmarkLabel.alpha = 0;
    _bookmarkLabel.hidden = NO;

    [UIView animateWithDuration:0.3 animations:^{
        _bookmarkLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            _bookmarkLabel.alpha = 0;
        }];
    }];
}

- (void)fetchImage:(NSString *)imageURL useOperationQueue:(NSOperationQueue *)operationQueue {
    // remove any previous images (from cell reuse) while image is downloading
    self.logoImageView.image = nil;
    
    _fetchImageOperation = [ChallengeAPI fetchImage:imageURL operationQueue:operationQueue withBlock:^(UIImage *image) {
        self.logoImageView.image = image;
    }];
}

- (IBAction)GoToURLButton:(UIButton *)sender {
    
    NSString *urlString = item.url;
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[UIApplication sharedApplication] openURL:url];
    
}


- (void)cancelUpdate {
    if (_fetchImageOperation) {
        [_fetchImageOperation cancel];
    }
    self.logoImageView.image = nil;
}
@end

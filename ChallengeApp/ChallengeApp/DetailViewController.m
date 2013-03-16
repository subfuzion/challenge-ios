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

@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIButton *addFavButton;
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;

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
        //self.titleLabel.text = item.title;
        //self.detailDescriptionLabel.text = item.summary;
        //self.posterLabel.text = [NSString stringWithFormat:@"By %@", item.poster];
        
  
        // load image asynchronously
        [self fetchImage:item.imageURL useOperationQueue:_backgroundOperationQueue];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.    
    
    UIImage *buttonImage = [[UIImage imageNamed:@"blueButton.png"]
                            stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    
    [_websiteButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_addFavButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    if (!_backgroundOperationQueue) {
        _backgroundOperationQueue = [[NSOperationQueue alloc] init];
    }
    
    if (!_challengeAPI) {
        _challengeAPI = [[ChallengeAPI alloc] init];
    }
    
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"detailWebView.html" ofType:nil]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_detailWebView loadRequest:request];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self configureView];

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

}

- (void)fetchImage:(NSString *)imageURL useOperationQueue:(NSOperationQueue *)operationQueue {
    // remove any previous images (from cell reuse) while image is downloading
    //self.logoImageView.image = nil;
    
    //_fetchImageOperation = [ChallengeAPI fetchImage:imageURL operationQueue:operationQueue withBlock:^(UIImage *image) {
      //  self.logoImageView.image = image;
    //}];
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
    //self.logoImageView.image = nil;
}
@end

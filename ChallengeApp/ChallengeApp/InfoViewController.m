//
//  InfoViewController.m
//  ChallengeApp
//
//  Created by Tenny Susanto on 3/12/13.
//  Copyright (c) 2013 Subfuzion. All rights reserved.
//

#import "InfoViewController.h"
#import "ChallengeAPI.h"


NSString *const kAppId = @"622479138";


@interface InfoViewController () <UIWebViewDelegate>

- (IBAction)doneClick:(id)sender;
- (IBAction)shareClick:(UIButton *)sender;
- (IBAction)rateClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;
@property (weak, nonatomic) IBOutlet UIButton *rateAppButton;
@property (weak, nonatomic) IBOutlet UIButton *shareAppButton;

@end

@implementation InfoViewController

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

    
    self.infoWebView.delegate = self;
    
//    [self.activityIndicator startAnimating];
//
//    [ChallengeAPI fetchInfoPageExecute:^(NSString * page) {
//        [self.infoWebView loadHTMLString:page baseURL:nil];
//        [self.activityIndicator stopAnimating];
//    }];
    UIImage *buttonImage = [[UIImage imageNamed:@"blueButton.png"]
                            stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    
    
    [_rateAppButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_shareAppButton setBackgroundImage:buttonImage forState:UIControlStateNormal];


    NSURL *url = [ChallengeAPI urlForInfoPage];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.infoWebView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareClick:(UIButton *)sender {
    
    NSString *message = @"I want to share this challenge.gov app with you...";
    
    NSString *appurl = [NSString stringWithFormat:@"Download the app from http://itunes.apple.com/app/id%@", kAppId];
    
    NSArray *postItems = @[message,appurl];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:postItems
                                            applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact];
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
}



- (IBAction)rateClick:(UIButton *)sender {
    
    NSString *url = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", kAppId];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [ChallengeAPI startNetworkOperation];
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [ChallengeAPI finishNetworkOperation];
    [self.activityIndicator stopAnimating];
}


@end

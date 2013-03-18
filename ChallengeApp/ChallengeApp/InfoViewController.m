//
//  InfoViewController.m
//  ChallengeApp
//
//  Created by Tenny Susanto on 3/12/13.
//  Copyright (c) 2013 Subfuzion. All rights reserved.
//

#import "InfoViewController.h"
#import "ChallengeAPI.h"

@interface InfoViewController () <UIWebViewDelegate>

- (IBAction)doneClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;

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

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [ChallengeAPI startNetworkOperation];
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [ChallengeAPI finishNetworkOperation];
    [self.activityIndicator stopAnimating];
}


@end

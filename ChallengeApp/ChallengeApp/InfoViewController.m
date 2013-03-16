//
//  InfoViewController.m
//  ChallengeApp
//
//  Created by Tenny Susanto on 3/12/13.
//  Copyright (c) 2013 Subfuzion. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()
- (IBAction)doneClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIWebView *infowebView;
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
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"infoView.html" ofType:nil]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_infowebView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneClick:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}
@end

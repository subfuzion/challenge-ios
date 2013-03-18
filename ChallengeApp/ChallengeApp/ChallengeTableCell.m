//
// Created by tony on 3/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ChallengeTableCell.h"
#import "ChallengeAPI.h"

@interface ChallengeTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *submitDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *prizeLabel;

@end

@implementation ChallengeTableCell {
    // a reference to the operation is stored in case we want to cancel
    // (when cell scrolls out of view)
    NSOperation *_fetchImageOperation;
}

- (void)updateCellData:(Challenge *)challenge useOperationQueue:(NSOperationQueue *)operationQueue {
    if (challenge == nil) return;

    self.titleLabel.text = challenge.title;
    //[self.titleLabel sizeToFit];  << tony: handled in NIB settings

    self.submitDateLabel.text = [NSString stringWithFormat:@"Submit by: %@", [challenge.submissionPeriodEndDate substringToIndex:12]];

    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setMaximumFractionDigits:0];
    NSString *prizeMoney = [currencyFormatter stringFromNumber:[NSNumber numberWithInt:[challenge.prizeMoney intValue]]];
    self.prizeLabel.text = prizeMoney;

    // load image asynchronously
    [self fetchImage:challenge.imageURL useOperationQueue:operationQueue];
}

- (void)fetchImage:(NSString *)imageURL useOperationQueue:(NSOperationQueue *)operationQueue {
    // remove any previous images (from cell reuse) while image is downloading
    self.logoImageView.image = nil;
    [self setNeedsLayout];

    _fetchImageOperation = [ChallengeAPI fetchImage:imageURL operationQueue:operationQueue withBlock:^(UIImage *image) {
        self.logoImageView.image = image;
        [self setNeedsLayout];
    }];
}

- (void)cancelUpdate {
    if (_fetchImageOperation) {
        [_fetchImageOperation cancel];
    }
    self.logoImageView.image = nil;
    [self setNeedsLayout];
}

@end
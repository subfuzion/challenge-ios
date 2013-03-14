//
// Created by tony on 3/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ChallengeTableCell.h"
#import "ChallengeAPI.h"

@implementation ChallengeTableCell {
	// a reference to the operation is stored in case we want to cancel
	// (when cell scrolls out of view)
	NSOperation *_fetchImageOperation;
}

- (void)updateCellData:(Challenge *)challenge useOperationQueue:(NSOperationQueue *)operationQueue {
	if (challenge == nil) return;

	self.titleLabel.text = challenge.title;
    
    //[self.titleLabel sizeToFit];
    
	self.posterLabel.text = [NSString stringWithFormat:@"Submit by: %@", [challenge.submissionPeriodEndDate substringToIndex:12]];
    
    
    int prizemoneyInt = [challenge.prizeMoney intValue];
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setMaximumFractionDigits:0];
    
    NSString *prizemoneyString = [currencyFormatter stringFromNumber:[NSNumber numberWithInt:prizemoneyInt]];
    
    self.prizeLabel.text = prizemoneyString;
    
	// load image asynchronously
	[self fetchImage:challenge.imageURL useOperationQueue:operationQueue];
}

- (void)fetchImage:(NSString *)imageURLPath useOperationQueue:(NSOperationQueue *)operationQueue {
	// remove any previous images (from cell reuse) while image is downloading
	self.logoImageView.image = nil;
	[self setNeedsLayout];

	_fetchImageOperation = [ChallengeAPI fetchImage:imageURLPath operationQueue:operationQueue withBlock:^(UIImage *image) {
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
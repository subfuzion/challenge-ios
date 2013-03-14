//
// Created by tony on 3/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ChallengeTableCell.h"


@implementation ChallengeTableCell {
	// a reference to the operation is stored in case we want to cancel
	// (when cell scrolls out of view)
	NSBlockOperation *_fetchImageOperation;
}

- (void)updateCellData:(Challenge *)challenge useOperationQueue:(NSOperationQueue *)operationQueue {
	if (challenge == nil) return;

	self.titleLabel.text = challenge.title;
	self.posterLabel.text = challenge.poster;

	// load image asynchronously
	[self fetchImage:challenge.imageURL useOperationQueue:operationQueue];
}

- (void)fetchImage:(NSString *)imageURLPath useOperationQueue:(NSOperationQueue *)operationQueue {
	// todo: move to ChallengeAPI
	if (!imageURLPath) return;
	if (!operationQueue) return;
    
    // remove any previous images (from cell reuse) while image is downloading
    self.logoImageView.image = nil;
    [self setNeedsLayout];
    
    _fetchImageOperation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOp = _fetchImageOperation;
    __weak ChallengeTableCell *weakSelf = self;
    [_fetchImageOperation addExecutionBlock:^(void) {
        NSURL *url = [[NSURL alloc] initWithString:imageURLPath];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            if (!weakOp.isCancelled) {
                weakSelf.logoImageView.image = image;
                [weakSelf setNeedsLayout];
            }
        }];
    }];
    
    // queue the operation
    [operationQueue addOperation:_fetchImageOperation];
}

- (void)cancelUpdate {
	// todo: move to ChallengeAPI
	if (_fetchImageOperation) {
		[_fetchImageOperation cancel];
	}
    self.logoImageView.image = nil;
    [self setNeedsLayout];
}

@end
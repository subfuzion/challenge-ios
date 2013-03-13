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
	if (imageURLPath == nil) return;

	if (!operationQueue) {
		NSURL *imageURL = [[NSURL alloc] initWithString:imageURLPath];
		UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
		self.logoImageView.image = image;
		[self setNeedsLayout];

	} else {
		// Async solution inspired by Stav Ashuri's blog article:
		// http://stavash.wordpress.com/2012/12/14/advanced-issues-asynchronous-uitableviewcell-content-loading-done-right/
		_fetchImageOperation = [[NSBlockOperation alloc] init];
		__weak NSBlockOperation *weakOpRef = _fetchImageOperation;
		[_fetchImageOperation addExecutionBlock:^(void) {
			NSURL *url = [[NSURL alloc] initWithString:imageURLPath];
			UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
			[[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
				if (!weakOpRef.isCancelled) {
					self.logoImageView.image = image;
					[self setNeedsLayout];
					_fetchImageOperation = nil;
				}
			}];
		}];

		// queue the operation
		[operationQueue addOperation:_fetchImageOperation];

		// remove any previous images (from cell reuse) while image is downloading
		self.logoImageView.image = nil;
		[self setNeedsLayout];
	}
}

- (void)cancelUpdate {
	if (_fetchImageOperation) {
		[_fetchImageOperation cancel];
		_fetchImageOperation = nil;
	}
}

@end